import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/action_button.dart';
import '../widgets/festival_page.dart';
import '../widgets/preview_dialog.dart';
import '../widgets/reward_ticket.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) => FestivalPage(
    builder: (context, width, height) => Column(
      children: [
        const FestivalHeader(title: 'Festival Perks'),
        const SizedBox(height: 28),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF08392A),
            border: Border.all(color: AppTheme.green.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.green.withValues(alpha: 0.25),
                blurRadius: 28,
              ),
            ],
          ),
          child: const Icon(
            Icons.stars_rounded,
            size: 31,
            color: AppTheme.green,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Boom! Reward Unlocked',
          textAlign: TextAlign.center,
          style: AppTheme.heading(width >= 390 ? 28 : 25),
        ),
        const SizedBox(height: 12),
        Text(
          'Thanks for keeping the festival clean! You earned free merch & drinks perks.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 34),
        const RewardTicket(),
        const SizedBox(height: 42),
        ActionButton(
          label: 'Save Reward',
          icon: Icons.file_download_outlined,
          onPressed: () => showPreviewInfo(
            context,
            title: 'Reward saving comes next',
            message:
                'This is a demonstration reward. Saving it locally will be added '
                'in Phase 2. Nothing has been saved or redeemed.',
          ),
        ),
      ],
    ),
  );
}
