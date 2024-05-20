import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteCategoryCubit extends Cubit<int?> {
  FavouriteCategoryCubit() : super(null);

  setIndex(int index) async {
    if (index != state) {
      emit(index);
    } else {
      emit(null);
    }
  }
}
