import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../config/app_config.dart';
import '../models/scheme_item.dart';
import '../data/scheme_data.dart';
import '../widgets/hero_header.dart';
import '../widgets/mobile_nav_drawer.dart';
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
  final ValueNotifier<bool> _scrollingNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _scrollingNotifier.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification n) {
    if (n is ScrollStartNotification) {
      _scrollingNotifier.value = true;
    } else if (n is ScrollEndNotification) {
      _scrollingNotifier.value = false;
    }
    return false;
  }

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive columns & ratio calculation
    int columns = 2;
    if (screenWidth >= 1100) {
      columns = 4;
    } else if (screenWidth >= 750) {
      columns = 3;
    } else if (screenWidth < kMobileBreakpoint) {
      columns = 1;
    }

    double aspectRatio = 0.72;
    if (columns == 1) {
      aspectRatio = 1.05;
    } else if (columns == 2) {
      aspectRatio = 0.75;
    } else if (columns == 3) {
      aspectRatio = 0.85;
    }

    return Scaffold(
      endDrawer: const MobileNavDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: CustomScrollView(
          // Smooth mobile & web momentum scroll
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          cacheExtent: 800,
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: SizedBox(
                height: 35.h,
                child: HeroHeader(
                  onSearchChanged: (q) => setState(() => _searchQuery = q),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Section Heading: Schemes & Scholarships
            SliverToBoxAdapter(child: dividedHeading('Schemes & Scholarships')),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Schemes Grid / Empty State
            if (filtered.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(
                      'Koi scheme nahi mili.',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14, // Crisp integer font size (No Blur)
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
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

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Scheme Highlights Image Carousel
            const SliverToBoxAdapter(
              child: RepaintBoundary(
                child: ImageCarouselSection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Adsterra Banner
            SliverToBoxAdapter(
              child: RepaintBoundary(
                child: Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _scrollingNotifier,
                    builder: (context, isScrolling, _) {
                      return AdsterraBanner(
                        zoneKey: kAdsterraHomeBannerZoneKey,
                        isScrolling: isScrolling,
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Footer Section (bottom safe-area space handled inside SiteFooter itself,
            // so there's no gap/seam showing the page background below it)
            const SliverToBoxAdapter(child: SiteFooter()),
          ],
        ),
      ),
    );
  }
}