using System;
using System.Collections.Generic;

namespace BringMeHome.Models.Model;

public partial class Users
{
    public int UsersId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string UserEmail { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string UserPhone { get; set; } = null!;

    public bool? UserStatus { get; set; }

    public virtual ICollection<UsersRoles> UserRoles { get; set; } = new List<UsersRoles>();


}
