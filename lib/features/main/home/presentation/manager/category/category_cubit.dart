import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/repositories/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {

  final CategoryRepository categoryRepository;

  CategoryCubit(this.categoryRepository) : super(CategoryState());

  getCategories() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final response = await categoryRepository.getCategories();
    response.fold(
      (failure) => emit(state.copyWith(failure: failure,status: FormzSubmissionStatus.failure)),
      (categories) => emit(state.copyWith(categories: categories,status: FormzSubmissionStatus.success)),
    );
  }
}
