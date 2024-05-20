import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:travel_app/core/failure/failure.dart';
import 'package:travel_app/features/main/home/data/models/banner_model.dart';
import 'package:travel_app/features/main/home/data/repositories/banner_repository.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final pageController = PageController();
  final BannerRepository bannerRepository;

  BannerCubit(this.bannerRepository) : super(BannerState());

  getBanners() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final response = await bannerRepository.getBanners();
    response.fold(
      (failure) => emit(BannerState.failure(failure)),
      (banners) => emit(BannerState.success(banners)),
    );
  }
}
