import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/action_button.dart';
import '../widgets/festival_media.dart';
import '../widgets/festival_page.dart';
import '../widgets/preview_dialog.dart';
import 'reward_screen.dart';

enum EditStyle {
  cinematic('Cinematic', 'Slow-mo bass drop & flare', Icons.movie_outlined),
  hype('Hype', 'Glitch transitions & drop', Icons.bolt),
  funny(
    'Funny',
    'Cartoon SFX & soundbite',
    Icons.sentiment_very_satisfied_outlined,
  );

  const EditStyle(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

class MomentScreen extends StatefulWidget {
  const MomentScreen({super.key});

  @override
  State<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> {
  EditStyle _style = EditStyle.hype;
  bool _submissionPreviewConfirmed = false;

  void _showPlaybackInfo() => showPreviewInfo(
    context,
    title: 'Video playback comes in Phase 2',
    message:
        'This is a still-image preview. A local portrait video will bring your '
        'moment to life in the next phase. No AI video has been generated.',
  );

  Future<void> _previewSubmission() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text('Show your moment publicly?', style: AppTheme.heading(23)),
        content: Text(
          'Your ${_style.label} moment would appear on the festival’s '
          'large screen, where other visitors could see you.\n\n'
          'This is a consent preview only. Nothing will be uploaded or sent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Private'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm Preview'),
          ),
        ],
      ),
    );
    // Cancel, Back and outside dismissal all leave the state untouched.
    if (!mounted || confirmed != true) return;
    setState(() => _submissionPreviewConfirmed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo only. No video was uploaded or sent.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => FestivalPage(
    builder: (context, width, height) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FestivalHeader(title: 'Your Moment'),
        const SizedBox(height: 24),
        FestivalMedia(
          height: (height * 0.6).clamp(280, math.max(280, width / 0.65)),
          overlays: [
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xCC0B0E14),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: IconButton(
                      tooltip: 'Audio playback preview',
                      onPressed: _showPlaybackInfo,
                      icon: const Icon(Icons.volume_up_outlined, size: 19),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MediaBadge(
                    child: Text(
                      'HD',
                      style: AppTheme.mono(size: 11, color: AppTheme.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xDD0B0E14),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Video playback preview',
                      onPressed: _showPlaybackInfo,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.green,
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const LinearProgressIndicator(
                          value: 0,
                          minHeight: 5,
                          backgroundColor: AppTheme.border,
                          color: AppTheme.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 2,
                      child: Text(
                        'STILL PREVIEW',
                        style: AppTheme.mono(size: 8, color: AppTheme.cyan),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'SELECT EDIT STYLE',
          style: AppTheme.mono(size: 12).copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 310 ||
                MediaQuery.textScalerOf(context).scale(14) > 18;
            final options = EditStyle.values
                .map(
                  (style) => _StyleCard(
                    style: style,
                    selected: style == _style,
                    onTap: () => setState(() {
                      _style = style;
                      _submissionPreviewConfirmed = false;
                    }),
                  ),
                )
                .toList();
            if (stacked) {
              return Column(
                children: [
                  for (final option in options)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: option,
                    ),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(child: options[i]),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Demo styles · AI editing is not connected',
          style: AppTheme.mono(size: 8),
        ),
        const SizedBox(height: 24),
        ActionButton(
          label: 'Submit to Festival Screen',
          icon: Icons.tv_rounded,
          onPressed: _previewSubmission,
        ),
        if (_submissionPreviewConfirmed) ...[
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppTheme.green, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Submission preview confirmed',
                  style: TextStyle(color: AppTheme.green),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 10),
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

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.selected,
    required this.onTap,
  });
  final EditStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    key: ValueKey('style-${style.label}'),
    button: true,
    selected: selected,
    label: '${style.label}, ${style.description}',
    onTap: onTap,
    excludeSemantics: true,
    child: AnimatedContainer(
      constraints: const BoxConstraints(minHeight: 94),
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF08252A) : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppTheme.green : AppTheme.border,
          width: selected ? 1.5 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppTheme.cyan.withValues(alpha: 0.15),
                  blurRadius: 20,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          style.label,
                          style: AppTheme.heading(16).copyWith(
                            color: selected
                                ? AppTheme.cyan
                                : const Color(0xFFE0DFE7),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      style.icon,
                      size: 17,
                      color: selected ? AppTheme.cyan : AppTheme.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  style.description,
                  style: AppTheme.mono(
                    size: 9,
                    color: selected ? const Color(0xFFC1EDFF) : AppTheme.muted,
                  ).copyWith(letterSpacing: 0, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
