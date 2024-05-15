import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/home/presentation/pages/home_screen.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: const PlaceDetailBottomNavBar(),
    );
  }
}

class PlaceDetailBottomNavBar extends StatelessWidget {
  const PlaceDetailBottomNavBar({super.key});

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
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
          const Gap(8),
          Expanded(child: FilledButton(onPressed: () {}, child: const Text('Navigate'))),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final Place place;

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
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(place.image),
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
  final Place place;

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
            Text(place.location, style: AppTextStyle.subtitleS1Medium),
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
  final Place place;

  const ImageGallery({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage(place.image),
                fit: BoxFit.cover,
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
              itemBuilder: (context, index) => Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: AssetImage(place.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const Gap(8),
              itemCount: 5,
            ),
          ),
        ),
      ],
    );
  }
}
