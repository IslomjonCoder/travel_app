import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/main.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit() : super(LoginState());

  login() async {
    if (!formKey.currentState!.validate()) return;
    emit(LoginState(status: FormzSubmissionStatus.inProgress));
    try {
      await supabase.auth
          .signInWithPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      emit(LoginState(status: FormzSubmissionStatus.success));
    } on AuthException catch (e) {
      emit(LoginState.failure(failure: Failure(message: e.message)));
    } catch (e) {
      emit(LoginState.failure(failure: Failure(message: e.toString())));
    }
  }
}
