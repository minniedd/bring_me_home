using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class User
{
    public int UsersId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string UserEmail { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string UserPhone { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public string? UserStatus { get; set; }

    public virtual ICollection<ReviewComment> ReviewComments { get; set; } = new List<ReviewComment>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
