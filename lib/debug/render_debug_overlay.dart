// lib/debug/render_debug_overlay.dart
//
// SIRF DEBUGGING ke liye — text blur ka asal reason pakadne wala widget.
// Ye production mein nahi rehna chahiye, sirf temporary diagnosis ke liye.
//
// Ye kya karta hai:
// 1. Browser console mein (F12 > Console) print karta hai:
//    - Flutter renderer kya hai (CanvasKit ya HTML)
//    - window.devicePixelRatio kya hai
//    - MediaQuery ka devicePixelRatio Flutter side par kya dikh raha hai
//    - textScaleFactor / browser zoom se related info
// 2. Screen ke top-left corner par ek chhota overlay dikhata hai jisme
//    yehi info likhi hoti hai, taake aap live dekh sakein.
//
// NOTE: Ye sab sirf Flutter WEB par meaningful hai (browser/DOM info).
// Phone app (Android/iOS) par ye ab crash nahi karega — bas khali/zero
// diagnostics dikhayega, kyunke dart:html wahan available hi nahi hoti.
//
// USAGE: app.dart ke MaterialApp ke andar builder mein isko wrap kar dena
// (neeche instructions dekhein).

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../platform/browser_diagnostics.dart';

class RenderDebugOverlay extends StatefulWidget {
  final Widget child;
  const RenderDebugOverlay({super.key, required this.child});

  @override
  State<RenderDebugOverlay> createState() => _RenderDebugOverlayState();
}

class _RenderDebugOverlayState extends State<RenderDebugOverlay> {
  String _info = 'Collecting debug info...';

  @override
  void initState() {
    super.initState();
    // Ek frame render hone ke baad hi DOM inspect karo, taake
    // flt-glass-pane / canvas elements DOM mein aa chuke hon.
    WidgetsBinding.instance.addPostFrameCallback((_) => _collectDebugInfo());
  }

  void _collectDebugInfo() {
    final buffer = StringBuffer();

    // 1) Devices/browser pixel ratio (asal browser value, web par hi milega)
    final diag = readBrowserDiagnostics();
    final browserDpr = diag.devicePixelRatio;
    buffer.writeln('window.devicePixelRatio = $browserDpr');

    // 2) Flutter side ka devicePixelRatio (MediaQuery se)
    final flutterDpr = MediaQuery.of(context).devicePixelRatio;
    buffer.writeln('MediaQuery.devicePixelRatio = $flutterDpr');

    // Agar ye dono match nahi karte, to yehi blur ki sabse badi wajah hai.
    final mismatch = (browserDpr - flutterDpr).abs() > 0.01;
    buffer.writeln('DPR MISMATCH: $mismatch  <-- true hai to yehi culprit hai (web only)');

    // 3) textScaleFactor / textScaler (agar user ne browser/OS text size
    //    bada rakha hai to bhi rendering ajeeb ho sakti hai)
    final textScaler = MediaQuery.of(context).textScaler;
    buffer.writeln('textScaler = $textScaler');

    // 4) Renderer detect karna: CanvasKit ek <canvas> tag glass-pane ke
    //    andar daalta hai; HTML renderer <span>/<p> se text render karta
    //    hai aur koi full-screen <canvas> nahi hota. (web only)
    final canvasSize = findCanvasSize();
    final rendererGuess = canvasSize != null ? 'CanvasKit (canvas-based)' : 'HTML (DOM-based) / Not Web';
    buffer.writeln('Detected renderer = $rendererGuess');

    // 5) Canvas ka actual pixel size vs CSS display size (agar canvas hai)
    if (canvasSize != null) {
      buffer.writeln('canvas.width (actual px) = ${canvasSize.width}');
      buffer.writeln('canvas.height (actual px) = ${canvasSize.height}');
      buffer.writeln('canvas CSS width = ${canvasSize.cssWidth}');
      buffer.writeln('canvas CSS height = ${canvasSize.cssHeight}');
      // Agar canvas.width != cssWidth * devicePixelRatio, blur hoga.
      final expectedWidth = diag.innerWidth * browserDpr;
      buffer.writeln('expected canvas.width (innerWidth * dpr) ~= $expectedWidth');
    }

    // 6) Screen / viewport info
    buffer.writeln('innerWidth = ${diag.innerWidth}');
    buffer.writeln('innerHeight = ${diag.innerHeight}');
    buffer.writeln('MediaQuery.size (logical) = ${MediaQuery.of(context).size}');
    buffer.writeln('kIsWeb = $kIsWeb');

    final result = buffer.toString();

    // Browser console mein print (F12 > Console mein dikhega)
    // ignore: avoid_print
    debugPrint('========== RENDER DEBUG INFO ==========\n$result========================================');

    if (mounted) {
      setState(() => _info = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // On-screen overlay — sirf debug ke liye, taake screenshot
        // bhejte waqt info bhi saath aa jaye.
        Positioned(
          top: 8,
          left: 8,
          child: Material(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SelectableText(
                  _info,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
