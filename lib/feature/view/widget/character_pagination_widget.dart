import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/provider/is_loading_provider.dart';
import 'package:rick_and_morty/feature/model/character.dart';
import 'package:rick_and_morty/feature/view/widget/character_card.dart';
import 'package:rick_and_morty/feature/view_model/base_character_view_model.dart';

class CharacterPaginationWidget extends ConsumerStatefulWidget {
  final void Function() loadItems;
  final AsyncNotifierProvider<BaseCharactersViewModel, List<Character>>
  currViewmodel;

  const CharacterPaginationWidget({
    super.key,
    required this.loadItems,
    required this.currViewmodel,
  });

  @override
  ConsumerState<CharacterPaginationWidget> createState() =>
      _CharacterPaginationWidgetState();
}

class _CharacterPaginationWidgetState
    extends ConsumerState<CharacterPaginationWidget> {
  late final ScrollController _scrollController;

  final int maxPages = 42;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      widget.loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(widget.currViewmodel)
        .when(
          data: (data) => data.isEmpty
              ? Center(child: Text("No character found"))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      data.length + (ref.watch(isLoadingProvider) ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < data.length) {
                      return CharacterCard(character: data[index]);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
          error: (e, stack) => Center(child: Text("$e, $stack")),
          loading: () => Center(child: CircularProgressIndicator()),
        );
  }
}
