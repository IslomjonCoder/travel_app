import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:travel_app/features/main/settings/presentation/pages/about_us_screen.dart';
import 'package:travel_app/features/main/settings/presentation/pages/language_screen.dart';
import 'package:travel_app/features/main/settings/presentation/pages/notifications_screen.dart';
import 'package:travel_app/features/main/settings/presentation/pages/terms_conditions_screen.dart';
import 'package:travel_app/generated/l10n.dart';
import 'package:travel_app/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(8),
                ProfileItem(
                    title: S
                        .of(context)
                        .language,
                    icon: AppImages.languageCircle,
                    subtitle: state.locale,
                    onTap: () => context.push(const LanguageScreen())),
                const Gap(8),
                ProfileItem(
                  title: S
                      .of(context)
                      .notifications,
                  icon: AppImages.notification,
                  onTap: () => context.push(const NotificationScreen()),
                ),
                const Gap(8),
                ProfileItem(
                  title: S
                      .of(context)
                      .termsAndConditions,
                  icon: AppImages.document,
                  onTap: () => context.push(const TermsConditionsScreen()),
                ),
                ProfileItem(
                  title: S
                      .of(context)
                      .aboutApp,
                  icon: AppImages.infoCircle,
                  onTap: () => context.push(const AboutUsScreen()),
                ),
                const Gap(8),
                ProfileItem(
                  title: S
                      .of(context)
                      .logout,
                  titleColor: AppColors.error500,
                  icon: AppImages.logout,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S
                              .of(context)
                              .logout),
                          content: Text(S
                              .of(context)
                              .areYouSureYouWantToLogout),
                          actions: [
                            TextButton(
                              child: Text(S
                                  .of(context)
                                  .cancel),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text(S
                                  .of(context)
                                  .logout),
                              style: TextButton.styleFrom(foregroundColor: AppColors.error500),
                              onPressed: () {
                                supabase.auth.signOut();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    this.titleColor,
    required this.icon,
    this.subtitle,
    required this.onTap,
  });

  final VoidCallback onTap;

  final String icon;
  final String title;
  final Color? titleColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: subtitle == null ? 16 : 8),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(titleColor ?? AppColors.greyscale900, BlendMode.srcIn),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: AppTextStyle.subtitleS1Medium.copyWith(color: titleColor)),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyle.otherCaption.copyWith(color: AppColors.greyscale400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
