import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Official website ka link kholta hai (naya browser tab). Flutter WEB
// specific — dart:html.window.open use karta hai. Agar url khali ho
// ya invalid ho to SnackBar se user ko bata deta hai.
void openOfficialLink(BuildContext context, String url) {
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
    final newWindow = html.window.open(url, '_blank');
    if (newWindow == null) {
      html.window.location.href = url;
    }
  } catch (e, st) {
    debugPrint('[openOfficialLink] ERROR: $e\n$st');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link kholte waqt error aayi: $e'), backgroundColor: Colors.redAccent),
    );
  }
}
