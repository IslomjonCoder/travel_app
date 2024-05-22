class Review {
  final String text;
  final double rating;
  final int placeId;

  Review({
    required this.text,
    required this.rating,
    required this.placeId,
  });

  Map<String, dynamic> toMap() => {'text': text, 'rating': rating, 'place_id': placeId};
}

class ReviewModel extends Review {
  final int id;
  final DateTime createdAt;
  final ProfileModel profile;

  ReviewModel({
    required this.id,
    required super.text,
    required super.rating,
    required super.placeId,
    required this.createdAt,
    required this.profile,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    print(map);
    return ReviewModel(
      id: map['id'] as int,
      text: map['text'] as String,
      rating: map['rating'] is int ? map['rating'].toDouble() : map['rating'] as double,
      placeId: map['place_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      profile: ProfileModel.fromMap(map['profile'] as Map<String, dynamic>),
    );
  }

  ReviewModel.empty()
      : this(
          id: 0,
          text: '',
          rating: 0,
          placeId: 0,
          createdAt: DateTime.now(),
          profile: ProfileModel(id: '', name: ''),
        );
}

class ProfileModel {
  final String id;
  final String name;

  ProfileModel({
    required this.id,
    required this.name,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
