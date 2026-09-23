// Platform-agnostic data models. Ye file kisi bhi platform (web/android/ios)
// pe safely import ho sakti hai — koi dart:html nahi hai isme.

class BrowserDiagnostics {
  final double devicePixelRatio;
  final double screenWidth;
  final double innerWidth;
  final double innerHeight;
  final bool isFakeUserAgent;

  const BrowserDiagnostics({
    this.devicePixelRatio = 0,
    this.screenWidth = 0,
    this.innerWidth = 0,
    this.innerHeight = 0,
    this.isFakeUserAgent = false,
  });
}

class CanvasSize {
  final int width;
  final int height;
  final String cssWidth;
  final String cssHeight;

  const CanvasSize({
    required this.width,
    required this.height,
    required this.cssWidth,
    required this.cssHeight,
  });
}
