using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class AnimalStatusResponse
    {
        public int StatusID { get; set; }
        public string StatusName { get; set; }
        public string Description { get; set; }
    }
}
