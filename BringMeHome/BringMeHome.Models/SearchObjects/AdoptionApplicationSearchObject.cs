using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class AdoptionApplicationSearchObject:BaseSearchObject
    {
        public int ApplicationID { get; set; }
        public int AdopterID { get; set; }
        public int AnimalID { get; set; }
    }
}
