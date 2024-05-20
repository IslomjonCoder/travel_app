import 'package:flutter_bloc/flutter_bloc.dart';

part 'place_detail_state.dart';

class PlaceDetailCubit extends Cubit<PlaceDetailState> {
  PlaceDetailCubit() : super(PlaceDetailState());

  changeImageIndex(int index) {
    emit(state.copyWith(index: index));
  }
}
