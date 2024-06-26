import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:translator/translator.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/helpers/location.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/presentation/manager/category/category_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/detail/place_detail_cubit.dart';
import 'package:travel_app/features/main/home/presentation/pages/review_screen.dart';
import 'package:travel_app/features/main/home/presentation/pages/review_see_all_screen.dart';
import 'package:travel_app/features/main/settings/presentation/manager/settings/settings_cubit.dart';
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
              if (place.review.isNotEmpty) ReviewsSection(place: place),
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
            icon: Icon(context.watch<FavouriteCubit>().isFavourite(place) ? Icons.favorite : Icons.favorite_border,
                color: context.watch<FavouriteCubit>().isFavourite(place) ? Colors.red : null),
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
          const Gap(8),
          IconButton.outlined(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: () async => context.push(ReviewAddScreen(place: place)),
            icon: const Icon(Icons.comment),
          ),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final PlaceModel place;

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
              onPressed: () {
                context.push(ReviewSeeAllScreen(place: place));
              },
              child: Text("See all", style: AppTextStyle.bodyB2.copyWith(color: AppColors.greyscale400)),
            ),
          ],
        ),
        const Gap(8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final comment = place.review[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Text(
                            comment.profile.name,
                            style: AppTextStyle.subtitleS1,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(comment.createdAt),
                            style: AppTextStyle.subtitleS2.copyWith(color: AppColors.greyscale400),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(Icons.star,
                            color: index < comment.rating ? Colors.yellow.shade800 : Colors.grey, size: 16),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  textAlign: TextAlign.start,
                  comment.text,
                  style: AppTextStyle.otherCaption.copyWith(color: AppColors.greyscale400),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Gap(8),
          itemCount: place.review.length,
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
    final settingsCubit = context.watch<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
FutureBuilder(
  initialData: place.name,
  future: GoogleTranslator()
      .translate(place.name, to: settingsCubit.state.language.locale.languageCode, from: "en"),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Skeletonizer(
        child: Text(
          place.name,
          style: AppTextStyle.headlineSemiboldH6,
        ),
      );
    }
    return Text(
      snapshot.data.text ?? place.name,
      style: AppTextStyle.headlineSemiboldH6,
    );
  },
),
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
            FutureBuilder(
              initialData: place.region.name,
              future: GoogleTranslator()
                  .translate(place.region.name, to: settingsCubit.state.language.locale.languageCode, from: "en"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    child: Text(
                      place.region.name,
                      style: AppTextStyle.subtitleS2Medium,
                    ),
                  );
                }
                return Text(
                  snapshot.data.text ?? place.region.name,
                  style: AppTextStyle.subtitleS2Medium,
                );
              },
            ),
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
            FutureBuilder(
              initialData:  place.description,
              future: GoogleTranslator()
                  .translate(place.description, to: settingsCubit.state.language.locale.languageCode, from: "en"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    child: Text(
                      place.description,
                      style: AppTextStyle.bodyB1,
                    ),
                  );
                }
                return Text(
                  snapshot.data.text ?? place.description,
                  style: AppTextStyle.bodyB1,
                );
              },
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
