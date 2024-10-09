using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class ApplicationAnswer
{
    public int ApplicationAnswerId { get; set; }

    public string? Status { get; set; }

    public DateTime? VisitDate { get; set; }

    public int? ApplicationId { get; set; }

    public virtual Application? Application { get; set; }
}
