using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Model
{
    public class Roles
    {
        public int RolesId { get; set; }

        public string Name { get; set; } = null!;

        public string? Description { get; set; }
    }
}
