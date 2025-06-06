﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Adopters
    {
        public class Adopter
        {
            [Key]
            public int AdopterID { get; set; }

            public int UserID { get; set; }

            [StringLength(20)]
            public string Phone { get; set; }

            [StringLength(200)]
            public string Address { get; set; }

            public int CityID { get; set; }

            // Navigation properties
            [ForeignKey("UserID")]
            public virtual User User { get; set; }

            [ForeignKey("CityID")]
            public virtual City City { get; set; }

            public virtual ICollection<AdoptionApplication> AdoptionApplications { get; set; }
        }
    }
}
