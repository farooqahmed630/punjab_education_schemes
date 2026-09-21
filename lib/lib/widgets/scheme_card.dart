import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../models/scheme_item.dart';
import '../pages/ad_page.dart';

class SchemeCard extends StatelessWidget {
  final SchemeItem item;
  const SchemeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: kPrimaryGreen.withOpacity(0.08),
        highlightColor: kGold.withOpacity(0.06),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AdPage(item: item)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kPrimaryGreen.withOpacity(0.08)),
            boxShadow: [BoxShadow(color: kDarkGreen.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.7.w, vertical: 1.2.h),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Agar item.imageAsset diya gaya hai (jaise pehle card
                  // mein test ke liye) to wahi image dikhti hai; warna
                  // wapas normal gradient placeholder box.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (item.imageAsset != null && item.imageAsset!.isNotEmpty)
                        ? Image.asset(
                            item.imageAsset!,
                            width: 53.3.w,
                            height: 53.3.w,
                            fit: BoxFit.cover,
                            // Chhoti size par hi decode — grid mein bohot
                            // saare cards hote hain, full-res decode se
                            // scroll slow ho sakti hai.
                            cacheWidth: 192,
                            cacheHeight: 192,
                            errorBuilder: (_, __, ___) => Container(
                              width: 25.6.w,
                              height: 25.6.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image_rounded, color: kPrimaryGreen, size: 28.sp),
                            ),
                          )
                        : Container(
                            width: 10.7.w,
                            height: 10.7.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                            ),
                          ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: 45.3.w,
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      // Font size pehle 20.5.sp thi — bohot bari, jis
                      // wajah se FittedBox ko bohot zyada scale-down
                      // karna padta tha (blur + slow scroll ki wajah).
                      // Sensible size par le aaya.
                      style: TextStyle(fontSize: 24.5.sp, fontWeight: FontWeight.w900, color: kDarkGreen),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  SizedBox(
                    width: 45.3.w,
                    child: Text(
                      item.shortDesc,
                      textAlign: TextAlign.center,
                      // Pehle 28.5.sp thi (title se bhi bari!) — yehi
                      // sab se bara blur/slow-scroll culprit tha. Ab
                      // title se chhoti, normal description size.
                      style: TextStyle(fontSize: 24.5.sp, fontWeight: FontWeight.w600, color: Colors.black54, height: 1.3),
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                  Container(height: 1, width: 6.4.w, color: kGold.withOpacity(0.5)),
                  SizedBox(height: 0.7.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mazeed Detail', style: TextStyle(color: kGold, fontWeight: FontWeight.w900, fontSize: 22.5.sp)),
                      SizedBox(width: 0.8.w),
                      Icon(Icons.arrow_forward_rounded, color: kGold, size: 22.sp),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
