import 'dart:ffi';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travel_app/features/main/favourite/presentation/manager/favourite_cubit.dart';
import 'package:travel_app/features/main/home/data/data_sources/place_datasource.dart';
import 'package:travel_app/features/main/home/data/repositories/place_repository.dart';
import 'package:travel_app/features/main/home/presentation/manager/search/search_bloc.dart';
import 'package:travel_app/features/main/home/presentation/pages/place_detail.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(PlaceRepository(PlaceDataSourceImpl())),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: TextFormField(
              controller: context.read<SearchBloc>().searchController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              onChanged: (event) => context.read<SearchBloc>().add(SearchTextChanged(event)),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Search',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<SearchBloc>().searchController.clear();
                  context.read<SearchBloc>().add(SearchTextChanged(''));
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          body: context.watch<SearchBloc>().searchController.text.isEmpty
              ? ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.update),
                      trailing: const Icon(Icons.keyboard_double_arrow_up_outlined),
                      onTap: () {
                        context.read<SearchBloc>().searchController.text = "something";
                        context.read<SearchBloc>().add(SearchTextChanged('something'));
                      },
                      title: const Text("something"),
                    );
                  },
                )
              : BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state.status.isFailure) {
                      return Text(state.failure?.message ?? "");
                    }

                    if (state.status.isInProgress) {
                      return Skeletonizer(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.place),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                              title: const Text("state.places[index].name"),
                            );
                          },
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.place),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            print(state.places[index].name);
                            context.push(BlocProvider.value(
                              value: BlocProvider.of<FavouriteCubit>(context),
                              child: PlaceDetail(place: state.places[index]),
                            ));
                          },
                          title: Text(state.places[index].name),
                        );
                      },
                    );
                  },
                ),
        );
      }),
    );
  }
}
