import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/enum/enum.dart';

class FiltersNotifier extends Notifier<String> {
  @override
  build() {
    return "";
  }

  void applyFilters({
    required CharacterStatus chStatus,
    required CharacterGender chGender,
    required String chName,
  }) {
    String filters = "";

    if (chName != "") {
      filters += "&name=$chName";
    }

    if (chStatus != CharacterStatus.all) {
      filters += "&status=${chStatus.name}";
    }

    if (chGender != CharacterGender.all) {
      filters += "&gender=${chGender.name}";
    }
    state = filters;
  }

  void deleteFilters() {
    state = "";
  }
}

final filtersProvider = NotifierProvider(FiltersNotifier.new);
