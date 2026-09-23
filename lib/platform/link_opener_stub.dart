// MOBILE/DESKTOP (non-web) ke liye — external browser mein link kholta
// hai `url_launcher` package se. Agar pubspec.yaml mein url_launcher
// add nahi hai, to `flutter pub add url_launcher` chala lein.
import 'package:url_launcher/url_launcher.dart' as launcher;

Future<bool> tryOpenLink(String url) async {
  final uri = Uri.parse(url);
  return launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
}
