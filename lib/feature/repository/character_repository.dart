abstract class CharacterRepository {
  Future<Map<String, Object>> loadItems({
    required int pageIndex,
    String filters = "",
  });
}
