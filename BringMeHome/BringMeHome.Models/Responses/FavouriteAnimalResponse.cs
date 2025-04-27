using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class FavouriteAnimalResponse
    {
        public int AnimalID { get; set; }
        public string Name { get; set; }
        public int Age { get; set; }
        public string BreedName { get; set; }
        public string ShelterName { get; set; }
    }
}
