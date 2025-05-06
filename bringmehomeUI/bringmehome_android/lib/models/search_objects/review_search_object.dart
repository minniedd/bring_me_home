class ReviewSearchObject {
  String? fTS;
  int? pageNumber;
  int? pageSize;

  ReviewSearchObject({
    this.fTS,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    
    if (fTS != null && fTS!.isNotEmpty) {
      json['fTS'] = fTS;
    }
    
    json['pageNumber'] = pageNumber;
    json['pageSize'] = pageSize;
    
    return json;
  }
}