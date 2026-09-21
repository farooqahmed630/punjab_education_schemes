import 'package:flutter/material.dart';

class SchemeItem {
  final String title;
  final String shortDesc;
  final String fullDetail;
  final IconData icon;
  final String officialUrl;
  // Optional — agar diya jaye to card ke upar icon ki jagah ye image
  // dikhti hai (jaise 'assets/cmlaptopscheme.jpg'). Null/empty rahe to
  // card wapas normal gradient+icon placeholder dikhata hai.
  final String? imageAsset;

  const SchemeItem({
    required this.title,
    required this.shortDesc,
    required this.fullDetail,
    required this.icon,
    this.officialUrl = '',
    this.imageAsset,
  });
}
