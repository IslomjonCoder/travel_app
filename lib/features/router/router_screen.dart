import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/features/auth/presentation/pages/auth_screen.dart';
import 'package:travel_app/features/auth/presentation/pages/login_screen.dart';
import 'package:travel_app/features/navigation/pages/navigation_screen.dart';
import 'package:travel_app/main.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.session != null) {
            return  const NavigationScreen();
          } else {
            return const AuthScreen();
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
