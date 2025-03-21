using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Species
    {
        [Key]
        public int SpeciesID { get; set; }

        [Required, StringLength(100)]
        public string SpeciesName { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        public int AverageLifespan { get; set; }

        [StringLength(500)]
        public string CommonTraits { get; set; }

        // Navigation properties
        public virtual ICollection<Animal> Animals { get; set; }
        public virtual ICollection<Breed> Breeds { get; set; }
    }
}
