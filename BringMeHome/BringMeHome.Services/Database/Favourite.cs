using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Favourite
{
    public int FavouritesId { get; set; }

    public int? CustomersId { get; set; }

    public int? AnimalsId { get; set; }

    public DateTime? DateLiked { get; set; }

    public string IsLiked { get; set; } = null!;

    public string? ModifiedBy { get; set; }

    public DateTime? ModifiedDate { get; set; }

    public virtual Animal? Animals { get; set; }

    public virtual Customer? Customers { get; set; }
}
