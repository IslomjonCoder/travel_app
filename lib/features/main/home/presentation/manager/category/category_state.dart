part of 'category_cubit.dart';

class CategoryState {
  final FormzSubmissionStatus status;
  List<CategoryModel> categories;
  final Failure? failure;

  CategoryState({
    this.status = FormzSubmissionStatus.initial,
    this.categories = const [],
    this.failure,
  });



  CategoryState copyWith({
    FormzSubmissionStatus? status,
    List<CategoryModel>? categories,
    Failure? failure,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      failure: failure ?? this.failure,
    );
  }
}
