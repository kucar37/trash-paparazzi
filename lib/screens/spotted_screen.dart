import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/action_button.dart';
import '../widgets/festival_media.dart';
import '../widgets/festival_page.dart';
import 'moment_screen.dart';
import 'reward_screen.dart';

class SpottedScreen extends StatelessWidget {
  const SpottedScreen({super.key});

  @override
  Widget build(BuildContext context) => FestivalPage(
    spotted: true,
    builder: (context, width, height) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.green.withValues(alpha: 0.035),
            border: Border.all(
              color: AppTheme.green.withValues(alpha: 0.4),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            'Trash Paparazzi',
            style: AppTheme.mono(
              size: 21,
              color: AppTheme.green,
            ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.4),
          ),
        ),
        const SizedBox(height: 22),
        FestivalMedia(
          height: (height * 0.48).clamp(240, math.max(240, width / 0.83)),
          overlays: [
            Positioned(
              top: 14,
              left: 14,
              right: 14,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 8,
                runSpacing: 6,
                children: [
                  MediaBadge(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Color(0xFFFF351A),
                          size: 9,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DEMO REC',
                          style: AppTheme.mono(size: 9, color: AppTheme.white),
                        ),
                      ],
                    ),
                  ),
                  MediaBadge(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppTheme.cyan,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'STAGE 2 // OASIS BIN #07',
                            style: AppTheme.mono(size: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'You Got Spotted!',
          style: AppTheme.heading(width * 0.071)
              .copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Text(
          'You returned an Eco-Cup at Stage 2. Your festival moment is ready to preview!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        MediaBadge(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, size: 16, color: AppTheme.cyan),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '+250 ECO-CREDITS',
                  style: AppTheme.mono(size: 10, color: AppTheme.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'DEMO EXPERIENCE · SIMULATED DETECTION',
          style: AppTheme.mono(size: 8),
        ),
        const SizedBox(height: 28),
        ActionButton(
          label: 'Watch My Moment',
          icon: Icons.play_arrow_rounded,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const MomentScreen()),
          ),
        ),
        const SizedBox(height: 12),
        ActionButton(
          label: 'Claim Reward',
          icon: Icons.stars_outlined,
          primary: false,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const RewardScreen()),
          ),
        ),
      ],
    ),
  );
}
