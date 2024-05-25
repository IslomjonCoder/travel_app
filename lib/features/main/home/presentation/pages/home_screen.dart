import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/home/data/models/banner_model.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/presentation/manager/banner/banner_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/category/category_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/category_index/category_index_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/place/place_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/region/region_cubit.dart';
import 'package:travel_app/features/main/home/presentation/pages/place_detail.dart';
import 'package:travel_app/features/main/home/presentation/pages/region_detail_screen.dart';
import 'package:travel_app/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final response = await supabase.from('places').select().single();
          // final wkbHex = response['location'] as String;
          // final pointFromWKB = Point.decodeHex(wkbHex);
          // await supabase.from('places').insert({
          //   'location': 'POINT(41.34785176305069 69.2850566282956)',
          //   'name': "Besh Qozon",
          //   'description':
          //       """Besh qozon 'https://beshqozon.uz/uz/'""",
          //   "category_id": 5,
          //   "region_id": 2,
          //   "time": "09:00-23:00"
          //
          // });
          final response = await supabase.from('places').select('*,regions(*) ,categories(*),images(path), reviews(*,profile(*))');
          print(response);
          final List<PlaceModel> places = response.map((e) => PlaceModel.fromMap(e)).toList();
          // print("inserted");
          // context.read<PlaceCubit>().getAllPlaces();
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      drawer: Drawer(
        //   using region cubit show all regions

        child: BlocBuilder<RegionCubit, RegionState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.regions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.regions[index].name),
                  onTap: () {
                    final List<PlaceModel> filteredPlaces = context
                        .read<PlaceCubit>()
                        .state
                        .places
                        .where((element) => element.region.id == state.regions[index].id)
                        .toList();
                    Scaffold.of(context).closeDrawer();
                    context.push(BlocProvider.value(
                      value: BlocProvider.of<FavouriteCubit>(context),
                      child: RegionDetailScreen(regions: filteredPlaces, regionName: state.regions[index].name),
                    ));
                  },
                );
              },
            );
          },
        ),
      ),
      body: BlocListener<CategoryIndexCubit, int?>(
        listener: (context, state) {
          if (state == null) {
            context.read<PlaceCubit>().getAllPlaces();
          } else {
            context.read<PlaceCubit>().getPlacesListByCategory(context.read<CategoryCubit>().state.categories[state]);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Custom PageView and PageIndicator widgets
              const CustomPageView(),
              const Gap(16),
              const PageIndicator(),
              const Gap(16),
              // CategoryList widget
              CategoryList(
                onTap: (int index) => context.read<CategoryIndexCubit>().changeIndex(index),
                selectedIndex: context.watch<CategoryIndexCubit>().state,
              ),
              const Gap(16),
              // FeaturedPlacesList widget
              const FeaturedPlacesList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for the CategoryList
class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.onTap, this.selectedIndex});

  final Function(int index) onTap;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return SizedBox(
            height: 40,
            child: Skeletonizer(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => CategoryListItem(
                  category: CategoryModel(id: 0, name: 'Nature', image: ''),
                  isNetworkImage: false,
                  index: 0,
                  onTap: (int index) {},
                ),
                separatorBuilder: (context, index) => const Gap(4),
                itemCount: 10,
              ),
            ),
          );
        }
        if (state.status.isFailure) {
          return Text(state.failure?.message ?? "");
        }
        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => CategoryListItem(
              category: state.categories[index],
              index: index,
              onTap: onTap,
              selectedIndex: selectedIndex,
            ),
            separatorBuilder: (context, index) => const Gap(4),
            itemCount: state.categories.length,
          ),
        );
      },
    );
  }
}

// Custom widget for a single category list item
class CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final bool isNetworkImage;

  final int index;
  final int? selectedIndex;
  final Function(int index) onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    this.isNetworkImage = true,
    required this.index,
    required this.onTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selectedIndex == index && !context.watch<CategoryCubit>().state.status.isInProgress
              ? AppColors.brandColor100
              : null,
          border: Border.all(color: AppColors.greyscale100),
        ),
        child: Row(
          children: [
            isNetworkImage
                ? CachedNetworkImage(imageUrl: category.image, width: 20, height: 20, fit: BoxFit.cover)
                : const Text('oo'),
            const Gap(4),
            Text(category.name, style: AppTextStyle.subtitleS2Medium),
          ],
        ),
      ),
    );
  }
}

// Custom widget for the FeaturedPlacesList
class FeaturedPlacesList extends StatelessWidget {
  const FeaturedPlacesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceCubit, PlaceState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return Text(state.failure?.message ?? "");
        }

        if (state.status.isSuccess && state.places.isEmpty) {
          return const Text("No places found", style: AppTextStyle.headlineSemiboldH6);
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return state.status.isInProgress
                ? Skeletonizer(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 7 / 5,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.bottomLeft,
                                decoration: const BoxDecoration(color: Colors.red),
                                child: const Text('place.name').applyShimmer(),
                              ).applyShimmer(),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppImages.locationMarker,
                                  height: 16,
                                ).applyShimmer(),
                                const Gap(4),
                                const Text('ksalds;lsss'),
                              ],
                            ),
                            const Gap(4),
                            Row(
                              children: [
                                SvgPicture.asset(AppImages.clock, height: 16),
                                const Gap(4),
                                const Text('sdxskjl'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : FeaturedPlaceItem(place: state.places[index]);
          },
          separatorBuilder: (context, index) => const Gap(16),
          itemCount: state.status.isInProgress ? 10 : state.places.length,
        );
      },
    );
  }
}

// Custom widget for a single featured place item
class FeaturedPlaceItem extends StatelessWidget {
  const FeaturedPlaceItem({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(BlocProvider.value(
        value: context.read<FavouriteCubit>(),
        child: PlaceDetail(place: place),
      )),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 7 / 5,
            child: Hero(
              tag: place.id,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          place.images.isEmpty ? AppImages.imagePlaceHolder : place.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: const [0.3, 0.99],
                        colors: [Colors.transparent, AppColors.greyscale700.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      place.name,
                      style: AppTextStyle.subtitleS1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(8),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.locationMarker,
                    height: 16,
                  ),
                  const Gap(4),
                  Text(place.region.name, style: AppTextStyle.subtitleS2Medium),
                ],
              ),
              const Gap(4),
              Row(
                children: [
                  SvgPicture.asset(AppImages.clock, height: 16),
                  const Gap(4),
                  Text(place.time, style: AppTextStyle.subtitleS2),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final cubit = context.read<BannerCubit>();
        return Center(
          child: Skeletonizer(
            enabled: state.status.isInProgress,
            child: SmoothPageIndicator(
              controller: cubit.pageController,
              count: state.status.isInProgress ? 3 : state.banners.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                dotColor: AppColors.greyscale300,
                activeDotColor: state.status.isInProgress ? AppColors.greyscale300 : AppColors.brandColor500Default,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        final cubit = context.read<BannerCubit>();

        return Skeletonizer(
          enabled: state.status.isInProgress,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView(
              controller: cubit.pageController,
              children: state.status.isInProgress
                  ? List.generate(
                      3,
                      (index) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12.0)),
                            ).applyShimmer(enable: state.status.isInProgress),
                          ))
                  : state.banners.map((e) => PageViewItem(banner: e)).toList(),
            ),
          ),
        );
      },
    );
  }
}

class PageViewItem extends StatelessWidget {
  final BannerEntity banner;

  const PageViewItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(banner.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
