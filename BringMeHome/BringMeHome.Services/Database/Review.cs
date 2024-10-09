using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Review
{
    public int ReviewId { get; set; }

    public string? ReviewText { get; set; }

    public int? ShelterId { get; set; }

    public int? CustomersId { get; set; }

    public int? Rating { get; set; }

    public DateTime? ReviewDate { get; set; }

    public virtual Customer? Customers { get; set; }

    public virtual ICollection<ReviewComment> ReviewComments { get; set; } = new List<ReviewComment>();

    public virtual Shelter? Shelter { get; set; }
}
