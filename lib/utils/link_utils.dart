import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../platform/link_opener.dart';

// Official website ka link kholta hai. Web par naya tab khulta hai
// (dart:html), phone app par external browser khulta hai (url_launcher).
// NOTE: phone build ke liye pubspec.yaml mein `url_launcher` add karna
// hoga: `flutter pub add url_launcher`
Future<void> openOfficialLink(BuildContext context, String url) async {
  debugPrint('[openOfficialLink] pressed. url="$url"');

  if (url.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Official website ka link jald add kiya jayega.'), backgroundColor: kDarkGreen),
    );
    return;
  }
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ye link open nahi ho saka.'), backgroundColor: Colors.redAccent),
    );
    return;
  }
  try {
    await tryOpenLink(url);
  } catch (e, st) {
    debugPrint('[openOfficialLink] ERROR: $e\n$st');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link kholte waqt error aayi: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }
}
