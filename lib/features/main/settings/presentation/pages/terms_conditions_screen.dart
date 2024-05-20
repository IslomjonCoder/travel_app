import 'package:flutter/material.dart';
import 'package:travel_app/generated/l10n.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).termsAndConditions),
      ),
      body: const Center(
        child: Text('Terms and Conditions Screen'),
      ),
    );
  }
}
