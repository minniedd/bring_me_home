using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace BringMeHome.Models.Requests
{
    public class AdoptionApplicationRequest
    {
        [Required]
        public int AdopterID { get; set; }

        [Required]
        public int AnimalID { get; set; }

        [Required]
        [DataType(DataType.Date)]
        public DateTime ApplicationDate { get; set; }

        [Required]
        public int StatusID { get; set; }

        public int? ReviewedByStaffID { get; set; }

        [DataType(DataType.Date)]
        public DateTime? ReviewDate { get; set; }

        [StringLength(1000)]
        public string Notes { get; set; }

        public string? LivingSituation { get; set; }

        public string? IsAnimalAllowed { get; set; }

        [Required]
        public List<int> AdoptionReasonIds { get; set; }
    }
}


