import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';

// Home page ke section titles ke liye (jaise "CM Vision",
// "Schemes & Scholarships") — center mein text, dono taraf gold line.
Widget dividedHeading(String text, {Color color = kDarkGreen}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.3.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 4.3.w, height: 2, color: kGold.withOpacity(0.5)),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.1.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.3),
              ),
            ),
          ),
        ),
        Container(width: 4.3.w, height: 2, color: kGold.withOpacity(0.5)),
      ],
    ),
  );
}
