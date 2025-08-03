import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty/feature/model/character.dart';
import 'package:rick_and_morty/feature/repository/character_repository.dart';

class RestCharacterRepository implements CharacterRepository {
  @override
  Future<Map<String, Object>> loadItems({
    required int pageIndex,
    String filters = "",
  }) async {
    String query =
        "https://rickandmortyapi.com/api/character/?page=$pageIndex$filters";

    final url = Uri.parse(query);

    final response = await http.get(url);

    if (response.statusCode == 400) {
      throw Exception();
    }

    if (response.statusCode == 404) {
      return {"items": [], "maxPages": 0};
    }

    final Map data = json.decode(response.body);

    final List result = (data["results"] as List)
        .map((json) => Character.fromJson(json))
        .toList();

    final int maxPages = data["info"]!["pages"];

    return {"results": result, "maxPages": maxPages};
  }
}
