import 'package:flutter/material.dart';

enum ButtonVariant { primary, outline, ghost, link }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        if (prefixIcon != null)
          Align(alignment: Alignment.centerLeft, child: prefixIcon),
        if (suffixIcon != null)
          Align(alignment: Alignment.centerRight, child: suffixIcon),
      ],
    );

    // Ghost & link pakai TextButton
    if (variant == ButtonVariant.ghost || variant == ButtonVariant.link) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF18181B),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.all(
              variant == ButtonVariant.ghost
                  ? Colors.grey.shade200
                  : Colors.transparent,
            ),
          ),
          child: content,
        ),
      );
    }

    // Outline
    if (variant == ButtonVariant.outline) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF18181B),
            side: BorderSide(color: Colors.grey.shade300),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        ),
      );
    }

    // Primary (default)
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF18181B),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: content,
      ),
    );
  }
}