import 'package:travel_app/features/main/home/data/models/review_model.dart';
import 'package:travel_app/main.dart';

abstract class ReviewDataSource {
  Future<void> addReview(Review review);

  Future<List<ReviewModel>> getReviews();

  Future<List<ReviewModel>> getReviewsByPlaceId({required int placeId});
}

class ReviewDataSourceImpl implements ReviewDataSource {
  @override
  Future<void> addReview(Review review) async {
    try {
      await supabase.from('reviews').insert(review.toMap());
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getReviews() async {
    try {
      final response = await supabase.from('reviews').select();
      return response.map((review) => ReviewModel.fromMap(review)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsByPlaceId({required int placeId}) async {
    try {
      final response =
          await supabase.from('reviews').select("*,profile(*)").eq('place_id', placeId).order('created_at', ascending: false);
      return response.map((review) => ReviewModel.fromMap(review)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
