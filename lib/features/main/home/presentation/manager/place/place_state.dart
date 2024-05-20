part of 'place_cubit.dart';

class PlaceState {
  final FormzSubmissionStatus status;
  List<PlaceModel> places;
  final Failure? failure;

  PlaceState({
    this.status = FormzSubmissionStatus.initial,
    this.places = const [],
    this.failure,
  });

  PlaceState.success(List<PlaceModel> places) : this(places: places, status: FormzSubmissionStatus.success);

  PlaceState.failure(Failure failure) : this(failure: failure, status: FormzSubmissionStatus.failure);

  PlaceState copyWith({
    FormzSubmissionStatus? status,
    List<PlaceModel>? places,
    Failure? failure,
  }) {
    return PlaceState(
      status: status ?? this.status,
      places: places ?? this.places,
      failure: failure ?? this.failure,
    );
  }
}
