import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Replace the optional asset with an original photo, never a screen capture.
class FestivalMedia extends StatelessWidget {
  const FestivalMedia({
    super.key,
    required this.height,
    this.overlays = const [],
  });
  static const photoPath = 'assets/images/festival_photo.jpg';
  final double height;
  final List<Widget> overlays;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppTheme.border),
    ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          photoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const _FestivalPlaceholder(),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x44000000),
                Colors.transparent,
                Color(0xB30B0E14),
              ],
              stops: [0, 0.6, 1],
            ),
          ),
        ),
        ...overlays,
      ],
    ),
  );
}

class MediaBadge extends StatelessWidget {
  const MediaBadge({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xDD080D10),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppTheme.border.withValues(alpha: 0.8)),
    ),
    child: child,
  );
}

class _FestivalPlaceholder extends StatelessWidget {
  const _FestivalPlaceholder();

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label:
        'Illustrated festival placeholder, cup return area under green lasers',
    child: Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _FestivalPainter()),
        Positioned(
          top: 80,
          bottom: 112,
          left: 18,
          right: 18,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xCC0A231B),
                        border: Border.all(
                          color: AppTheme.green.withValues(alpha: 0.6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.green.withValues(alpha: 0.15),
                            blurRadius: 36,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.recycling_rounded,
                        color: AppTheme.green,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'A greener kind\nof main character.',
                      textAlign: TextAlign.center,
                      style: AppTheme.heading(27),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CUP RETURN  /  STAGE 2',
                      style: AppTheme.mono(size: 10, color: AppTheme.cyan),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          left: 12,
          right: 12,
          child: Center(
            child: MediaBadge(
              child: Text(
                'FESTIVAL IMAGE PLACEHOLDER',
                textAlign: TextAlign.center,
                style: AppTheme.mono(size: 9),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// A lightweight, offline fallback. This illustration is not a visitor recording.
class _FestivalPainter extends CustomPainter {
  const _FestivalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101C2C), Color(0xFF08221E), Color(0xFF0B1016)],
        ).createShader(bounds),
    );
    final origin = Offset(size.width * 0.8, size.height * 0.23);
    final glow = Paint()
      ..color = AppTheme.cyan.withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(origin, size.width * 0.28, glow);
    for (var i = 0; i < 12; i++) {
      final end = Offset(
        size.width * (i / 9 - 0.2),
        i.isEven ? 0 : size.height * 0.48,
      );
      final color = i.isEven ? AppTheme.green : AppTheme.cyan;
      canvas.drawLine(
        origin,
        end,
        Paint()
          ..strokeWidth = 6
          ..color = color.withValues(alpha: 0.025),
      );
      canvas.drawLine(
        origin,
        end,
        Paint()
          ..strokeWidth = 0.8
          ..color = color.withValues(alpha: 0.25),
      );
    }
    // Distant stage lighting and a stylized crowd.
    final random = math.Random(7);
    for (var i = 0; i < 90; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height * (0.62 + random.nextDouble() * 0.35);
      final radius = 2 + random.nextDouble() * 7;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = const Color(0xFF060C12),
      );
      if (i % 5 == 0) {
        canvas.drawCircle(
          Offset(x + 2, y - 6),
          1.2,
          Paint()..color = AppTheme.cyan.withValues(alpha: 0.5),
        );
      }
    }
    final floor = Path()
      ..moveTo(0, size.height * 0.86)
      ..lineTo(size.width, size.height * 0.69)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(floor, Paint()..color = const Color(0x88041110));
    canvas.drawLine(
      Offset(0, size.height * 0.86),
      Offset(size.width, size.height * 0.69),
      Paint()
        ..color = AppTheme.green.withValues(alpha: 0.25)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _FestivalPainter oldDelegate) => false;
}
