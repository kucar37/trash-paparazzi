import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Safe-area sizing plus scrolling keeps every control reachable on small phones.
class FestivalPage extends StatelessWidget {
  const FestivalPage({super.key, required this.builder, this.spotted = false});

  final Widget Function(BuildContext context, double width, double height)
  builder;
  final bool spotted;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: BoxDecoration(
        color: spotted ? const Color(0xFF061308) : AppTheme.background,
        gradient: RadialGradient(
          center: const Alignment(0.1, -0.95),
          radius: 1.05,
          colors: [
            spotted ? const Color(0xFF07391E) : const Color(0xFF0A3528),
            AppTheme.background,
          ],
          stops: const [0, 0.7],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Android briefly reports an empty viewport while its surface starts.
            if (constraints.maxWidth <= 36 || constraints.maxHeight <= 46) {
              return const SizedBox.shrink();
            }
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: constraints.maxWidth.clamp(0, 540),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                  child: builder(
                    context,
                    constraints.maxWidth.clamp(0, 540) - 36,
                    constraints.maxHeight - 46,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class FestivalHeader extends StatelessWidget {
  const FestivalHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.border),
        ),
        child: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
      Expanded(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.heading(25),
        ),
      ),
      const SizedBox(width: 48),
    ],
  );
}
