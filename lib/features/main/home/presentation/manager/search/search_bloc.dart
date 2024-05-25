import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/repositories/place_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  final searchController = TextEditingController();
  final PlaceRepository placeRepository;

  SearchBloc(this.placeRepository) : super(SearchState()) {
    on<SearchTextChanged>(_onSearchTextChanged, transformer: debounce(const Duration(milliseconds: 500)));
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final response = await placeRepository.searchPlaces(event.text);
    response.fold(
      (l) => emit(state.copyWith(status: FormzSubmissionStatus.failure, failure: l)),
      (r) {
        print(r.length);
        emit(state.copyWith(status: FormzSubmissionStatus.success, places: r));
      },
    );
  }
}
