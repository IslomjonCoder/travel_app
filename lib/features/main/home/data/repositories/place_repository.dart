import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/data_sources/place_datasource.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';

class PlaceRepository {
  final PlaceDataSource placeDataSource;

  PlaceRepository(this.placeDataSource);

  static List<PlaceEntity> places = [
    PlaceEntity(
      name: "Registan Square",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Samarkand",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Tashkent city",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Magic city Park",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Shakhi Zinda",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Samarkand",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Humo Arena",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "TV Tower",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Besh qozon",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Japan garden",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
    PlaceEntity(
      name: "Bunyodkor stadium",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      location: "Tashkent",
      time: "8:00 - 17:00",
      region: Region(id: 0, name: ""),
    ),
  ];

  List<PlaceModel> placeModels = [];

  Future<Either<Failure, List<PlaceModel>>> getPlaces() async {
    try {
      final response = await placeDataSource.getPlaces();
      placeModels = response;

      return right(response);
    } on PostgrestException catch (e) {
      return left(Failure(message: e.message));
    } on FormatException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  List<PlaceModel> get getPlacesList => placeModels;

  List<PlaceModel> getPlacesListByCategory(CategoryModel category) {
    final filteredPlaces = placeModels.where((element) => element.category.id == category.id);
    return filteredPlaces.toList();
  }
  getAllPlaces() {
    return placeModels;
  }
}
