using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class CountryRequest
    {
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
    }
}
