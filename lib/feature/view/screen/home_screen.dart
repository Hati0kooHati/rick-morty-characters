import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/enum/enum.dart';
import 'package:rick_and_morty/core/provider/curr_api_provider.dart';
import 'package:rick_and_morty/core/provider/filters_provider.dart';
import 'package:rick_and_morty/core/provider/is_search_widget_on_provider.dart';
import 'package:rick_and_morty/core/provider/is_searching.dart';
import 'package:rick_and_morty/feature/view/widget/character_pagination_widget.dart';
import 'package:rick_and_morty/feature/view/widget/search_widget.dart';
import 'package:rick_and_morty/feature/view_model/characters_view_model.dart';
import 'package:rick_and_morty/feature/view_model/search_character_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void showSnackBar(BuildContext context, String currApi) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Источник данных: $currApi")));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currViewModel = ref.watch(isSearchingProvider)
        ? searchCharacterViewmodel
        : charactersViewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(currApiProvider) == Api.rest ? "REST API" : "GraphQL",
        ),
        actions: [
          IconButton(
            onPressed: () =>
                ref.watch(isSearchWidgetOnProvider.notifier).state = true,
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          if (ref.watch(isSearchWidgetOnProvider))
            SearchWidget(
              applyFilters:
                  ({
                    required CharacterStatus chStatus,
                    required CharacterGender chGender,
                    required String chName,
                  }) => ref
                      .watch(filtersProvider.notifier)
                      .applyFilters(
                        chStatus: chStatus,
                        chGender: chGender,
                        chName: chName,
                      ),
              deleteFilters: () =>
                  ref.watch(filtersProvider.notifier).deleteFilters(),
            ),
          Expanded(
            child: Stack(
              children: [
                CharacterPaginationWidget(
                  loadItems: () =>
                      ref.watch(currViewModel.notifier).loadItems(),
                  currViewmodel: currViewModel,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (ref.read(currApiProvider.notifier).state ==
                          Api.rest) {
                        ref.read(currApiProvider.notifier).state = Api.graph;
                        showSnackBar(context, "GraphQL");
                      } else {
                        ref.read(currApiProvider.notifier).state = Api.rest;
                        showSnackBar(context, "REST API");
                      }
                    },
                    child: Icon(Icons.change_circle_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
