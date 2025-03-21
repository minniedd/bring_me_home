using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Breed
    {
        [Key]
        public int BreedID { get; set; }

        public int SpeciesID { get; set; }

        [Required, StringLength(100)]
        public string BreedName { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        [StringLength(50)]
        public string SizeCategory { get; set; }

        [StringLength(500)]
        public string TemperamentNotes { get; set; }

        [StringLength(500)]
        public string SpecialNeeds { get; set; }

        [StringLength(500)]
        public string CommonHealthIssues { get; set; }

        // Navigation properties
        [ForeignKey("SpeciesID")]
        public virtual Species Species { get; set; }

        public virtual ICollection<Animal> Animals { get; set; }
    }
}
