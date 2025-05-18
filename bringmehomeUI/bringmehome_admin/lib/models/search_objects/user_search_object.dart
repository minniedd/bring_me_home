class UserSearchObject{
  String? fts;
  String? username;
  String? email;
  int pageNumber;
  int pageSize;

  UserSearchObject({
    this.fts,
    this.username,
    this.email,
    this.pageNumber = 1,  
    this.pageSize = 10,  
  });

  Map<String, dynamic> toJson() {
    return {
      if (fts != null) 'FTS': fts,
      if(username != null) 'Username': username,
      if(email != null) 'Email': email,
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}