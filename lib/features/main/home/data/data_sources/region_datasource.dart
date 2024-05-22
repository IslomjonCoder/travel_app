import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/main.dart';

abstract class RegionDataSource {
  Future<List<Region>> getRegions();
}

class RegionDataSourceImpl implements RegionDataSource {
  @override
  Future<List<Region>> getRegions() async {
    try {
      final response = await supabase.from('regions').select('*');
      return response.map((e) => Region.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}