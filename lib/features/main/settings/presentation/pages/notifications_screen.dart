import 'package:flutter/material.dart';
import 'package:travel_app/generated/l10n.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifications),
      ),
      body: const Center(
        child: Text('Notification Screen'),
      ),
    );
  }
}
