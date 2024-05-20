class BannerEntity {
  final String image;

  BannerEntity({
    required this.image,
  });
}

class BannerModel extends BannerEntity {
  final int id;

  BannerModel({
    required this.id,
    required super.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] as int,
      image: map['image'] as String,
    );
  }
}
