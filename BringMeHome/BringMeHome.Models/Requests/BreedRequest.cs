using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class BreedRequest
    {
        public int SpeciesID { get; set; }
        public string BreedName { get; set; }
        public string Description { get; set; }
        public string SizeCategory { get; set; }
        public string TemperamentNotes { get; set; }
        public string SpecialNeeds { get; set; }
        public string CommonHealthIssues { get; set; }
    }
}
