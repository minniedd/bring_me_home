using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class AppReportResponse
    {
        public int TotalAnimals { get; set; }
        public int TotalAdoptions { get; set; }
        public int TotalActiveAdoptions { get; set; }
        public Dictionary<string, int> TotalAnimalsBySpecies { get; set; } = new Dictionary<string, int>(); 
    }
}
