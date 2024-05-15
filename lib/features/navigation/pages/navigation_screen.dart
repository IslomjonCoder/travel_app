import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/features/main/favourite/presentation/pages/favourite_scren.dart';
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
  List<Widget> screens = [
    const HomeScreen(),
    const MapScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, index) {
          return Scaffold(
            body: IndexedStack(
              index: index,
              children: screens,
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
