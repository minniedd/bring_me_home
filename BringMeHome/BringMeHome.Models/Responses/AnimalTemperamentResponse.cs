﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Responses
{
    public class AnimalTemperamentResponse
    {
        public int TemperamentID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}
