part of 'review_get_all_cubit.dart';

class ReviewGetAllState {
  final FormzSubmissionStatus status;
  final Failure? failure;
  final List<ReviewModel> reviews;

  ReviewGetAllState({
    this.status = FormzSubmissionStatus.initial,
    this.failure,
    this.reviews = const [],
  });

  ReviewGetAllState copyWith({
    FormzSubmissionStatus? status,
    Failure? failure,
    List<ReviewModel>? reviews,
  }) {
    return ReviewGetAllState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      reviews: reviews ?? this.reviews,
    );
  }
}
