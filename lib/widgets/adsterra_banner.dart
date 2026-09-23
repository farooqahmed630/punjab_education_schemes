import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

import '../platform/ad_iframe_registrar.dart';

// ---- DEBUG NOTE (no behavior change) ----
// This widget renders an <iframe> via HtmlElementView. On Flutter Web,
// platform views (iframes) sitting INSIDE a scrollable area (here it's
// inside the CustomScrollView on HomePage) are a well-known cause of
// slow/janky scrolling: the browser has to keep re-clipping and
// repositioning the real DOM iframe to track the Flutter canvas on
// every scroll frame. To confirm this is contributing on your machine,
// scroll the page and watch DevTools Performance tab (or the
// [PERF] JANKY FRAME logs from home_page.dart) specifically around the
// moment the ad banner scrolls into/out of view.
//
// PHONE NOTE: ye HTML <iframe> ad sirf Flutter Web par kaam karta hai.
// Android/iOS app mein Adsterra ka ye banner render nahi hota (koi
// alag native ad SDK chahiye hoga), is liye phone build par ye widget
// khud khali/placeholder box dikha deta hai — build fail nahi hoga.

// Reusable Adsterra BANNER widget — kahin bhi use kar sakte hain, bas
// zoneKey/width/height pass karen. Zone key placeholder hone tak
// khali box return karta hai (koi crash nahi).
class AdsterraBanner extends StatefulWidget {
  final String zoneKey;
  final double width;
  final double height;
  // FIX: jab ye true hota hai (user active scroll kar raha hai),
  // widget real <iframe> ki bajaye niche ek halka static placeholder
  // dikhata hai. Wajah: Flutter Web mein scrollable ke andar platform
  // view (iframe) ko browser ko har scroll frame par reposition/re-clip
  // karna padta hai — yehi is section ke paas record hue janky frames
  // (build ~20-30ms) ki asal wajah thi. Scroll rukte hi (isScrolling
  // false) asal ad iframe wapas mount ho jata hai.
  final bool isScrolling;
  const AdsterraBanner({
    super.key,
    required this.zoneKey,
    this.width = 300,
    this.height = 250,
    this.isScrolling = false,
  });

  @override
  State<AdsterraBanner> createState() => _AdsterraBannerState();
}

class _AdsterraBannerState extends State<AdsterraBanner> {
  String? _viewType;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('[PERF] AdsterraBanner(${widget.zoneKey}) mounted — an iframe platform view is now live inside the scroll area.');
    }
    if (kIsWeb) {
      _viewType = registerAdIframeView(
        zoneKey: widget.zoneKey,
        width: widget.width.toInt(),
        height: widget.height.toInt(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.zoneKey.startsWith('YOUR_ADSTERRA')) {
      return const SizedBox.shrink();
    }
    if (!kIsWeb || _viewType == null) {
      // Phone app: real iframe ad nahi bante, is liye halka placeholder.
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }
    if (widget.isScrolling) {
      // Scroll ke dauran real iframe ki jagah simple placeholder —
      // koi DOM element scroll frame ke saath reposition nahi ho raha,
      // is liye ye rendering Flutter ke apne canvas jitni hi tez hai.
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }
    return SizedBox(width: widget.width, height: widget.height, child: HtmlElementView(viewType: _viewType!));
  }
}
