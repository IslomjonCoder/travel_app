part of 'place_detail_cubit.dart';

class PlaceDetailState {
  final int index;

  PlaceDetailState({
    this.index = 0,
  });

  PlaceDetailState copyWith({
    int? index,
  }) {
    return PlaceDetailState(
      index: index ?? this.index,
    );
  }
}
