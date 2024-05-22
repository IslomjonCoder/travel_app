part of 'review_cubit.dart';

class ReviewState {
  final FormzSubmissionStatus status;
  final Failure? failure;
  final double rating;

  ReviewState({
    this.status = FormzSubmissionStatus.initial,
    this.rating = 5,
    this.failure,
  });

  ReviewState copyWith({
    FormzSubmissionStatus? status,
    Failure? failure,
    double? rating,
  }) {
    return ReviewState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      rating: rating ?? this.rating,
    );
  }
}
