using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class ApplicationStatus
    {
        [Key]
        public int StatusID { get; set; }

        [Required, StringLength(50)]
        public string StatusName { get; set; }

        [StringLength(200)]
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<AdoptionApplication> Applications { get; set; }
    }
}
