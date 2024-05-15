import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/main.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterCubit() : super(RegisterState());

  register() async {
    if (!formKey.currentState!.validate()) return;
    emit(RegisterState(status: FormzSubmissionStatus.inProgress));
    try {
      await supabase.auth.signUp(password: passwordController.text.trim(), email: emailController.text.trim());
      emit(RegisterState(status: FormzSubmissionStatus.success));
    } on AuthException catch (e) {
      emit(RegisterState.failure(failure: Failure(message: e.message)));
    } catch (e) {
      emit(RegisterState.failure(failure: Failure(message: e.toString())));
    }
  }
}
