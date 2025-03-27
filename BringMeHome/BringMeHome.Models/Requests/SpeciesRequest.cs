using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class SpeciesRequest
    {
        public string SpeciesName { get; set; }
        public string Description { get; set; }
        public int AverageLifespan { get; set; }
        public string CommonTraits { get; set; }
    }
}
