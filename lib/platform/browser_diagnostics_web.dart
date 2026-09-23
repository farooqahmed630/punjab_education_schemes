// WEB build ke liye asal implementation — dart:html sirf isi file mein
// import hoti hai, aur ye file sirf web par hi conditional import se
// select hoti hai (dekhein browser_diagnostics.dart).

import 'dart:html' as html;

import 'browser_diagnostics_model.dart';

export 'browser_diagnostics_model.dart';

BrowserDiagnostics readBrowserDiagnostics() {
  return BrowserDiagnostics(
    devicePixelRatio: html.window.devicePixelRatio,
    screenWidth: (html.window.screen?.width ?? 0).toDouble(),
    innerWidth: (html.window.innerWidth ?? 0).toDouble(),
    innerHeight: (html.window.innerHeight ?? 0).toDouble(),
    isFakeUserAgent: html.window.navigator.userAgent.contains('fake'),
  );
}

CanvasSize? findCanvasSize() {
  final glassPane = html.document.querySelector('flt-glass-pane');
  final canvasEl = glassPane?.querySelector('canvas');
  if (canvasEl == null) return null;
  final canvas = canvasEl as html.CanvasElement;
  return CanvasSize(
    width: canvas.width ?? 0,
    height: canvas.height ?? 0,
    cssWidth: canvas.style.width,
    cssHeight: canvas.style.height,
  );
}
