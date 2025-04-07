using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class AnimalResponse
    {
        public int AnimalID { get; set; }
        public string Name { get; set; }
        public int SpeciesID { get; set; }
        public int BreedID { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; }
        public decimal Weight { get; set; }
        public DateTime DateArrived { get; set; }
        public int StatusID { get; set; }
        public string Description { get; set; }
        public string HealthStatus { get; set; }
        public int ShelterID { get; set; }
        public List<ColorResponse> Colors { get; set; }
        public List<AnimalTemperamentResponse> Temperaments { get; set; }
    }
}
