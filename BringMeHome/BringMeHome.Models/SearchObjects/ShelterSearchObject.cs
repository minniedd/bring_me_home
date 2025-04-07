using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class ShelterSearchObject:BaseSearchObject
    {
        public int? CityID { get; set; }
        public int? CantonID { get; set; }
    }
}
