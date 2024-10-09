using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Canton
{
    public int CantonId { get; set; }

    public string? Name { get; set; }

    public virtual ICollection<City> Cities { get; set; } = new List<City>();
}
