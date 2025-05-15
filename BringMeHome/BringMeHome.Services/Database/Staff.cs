using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Staff
    {
        [Key]
        public int StaffID { get; set; }

        public int UserID { get; set; }

        [StringLength(100)]
        public string Position { get; set; }

        [StringLength(100)]
        public string Department { get; set; }

        public int ShelterID { get; set; }

        [DataType(DataType.Date)]
        public DateTime HireDate { get; set; }

        [StringLength(20)]
        public string Status { get; set; }

        public int AccessLevel { get; set; }

        // Navigation properties
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [ForeignKey("ShelterID")]
        public virtual Shelter Shelter { get; set; }

        public virtual ICollection<AdoptionApplication> ReviewedApplications { get; set; }
    }
}
