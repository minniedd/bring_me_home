class EventSearchObject {
  String? fts;
  int pageNumber;
  int pageSize;

  EventSearchObject({
    this.fts,
    this.pageNumber = 1,  
    this.pageSize = 10,  
  });

  Map<String, dynamic> toJson() {
    return {
      if (fts != null) 'FTS': fts,
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}