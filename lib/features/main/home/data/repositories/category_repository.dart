import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/data_sources/category_data_source.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';

class CategoryRepository {
  final CategoryDataSource categoryDataSource;

  CategoryRepository( this.categoryDataSource);

  static List<CategoryEntity> categories = [
    CategoryEntity(name: 'Historical', image: 'assets/images/historical.png'),
    CategoryEntity(name: "Hotel", image: 'assets/images/hotel.png'),
    CategoryEntity(name: 'Food', image: 'assets/images/food.png'),
    CategoryEntity(name: 'Nature', image: 'assets/images/nature.png'),
    CategoryEntity(name: 'Travel', image: 'assets/images/travel.png'),
    CategoryEntity(name: 'Culture', image: 'assets/images/culture.png'),
    CategoryEntity(name: 'Shopping', image: 'assets/images/shopping.png'),
    CategoryEntity(name: 'Restrooms', image: 'assets/images/restrooms.png'),
  ];

  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await categoryDataSource.getCategories();
      return Right(categories);
    } on PostgrestException catch (e) {
      return Left(Failure(message: e.message));
    } on FormatException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
