import 'package:flutter/material.dart';
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
}
double aspectRatio = 0.78;
if (columns == 2) {
  aspectRatio = 0.54;
} else if (columns == 3) {
  aspectRatio = 0.68;
}

return Scaffold(
  endDrawer: const MobileNavDrawer(),
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 35.h,
        pinned: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: const [SizedBox.shrink()],
        backgroundColor: kDarkGreen,
        flexibleSpace: FlexibleSpaceBar(
          // IMPORTANT: default collapseMode (parallax) resizes this
          // background on EVERY scroll frame, which forces the
          // FittedBox inside HeroHeader to re-measure/re-scale its
          // text 60x/sec — that's what caused the phone text glitch
          // AND the slow scroll. Pinning it keeps the background at
          // a fixed size (just gets clipped as it collapses), so the
          // FittedBox only computes its scale once.
          collapseMode: CollapseMode.pin,
          background: HeroHeader(
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
      const SliverToBoxAdapter(child: ImageCarouselSection()),
      SliverToBoxAdapter(child: SizedBox(height: 3.4.h)),
      SliverToBoxAdapter(
        child: Center(
          child: AdsterraBanner(zoneKey: kAdsterraHomeBannerZoneKey),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 2.5.h)),
      const SliverToBoxAdapter(child: SiteFooter()),
    ],
  ),
);
}
}