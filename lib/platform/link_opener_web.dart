import 'dart:html' as html;

Future<bool> tryOpenLink(String url) async {
  final newWindow = html.window.open(url, '_blank');
  if (newWindow == null) {
    html.window.location.href = url;
  }
  return true;
}
