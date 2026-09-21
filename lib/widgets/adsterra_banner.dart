import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// ---- DEBUG NOTE (no behavior change) ----
// This widget renders an <iframe> via HtmlElementView. On Flutter Web,
// platform views (iframes) sitting INSIDE a scrollable area (here it's
// inside the CustomScrollView on HomePage) are a well-known cause of
// slow/janky scrolling: the browser has to keep re-clipping and
// repositioning the real DOM iframe to track the Flutter canvas on
// every scroll frame. To confirm this is contributing on your machine,
// scroll the page and watch DevTools Performance tab (or the
// [PERF] JANKY FRAME logs from home_page.dart) specifically around the
// moment the ad banner scrolls into/out of view.

// Reusable Adsterra BANNER widget — kahin bhi use kar sakte hain, bas
// zoneKey/width/height pass karen. Zone key placeholder hone tak
// khali box return karta hai (koi crash nahi).
class AdsterraBanner extends StatefulWidget {
  final String zoneKey;
  final double width;
  final double height;
  // FIX: jab ye true hota hai (user active scroll kar raha hai),
  // widget real <iframe> ki bajaye niche ek halka static placeholder
  // dikhata hai. Wajah: Flutter Web mein scrollable ke andar platform
  // view (iframe) ko browser ko har scroll frame par reposition/re-clip
  // karna padta hai — yehi is section ke paas record hue janky frames
  // (build ~20-30ms) ki asal wajah thi. Scroll rukte hi (isScrolling
  // false) asal ad iframe wapas mount ho jata hai.
  final bool isScrolling;
  const AdsterraBanner({
    super.key,
    required this.zoneKey,
    this.width = 300,
    this.height = 250,
    this.isScrolling = false,
  });

  @override
  State<AdsterraBanner> createState() => _AdsterraBannerState();
}

class _AdsterraBannerState extends State<AdsterraBanner> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('[PERF] AdsterraBanner(${widget.zoneKey}) mounted — an iframe platform view is now live inside the scroll area.');
    }
    _viewType = 'adsterra-banner-${widget.zoneKey}-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '${widget.width.toInt()}px'
        ..style.height = '${widget.height.toInt()}px'
        ..srcdoc = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  html, body { margin:0; padding:0; background:transparent; display:flex;
    align-items:center; justify-content:center; overflow:hidden; }
</style>
</head>
<body>
<script type="text/javascript">
  atOptions = {
    'key' : '${widget.zoneKey}',
    'format' : 'iframe',
    'height' : ${widget.height.toInt()},
    'width' : ${widget.width.toInt()},
    'params' : {}
  };
</script>
<script type="text/javascript" src="https://www.highperformanceformat.com/${widget.zoneKey}/invoke.js"></script>
</body>
</html>
''';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.zoneKey.startsWith('YOUR_ADSTERRA')) {
      return const SizedBox.shrink();
    }
    if (widget.isScrolling) {
      // Scroll ke dauran real iframe ki jagah simple placeholder —
      // koi DOM element scroll frame ke saath reposition nahi ho raha,
      // is liye ye rendering Flutter ke apne canvas jitni hi tez hai.
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }
    return SizedBox(width: widget.width, height: widget.height, child: HtmlElementView(viewType: _viewType));
  }
}
