using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class ApplicationStatusRequest
    {
        public int StatusID { get; set; }
        public string StatusName { get; set; }
        public string Description { get; set; }
    }
}
