using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class AdoptionReason
{
    public int AdoptionReasonId { get; set; }

    public string ReasonText { get; set; } = null!;

    public string IsOther { get; set; } = null!;

    public string? OtherText { get; set; }

    public virtual ICollection<Application> Applications { get; set; } = new List<Application>();
}
