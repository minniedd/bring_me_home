using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class StaffResponse
    {
        public int StaffID { get; set; }
        public int UserID { get; set; }
        public string Position { get; set; }
        public string Department { get; set; }
        public int ShelterID { get; set; }
        public DateTime HireDate { get; set; }
        public string Status { get; set; }
        public int AccessLevel { get; set; }
        public UserResponse? User { get; set; }
    }
}
