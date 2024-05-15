import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/home/presentation/pages/place_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Custom PageView and PageIndicator widgets
            const CustomPageView(),
            const Gap(16),
            const PageIndicator(),
            const Gap(16),
            // CategoryList widget
            CategoryList(),
            const Gap(16),
            // FeaturedPlacesList widget
            const FeaturedPlacesList(),
          ],
        ),
      ),
    );
  }
}

// Custom widget for the CategoryList
class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<String> categories = [
    'Historical',
    'Food',
    'Nature',
    'Travel',
    'Culture',
    'Shopping',
    'Restrooms',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CategoryListItem(
            category: categories[index],
          );
        },
        separatorBuilder: (context, index) => const Gap(4),
        itemCount: categories.length,
      ),
    );
  }
}

// Custom widget for a single category list item
class CategoryListItem extends StatelessWidget {
  final String category;

  const CategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greyscale100),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.travel,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
            const Gap(4),
            Text(
              category,
              style: AppTextStyle.subtitleS2Medium,
            ),
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
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return FeaturedPlaceItem(place: registanSquare);
      },
      separatorBuilder: (context, index) => const Gap(16),
      itemCount: 10,
    );
  }
}

// Custom widget for a single featured place item
class FeaturedPlaceItem extends StatelessWidget {
  const FeaturedPlaceItem({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(PlaceDetail(place: place)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: AspectRatio(
              aspectRatio: 7 / 5,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(place.image),
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
                  Text(place.location, style: AppTextStyle.subtitleS2Medium),
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
    final pageController = PageController();

    return Center(
      child: SmoothPageIndicator(
        controller: pageController,
        count: 3,
        effect: const WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          dotColor: AppColors.greyscale300,
          activeDotColor: AppColors.brandColor500Default,
        ),
      ),
    );
  }
}

class CustomPageView extends StatelessWidget {
  const CustomPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: const [
          PageViewItem(image: AppImages.onBoardingImage1),
          PageViewItem(image: AppImages.onBoardingImage1),
          PageViewItem(image: AppImages.onBoardingImage1),
        ],
      ),
    );
  }
}

class PageViewItem extends StatelessWidget {
  final String image;

  const PageViewItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class Place {
  final String image;
  final String name;
  final String description;
  final String location;
  final String time;

  Place({
    required this.image,
    required this.name,
    required this.description,
    required this.location,
    required this.time,
  });
}

final registanSquare = Place(
  image: AppImages.onBoardingImage1,
  name: 'Registan Square',
  description:
      'The Registan is a historic site in the city of Samarkand, known for its beautiful architecture and rich history. Lectus a velit sed pretium egestas integer lacus, mi. Risus eget venenatis at amet sed. Fames rhoncus purus ornare nulla. Lorem dolor eget sagittis mattis eget nam. Nulla nisi egestas nisl nibh eleifend luctus.',
  location: "Registan Square, Samarkand",
  time: '8:00 - 17:00',
);
