using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BringMeHome.Services.Database.Adopters;

namespace BringMeHome.Services.Database
{
    public class Canton
    {
        [Key]
        public int CantonID { get; set; }

        [Required, StringLength(100)]
        public string CantonName { get; set; }

        [StringLength(10)]
        public string CantonCode { get; set; }

        public int CountryID { get; set; }

        // Navigation properties
        [ForeignKey("CountryID")]
        public virtual Country Country { get; set; }

        public virtual ICollection<City> Cities { get; set; }
        public virtual ICollection<Shelter> Shelters { get; set; }
        public virtual ICollection<Adopter> Adopters { get; set; }
    }
}
