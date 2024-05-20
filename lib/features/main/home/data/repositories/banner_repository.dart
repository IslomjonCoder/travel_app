import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/data_sources/banner_data_source.dart';
import 'package:travel_app/features/main/home/data/models/banner_model.dart';

class BannerRepository {
  final BannerDataSource bannerDataSource;

  BannerRepository(this.bannerDataSource);

  Future<Either<Failure, List<BannerModel>>> getBanners() async {
    try {
      final response = await bannerDataSource.getBanners();
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
