import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      boxShadow: primary
          ? [
              BoxShadow(
                color: AppTheme.green.withValues(alpha: 0.22),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ]
          : null,
    ),
    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primary
              ? AppTheme.green
              : AppTheme.surface.withValues(alpha: 0.8),
          foregroundColor: primary ? const Color(0xFF002414) : AppTheme.white,
          minimumSize: const Size(0, 58),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          side: primary
              ? BorderSide.none
              : const BorderSide(color: AppTheme.border),
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: primary ? const Color(0xFF00592F) : AppTheme.cyan,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTheme.heading(20).copyWith(
                  color: primary
                      ? const Color(0xFF002414)
                      : const Color(0xFFE0DFE7),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
