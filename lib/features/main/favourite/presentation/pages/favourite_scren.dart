import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/home/presentation/pages/home_screen.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      // CategoryList widget
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CategoryList(),
            const Gap(16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  InkWell(
                    onTap: () {},
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
                                    image: AssetImage(registanSquare.image),
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
                        Text(registanSquare.name, style: AppTextStyle.headlineMediumH6),
                        const Gap(8),
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.locationMarker, height: 16, width: 16),
                            Text(registanSquare.location, style: AppTextStyle.subtitleS1),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.clock, height: 16, width: 16),
                            Text(registanSquare.time, style: AppTextStyle.subtitleS1),
                          ],
                        ),
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => const Gap(16),
              itemCount: 10,
            )
          ],
        ),
      ),
    );
  }
}
