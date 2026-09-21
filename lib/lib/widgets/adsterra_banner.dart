import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

// Reusable Adsterra BANNER widget — kahin bhi use kar sakte hain, bas
// zoneKey/width/height pass karen. Zone key placeholder hone tak
// khali box return karta hai (koi crash nahi).
class AdsterraBanner extends StatefulWidget {
  final String zoneKey;
  final double width;
  final double height;
  const AdsterraBanner({super.key, required this.zoneKey, this.width = 300, this.height = 250});

  @override
  State<AdsterraBanner> createState() => _AdsterraBannerState();
}

class _AdsterraBannerState extends State<AdsterraBanner> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
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
    return SizedBox(width: widget.width, height: widget.height, child: HtmlElementView(viewType: _viewType));
  }
}
