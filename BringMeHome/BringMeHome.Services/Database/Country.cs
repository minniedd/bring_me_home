using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Country
    {
        [Key]
        public int CountryID { get; set; }

        [Required, StringLength(100)]
        public string CountryName { get; set; }

        [StringLength(10)]
        public string CountryCode { get; set; }

        // Navigation properties
        public virtual ICollection<Canton> Cantons { get; set; }
    }
}
