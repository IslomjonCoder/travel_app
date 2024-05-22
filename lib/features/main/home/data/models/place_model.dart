import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:hive/hive.dart';
import 'package:travel_app/features/main/home/data/models/review_model.dart';

part 'place_model.g.dart';

class PlaceEntity {
  final String name;
  final String description;
  final String location;
  final String time;
  final Region region;

  PlaceEntity({
    required this.name,
    required this.description,
    required this.location,
    required this.time,
    required this.region,
  });
}

@HiveType(typeId: 0)
class PlaceModel extends PlaceEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<String> images;
  @HiveField(2)
  final CategoryModel category;
  @HiveField(3)
  @override
  final String name;
  @HiveField(4)
  @override
  final String description;
  @HiveField(5)
  @override
  final String location;
  @HiveField(6)
  @override
  final String time;
  @HiveField(7)
  @override
  final Region region;
  final ReviewModel review;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.time,
    required this.region,
    this.images = const [],
    required this.category,
    required this.review,
  }) : super(
    name: name,
    description: description,
    location: location,
    time: time,
    region: region,
  );

  PlaceModel.empty()
      : this(
          id: 0,
          name: '',
          description: '',
          location: '',
          time: '',
          region: Region.empty(),
          images: [],
          category: CategoryModel.empty(),
          review: ReviewModel.empty(),
        );

  Map<String, dynamic> toMap() => {
        'id': id,
      };

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
        id: map['id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        location: map['location'] as String,
        time: map['time'] as String,
        region: Region.fromMap(map['regions'] as Map<String, dynamic>),
        images: List<String>.from((map['images'] as List).map((e) => e['path'])),
        category: CategoryModel.fromMap(map['categories'] as Map<String, dynamic>), review: ReviewModel.fromMap(map['reviews'] as Map<String, dynamic>));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          images == other.images &&
          category == other.category;

  @override
  int get hashCode => id.hashCode ^ images.hashCode ^ category.hashCode;
}
@HiveType(typeId: 2)
class Region {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  Region({required this.id, required this.name});

  Region.empty() : this(id: 0, name: '');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Region.fromMap(Map<String, dynamic> map) {
    return Region(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
