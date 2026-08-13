import 'package:flutter/material.dart';

/// Shows a short "coming soon" snackbar. Used for placeholder actions
/// (search, notifications, reports, preview) that aren't built yet.
void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text('هذه الميزة قيد التطوير — قريبًا'),
      ),
      duration: Duration(seconds: 2),
    ),
  );
}
