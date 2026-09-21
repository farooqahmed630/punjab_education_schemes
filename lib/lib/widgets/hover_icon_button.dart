import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';

// Hover-aware icon button — white by default, gold on mouse hover.
// `size` optional hai — default chhota hai (jaise search icon ke liye),
// bara icon (jaise drawer/hamburger) chahiye ho to explicitly bada
// size pass kar dein.
class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double? size;
  const HoverIconButton({super.key, required this.icon, required this.onTap, this.size});

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(0.1.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovering ? Colors.white.withOpacity(0.12) : Colors.transparent,
          ),
          child: Icon(widget.icon, color: _hovering ? kGold : Colors.white, size: widget.size ?? 16.sp),
        ),
      ),
    );
  }
}