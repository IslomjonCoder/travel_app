import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/main.dart';

abstract class CategoryDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await supabase.from('categories').select();
      return (response as List).map((e) => CategoryModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
