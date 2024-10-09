using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Shelter
{
    public int ShelterId { get; set; }

    public string Name { get; set; } = null!;

    public int? CityId { get; set; }

    public virtual ICollection<Animal> Animals { get; set; } = new List<Animal>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
