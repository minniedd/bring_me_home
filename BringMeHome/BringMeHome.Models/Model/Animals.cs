using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace BringMeHome.Models.Model
{
    public class Animals
    {
        public int AnimalsId { get; set; }

        public string Name { get; set; } = null!;

        public string Age { get; set; } = null!;

        public string Gender { get; set; } = null!;

        public string Weight { get; set; } = null!;

        public string About { get; set; } = null!;

        public byte[]? Photo { get; set; }

        public DateTime? RegistrationDate { get; set; }

        public string? IsAdopted { get; set; }

        public string? IsDeleted { get; set; }

        public int? BreedId { get; set; }

        public int? AnimalTypeId { get; set; }

        public int? ShelterId { get; set; }

        public int? CityId { get; set; }
    }
}
