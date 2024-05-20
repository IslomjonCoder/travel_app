import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/repositories/place_repository.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  final PlaceRepository placeRepository;

  PlaceCubit(this.placeRepository) : super(PlaceState());

  getPlaces() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final response = await placeRepository.getPlaces();
    response.fold(
      (failure) => emit(PlaceState.failure(failure)),
      (places) => emit(PlaceState.success(places)),
    );
  }

  getPlacesListByCategory(CategoryModel category) async {
    final response = placeRepository.getPlacesListByCategory(category);
    emit(PlaceState.success(response));
  }
  getAllPlaces() async {
    final response = placeRepository.getPlacesList;
    emit(PlaceState.success(response));
  }
}
