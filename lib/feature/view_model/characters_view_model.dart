import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rick_and_morty/feature/repository/graph_character_repository.dart';
import 'package:rick_and_morty/feature/repository/rest_character_repository.dart';
import 'package:rick_and_morty/feature/view_model/base_character_view_model.dart';

class CharactersViewModel extends BaseCharactersViewModel {
  CharactersViewModel(super.restRepo, super.graphRepo);

  @override
  String get filters => "";
}

final charactersViewModel = AsyncNotifierProvider(
  () => CharactersViewModel(
    RestCharacterRepository(),
    GraphCharacterRepository(),
  ),
);
