using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class AnimalRequest
    {
        public string Name { get; set; }
        public int BreedID { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; }
        public decimal Weight { get; set; }
        public DateTime DateArrived { get; set; }
        public int StatusID { get; set; }
        public string Description { get; set; }
        public byte[]? AnimalImage { get; set; }
        public string? HealthStatus { get; set; }
        public int ShelterID { get; set; }
        public int ColorID { get; set; } 
        public int TemperamentID { get; set; }
    }
}
