import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:travel_app/features/auth/presentation/pages/login_screen.dart';
import 'package:travel_app/features/auth/presentation/pages/register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthPage>(
        builder: (context, state) {
          if (state == AuthPage.login) {
            return const LoginScreen();
          } else {
            return const RegisterScreen();
          }
        },
      ),
    );
  }
}
