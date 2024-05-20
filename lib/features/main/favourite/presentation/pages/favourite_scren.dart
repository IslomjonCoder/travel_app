import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_category/favourite_category_cubit.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/home/data/repositories/place_repository.dart';
import 'package:travel_app/features/main/home/presentation/manager/category/category_cubit.dart';
import 'package:travel_app/features/main/home/presentation/pages/home_screen.dart';
import 'package:travel_app/features/main/home/presentation/pages/place_detail.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      // CategoryList widget
      body: BlocListener<FavouriteCategoryCubit, int?>(
        listener: (context, state) {
          if (state == null) {
            context.read<FavouriteCubit>().getFavourites();
          } else {
            context
                .read<FavouriteCubit>()
                .getPlacesListByCategory(context.read<CategoryCubit>().state.categories[state].id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CategoryList(
                onTap: (index) => context.read<FavouriteCategoryCubit>().setIndex(index),
                selectedIndex: context.watch<FavouriteCategoryCubit>().state,
              ),
              const Gap(16),
              Expanded(
                child: BlocBuilder<FavouriteCubit, FavouriteState>(
                  builder: (context, state) {
                    if (state.places.isEmpty) {
                      return const Center(child: Text('No Favourites', style: AppTextStyle.headlineSemiboldH5));
                    }
                    return ListView.separated(

                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => context.push(BlocProvider.value(
                          value: context.read<FavouriteCubit>(),
                          child: PlaceDetail(place: state.places[index]),
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.6,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(state.places[index].images.isEmpty
                                            ? AppImages.imagePlaceHolder
                                            : state.places[index].images.first),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton.filled(
                                      style: IconButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.black.withOpacity(0.5),
                                      ),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(PlaceRepository.places.first.name, style: AppTextStyle.headlineMediumH6),
                            const Gap(8),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.locationMarker, height: 16, width: 16),
                                Text(PlaceRepository.places.first.location, style: AppTextStyle.subtitleS1),
                              ],
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.clock, height: 16, width: 16),
                                Text(PlaceRepository.places.first.time, style: AppTextStyle.subtitleS1),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => const Gap(16),
                      itemCount: state.places.length,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
