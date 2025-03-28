using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class CantonResponse
    {
        public int CantonID { get; set; }
        public string CantonName { get; set; }
        public string CantonCode { get; set; }
        public int CountryID { get; set; }
    }
}
