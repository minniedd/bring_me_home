using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Review
    {
        [Key]
        public int ReviewID { get; set; }
        public int UserID { get; set; }
        public int ShelterID { get; set; }
        public float Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public virtual User User { get; set; }
        public virtual Shelter Shelter { get; set; }
    }
}
