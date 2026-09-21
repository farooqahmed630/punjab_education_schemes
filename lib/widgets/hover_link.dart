import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';

// Hover-aware small text link — white by default, gold on mouse hover.
// Web/desktop pe hover kaam karta hai; mobile/touch pe bas tap hota hai.
class HoverLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const HoverLink({super.key, required this.label, required this.onTap});

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            color: _hovering ? kGold : Colors.white,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
