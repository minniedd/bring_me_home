using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static BringMeHome.Services.Database.Adopters;

namespace BringMeHome.Services.Database
{
    public class Feedback
    {
        public int FeedbackID { get; set; }
        public int AdopterID { get; set; } 
        public int AnimalID { get; set; } 
        public int ShelterID { get; set; } 
        public int Rating { get; set; } 
        public string Comment { get; set; }
        public DateTime FeedbackDate { get; set; }

        // Navigation Properties
        public Adopter Adopter { get; set; }
        public Animal Animal { get; set; }
        public Shelter Shelter { get; set; }
    }
}
