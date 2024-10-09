using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class AnimalType
{
    public int AnimalTypeId { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<Animal> Animals { get; set; } = new List<Animal>();
}
