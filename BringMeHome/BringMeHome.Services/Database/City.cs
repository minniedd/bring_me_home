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
    public class City
    {
        [Key]
        public int CityID { get; set; }

        [Required, StringLength(100)]
        public string CityName { get; set; }

        public int CantonID { get; set; }

        // Navigation properties
        [ForeignKey("CantonID")]
        public virtual Canton Canton { get; set; }

        public virtual ICollection<Shelter> Shelters { get; set; }
        public virtual ICollection<Adopter> Adopters { get; set; }
    }
}
