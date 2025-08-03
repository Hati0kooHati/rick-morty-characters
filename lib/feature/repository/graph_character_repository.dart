import 'package:rick_and_morty/core/utilities/utilities.dart';
import 'package:rick_and_morty/feature/model/character.dart';
import 'package:rick_and_morty/feature/repository/character_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink("https://rickandmortyapi.com/graphql");

final client = GraphQLClient(link: httpLink, cache: GraphQLCache());

class GraphCharacterRepository implements CharacterRepository {
  @override
  Future<Map<String, Object>> loadItems({
    required int pageIndex,
    String filters = "",
  }) async {
    final Map<String, String> filtersMap = transformFiltersForGraphQl(filters);

    final query = gql('''
      query {
        characters(
          page: $pageIndex
          filter: { name: "${filtersMap["name"]}" status: "${filtersMap["status"]}" gender: "${filtersMap["gender"]}" }
        ) {
          info {
            pages
          }
          results {
            image
            name
            status
            location {
              name
            }
            species
            gender
          }
        }
      }
    ''');

    final result = await client.query(QueryOptions(document: query));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<Character> results =
        ((result.data?['characters']?['results'] ?? []) as List)
            .map((json) => Character.fromJson(json))
            .toList();
    return {
      "results": results,
      "maxPages": result.data?['characters']?['info']?['pages'] ?? 0,
    };
  }
}
