part of 'region_cubit.dart';

class RegionState {
  final List<Region> regions;
  final Failure? failure;
  final FormzSubmissionStatus status;

  RegionState({
    this.regions = const [],
    this.failure,
    this.status = FormzSubmissionStatus.initial,
  });


  RegionState copyWith({
    List<Region>? regions,
    Failure? failure,
    FormzSubmissionStatus? status,
  }) {
    return RegionState(
      regions: regions ?? this.regions,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
