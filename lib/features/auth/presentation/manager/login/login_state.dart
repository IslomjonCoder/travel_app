part of 'login_cubit.dart';

class LoginState {
  final FormzSubmissionStatus status;
  final Failure? failure;

  LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.failure,
  });

  LoginState.failure({required Failure failure}) : this(status: FormzSubmissionStatus.failure, failure: failure);

  LoginState.success() : this(status: FormzSubmissionStatus.success);
  LoginState copyWith({
    FormzSubmissionStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
