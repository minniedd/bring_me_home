using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Customer
{
    public int CustomersId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? Email { get; set; }

    public string? PhoneNumber { get; set; }

    public string Username { get; set; } = null!;

    public string? Address { get; set; }

    public int? CityId { get; set; }

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public string Status { get; set; } = null!;

    public virtual ICollection<Application> Applications { get; set; } = new List<Application>();

    public virtual City? City { get; set; }

    public virtual ICollection<Favourite> Favourites { get; set; } = new List<Favourite>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
}
