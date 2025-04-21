class AnimalSearchObject {
  String? fts;
  int? colorID;
  int? temperamentID;
  int? speciesID;
  int? breedID;
  int? shelterID;
  int pageNumber;
  int pageSize;

  AnimalSearchObject({
    this.fts,
    this.colorID,
    this.temperamentID,
    this.speciesID,
    this.breedID,
    this.shelterID,
    this.pageNumber = 1,  
    this.pageSize = 10,  
  });

  Map<String, dynamic> toJson() {
    return {
      if (fts != null) 'FTS': fts,
      if (colorID != null) 'ColorID': colorID,
      if (temperamentID != null) 'TemperamentID': temperamentID,
      if (speciesID != null) 'SpeciesID': speciesID,
      if (breedID != null) 'BreedID': breedID,
      if (shelterID != null) 'ShelterID': shelterID,
      'PageNumber': pageNumber,
      'PageSize': pageSize,
    };
  }
}