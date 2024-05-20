import 'package:travel_app/features/main/home/data/models/banner_model.dart';
import 'package:travel_app/main.dart';

abstract class BannerDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerDataSourceImpl implements BannerDataSource {
  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await supabase.from('banners').select();
      return (response as List).map((e) => BannerModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}