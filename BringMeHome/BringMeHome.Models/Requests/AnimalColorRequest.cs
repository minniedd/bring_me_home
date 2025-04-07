using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class AnimalColorRequest
    {
        public int ColorID { get; set; }
        public bool IsPrimary { get; set; }
    }
}
