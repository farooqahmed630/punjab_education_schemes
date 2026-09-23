import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'app.dart';
import 'platform/adsterra_interstitial_injector.dart';

void main() {
  _injectAdsterraInterstitial();
  runApp(const PunjabSchemesApp());
}

// Adsterra ke interstitial/social-bar/popunder scripts khud apna
// overlay dikhate hain — bas ek <script> tag page ke <head> mein
// lagana hota hai. App start hote hi document ke head mein inject
// ho jata hai. (Sirf Web par kaam karta hai; phone app par ye
// automatically no-op ho jata hai — dekhein platform/adsterra_interstitial_injector.dart)
void _injectAdsterraInterstitial() {
  if (kAdsterraInterstitialZoneKey == 'YOUR_ADSTERRA_INTERSTITIAL_ZONE_KEY_HERE') {
    return;
  }
  injectAdsterraInterstitialScript(kAdsterraInterstitialZoneKey);
}
