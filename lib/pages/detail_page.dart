import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../models/scheme_item.dart';
import '../utils/link_utils.dart';
import 'home_page.dart';

class DetailPage extends StatelessWidget {
  final SchemeItem item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text(item.title, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 2.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.9.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.12), kGold.withOpacity(0.12)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.icon, size: 64.sp, color: kPrimaryGreen),
                ),
                SizedBox(height: 2.7.h),
                Text(item.title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: kDarkGreen)),
                SizedBox(height: 1.5.h),
                Text(item.fullDetail, style: TextStyle(fontSize: 14.sp, height: 1.6, color: Colors.black87)),
                SizedBox(height: 3.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.7.w, vertical: 1.7.h),
                  decoration: BoxDecoration(color: kGold.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: kGold.withOpacity(0.4))),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: kGold),
                      SizedBox(width: 2.7.w),
                      Expanded(
                        child: Text(
                          'Eligibility aur apply karne ka tareeqa Punjab Govt ki official website se verify karen — details waqt ke sath update hoti rehti hain.',
                          style: TextStyle(fontSize: 11.5.sp, color: kDarkGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.2.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryGreen,
                      side: const BorderSide(color: kPrimaryGreen),
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: Icon(Icons.open_in_new_rounded, size: 18.sp),
                    label: const Text('Official Website Par Jayen'),
                    onPressed: () => openOfficialLink(context, item.officialUrl),
                  ),
                ),
                SizedBox(height: 1.5.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
                    },
                    child: Text('Home pe wapas jayen', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
