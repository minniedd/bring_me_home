using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace BringMeHome.Services.Database
{
    public class AdoptionReason
    {
        public int ApplicationID { get; set; }
        public AdoptionApplication Application { get; set; }

        public int ReasonID { get; set; }
        public Reason Reason { get; set; }
    }
}
