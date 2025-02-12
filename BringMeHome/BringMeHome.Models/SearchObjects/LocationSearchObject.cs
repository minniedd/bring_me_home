using BringMeHome.Models.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class LocationSearchObject:BaseSearchObject
    {
        public string CantonName { get; set; }
        public string CityName { get; set; }
    }
}
