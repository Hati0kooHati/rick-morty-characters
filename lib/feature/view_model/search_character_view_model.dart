import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/provider/filters_provider.dart';

import 'package:rick_and_morty/feature/repository/graph_character_repository.dart';
import 'package:rick_and_morty/feature/repository/rest_character_repository.dart';
import 'package:rick_and_morty/feature/view_model/base_character_view_model.dart';

class SearchCharacterViewModel extends BaseCharactersViewModel {
  SearchCharacterViewModel(super._restRepo, super._graphRepo);

  @override
  String get filters => ref.watch(filtersProvider);
}

final searchCharacterViewmodel = AsyncNotifierProvider(
  () => SearchCharacterViewModel(
    RestCharacterRepository(),
    GraphCharacterRepository(),
  ),
);
