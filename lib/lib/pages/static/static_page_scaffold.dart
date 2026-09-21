import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';

// Shared scaffold jo Privacy Policy / About Us / Contact Us teeno
// static pages use karte hain — sirf title aur body children pass
// karne hote hain.
class StaticPageScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const StaticPageScaffold({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 2.5.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ),
      ),
    );
  }
}
