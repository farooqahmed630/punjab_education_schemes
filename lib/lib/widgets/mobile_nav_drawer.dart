import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../pages/static/privacy_policy_page.dart';
import '../pages/static/about_us_page.dart';
import '../pages/static/contact_us_page.dart';

class MobileNavDrawer extends StatelessWidget {
  const MobileNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 16,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kDarkGreen, kPrimaryGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5.3.w, 3.h, 5.3.w, 2.5.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.1.w),
                      decoration: BoxDecoration(
                        color: kGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kGoldLight.withOpacity(0.4)),
                      ),
                      child: Icon(Icons.school_rounded, color: kGoldLight, size: 24.sp),
                    ),
                    SizedBox(width: 3.2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Punjab Education',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            'Schemes & Portals',
                            style: GoogleFonts.montserrat(
                              color: kGoldLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: Colors.white70, size: 22.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.7.w),
                child: Column(
                  children: [
                    _drawerLink(
                      context,
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                      const PrivacyPolicyPage(),
                    ),
                    SizedBox(height: 1.h),
                    _drawerLink(
                      context,
                      Icons.info_outline_rounded,
                      'About Us',
                      const AboutUsPage(),
                    ),
                    SizedBox(height: 1.h),
                    _drawerLink(
                      context,
                      Icons.mail_outline_rounded,
                      'Contact Us',
                      const ContactUsPage(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 2.5.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    '© 2026 Punjab Education Schemes\nIndependent Educational Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 11.sp, height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerLink(BuildContext context, IconData icon, String label, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Container(
          padding: EdgeInsets.all(1.6.w),
          decoration: BoxDecoration(
            color: kGold.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kGoldLight, size: 18.sp),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 20.sp),
        dense: true,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
