import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'festival_media.dart';

class RewardTicket extends StatelessWidget {
  const RewardTicket({super.key});
  static const demoCode = 'TP-DEMO-8849-X';

  Future<void> _copyCode(BuildContext context) async {
    try {
      await Clipboard.setData(const ClipboardData(text: demoCode));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Demo reward code copied. This is not a redeemable voucher.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not copy the code. You can read it on the card.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.border),
      color: AppTheme.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 30,
          offset: const Offset(0, 20),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppTheme.green, Colors.transparent],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppTheme.green.withValues(alpha: 0.07),
                      border: Border.all(
                        color: AppTheme.green.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'ECO-PAPARAZZI VERIFIED',
                      style: AppTheme.mono(
                        size: 10,
                        color: AppTheme.green,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: AppTheme.cyan,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Valid Tonight',
                        style: AppTheme.mono(size: 9, color: AppTheme.cyan),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Free Signature Drink +\n20% Off Merch',
                style: AppTheme.heading(25)
                    .copyWith(color: const Color(0xFFE0DFE7), height: 1.2),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF272B30), height: 1),
              const SizedBox(height: 14),
              const _DetailRow(
                icon: Icons.storefront_outlined,
                text: 'Any Official Festival Bar & Merch Booth',
              ),
              const SizedBox(height: 8),
              const _DetailRow(
                icon: Icons.alarm,
                text: 'Valid Tonight until 04:00 AM',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                left: 22,
                right: 22,
                child: CustomPaint(
                  size: Size(double.infinity, 1),
                  painter: _DashedLinePainter(),
                ),
              ),
              Positioned(left: -11, child: _notch()),
              Positioned(right: -11, child: _notch()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
          child: Column(
            children: [
              Semantics(
                label: 'Decorative QR preview. Not scannable or redeemable.',
                image: true,
                child: ExcludeSemantics(
                  child: Container(
                    width: 144,
                    height: 144,
                    color: AppTheme.white,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      size: 132,
                      color: AppTheme.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('QR preview • not scannable', style: AppTheme.mono(size: 9)),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 2,
                children: [
                  MediaBadge(
                    child: Text(
                      demoCode,
                      style: AppTheme.mono(
                        size: 12,
                        color: AppTheme.white,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy demo reward code',
                    onPressed: () => _copyCode(context),
                    icon: const Icon(
                      Icons.copy_outlined,
                      color: AppTheme.muted,
                      size: 18,
                    ),
                  ),
                ],
              ),
              Text(
                'DEMO REWARD · NOT REDEEMABLE',
                style: AppTheme.mono(size: 8),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _notch() => Container(
    width: 22,
    height: 22,
    decoration: const BoxDecoration(
      color: AppTheme.background,
      shape: BoxShape.circle,
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppTheme.muted, size: 17),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    ],
  );
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.border
      ..strokeWidth = 2;
    for (double x = 0; x < size.width; x += 11) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + 6).clamp(0, size.width), 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}
