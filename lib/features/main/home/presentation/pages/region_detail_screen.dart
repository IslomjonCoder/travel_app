import 'package:flutter/material.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';
import 'package:travel_app/features/main/home/presentation/pages/home_screen.dart';
import 'package:travel_app/generated/l10n.dart';

class RegionDetailScreen extends StatelessWidget {
  const RegionDetailScreen({super.key, required this.regions, required this.regionName});

  final List<PlaceModel> regions;
final String regionName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(regionName),
      ),
      body: regions.isEmpty ? Center(child: Text(S.of(context).noRegionsFound,style: AppTextStyle.headlineSemiboldH5,)): ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          return FeaturedPlaceItem(place: regions[index]);
        },
      ),
    );
  }
}
