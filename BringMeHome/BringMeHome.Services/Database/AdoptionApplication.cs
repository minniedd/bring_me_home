using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BringMeHome.Services.Database.Adopters;

namespace BringMeHome.Services.Database
{
    public class AdoptionApplication
    {
        [Key]
        public int ApplicationID { get; set; }

        public int AdopterID { get; set; }

        public int AnimalID { get; set; }

        [DataType(DataType.Date)]
        public DateTime ApplicationDate { get; set; }

        public int StatusID { get; set; }

        public int? ReviewedByStaffID { get; set; }

        [DataType(DataType.Date)]
        public DateTime? ReviewDate { get; set; }

        [StringLength(1000)]
        public string Notes { get; set; }

        public string? LivingSituation { get; set; }

        public string? IsAnimalAllowed { get; set; }

        public int AdoptionReasonId { get; set; }

        // Navigation properties
        [ForeignKey("AdopterID")]
        public virtual Adopter Adopter { get; set; }

        [ForeignKey("AnimalID")]
        public virtual Animal Animal { get; set; }

        [ForeignKey("StatusID")]
        public virtual ApplicationStatus Status { get; set; }

        [ForeignKey("ReviewedByStaffID")]
        public virtual Staff ReviewedBy { get; set; }

        public ICollection<AdoptionReason> AdoptionReasons { get; set; }


    }
}
