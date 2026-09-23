// WEB build ke liye asal implementation. dart:html / dart:ui_web sirf
// isi file mein import hoti hain.

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

String? registerAdIframeView({
  required String zoneKey,
  required int width,
  required int height,
}) {
  final viewType =
      'adsterra-banner-$zoneKey-${DateTime.now().microsecondsSinceEpoch}';
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '${width}px'
      ..style.height = '${height}px'
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
    'key' : '$zoneKey',
    'format' : 'iframe',
    'height' : $height,
    'width' : $width,
    'params' : {}
  };
</script>
<script type="text/javascript" src="https://www.highperformanceformat.com/$zoneKey/invoke.js"></script>
</body>
</html>
''';
    return iframe;
  });
  return viewType;
}
