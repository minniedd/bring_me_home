using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class AnimalsSearchObject:BaseSearchObject
    {
        public string? Name { get; set; } 
        public int? AnimalTypeId { get; set; } 
        public string? Breed { get; set; } 
        public int? CityId { get; set; } 
        public bool? IsAdopted { get; set; }
    }
}
