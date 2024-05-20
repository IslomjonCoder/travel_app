
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/generated/l10n.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutApp),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            VersionInfo(),
            Gap(24),
            Divider(),
            Gap(24),
            AboutUsDescription(
              title: 'Short about us',
              body:
                  'Bibendum sit eu morbi velit praesent. Fermentum mauris fringilla vitae feugiat vel sit blandit quam. In mi sodales nisl eleifend duis porttitor. Convallis euismod facilisis neque eget praesent diam in nulla. Faucibus interdum vulputate rhoncus mauris id facilisis est nunc habitant. Velit posuere facilisi tortor sed.',
            ),
            Gap(24),
            AboutUsDescription(
              title: 'Vission',
              body:
                  'Lectus a velit sed pretium egestas integer lacus, mi. Risus eget venenatis at amet sed. Fames rhoncus purus ornare nulla. Lorem dolor eget sagittis mattis eget nam. Nulla nisi egestas nisl nibh eleifend luctus.',
            ),
          ],
        ),
      ),
    );
  }
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('1.9.4', style: AppTextStyle.headlineSemiboldH6),
        Text('Current version', style: AppTextStyle.bodyB2.copyWith(color: AppColors.greyscale400)),
      ],
    );
  }
}

class AboutUsDescription extends StatelessWidget {
  const AboutUsDescription({super.key, required this.title, required this.body,  this.titleStyle=AppTextStyle.headlineMediumH6});

  final String title;
  final String body;
  final TextStyle titleStyle ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: titleStyle),
        const Gap(16),
        Text(
          body,
          style: AppTextStyle.bodyB1,
        ),
      ],
    );
  }
}
