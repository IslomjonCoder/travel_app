import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/data_sources/region_datasource.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';

abstract class RegionRepository {
  Future<Either<Failure, List<Region>>> getRegions();
}

class RegionRepositoryImpl implements RegionRepository {
  final RegionDataSource regionDataSource;

  RegionRepositoryImpl(this.regionDataSource);

  @override
  Future<Either<Failure, List<Region>>> getRegions() async {
    try {
      final response = await regionDataSource.getRegions();
      return Right(response);
    } on PostgrestException catch (e) {
      return Left(Failure(message: e.message));
    } on FormatException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
