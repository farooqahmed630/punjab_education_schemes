import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';

// Privacy/About/Contact pages ke liye chote reusable pieces —
// icon badge, section heading, paragraph, aur bullet line.

Widget pageIntroBadge(IconData icon) {
  return Container(
    width: 13.9.w,
    height: 13.9.w,
    decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryGreen.withOpacity(0.10)),
    child: Icon(icon, color: kPrimaryGreen, size: 26.sp),
  );
}

Widget sectionHeading(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 2.2.h, bottom: 1.h),
    child: Row(
      children: [
        Container(width: 1.1.w, height: 2.h, decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 2.1.w),
        Text(text, style: TextStyle(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: kDarkGreen)),
      ],
    ),
  );
}

Widget paragraph(String text) {
  return Text(text, style: TextStyle(fontSize: 13.5.sp, height: 1.65, color: Colors.black87));
}

Widget bulletLine(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 0.7.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.7.h),
          child: Icon(Icons.circle, size: 6.sp, color: kGold),
        ),
        SizedBox(width: 2.7.w),
        Expanded(child: paragraph(text)),
      ],
    ),
  );
}
