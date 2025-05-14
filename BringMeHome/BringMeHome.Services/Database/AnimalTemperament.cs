using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class AnimalTemperament
    {
        [Key]
        public int TemperamentID { get; set; }

        [Required, StringLength(50)]
        public string Name { get; set; }

        [StringLength(200)]
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<Animal> Animals { get; set; }
    }
}
