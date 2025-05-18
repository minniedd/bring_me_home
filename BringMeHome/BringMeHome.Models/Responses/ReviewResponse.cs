using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class ReviewResponse
    {
        public int ReviewID { get; set; }
        public int UserID { get; set; }
        public string? ShelterName { get; set; }
        public float Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public UserResponse User { get; set; }
    }
}
