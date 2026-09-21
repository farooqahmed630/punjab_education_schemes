import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../data/carousel_images.dart';
import 'section_heading.dart';
import '../pages/image_ad_page.dart';

// Auto-changing image carousel — har 8 second baad khud agli image pe
// slide hota hai, aur left/right arrow se manually bhi control hota hai.
class ImageCarouselSection extends StatefulWidget {
  const ImageCarouselSection({super.key});

  @override
  State<ImageCarouselSection> createState() => _ImageCarouselSectionState();
}

class _ImageCarouselSectionState extends State<ImageCarouselSection> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    if (kCarouselImages.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 8), (_) {
        if (!mounted) return;
        _step(_direction);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _step(int intendedDirection) {
    int next = _currentPage + intendedDirection;
    if (next < 0) {
      next = kCarouselImages.length > 1 ? 1 : 0;
      intendedDirection = 1;
    } else if (next >= kCarouselImages.length) {
      next = kCarouselImages.length - 2;
      if (next < 0) next = 0;
      intendedDirection = -1;
    }
    _direction = intendedDirection;
    _controller.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    if (kCarouselImages.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(3.0.w, 0.3.h, 3.0.w, 0),
      child: Column(
        children: [
          dividedHeading('Scheme Highlights'),
          SizedBox(height: 1.2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.1.w, vertical: 0.7.h),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final activeIndex = kCarouselImages.length > 1
                    ? (_currentPage * 2 / (kCarouselImages.length - 1)).round().clamp(0, 2)
                    : 0;
                final active = index == activeIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 0.8.w),
                  width: active ? 3.5.w : 1.0.w,
                  // Height pehle `.h` (screen-HEIGHT %) thi jabke width
                  // `.w` (screen-WIDTH %) par based thi — phone par ye
                  // do alag units mix hone ki wajah se dots ka shape
                  // galat/inconsistent ban raha tha (khaas kar jab
                  // mobile browser ka address-bar show/hide hone se
                  // viewport height dynamically badalta hai). Ab height
                  // bhi `.w` par based hai (inactive dot ke width jitni),
                  // taake dono screen orientation aur mobile browsers
                  // par consistent, perfectly round/pill shape bane.
                  height: 1.0.w,
                  decoration: BoxDecoration(
                    color: active ? kGold : kPrimaryGreen.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 1.2.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CarouselArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _step(-1),
                ),
                SizedBox(width: 2.1.w),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                    minWidth: 160,
                    maxHeight: 145,
                    minHeight: 110,
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: kPrimaryGreen.withOpacity(0.06),
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: kCarouselImages.length,
                          onPageChanged: (i) => setState(() => _currentPage = i),
                          itemBuilder: (context, index) {
                            final path = kCarouselImages[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ImageAdPage(imagePath: path)),
                                );
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    path,
                                    fit: BoxFit.cover,
                                    // Carousel images bhi display size par
                                    // decode kiye jate hain — bade original
                                    // photos ko baar baar full-res paint
                                    // karne se scroll lag hota tha.
                                    cacheWidth: 480,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: kPrimaryGreen.withOpacity(0.08),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.image_not_supported_rounded,
                                        color: kPrimaryGreen,
                                        size: 36.sp,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 1.1.w,
                                    bottom: 1.h,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 1.9.w, vertical: 0.3.h),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.zoom_in_rounded, color: Colors.white, size: 10.sp),
                                          SizedBox(width: 1.1.w),
                                          Text(
                                            'Dekhen',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.1.w),
                _CarouselArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _step(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Small round left/right arrow button — sirf isi file ke andar use hota hai.
class _CarouselArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CarouselArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPrimaryGreen,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(0.5.w),
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
      ),
    );
  }
}
