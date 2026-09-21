import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../models/scheme_item.dart';
import '../pages/ad_page.dart';
import '../config/app_config.dart';

class SchemeCard extends StatelessWidget {
  final SchemeItem item;
  const SchemeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary: is card ka apna gradient/shadow/InkWell splash hai.
    // Bina isolation ke, ek card ke andar koi bhi repaint (jaise InkWell
    // tap ripple) puri grid ke repaint ko trigger kar sakta hai. Har
    // card ko apni alag repaint layer dene se sirf wahi card repaint
    // hota hai — baaqi grid untouched rehti hai, scroll aur zyada smooth.
    //
    // FIX: pehle image/title/description ki width fixed `.w` (poori
    // SCREEN width ka %) se set hoti thi — cell ki apni actual width se
    // koi lena dena nahi tha. Jab mobile par grid 1-column ho gaya
    // (poori-width wali card), to image/text ab bhi sirf ~45-53% SCREEN
    // width jitne chhote rahe, jabke card khud bohot zyada wide thi —
    // is wajah se image chhoti dikhti thi aur text ek tang column mein
    // ek-ek word karke wrap ho raha tha ("one word per line"). Ab
    // LayoutBuilder se cell ki ASAL available width nikal kar image aur
    // text ki width usi ke hisaab se (%) set karte hain — chahe grid 1
    // column ho ya 4, dono hamesha cell ke hisaab se sahi proportion
    // mein render honge.
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (kDebugMode) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              debugPrint('[PERF] SchemeCard "${item.title}" rebuilt.');
            });
            debugPrint('[PERF] SchemeCard "${item.title}" cell constraints: '
                '${constraints.maxWidth.toStringAsFixed(1)} x ${constraints.maxHeight.toStringAsFixed(1)}');
          }
          return _buildCard(context, constraints.maxWidth);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, double cellWidth) {
    // Image aur text ki width ab is cell ki actual width ke % se nikalti
    // hai (screen width ke % se nahi) — is liye single-column (poori
    // width) card par image bhi bari aur text bhi poori chaudi (wide)
    // dikhega, aur multi-column grid mein bhi apne chhote cell ke
    // hisaab se sahi proportion mein fit hoga.
    // Image ab thori bari (0.62 -> 0.78 of cell width).
    final double imageSize = cellWidth * 0.78;
    final double textWidth = cellWidth * 0.92;

    // FIX: pehle kIsWeb se font size decide hoti thi — lekin kIsWeb sirf
    // itna batata hai ke build "web" hai ya "native app", ye nahi ke
    // screen chhoti (phone) hai ya bari (desktop). Jab website ko phone
    // ke browser mein khola jata, wahan bhi kIsWeb=true hi rehta hai —
    // is liye phone (mobile web) par bhi hamesha "web" wale chhote font
    // dikhte thay, size change ka asar nahi hota tha. Ab asal SCREEN
    // WIDTH check kar rahe hain (wahi breakpoint jo grid ke columns
    // decide karta hai) — chahe app ho ya browser, chhoti (phone-width)
    // screen par bara font, bari (desktop) screen par chhota font.
    final bool isNarrowScreen = MediaQuery.of(context).size.width < kMobileBreakpoint;
    final double titleFontSize = isNarrowScreen ? 27.sp : 18.sp;
    final double descFontSize = isNarrowScreen ? 20.sp : 14.sp;
    final double buttonFontSize = isNarrowScreen ? 24.sp : 15.sp;
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
            // Vertical padding thori kam kar di (1.4.h -> 0.7.h) — margin
            // thora tight, lekin ab bhi content top/bottom edge se
            // bilkul chipka hua nahi.
            padding: EdgeInsets.symmetric(horizontal: 2.7.w, vertical: 0.7.h),
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
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                            // Chhoti size par hi decode — grid mein bohot
                            // saare cards hote hain, full-res decode se
                            // scroll slow ho sakti hai.
                            cacheWidth: 320,
                            cacheHeight: 320,
                            errorBuilder: (_, __, ___) => Container(
                              width: imageSize * 0.48,
                              height: imageSize * 0.48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image_rounded, color: kPrimaryGreen, size: 28.sp),
                            ),
                          )
                        : Container(
                            width: imageSize * 0.2,
                            height: imageSize * 0.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                            ),
                          ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      // Font size pehle 20.5.sp thi — bohot bari, jis
                      // wajah se FittedBox ko bohot zyada scale-down
                      // karna padta tha (blur + slow scroll ki wajah).
                      // Sensible size par le aaya.
                      style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w900, color: kDarkGreen),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      item.shortDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: descFontSize, fontWeight: FontWeight.w700, color: Colors.black54, height: 1.3),
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                  Container(height: 1, width: 6.4.w, color: kGold.withOpacity(0.5)),
                  SizedBox(height: 1.7.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 1.1.h),
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Apply Now',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: buttonFontSize),
                    ),
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