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
          // FIX (BLUR ROOT CAUSE, take 2): pehle yahan sirf maxWidth pass
          // hota tha aur neeche FittedBox(scaleDown) puri Column ko
          // (including text) ek Transform-scale matrix se fit karta tha.
          // Chahe font size ab cellWidth-based ho gaya ho, baaqi content
          // (image size, padding, spacing) ab bhi Sizer ke .h/.w se aata
          // — yani SCREEN ke % se — jabke cell ki apni height alag hoti
          // hai (khaas kar mobile/1-column mode mein, jahan cell bohot
          // tall ho jata hai). Is mismatch ki wajah se FittedBox ka scale
          // factor kabhi bhi bilkul 1.0 nahi ban pata — aur jab tak text
          // kisi bhi Transform-scale ke andar hai (chahe 0.97x hi sahi),
          // browser use apne NATIVE pixel size par render nahi karta,
          // hamesha thora blur rahega. Isi liye FittedBox ko yahan se
          // hata diya gaya hai (neeche dekhein) — ab maxHeight bhi pass
          // kar rahe hain taake Column apni available height ke andar
          // khud fit ho (Expanded + overflow:ellipsis se), kisi scale
          // matrix ki zaroorat hi na pare.
          return _buildCard(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, double cellWidth, double cellHeight) {
    // BLUR FIX (final): font sizes ab fixed (device-independent-pixel)
    // values hain, cellWidth par depend nahi karte — taake grid
    // resize/column-change ke dauran font achanak bara/chota na ho
    // (jaisa debug logs mein cell constraints baar baar badalte dikhe
    // the: 928 -> 559 -> 3202 -> 2.3). Image aur spacing ab `Expanded`
    // aur fixed gaps se aate hain, FittedBox scale ki zaroorat hi khatam
    // ho gayi hai (upar build() mein dekhein) — is liye text hamesha
    // apne native pixel size par render hota hai, crisp rehta hai.
    final bool isNarrowScreen = MediaQuery.of(context).size.width < kMobileBreakpoint;
    final double titleFontSize = isNarrowScreen ? 17.0 : 15.0;
    final double descFontSize = isNarrowScreen ? 13.5 : 12.0;
    final double buttonFontSize = isNarrowScreen ? 14.5 : 13.0;
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
            // Vertical padding thodi badha di gayi hai taake content
            // (image/title/desc/button) card ke top aur bottom edge se
            // ek acha visible margin rakhe, chipka hua na lage.
            padding: EdgeInsets.symmetric(horizontal: 2.7.w, vertical: 1.6.h),
            // OVERFLOW FIX: pehle image ek FIXED AspectRatio (1.05) mein
            // thi. Wo desktop/preview ke bare cell (347px+ tall) par theek
            // dikhti thi, lekin real phone par 1-column grid ka cell
            // sirf ~347px tall nikla aur fixed-size image + title + desc
            // + divider + button sab milakar us se zyada height maang
            // rahe the — isi liye "RenderFlex overflowed by 116 pixels"
            // error aata tha.
            //
            // Fix: image ab `Expanded` mein hai (fixed AspectRatio nahi)
            // — Column pehle title/desc/divider/button ki (fixed,
            // chhoti) height reserve karta hai, aur JO BHI height bachti
            // hai wahi image ko milti hai. Is tarah total height hamesha
            // == available cell height rehti hai — chahe cell 250px tall
            // ho ya 700px, card kabhi overflow nahi karega.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (item.imageAsset != null && item.imageAsset!.isNotEmpty)
                        ? Image.asset(
                            item.imageAsset!,
                            fit: BoxFit.contain,
                            // Chhoti size par hi decode — grid mein bohot
                            // saare cards hote hain, full-res decode se
                            // scroll slow ho sakti hai.
                            cacheWidth: 320,
                            cacheHeight: 320,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_rounded, color: kPrimaryGreen, size: 28),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPrimaryGreen.withOpacity(0.14), kGold.withOpacity(0.14)]),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w900, color: kDarkGreen),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.shortDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: descFontSize, fontWeight: FontWeight.w700, color: Colors.black54, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Center(child: Container(height: 1, width: 46, color: kGold.withOpacity(0.5))),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Apply Now',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: buttonFontSize),
                    ),
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