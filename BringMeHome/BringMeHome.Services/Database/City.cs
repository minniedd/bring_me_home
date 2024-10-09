using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class City
{
    public int CityId { get; set; }

    public string? Name { get; set; }

    public int? CantonId { get; set; }

    public virtual ICollection<Animal> Animals { get; set; } = new List<Animal>();

    public virtual Canton? Canton { get; set; }

    public virtual ICollection<Customer> Customers { get; set; } = new List<Customer>();
}
