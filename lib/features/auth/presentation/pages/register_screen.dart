import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/helpers/dialog.dart';
import 'package:travel_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:travel_app/features/auth/presentation/manager/register/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (listenerContext, state) {
          if (state.status.isInProgress) {
            DialogHelper.showProgressDialog(context, message: 'Creating account...');
          }

          if (state.status.isFailure) {
            Navigator.pop(listenerContext);
            DialogHelper.showFailureDialog(context, state.failure?.message);
          }
          if (state.status.isSuccess) {
            Navigator.pop(listenerContext);
          }
        },
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<RegisterCubit>(context);
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Gap(16 * 4),
                      const Text('Sign up', style: AppTextStyle.headlineSemiboldH5, textAlign: TextAlign.center),
                      const Gap(40),
                      Form(
                        key: cubit.formKey,
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
                              },
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
                              validator: (value) {
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
                        onPressed: () {
                          cubit.register();
                          // supabase.auth.signUp(email: 'a@b.com', password: '123456');
                        },
                        child: const Text('Sign up'),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () => context.read<AuthCubit>().changePage(),
                            style: TextButton.styleFrom(foregroundColor: AppColors.info500),
                            child: const Text('Log in'),
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
