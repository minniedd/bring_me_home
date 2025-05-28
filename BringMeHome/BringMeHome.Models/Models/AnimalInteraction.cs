using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Models
{
    public class AnimalInteraction
    {
        [Microsoft.ML.Data.KeyType(count: 10000)]
        public uint UserId { get; set; }
        [Microsoft.ML.Data.KeyType(count: 10000)]
        public uint AnimalId { get; set; }
        public float Label { get; set; }
    }
}
