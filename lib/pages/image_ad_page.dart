import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../config/app_config.dart';

// Carousel image pe click hone ke baad ye ad page dikhti hai, phir
// full-screen zoomable image dialog khulta hai.
class ImageAdPage extends StatefulWidget {
  final String imagePath;
  const ImageAdPage({super.key, required this.imagePath});

  @override
  State<ImageAdPage> createState() => _ImageAdPageState();
}

class _ImageAdPageState extends State<ImageAdPage> {
  static const int _adSeconds = 5;
  int _secondsLeft = _adSeconds;
  Timer? _timer;
  late final String _viewType;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _viewType = 'adsterra-banner-img-${DateTime.now().microsecondsSinceEpoch}';
    _registerAdView();
    _startCountdown();
  }

  void _registerAdView() {
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.width = '300px'
        ..style.height = '250px'
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
    'key' : '$kAdsterraZoneKey',
    'format' : 'iframe',
    'height' : 250,
    'width' : 300,
    'params' : {}
  };
</script>
<script type="text/javascript" src="https://www.highperformanceformat.com/$kAdsterraZoneKey/invoke.js"></script>
</body>
</html>
''';
      return iframe;
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
        _showFullImageDialog();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _showFullImageDialog() {
    if (_dialogShown) return;
    _dialogShown = true;
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => _FullImageDialog(imagePath: widget.imagePath),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth < 340 ? screenWidth - 32 : 320.0;
    final boxHeight = boxWidth * 266 / 320;
    final innerWidth = boxWidth - 16;
    final innerHeight = innerWidth * 250 / 300;
    return Scaffold(
      backgroundColor: kDarkGreen,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 0.7.h),
                child: Text('ADVERTISEMENT', style: TextStyle(color: Colors.white38, fontSize: 11.sp, letterSpacing: 2)),
              ),
              Container(
                width: boxWidth,
                height: boxHeight,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
                alignment: Alignment.center,
                child: SizedBox(width: innerWidth, height: innerHeight, child: HtmlElementView(viewType: _viewType)),
              ),
              SizedBox(height: 3.2.h),
              SizedBox(
                width: 11.7.w,
                height: 11.7.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(color: kGold, value: 1 - (_secondsLeft / _adSeconds), strokeWidth: 3),
                    Text('$_secondsLeft', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
              Text('Tasveer khulne wali hai...', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

// Full-screen, zoomable image dialog — sirf isi file ke andar use hota hai.
class _FullImageDialog extends StatelessWidget {
  final String imagePath;
  const _FullImageDialog({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(2.7.w),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 32.h,
                  alignment: Alignment.center,
                  child: Icon(Icons.broken_image_rounded, color: Colors.white38, size: 50.sp),
                ),
              ),
            ),
          ),
          Positioned(
            top: 1.h,
            right: 2.1.w,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
