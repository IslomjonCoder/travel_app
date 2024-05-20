import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';
class CategoryEntity {
  final String name;
  final String image;

  CategoryEntity({
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}

@HiveType(typeId: 1)
class CategoryModel extends CategoryEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  }) : super(
          name: name,
          image: image,
        );

  CategoryModel.empty()
      : this(
          id: 0,
          name: '',
          image: '',
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}
