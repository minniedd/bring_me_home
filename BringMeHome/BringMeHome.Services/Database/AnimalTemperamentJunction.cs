using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class AnimalTemperamentJunction
    {
        [Key]
        public int JunctionID { get; set; }

        public int AnimalID { get; set; }

        public int TemperamentID { get; set; }

        public int Rating { get; set; }

        [StringLength(500)]
        public string Notes { get; set; }

        public int? AssessedByID { get; set; }

        [DataType(DataType.Date)]
        public DateTime? AssessmentDate { get; set; }

        // Navigation properties
        [ForeignKey("AnimalID")]
        public virtual Animal Animal { get; set; }

        [ForeignKey("TemperamentID")]
        public virtual AnimalTemperament Temperament { get; set; }

        [ForeignKey("AssessedByID")]
        public virtual Staff AssessedBy { get; set; }
    }
}
