import 'dart:html' as html;

void injectAdsterraInterstitialScript(String zoneKey) {
  final script = html.ScriptElement()
    ..type = 'text/javascript'
    ..src = 'https://www.highperformanceformat.com/$zoneKey/invoke.js'
    ..async = true;
  html.document.head?.append(script);
}
