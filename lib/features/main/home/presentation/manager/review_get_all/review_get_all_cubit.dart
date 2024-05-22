import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/review_model.dart';
import 'package:travel_app/features/main/home/data/repositories/review_repository.dart';

part 'review_get_all_state.dart';

class ReviewGetAllCubit extends Cubit<ReviewGetAllState> {
  final ReviewRepository reviewRepository;

  ReviewGetAllCubit(this.reviewRepository) : super(ReviewGetAllState());

  void getReviewsByUserId(int placeId) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final response = await reviewRepository.getReviewsByPlaceId(placeId);
    response.fold(
      (l) => emit(state.copyWith(status: FormzSubmissionStatus.failure, failure: l)),
      (r) => emit(state.copyWith(status: FormzSubmissionStatus.success, reviews: r)),
    );
  }
}
