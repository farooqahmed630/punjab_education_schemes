import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../config/app_config.dart';
import '../models/scheme_item.dart';
import '../data/scheme_data.dart';
import '../widgets/hero_header.dart';
import '../widgets/mobile_nav_drawer.dart';
// import '../widgets/cm_vision_card.dart'; // CM Vision card disabled
import '../widgets/image_carousel_section.dart';
import '../widgets/scheme_card.dart';
import '../widgets/site_footer.dart';
import '../widgets/section_heading.dart';
import '../widgets/adsterra_banner.dart';
class HomePage extends StatefulWidget {
const HomePage({super.key});
@override
State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
String _searchQuery = '';

// ---- DEBUG ONLY: scroll/rebuild diagnostics, no behavior change ----
int _buildCount = 0;
int _jankyFramesDuringScroll = 0;

// FIX: pehle `_isScrolling` ek plain bool tha jise `setState()` se
// update kiya jata tha. Us se HAR scroll start/end par PUURA HomePage
// dobara build hota tha — jis wajah se grid ke saare currently-visible
// SchemeCard bhi bewajah rebuild ho rahe thay (logs mein har scroll ke
// sath "HomePage.build()" aur 5 "SchemeCard ... rebuilt" dikh rahe
// thay), aur yehi naye janky frames (34ms, 17ms build) ki wajah thi.
// Ab ValueNotifier use kar rahe hain: iski value change hone par SIRF
// wo widget rebuild hota hai jo ise `ValueListenableBuilder` se sun
// raha ho (neeche sirf AdsterraBanner) — baaqi poora page (HeroHeader,
// grid cards) bilkul untouched rehta hai.
final ValueNotifier<bool> _scrollingNotifier = ValueNotifier<bool>(false);
bool get _isScrolling => _scrollingNotifier.value;

@override
void initState() {
  super.initState();
  if (kDebugMode) {
    SchedulerBinding.instance.addTimingsCallback((timings) {
      if (!_isScrolling) return; // sirf actual scroll ke dauran count/print karo
      for (final t in timings) {
        final buildMs = t.buildDuration.inMicroseconds / 1000.0;
        final rasterMs = t.rasterDuration.inMicroseconds / 1000.0;
        // 16.6ms budget for 60fps — anything above means a dropped/janky frame.
        if (buildMs > 16.0 || rasterMs > 16.0) {
          _jankyFramesDuringScroll++;
          debugPrint('[PERF][SCROLLING] JANKY FRAME #$_jankyFramesDuringScroll -> build: ${buildMs.toStringAsFixed(1)}ms, raster: ${rasterMs.toStringAsFixed(1)}ms');
        }
      }
    });
  }
}

@override
void dispose() {
  _scrollingNotifier.dispose();
  super.dispose();
}

// NotificationListener: batata hai scroll kab shuru/khatam hua, aur
// scroll khatam hone par total janky-frame count print karta hai.
// NOTE: ye ab sirf debug logging ke liye nahi — `_scrollingNotifier` ab
// AdsterraBanner ko bhi diya jata hai (neeche build() mein) taake
// active scroll ke dauran real <iframe> ad ki jagah ek halka static
// placeholder dikhaya jaye. Isi wajah se ye function ab kDebugMode ke
// bina bhi chalta hai; sirf debugPrint() calls kDebugMode mein hain.
// IMPORTANT: yahan `setState()` bilkul use nahi hota — ValueNotifier
// khud apne listeners ko notify kar deta hai, is liye HomePage ka
// build() is se dobara trigger nahi hota.
bool _onScrollNotification(ScrollNotification n) {
  if (n is ScrollStartNotification) {
    _scrollingNotifier.value = true;
    _jankyFramesDuringScroll = 0;
    if (kDebugMode) {
      debugPrint('[PERF][SCROLLING] scroll started at pixel ${n.metrics.pixels.toStringAsFixed(1)}');
    }
  } else if (n is ScrollUpdateNotification) {
    if (kDebugMode) {
      debugPrint('[PERF][SCROLLING] pos=${n.metrics.pixels.toStringAsFixed(1)}');
    }
  } else if (n is ScrollEndNotification) {
    if (kDebugMode) {
      debugPrint('[PERF][SCROLLING] scroll ended at pixel ${n.metrics.pixels.toStringAsFixed(1)} — total janky frames this scroll: $_jankyFramesDuringScroll');
      if (_jankyFramesDuringScroll == 0) {
        debugPrint('[PERF][SCROLLING] ✅ 0 janky frames — SliverAppBar removal fixed the scroll.');
      } else {
        debugPrint('[PERF][SCROLLING] ⚠️ still $_jankyFramesDuringScroll janky frame(s) — some other widget is rebuilding on scroll, check HeroHeader/HomePage build counts above.');
      }
    }
    _scrollingNotifier.value = false;
  }
  return false;
}
// ---------------------------------------------------------------------


List<SchemeItem> get _filteredItems {
final q = _searchQuery.trim().toLowerCase();
if (q.isEmpty) return schemeItems;
return schemeItems
.where((s) => s.title.toLowerCase().contains(q) || s.shortDesc.toLowerCase().contains(q))
.toList();
}
@override
Widget build(BuildContext context) {
final filtered = _filteredItems;
_buildCount++;
if (kDebugMode) {
  debugPrint('[PERF] HomePage.build() called (count=$_buildCount) — should stay flat while scrolling, not climb every frame.');
}


// Column count sirf screen WIDTH par depend karta hai, isay yahan
// ek hi baar nikal lete hain (MediaQuery se) — pehle ye
// SliverLayoutBuilder ke andar tha, jiska builder Flutter mein
// scrollOffset badalte hi (yani HAR scroll frame par) dobara chalta
// hai. Isi wajah se poori grid section baar baar rebuild ho rahi
// thi aur scroll slow/janky lag raha tha. Ab ye sirf resize par
// dobara chalega, scroll par bilkul nahi.
final screenWidth = MediaQuery.of(context).size.width;
int columns = 2;
if (screenWidth >= 1100) {
  columns = 4;
} else if (screenWidth >= 750) {
  columns = 3;
} else if (screenWidth < kMobileBreakpoint) {
  // Mobile view (same breakpoint HeroHeader/MobileNavDrawer use) —
  // 2 chhoti-chhoti cards ki jagah ab ek hi, poori-width wali card
  // per row dikhti hai — jo request ki gayi thi.
  columns = 1;
}
// NOTE: SchemeCard ki image thori bari (0.62 -> 0.78 of cell width) aur
// card ke andar top/bottom padding bhi barha di gayi hai (margin ke
// liye) — is extra content ko FittedBox se bohot zyada scale-down hue
// baghair fit karne ke liye har column-count ka aspectRatio (width/
// height) thora kam kar diya gaya hai, taake cell/card thori zyada
// tall (bari) ho.
double aspectRatio = 0.52;
if (columns == 1) {
  // Single column: card ab poori screen-width jitni wide hai (2-column
  // wale se roughly double), is liye aspectRatio (width/height) bhi
  // us hisaab se zyada rakha — warna card bewajah bohot lamba/tall
  // dikhta.
  // Description font ab kaafi bari (32.sp) hai — 0.78 is content ke
  // liye kaafi kam tha, is liye FittedBox sab kuch wapas scale-down kar
  // deta tha aur font size ka increase dikhta hi nahi tha. Cell ko
  // kaafi taller kar diya (0.78 -> 0.42) taake ye bara text bina
  // scale-down hue apne asal size par fit ho jaye.
  aspectRatio = 0.42;
} else if (columns == 2) {
  // Pehle 0.54 tha — cell height content (220px+ image + 3-line title +
  // description + divider + button) ke liye kaafi kam padti thi, is
  // liye FittedBox ko bohot zyada scale-down karna parta tha (blur +
  // slow scroll ki asal wajah). Ab cell zyada taller hai taake content
  // apne natural (ya us ke qareeb) size par fit ho jaye.
  aspectRatio = 0.34;
} else if (columns == 3) {
  aspectRatio = 0.45;
}

return Scaffold(
  endDrawer: const MobileNavDrawer(),
  body: NotificationListener<ScrollNotification>(
    onNotification: _onScrollNotification,
    child: CustomScrollView(
    // FIX: pehle off-screen grid cards sirf tab build hote thay jab wo
    // viewport ke bilkul kareeb aate — is se woh build/layout cost
    // usi scroll frame ke budget (16ms) mein aa jati thi aur occasional
    // janky frame dikhta tha (logs mein "SchemeCard ... rebuilt" wale
    // frames). cacheExtent badha kar Flutter ko batate hain ke
    // viewport ke aage-peeche itne pixels ke items PEHLE (idle time
    // mein) build/layout kar le — jab tak wo scroll mein nazar aayen,
    // unka kaam pehle se ho chuka hota hai.
    cacheExtent: 1200,
    slivers: [
      // SliverAppBar hata diya gaya hai. SliverAppBar/FlexibleSpaceBar
      // scroll ke dauran apni geometry (collapse %, shrink offset) har
      // frame recalculate karta hai, aur ye value FlexibleSpaceBar ke
      // through HeroHeader tak internally propagate hoti thi — jis se
      // andar wala FittedBox baar baar re-layout hota tha aur scroll
      // slow/janky mehsoos hota tha. Ab HeroHeader ek plain
      // SliverToBoxAdapter mein hai: ye sirf ek dafa layout hota hai
      // aur scroll ke dauran dobara measure/rebuild nahi hota — simple
      // aur fast. (Header ab normal page content ki tarah upar scroll
      // ho kar chala jayega, pinned/sticky nahi rahega.)
      SliverToBoxAdapter(
        // FIX: pehle SliverAppBar ka `expandedHeight: 35.h` HeroHeader ko
        // ek fixed height deta tha. SliverToBoxAdapter khud koi height
        // force nahi karta — andar Column (crossAxisAlignment: stretch)
        // ko is wajah se UNBOUNDED height mil rahi thi, jo RenderFlex
        // layout crash (white screen) kar raha tha. SizedBox se wahi
        // fixed height wapas de di.
        child: SizedBox(
          height: 35.h,
          child: HeroHeader(
            onSearchChanged: (q) => setState(() => _searchQuery = q),
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 2.5.h)),
      // CM Vision card — temporarily disabled by request. Re-enable
      // by uncommenting these three slivers below.
      // SliverToBoxAdapter(child: dividedHeading('CM Vision', color: Colors.black)),
      // const SliverToBoxAdapter(child: SizedBox(height: 12)),
      // const SliverToBoxAdapter(
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 14),
      //     child: CmVisionCard(),
      //   ),
      // ),
      // const SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(child: dividedHeading('Schemes & Scholarships')),
      SliverToBoxAdapter(child: SizedBox(height: 2.h)),
      if (filtered.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.2.h),
            child: Center(
              child: Text('Koi scheme nahi mili.', style: TextStyle(color: Colors.black45, fontSize: 13.sp)),
            ),
          ),
        )
      else
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 2.7.w, vertical: 0.5.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 2.7.w,
              mainAxisSpacing: 1.7.h,
              childAspectRatio: aspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = filtered[index];
                return SchemeCard(item: item);
              },
              childCount: filtered.length,
            ),
          ),
        ),
      const SliverToBoxAdapter(child: RepaintBoundary(child: ImageCarouselSection())),
      SliverToBoxAdapter(child: SizedBox(height: 3.4.h)),
      SliverToBoxAdapter(
        child: RepaintBoundary(
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _scrollingNotifier,
              builder: (context, isScrolling, _) {
                return AdsterraBanner(zoneKey: kAdsterraHomeBannerZoneKey, isScrolling: isScrolling);
              },
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 2.5.h)),
      const SliverToBoxAdapter(child: SiteFooter()),
    ],
  ),
),
);
}
}