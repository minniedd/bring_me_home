using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Color
    {
        [Key]
        public int ColorID { get; set; }

        [Required, StringLength(50)]
        public string ColorName { get; set; }

        [StringLength(200)]
        public string Description { get; set; }

        // Navigation properties
        public virtual ICollection<AnimalColor> AnimalColors { get; set; }
    }
}
