import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

Future<void> showPreviewInfo(
  BuildContext context, {
  required String title,
  required String message,
}) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: Text(title, style: AppTheme.heading(23)),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Got It'),
      ),
    ],
  ),
);
