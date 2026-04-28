import 'package:flutter/material.dart';
import '../theme.dart';

enum BigButtonSize { sm, md, lg }

class BigButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final BigButtonSize size;
  final Widget? icon;

  const BigButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = AppColors.accent,
    this.textColor = Colors.white,
    this.size = BigButtonSize.lg,
    this.icon,
  });

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  bool _pressed = false;

  ({double fontSize, EdgeInsets padding, double radius, double shadow})
      get _sizes {
    switch (widget.size) {
      case BigButtonSize.lg:
        return (
          fontSize: 28,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          radius: 22,
          shadow: 8,
        );
      case BigButtonSize.md:
        return (
          fontSize: 20,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          radius: 16,
          shadow: 6,
        );
      case BigButtonSize.sm:
        return (
          fontSize: 15,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          radius: 12,
          shadow: 4,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _sizes;
    final settle = _pressed ? s.shadow - 2 : 0.0;
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, settle, 0),
          padding: s.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(s.radius),
            boxShadow: [
              BoxShadow(
                color: const Color(0x33000000),
                offset: Offset(0, _pressed ? 2 : s.shadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 10),
              ],
              DefaultTextStyle(
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: s.fontSize,
                  fontWeight: FontWeight.w600,
                ),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
