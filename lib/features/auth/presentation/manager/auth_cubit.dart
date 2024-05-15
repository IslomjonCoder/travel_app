import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthPage { login, register }

class AuthCubit extends Cubit<AuthPage> {
  AuthCubit() : super(AuthPage.login);

  void changePage() => emit(state == AuthPage.login ? AuthPage.register : AuthPage.login);
}
