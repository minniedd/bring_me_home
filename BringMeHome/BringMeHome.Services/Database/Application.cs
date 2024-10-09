using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Application
{
    public int ApplicationId { get; set; }

    public int? CustomersId { get; set; }

    public int? AnimalsId { get; set; }

    public string? LivingSituation { get; set; }

    public string? IsAnimalAllowed { get; set; }

    public int? AdoptionReasonId { get; set; }

    public string? IsApproved { get; set; }

    public DateOnly? ApplicationDate { get; set; }

    public virtual AdoptionReason? AdoptionReason { get; set; }

    public virtual Animal? Animals { get; set; }

    public virtual ICollection<ApplicationAnswer> ApplicationAnswers { get; set; } = new List<ApplicationAnswer>();

    public virtual Customer? Customers { get; set; }
}
