import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';
import 'static_page_scaffold.dart';
import 'static_page_helpers.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaticPageScaffold(
      title: 'Contact Us',
      children: [
        Row(
          children: [
            pageIntroBadge(Icons.chat_bubble_rounded),
            SizedBox(width: 3.2.w),
            Expanded(
              child: Text(
                'Sawal ho, feedback ho, ya kisi scheme ki maloomat mein correction chahiye — hum sunne ke liye maujood hain.',
                style: TextStyle(fontSize: 12.5.sp, color: Colors.black54, height: 1.5),
              ),
            ),
          ],
        ),
        sectionHeading('Rabta Karen'),
        paragraph('Neeche diye gaye zarayein se hum tak pohanch sakte hain:'),
        SizedBox(height: 1.7.h),
        const _ContactRow(icon: Icons.email_outlined, label: '123fam@gmail.com'),
        SizedBox(height: 1.2.h),
        const _ContactRow(icon: Icons.language_rounded, label: 'www.eduinfo.com'),
        SizedBox(height: 1.2.h),
        const _ContactRow(icon: Icons.schedule_rounded, label: 'Hum aam tor par 24-48 ghanton mein jawab dete hain.'),
        sectionHeading('Scheme Suggest Karen'),
        paragraph('Agar aapko koi aisi education scheme maloom hai jo abhi is list mein shamil nahi hai, to hamein uska naam aur agar mumkin ho to official link bhej dijiye — hum use review karke add kar denge.'),
        sectionHeading('Correction Report Karen'),
        paragraph('Agar kisi scheme ki details (jaise eligibility ya deadline) purani ya ghalat lag rahi hain, to please humein wo detail aur uska sahi/updated source bata dein, taake hum jald se jald theek kar saken.'),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ContactRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.7.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryGreen.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryGreen, size: 18.sp),
          SizedBox(width: 2.7.w),
          Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.black87))),
        ],
      ),
    );
  }
}
