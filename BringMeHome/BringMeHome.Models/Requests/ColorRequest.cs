using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class ColorRequest
    {
        public string ColorName { get; set; }
        public string Description { get; set; }

    }
}
