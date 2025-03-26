using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class AdoptionApplicationResponse
    {
        public int ApplicationID { get; set; }
        public int AdopterID { get; set; }
        public int AnimalID { get; set; }
        public DateTime ApplicationDate { get; set; }
        public int StatusID { get; set; }
        public int? ReviewedByStaffID { get; set; }
        public DateTime? ReviewDate { get; set; }
        public string Notes { get; set; }
        public string? LivingSituation { get; set; }
        public string? IsAnimalAllowed { get; set; }
        public List<int> AdoptionReasonIds { get; set; }
    }
}
