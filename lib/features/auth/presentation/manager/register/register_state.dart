part of 'register_cubit.dart';

class RegisterState {
  final FormzSubmissionStatus status;
  final Failure? failure;

  RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.failure,
  });

  RegisterState.failure({required Failure failure}) : this(status: FormzSubmissionStatus.failure, failure: failure);

  RegisterState.success() : this(status: FormzSubmissionStatus.success);

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Failure? failure,
  }) {
    return RegisterState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
