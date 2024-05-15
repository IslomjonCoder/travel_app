import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/text_styles.dart'; // Import Gap if needed

class DialogHelper {
  static void showProgressDialog(BuildContext context, {String? message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color : Colors.white,
              // color: context.watch<SettingsCubit>().state.darkMode
              //     ? AppColors.containerBackgroundColorDark
              //     : AppColors.containerBackgroundColorLight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const Gap(16),
                Text(message!,style: AppTextStyle.subtitleS2,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showFailureDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: context.watch<SettingsCubit>().state.darkMode
            //     ? AppColors.containerBackgroundColorDark
            //     : AppColors.containerBackgroundColorLight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const Gap(8),
                  Expanded(child: Text(message ?? 'An error occurred', softWrap: true)),
                ],
              ),
              const Gap(16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
