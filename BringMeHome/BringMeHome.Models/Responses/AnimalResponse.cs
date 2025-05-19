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
        public string SpeciesName { get; set; }
        public int BreedID { get; set; }
        public string BreedName { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; }
        public decimal Weight { get; set; }
        public DateTime DateArrived { get; set; }
        public int StatusID { get; set; }
        public string Description { get; set; }
        public string? AnimalImage { get; set; } 
        public string HealthStatus { get; set; }
        public int ShelterID { get; set; }
        public string ShelterName { get; set; }
        public int ColorID { get; set; }
        public string ColorName { get; set; }
        public int TempermentID { get; set; }
        public string TemperamentName { get; set; }
    }
}
