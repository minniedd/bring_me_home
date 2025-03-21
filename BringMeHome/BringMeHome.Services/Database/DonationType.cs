using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class DonationType
    {
        [Key]
        public int DonationTypeID { get; set; }

        [Required, StringLength(50)]
        public string TypeName { get; set; }

        [StringLength(200)]
        public string Description { get; set; }

        public bool TaxDeductible { get; set; }

        // Navigation properties
        public virtual ICollection<Donation> Donations { get; set; }
    }
}
