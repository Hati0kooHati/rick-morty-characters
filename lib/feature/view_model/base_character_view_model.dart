import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/enum/enum.dart';
import 'package:rick_and_morty/core/provider/curr_api_provider.dart';
import 'package:rick_and_morty/core/provider/is_loading_provider.dart';
import 'package:rick_and_morty/feature/model/character.dart';
import 'package:rick_and_morty/feature/repository/character_repository.dart';
import 'package:rick_and_morty/feature/repository/graph_character_repository.dart';
import 'package:rick_and_morty/feature/repository/rest_character_repository.dart';

abstract class BaseCharactersViewModel extends AsyncNotifier<List<Character>> {
  final RestCharacterRepository _restRepo;
  final GraphCharacterRepository _graphRepo;

  late CharacterRepository _currRepo;
  late int maxPage;
  int pageIndex = 1;

  BaseCharactersViewModel(this._restRepo, this._graphRepo);

  String get filters;

  @override
  Future<List<Character>> build() async {
    _currRepo = ref.watch(currApiProvider) == Api.rest ? _restRepo : _graphRepo;

    pageIndex = 1;

    final data = await _currRepo.loadItems(
      pageIndex: pageIndex,
      filters: filters,
    );
    maxPage = data["maxPages"] as int;
    pageIndex += 1;

    ref.watch(isLoadingProvider.notifier).state = false;

    return (data["results"] ?? <Character>[]) as List<Character>;
  }

  Future<void> loadItems() async {
    if (pageIndex <= maxPage && !ref.read(isLoadingProvider)) {
      return;
    }
    state = await AsyncValue.guard(() async {
      ref.watch(isLoadingProvider.notifier).state = true;

      final data = await _currRepo.loadItems(
        pageIndex: pageIndex,
        filters: filters,
      );

      final newState = List.of(state.value!);
      newState.addAll(data["results"] as List<Character>);
      pageIndex += 1;

      ref.watch(isLoadingProvider.notifier).state = false;
      return newState;
    });
  }
}
