using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class ReviewRequest
    {
        public int UserID { get; set; }
        public int ShelterID { get; set; }
        [Range(1, 5)]
        public int Rating { get; set; }
        public string? Comment { get; set; }
    }
}
