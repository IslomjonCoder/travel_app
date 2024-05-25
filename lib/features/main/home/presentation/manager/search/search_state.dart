part of 'search_bloc.dart';

class SearchState {
  final FormzSubmissionStatus status;
  final Failure? failure;
  final List<PlaceModel> places;

  SearchState({
    this.status = FormzSubmissionStatus.initial,
    this.failure,
    this.places = const [],
  });

  SearchState copyWith({
    FormzSubmissionStatus? status,
    Failure? failure,
    List<PlaceModel>? places,
  }) {
    return SearchState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      places: places ?? this.places,
    );
  }
}
