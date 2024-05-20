import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryIndexCubit extends Cubit<int?> {
  CategoryIndexCubit() : super(null);

  changeIndex(int index) {
    if (index == state) {
      emit(null);
    } else {
      emit(index);
    }
  }
}
