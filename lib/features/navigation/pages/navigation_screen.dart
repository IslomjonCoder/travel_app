import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/features/main/favourite/data/data_sources/favourite_service.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_category/favourite_category_cubit.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/favourite/presentation/pages/favourite_scren.dart';
import 'package:travel_app/features/main/home/data/data_sources/banner_data_source.dart';
import 'package:travel_app/features/main/home/data/data_sources/category_data_source.dart';
import 'package:travel_app/features/main/home/data/data_sources/place_datasource.dart';
import 'package:travel_app/features/main/home/data/data_sources/region_datasource.dart';
import 'package:travel_app/features/main/home/data/repositories/banner_repository.dart';
import 'package:travel_app/features/main/home/data/repositories/category_repository.dart';
import 'package:travel_app/features/main/home/data/repositories/place_repository.dart';
import 'package:travel_app/features/main/home/data/repositories/region_repository.dart';
import 'package:travel_app/features/main/home/presentation/manager/banner/banner_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/category/category_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/category_index/category_index_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/place/place_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/region/region_cubit.dart';
import 'package:travel_app/features/main/home/presentation/manager/search/search_bloc.dart';
import 'package:travel_app/features/main/home/presentation/pages/home_screen.dart';
import 'package:travel_app/features/main/map/presentation/pages/map_screen.dart';
import 'package:travel_app/features/main/settings/presentation/pages/settings_screen.dart';
import 'package:travel_app/features/navigation/manager/navigation_cubit.dart';
import 'package:travel_app/generated/l10n.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  // List<Widget> screens = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => BannerCubit(BannerRepository(BannerDataSourceImpl()))..getBanners()),
        BlocProvider(create: (context) => CategoryCubit(CategoryRepository(CategoryDataSourceImpl()))..getCategories()),
        BlocProvider(create: (context) => PlaceCubit(PlaceRepository(PlaceDataSourceImpl()))..getPlaces()),
        BlocProvider(create: (context) => CategoryIndexCubit()),
        // BlocProvider(create: (context) => SearchBloc(PlaceRepository(PlaceDataSourceImpl()))),
        BlocProvider(create: (context) => FavouriteCategoryCubit()),
        BlocProvider(create: (context) => RegionCubit(RegionRepositoryImpl(RegionDataSourceImpl()))..getRegions(), lazy: false,),
        BlocProvider(create: (context) => FavouriteCubit(FavouritesService())..getFavourites()),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          return Scaffold(
            body: IndexedStack(
              index: index,
              children:  [
                HomeScreen(),
                const MapScreen(),
                const FavouriteScreen(),
                const SettingsScreen(),
              ],
            ),
            bottomNavigationBar: Localizations.override(
              context: context,
              child: BottomNavigationBar(
                unselectedItemColor: AppColors.greyscale400,
                selectedItemColor: AppColors.brandColor500Default,
                onTap: (value) => context.read<NavigationCubit>().changePage(value),
                currentIndex: index,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: S.of(context).home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.map),
                    label: S.of(context).map,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite),
                    label: S.of(context).favourite,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: S.of(context).settings,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
