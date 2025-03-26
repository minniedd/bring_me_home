using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Role
    {
        [Key]
        public int RoleID { get; set; }

        [Required, StringLength(50)]
        public string RoleName { get; set; } 

        [StringLength(200)]
        public string Description { get; set; }

        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;

        public DateTime? UpdatedDate { get; set; }

        // Navigation Property
        public ICollection<UserRole> UserRoles { get; set; } 
    }
}
