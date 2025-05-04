using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class Reason
    {
        public int ReasonID { get; set; }
        public string ReasonType { get; set; }

        public virtual ICollection<AdoptionApplication> AdoptionApplications { get; set; } = new List<AdoptionApplication>();
    }
}
