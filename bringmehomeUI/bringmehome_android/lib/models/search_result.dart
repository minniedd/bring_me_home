class SearchResult<T> {
  int count = 0;
  List<T> result = [];

  SearchResult({
    this.count = 0,
    List<T>? result,
  }) : result = result ?? [];
}