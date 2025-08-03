Map<String, String> transformFiltersForGraphQl(String filters) {
  Map<String, String> filtersForGraphQl = {
    "name": "",
    "status": "",
    "gender": "",
  };

  if (filters.isNotEmpty) {
    for (String filter in filters.split("&")) {
      final List<String> filterSplited = filter.split("=");

      if (filterSplited.length == 2) {
        filtersForGraphQl[filterSplited[0]] = filterSplited[1];
      }
    }
  }

  return filtersForGraphQl;
}
