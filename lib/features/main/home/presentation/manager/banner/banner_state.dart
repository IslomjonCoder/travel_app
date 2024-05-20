part of 'banner_cubit.dart';

class BannerState {
  final FormzSubmissionStatus status;
  List<BannerEntity> banners;
  final Failure? failure;

  BannerState({
    this.status = FormzSubmissionStatus.initial,
    this.banners = const [],
    this.failure,
  });

  BannerState.success(List<BannerEntity> banners) : this(status: FormzSubmissionStatus.success, banners: banners);

  BannerState.failure(Failure failure) : this(status: FormzSubmissionStatus.failure, failure: failure);

  BannerState copyWith({
    FormzSubmissionStatus? status,
    List<BannerEntity>? banners,
    Failure? failure,
  }) {
    return BannerState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      failure: failure ?? this.failure,
    );
  }
}
