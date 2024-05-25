import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/main.dart';

abstract class PlaceDataSource {
  Future<List<PlaceModel>> getPlaces();

  Future<List<PlaceModel>> searchPlace(String text);
}

class PlaceDataSourceImpl implements PlaceDataSource {
  @override
  Future<List<PlaceModel>> getPlaces() async {
    try {
      final response =
          await supabase.from('places').select('*,regions(*) ,categories(*),images(path), reviews(*,profile(*))');
      return response.map((e) => PlaceModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PlaceModel>> searchPlace(String text) async {
    try {
      final response = await supabase
          .from('places')
          .select('*,regions(*) ,categories(*),images(path), reviews(*,profile(*))')
          .ilike('name', '%$text%');
      return response.map((e) => PlaceModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
