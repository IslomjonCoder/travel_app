import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/models/review_model.dart';
import 'package:travel_app/features/main/home/data/repositories/review_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository reviewRepository;
  final reviewController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ReviewCubit(this.reviewRepository) : super(ReviewState());

  void updateRating(double rating) => emit(state.copyWith(rating: rating, status: FormzSubmissionStatus.initial));

  void submitReview(PlaceModel place) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final review = Review(text: reviewController.text, rating: state.rating, placeId: place.id);
    final response = await reviewRepository.addReview(review);
    response.fold(
      (l) => emit(state.copyWith(status: FormzSubmissionStatus.failure, failure: l)),
      (r) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
    );
  }
}
