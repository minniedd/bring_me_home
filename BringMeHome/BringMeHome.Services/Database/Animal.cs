using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Animal
    {
        [Key]
        public int AnimalID { get; set; }

        [Required, StringLength(100)]
        public string Name { get; set; }

        public int BreedID { get; set; }

        public int Age { get; set; }

        [Required, StringLength(20)]
        public string Gender { get; set; }

        public decimal Weight { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateArrived { get; set; }

        public int StatusID { get; set; }

        [StringLength(1000)]
        public string Description { get; set; }

        public byte[]? AnimalImage { get; set; }

        [StringLength(500)]
        public string HealthStatus { get; set; }

        public int ShelterID { get; set; }

        public int? ColorID { get; set; }

        public int? TempermentID { get; set; }

        // Navigation properties
        [ForeignKey("BreedID")]
        public virtual Breed Breed { get; set; }

        [ForeignKey("StatusID")]
        public virtual AnimalStatus Status { get; set; }

        [ForeignKey("ShelterID")]
        public virtual Shelter Shelter { get; set; }

        [ForeignKey("ColorID")]
        public virtual Color Color { get; set; }

        [ForeignKey("TempermentID")]
        public virtual AnimalTemperament AnimalTemperament { get; set; }

        public virtual ICollection<AdoptionApplication> AdoptionApplications { get; set; }
    }
}
