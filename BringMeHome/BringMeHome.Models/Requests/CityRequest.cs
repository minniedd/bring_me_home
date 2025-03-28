using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class CityRequest
    {
        public string CityName { get; set; }
        public int CantonID { get; set; }
    }
}
