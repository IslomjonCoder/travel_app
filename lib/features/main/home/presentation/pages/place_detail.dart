import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/helpers/location.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/presentation/manager/detail/place_detail_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceDetailCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(place.name)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageGallery(place: place),
              const Gap(16),
              PlaceDescription(place: place),
              const Gap(16),
              ReviewsSection(place: place),
            ],
          ),
        ),
        bottomNavigationBar: PlaceDetailBottomNavBar(place: place),
      ),
    );
  }
}

class PlaceDetailBottomNavBar extends StatelessWidget {
  const PlaceDetailBottomNavBar({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          IconButton.outlined(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () async {
              context.read<FavouriteCubit>().toggleFavourite(place);

            },
            icon: Icon(context.watch<FavouriteCubit>().isFavourite(place) ? Icons.favorite : Icons.favorite_border, color: context.watch<FavouriteCubit>().isFavourite(place) ? Colors.red : null),
          ),
          const Gap(8),
          Expanded(
              child: FilledButton(
                  onPressed: () async {
                    final LatLng latLng = LocationHelper.convertWkb(place.location);
                    final query = '${latLng.latitude},${latLng.longitude}';
                    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                    await launchUrl(uri);
                  },
                  child: const Text('Navigate'))),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final PlaceEntity place;

  const ReviewsSection({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Reviews", style: AppTextStyle.headlineSemiboldH6),
            TextButton(
              onPressed: () {},
              child: Text("See all", style: AppTextStyle.bodyB2.copyWith(color: AppColors.greyscale400)),
            ),
          ],
        ),
        const Gap(8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Oscar Rogers',
                          style: AppTextStyle.subtitleS1,
                        ),
                        Text(
                          '29 Aug 2022',
                          style: AppTextStyle.subtitleS2.copyWith(color: AppColors.greyscale400),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(Icons.star, color: Colors.yellow.shade800, size: 16),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                'Bibendum sit eu morbi velit praesent. Fermentum mauris fringilla vitae feugiat vel sit blandit quam. In mi sodales nisl eleifend duis porttitor. Convallis euismod facilisis neque eget praesent diam in nulla. Faucibus interdum vulputate rhoncus mauris id facilisis est nunc habitant. Velit posuere facilisi tortor sed.',
                style: AppTextStyle.otherCaption.copyWith(color: AppColors.greyscale400),
              ),
            ],
          ),
          separatorBuilder: (context, index) => const Gap(8),
          itemCount: 3,
        ),
      ],
    );
  }
}

class PlaceDescription extends StatelessWidget {
  final PlaceEntity place;

  const PlaceDescription({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(place.name, style: AppTextStyle.headlineSemiboldH4),
        const Gap(8),
        Row(
          children: [
            SvgPicture.asset(
              AppImages.locationMarker,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
            ),
            const Gap(4),
            Text(place.region.name, style: AppTextStyle.subtitleS1Medium),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            SvgPicture.asset(
              AppImages.clock,
              height: 24,
              width: 24,
              fit: BoxFit.scaleDown,
            ),
            const Gap(4),
            Text(place.time, style: AppTextStyle.subtitleS2Medium),
          ],
        ),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Description", style: AppTextStyle.headlineSemiboldH6),
            const Gap(8),
            Text(
              place.description,
              style: AppTextStyle.bodyB2.copyWith(color: AppColors.greyscale400),
            ),
          ],
        ),
      ],
    );
  }
}

class ImageGallery extends StatelessWidget {
  final PlaceModel place;

  const ImageGallery({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceDetailCubit, PlaceDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog.fullscreen(
                      child: Stack(
                        children: [
                          PhotoView(imageProvider: CachedNetworkImageProvider(place.images[state.index])),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton.filled(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              // color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Hero(
                  tag: place.id,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            place.images.isEmpty ? AppImages.imagePlaceHolder : place.images[state.index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              height: 56,
              width: double.infinity,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => context.read<PlaceDetailCubit>().changeImageIndex(index),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(place.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const Gap(8),
                  itemCount: place.images.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
