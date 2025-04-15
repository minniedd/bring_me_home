using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class ShelterRequest
    {
        public string Name { get; set; }
        public string Address { get; set; }
        public int CityID { get; set; }
        public string ZipCode { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public int Capacity { get; set; }
        public int CurrentOccupancy { get; set; }
        public string OperatingHours { get; set; }
    }
}
