import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/repositories/region_repository.dart';

part 'region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  final RegionRepository regionRepository;

  RegionCubit(this.regionRepository) : super(RegionState());

    getRegions() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final response = await regionRepository.getRegions();

    response.fold(
      (l) => emit(state.copyWith(failure: l, status: FormzSubmissionStatus.failure)),
      (r) => emit(state.copyWith(regions: r, status: FormzSubmissionStatus.success)),
    );
  }
}
