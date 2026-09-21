import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../pages/static/privacy_policy_page.dart';
import '../pages/static/about_us_page.dart';
import '../pages/static/contact_us_page.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  Widget _footerLink(BuildContext context, String label, Widget page) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: kGoldLight,
        padding: EdgeInsets.symmetric(horizontal: 2.1.w, vertical: 0.5.h),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Text(label, style: TextStyle(fontSize: 14.sp)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 3.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [kPrimaryGreen, kDarkGreen]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.school_rounded, color: kGoldLight, size: 30.sp),
          SizedBox(height: 1.h),
          Text(
            'Punjab Education Schemes',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Ye ek independent informational platform hai. Har scheme ki eligibility\naur apply karne ka tareeqa official Punjab Govt website se verify karen.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18.5.sp, height: 1.5),
          ),
          SizedBox(height: 1.5.h),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              _footerLink(context, 'Privacy Policy', const PrivacyPolicyPage()),
              _footerLink(context, 'About Us', const AboutUsPage()),
              _footerLink(context, 'Contact Us', const ContactUsPage()),
            ],
          ),
          SizedBox(height: 1.2.h),
          Container(height: 1, width: 16.w, color: Colors.white24),
          SizedBox(height: 1.2.h),
          Text(
            '© 2026 Punjab Education Schemes. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
