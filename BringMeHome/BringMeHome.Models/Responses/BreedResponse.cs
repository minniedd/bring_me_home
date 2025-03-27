using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class BreedResponse
    {
        public int BreedID { get; set; }
        public int SpeciesID { get; set; }
        public string BreedName { get; set; }
        public string Description { get; set; }
        public string SizeCategory { get; set; }
        public string TemperamentNotes { get; set; }
        public string SpecialNeeds { get; set; }
        public string CommonHealthIssues { get; set; }
    }
}
