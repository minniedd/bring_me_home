using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class AnimalUpdateRequest
    {
        public string Name { get; set; } = null!;

        public string Age { get; set; } = null!;

        public string Gender { get; set; } = null!;

        public string Weight { get; set; } = null!;

        public string About { get; set; } = null!;

        public byte[]? Photo { get; set; }

        public string? IsAdopted { get; set; }

        public string? IsDeleted { get; set; }

        public int? BreedId { get; set; }

        public int? AnimalTypeId { get; set; }
    }
}
