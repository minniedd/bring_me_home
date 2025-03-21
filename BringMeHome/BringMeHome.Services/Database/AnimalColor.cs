using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class AnimalColor
    {
        [Key]
        public int AnimalColorID { get; set; }

        public int AnimalID { get; set; }

        public int ColorID { get; set; }

        public bool IsPrimary { get; set; }

        // Navigation properties
        [ForeignKey("AnimalID")]
        public virtual Animal Animal { get; set; }

        [ForeignKey("ColorID")]
        public virtual Color Color { get; set; }
    }
}
