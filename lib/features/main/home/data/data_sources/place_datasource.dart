import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/main.dart';

abstract class PlaceDataSource {
  Future<List<PlaceModel>> getPlaces();
}

class PlaceDataSourceImpl implements PlaceDataSource {
  @override
  Future<List<PlaceModel>> getPlaces() async {
    try {
      final response = await supabase.from('places').select('*,regions(*) ,categories(*),images(path)');
      return response.map((e) => PlaceModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
