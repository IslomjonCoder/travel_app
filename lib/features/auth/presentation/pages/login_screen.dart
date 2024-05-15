import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/helpers/dialog.dart';
import 'package:travel_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:travel_app/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:travel_app/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isInProgress) {
            DialogHelper.showProgressDialog(context, message: 'Logging in...');
          }

          if (state.status.isFailure) {
            Navigator.pop(context);
            DialogHelper.showFailureDialog(context, state.failure?.message);
          }
          if (state.status.isSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<LoginCubit>(context);
            return Scaffold(

              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(16 * 4),
                      const Text(
                        'Log in',
                        style: AppTextStyle.headlineSemiboldH5,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(40),
                      Form(

                        key: cubit.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Email', style: AppTextStyle.otherCaption),
                            const Gap(8),
                            TextFormField(
                              controller: cubit.emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              }
                            ),
                            const Gap(24),
                            const Text('Password', style: AppTextStyle.otherCaption),
                            const Gap(8),
                            TextFormField(
                              controller: cubit.passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter your password',
                              ),
                              validator:  (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const Gap(16 * 3),
                      FilledButton(
                        onPressed: () => cubit.login(),
                        child: const Text('Log in'),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () => context.read<AuthCubit>().changePage(),
                            style: TextButton.styleFrom(foregroundColor: AppColors.info500),
                            child: const Text('Register'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
