using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Model
{
    public class Location
    {
        public int CityId { get; set; }
        public string CityName { get; set; }
        public int CantonId { get; set; }
        public string CantonName { get; set; }
    }
}
