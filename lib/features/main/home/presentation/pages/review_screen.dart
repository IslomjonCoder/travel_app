import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/helpers/dialog.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/data/repositories/review_repository.dart';
import 'package:travel_app/features/main/home/presentation/manager/review/review_cubit.dart';
import 'package:travel_app/generated/l10n.dart';
import 'package:travel_app/main.dart';

class ReviewAddScreen extends StatelessWidget {
  const ReviewAddScreen({super.key, required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewCubit(ReviewRepositoryImpl()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Review Add Screen')),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () async {
              await supabase
                  .from('reviews')
                  .insert({'place_id': place.id, 'text': 'asdass', 'rating': context.read<ReviewCubit>().state.rating});
            },
          );
        }),
        body: BlocListener<ReviewCubit, ReviewState>(
          listener: (context, state) {
            if (state.status.isInProgress) {
              DialogHelper.showProgressDialog(context);
            }
            if (state.status.isSuccess) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
            if (state.status.isFailure) {
              Navigator.pop(context);
              DialogHelper.showFailureDialog(context, state.failure?.message ?? S.of(context).failedToAddReview);
            }
          },
          child: BlocBuilder<ReviewCubit, ReviewState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(S.of(context).typeSomething, style: AppTextStyle.subtitleS1),
                        const Gap(16),
                        Form(
                          key: context.read<ReviewCubit>().formKey,
                          child: TextFormField(
                            controller: context.read<ReviewCubit>().reviewController,
                            decoration: InputDecoration(hintText: S.of(context).writeYourReviewHere),
                            maxLines: 5,
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseEnterSomeText;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStars(
                          value: state.rating,

                          maxValueVisibility: false,
                          starColor: AppColors.brandColor500Default,
                          valueLabelVisibility: false,
                          onValueChanged: (value) => context.read<ReviewCubit>().updateRating(value),

                          // color: AppColors.brandColor500Default,
                        ),
                        Text(
                          state.rating.toInt().toString(),
                          style: AppTextStyle.bodyB1,
                        )
                      ],
                    ),
                    const Gap(24),
                    FilledButton(
                      onPressed: () {
                        if (context.read<ReviewCubit>().formKey.currentState!.validate()) {
                          context.read<ReviewCubit>().submitReview(place);
                        }
                      },
                      child: Text(S.of(context).submit),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
