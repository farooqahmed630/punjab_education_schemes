import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../config/app_config.dart';
import 'hover_link.dart';
import 'hover_icon_button.dart';
import '../pages/static/privacy_policy_page.dart';
import '../pages/static/about_us_page.dart';
import '../pages/static/contact_us_page.dart';

// Green curved header — top row mein (mobile pe hamburger, desktop pe
// Privacy/About/Contact links + search), niche naam/designation +
// CM ki tasveer.
class HeroHeader extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  const HeroHeader({super.key, required this.onSearchChanged});

  @override
  State<HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<HeroHeader> {
  bool _searchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    final opening = !_searchOpen;
    setState(() => _searchOpen = opening);
    if (!opening) {
      _searchController.clear();
      widget.onSearchChanged('');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    // ---- DEBUG ONLY: if this count keeps climbing WHILE you scroll
    // (not just on search-toggle/resize), the SliverAppBar pin fix is
    // not actually stopping rebuilds and the FittedBox text inside is
    // being re-measured every frame — which explains both the slow
    // scroll and the blur. ----
    _buildCount++;
    if (kDebugMode) {
      debugPrint('[PERF] HeroHeader.build() called (count=$_buildCount)');
    }
    // RepaintBoundary: is header ke andar gradient + ClipPath + shadows +
    // image hain, jo SliverAppBar collapse hote waqt har scroll-frame pe
    // repaint/opacity-composite hote hain. Isay isolate karne se scroll
    // ke dauran baqi page ka repaint load kam hota hai — phone pe scroll
    // zyada smooth mehsoos hoga.
    return RepaintBoundary(
      child: ClipPath(
      clipper: _HeaderCurveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kDarkGreen, kPrimaryGreen],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -6.h,
              right: -8.w,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -4.h,
              left: -6.w,
              child: Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGold.withOpacity(0.10),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                // stretch: top-row (drawer icon / links) ko poori width
                // deta hai. Bina is ke, Row apni "min" width le kar
                // Column ke default center-alignment ki wajah se BEECH
                // mein chala jata tha (phone mode ka bug).
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TOP ACTION BAR (Drawer Icon / Desktop Links)
                  // FittedBox: agar kabhi bhi (real chhoti screen ho ya
                  // browser window resize ke dauran ek transient glitch
                  // frame) available width kam pad jaye, ye content ko
                  // crash karne ki bajaye bas chhota kar deta hai — koi
                  // "RenderFlex overflowed" error nahi aayega.
                  Padding(
                    // vertical padding thodi barha di (0.5.h -> 1.8.h)
                    // taake drawer/menu icon thora niche shift ho jaye.
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Builder(
                        builder: (context) {
                          final isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;

                          if (isMobile) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                HoverIconButton(
                                  icon: Icons.menu_rounded,
                                  // Pehle 16.sp (default) tha — ab bara
                                  // kar diya taake phone pe zyada
                                  // visible/tappable ho.
                                  size: 26.sp,
                                  onTap: () => Scaffold.of(context).openEndDrawer(),
                                ),
                              ],
                            );
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!_searchOpen)
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    HoverLink(
                                      label: 'Privacy Policy',
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    HoverLink(
                                      label: 'About Us',
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const AboutUsPage()),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    HoverLink(
                                      label: 'Contact Us',
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const ContactUsPage()),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  width: 22.w,
                                  height: 4.0.h,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: kPrimaryGreen,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search_rounded, color: Colors.white, size:11.sp),
                                      SizedBox(width: 1.1.w),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          autofocus: true,
                                          onChanged: widget.onSearchChanged,
                                          cursorColor: Colors.white,
                                          style: TextStyle(fontSize: 10.5.sp, color: Colors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Search Kre...',
                                            hintStyle: TextStyle(fontSize: 10.5.sp, color: Colors.white60),
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(width: 2.w),
                              HoverIconButton(
                                icon: _searchOpen ? Icons.close_rounded : Icons.search_rounded,
                                onTap: _toggleSearch,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // LEFT-ALIGNED Titles & CM Image
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        // bottom: extra safe margin — header ka curve
                        // (_HeaderCurveClipper) left/right edges par 30px
                        // CHHOTA hai (sirf center mein poori height tak
                        // jata hai). Content yahan left-aligned hai, is
                        // liye bina is margin ke badge/image us "kate
                        // hue" zone mein chala jata tha aur green shade
                        // ke neeche hide ho jata tha (web/wide screens
                        // par zyada nazar aata tha).
                        padding: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 4.h),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---------------- FIRST COLUMN: TITLES ----------------
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Maryam Nawaz Sharif',
                                    maxLines: 1,
                                    // Font size pehle 38.sp thi — bohot
                                    // bari, jis wajah se FittedBox ko har
                                    // header render par bohot zyada
                                    // scale-down karna padta tha (yehi
                                    // blur + slow-scroll ki asal wajah
                                    // thi). Sensible size par le aaya.
                                    style: GoogleFonts.playfairDisplay(
                                      color: Colors.white,
                                      fontSize: 36.5.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  SizedBox(height: 4.5.h),
                                  Text(
                                    'Chief Minister, Punjab',
                                    maxLines: 1,
                                    style: GoogleFonts.montserrat(
                                      color: kGoldLight,
                                      fontSize: 26.5.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(height: 4.6.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.1.w, vertical: 0.3.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white24, width: 0.7),
                                    ),
                                    child: Text(
                                      'Education Schemes & Programs',
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 6.1.w),

                              // ---------------- NEXT COLUMN: CM IMAGE ----------------
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.2.h),
                                child: Container(
                                  padding: EdgeInsets.all(0.8.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [kGoldLight, kGold],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kGold.withOpacity(0.40),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 48.w,
                                    height: 48.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/cm_image.png',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        // Display size par hi decode karta hai —
                                        // full-res source image ko baar baar
                                        // decode/paint karne se scroll slow
                                        // hota hai, ye us cost ko kam karta hai.
                                        cacheWidth: 360,
                                        cacheHeight: 360,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.person_rounded,
                                          color: kPrimaryGreen,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}