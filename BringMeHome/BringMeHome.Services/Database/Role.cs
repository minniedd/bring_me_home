using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class Role
{
    public int RolesId { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
