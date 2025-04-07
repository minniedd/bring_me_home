using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class AnimalSearchObject:BaseSearchObject
    {
        public int? ColorID { get; set; }
        public int? TemperamentID { get; set; }
        public int? SpeciesID { get; set; }
        public int? BreedID { get; set; }
        public int? ShelterID { get; set; }
    }
}
