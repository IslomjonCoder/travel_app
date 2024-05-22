import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/models/review_model.dart';
import 'package:travel_app/features/main/home/data/repositories/review_repository.dart';
import 'package:travel_app/features/main/home/presentation/manager/review_get_all/review_get_all_cubit.dart';
import 'package:travel_app/main.dart';

class ReviewSeeAllScreen extends StatelessWidget {
  const ReviewSeeAllScreen({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewGetAllCubit(ReviewRepositoryImpl())..getReviewsByUserId(place.id),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final response = await supabase.from('reviews').select("*,profile(*)");
              print(response);
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(title: Text(place.name)),
          body: BlocBuilder<ReviewGetAllCubit, ReviewGetAllState>(
            builder: (context, state) {
              if (state.status.isSuccess && state.reviews.isEmpty) {
                return const Center(
                  child: Text('No reviews yet', style: AppTextStyle.subtitleS1),
                );
              }
              if (state.status.isFailure) {
                return Center(
                  child: Text('Failed to get reviews: ${state.failure?.message}', style: AppTextStyle.subtitleS1),
                );
              }
              return Skeletonizer(
                enabled: state.status.isInProgress,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return ReviewItem(
                        comment: state.status.isInProgress
                            ? ReviewModel(
                                id: 0,
                                text: 'Oscar Rogers',
                                rating: 5,
                                placeId: 0,
                                createdAt: DateTime.now(),
                                profile: ProfileModel(id: '', name: 'name'))
                            : state.reviews[index]);
                  },
                  separatorBuilder: (context, index) => const Gap(8),
                  itemCount: state.status.isInProgress ? 5 : state.reviews.length,
                ),
              );
            },
          )),
    );
  }
}

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    super.key,
    required this.comment,
  });

  final ReviewModel comment;

  String formatDateTime(DateTime dateTime) {
    // Use DateFormat to format the DateTime object
    String formattedDate = DateFormat('d MMM y').format(dateTime);

    // Replace the year part with '202'
    formattedDate = formattedDate.replaceFirst(RegExp(r'\d{4}$'), '202');

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 24),
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
                    // Since the requirement is '29 Aug 202' (202 instead of 2022),
                    // you need to replace the year part manually.
                    formatDateTime(comment.createdAt),
                    style: AppTextStyle.subtitleS2.copyWith(color: AppColors.greyscale400),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(
                5,
                (index) =>
                    Icon(Icons.star, color: index < comment.rating ? Colors.yellow.shade800 : Colors.grey, size: 16),
              ),
            ),
          ],
        ),
        const Gap(8),
        Text(
          comment.text,
          textAlign: TextAlign.start,
          style: AppTextStyle.otherCaption.copyWith(color: AppColors.greyscale400),
        ),
      ],
    );
  }
}
