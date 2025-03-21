using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
        public class Shelter
        {
            [Key]
            public int ShelterID { get; set; }

            [Required, StringLength(100)]
            public string Name { get; set; }

            [StringLength(200)]
            public string Address { get; set; }

            public int CityID { get; set; }

            public int CantonID { get; set; }

            [StringLength(20)]
            public string ZipCode { get; set; }

            [StringLength(20)]
            public string Phone { get; set; }

            [EmailAddress, StringLength(100)]
            public string Email { get; set; }

            public int Capacity { get; set; }

            public int CurrentOccupancy { get; set; }

            [StringLength(200)]
            public string OperatingHours { get; set; }

            // Navigation properties
            [ForeignKey("CityID")]
            public virtual City City { get; set; }

            [ForeignKey("CantonID")]
            public virtual Canton Canton { get; set; }

            public virtual ICollection<Animal> Animals { get; set; }
            public virtual ICollection<Staff> Staff { get; set; }
        }
    }
