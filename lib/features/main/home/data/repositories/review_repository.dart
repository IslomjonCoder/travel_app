import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/data_sources/review_datasource.dart';
import 'package:travel_app/features/main/home/data/models/review_model.dart';

abstract class ReviewRepository {
  final ReviewDataSource reviewDataSource;

  ReviewRepository({required this.reviewDataSource});

  Future<Either<Failure, Unit>> addReview(Review review);

  Future<Either<Failure, List<ReviewModel>>> getReviews();

  Future<Either<Failure, List<ReviewModel>>> getReviewsByPlaceId(int placeId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<Either<Failure, Unit>> addReview(Review review) async {
    try {
      await reviewDataSource.addReview(review);
      return right(unit);
    } on PostgrestException catch (e) {
      return left(Failure(message: e.message));
    } on FormatException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviews() async {
    try {
      final response = await reviewDataSource.getReviews();
      return right(response);
    } on PostgrestException catch (e) {
      return left(Failure(message: e.message));
    } on FormatException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  ReviewDataSource get reviewDataSource => ReviewDataSourceImpl();

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviewsByPlaceId(int placeId) async {
    try {
      final response = await reviewDataSource.getReviewsByPlaceId(placeId: placeId);
      return right(response);
    } on PostgrestException catch (e) {
      return left(Failure(message: e.message));
    } on FormatException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
