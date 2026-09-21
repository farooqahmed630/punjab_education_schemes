import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'app.dart';

void main() {
  _injectAdsterraInterstitial();
  runApp(const PunjabSchemesApp());
}

// Adsterra ke interstitial/social-bar/popunder scripts khud apna
// overlay dikhate hain — bas ek <script> tag page ke <head> mein
// lagana hota hai. App start hote hi document ke head mein inject
// ho jata hai.
void _injectAdsterraInterstitial() {
  if (kAdsterraInterstitialZoneKey == 'YOUR_ADSTERRA_INTERSTITIAL_ZONE_KEY_HERE') {
    return;
  }
  final script = html.ScriptElement()
    ..type = 'text/javascript'
    ..src = 'https://www.highperformanceformat.com/$kAdsterraInterstitialZoneKey/invoke.js'
    ..async = true;
  html.document.head?.append(script);
}
