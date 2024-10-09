using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Model
{
    public class UsersRoles
    {
        public int UserRolesId { get; set; }

        public int? UserId { get; set; }

        public int? RoleId { get; set; }

        public DateOnly DateChange { get; set; }

        public virtual Roles? Role { get; set; }

        public virtual Users? User { get; set; }
    }
}
