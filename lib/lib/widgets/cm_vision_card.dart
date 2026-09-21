import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';

class CmVisionCard extends StatelessWidget {
  const CmVisionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kPrimaryGreen.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: kDarkGreen.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Text(
        'Punjab ke har bache tak taleem ki roshni pohanchana hamara khwab hai. Digital Punjab banane ke liye har talib-e-ilm ko laptop ki sahulat di ja rahi hai, aur ghareeb aur mehnati bacchon ke liye Honhaar Scholarship ka aghaz kiya gaya hai. Government schools mein naye teachers ko practical tajurba dene ke sath sath, PEEF ke zariye deserving students ki university taleem ko asaan banaya ja raha hai. TEVTA ke zariye nojawano ko hunar aur rozgar se joda ja raha hai, taake har zilay tak education infrastructure behtar ho aur digital learning Punjab ke dor daraz ilaqon tak bhi pohanch sake. Talba ki mehnat ko sarkari sarparasti aur wasail deti hui, ek parhe likhe aur khushal Punjab ki taameer hi hamara maqsad hai.',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 18.5.sp,
          height: 1.85,
          color: kPrimaryGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
