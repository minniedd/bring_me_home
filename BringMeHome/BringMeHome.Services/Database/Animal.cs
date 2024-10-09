using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Animal
{
    public int AnimalsId { get; set; }

    public string Name { get; set; } = null!;

    public string Age { get; set; } = null!;

    public string Gender { get; set; } = null!;

    public string Weight { get; set; } = null!;

    public string About { get; set; } = null!;

    public byte[]? Photo { get; set; }

    public DateTime? RegistrationDate { get; set; }

    public string? IsAdopted { get; set; }

    public string? IsDeleted { get; set; }

    public int? BreedId { get; set; }

    public int? AnimalTypeId { get; set; }

    public int? ShelterId { get; set; }

    public int? CityId { get; set; }

    public virtual AnimalType? AnimalType { get; set; }

    public virtual ICollection<Application> Applications { get; set; } = new List<Application>();

    public virtual Breed? Breed { get; set; }

    public virtual City? City { get; set; }

    public virtual ICollection<Favourite> Favourites { get; set; } = new List<Favourite>();

    public virtual Shelter? Shelter { get; set; }
}
