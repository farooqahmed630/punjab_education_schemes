import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../config/app_config.dart';
import '../models/scheme_item.dart';
import '../platform/ad_iframe_registrar.dart';
import 'detail_page.dart';

// Scheme card pe click hone ke baad ye ad page dikhti hai. 5 second
// baad khud DetailPage pe navigate ho jati hai.
class AdPage extends StatefulWidget {
  final SchemeItem item;
  const AdPage({super.key, required this.item});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  static const int _adSeconds = 5;
  int _secondsLeft = _adSeconds;
  Timer? _timer;
  String? _viewType;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _viewType = registerAdIframeView(
        zoneKey: kAdsterraZoneKey,
        width: 300,
        height: 250,
      );
    }
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
        _showAfterAdDialog();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _showAfterAdDialog() {
    if (_dialogShown) return;
    _dialogShown = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DetailPage(item: widget.item)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth < 340 ? screenWidth - 32 : 320.0;
    final boxHeight = boxWidth * 266 / 320;
    final innerWidth = boxWidth - 16;
    final innerHeight = innerWidth * 250 / 300;
    return Scaffold(
      backgroundColor: kDarkGreen,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 0.7.h),
                child: Text('ADVERTISEMENT', style: TextStyle(color: Colors.white38, fontSize: 11.sp, letterSpacing: 2)),
              ),
              Container(
                width: boxWidth,
                height: boxHeight,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
                alignment: Alignment.center,
                child: SizedBox(
                  width: innerWidth,
                  height: innerHeight,
                  child: (kIsWeb && _viewType != null)
                      ? HtmlElementView(viewType: _viewType!)
                      : const SizedBox.shrink(),
                ),
              ),
              SizedBox(height: 3.2.h),
              SizedBox(
                width: 11.7.w,
                height: 11.7.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(color: kGold, value: 1 - (_secondsLeft / _adSeconds), strokeWidth: 3),
                    Text('$_secondsLeft', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
              Text('Ad chal rahi hai...', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
