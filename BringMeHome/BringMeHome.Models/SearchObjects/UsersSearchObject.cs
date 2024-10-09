using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class UsersSearchObject:BaseSearchObject
    {
        public string? UserFTS { get; set; }

        public bool? isUserRoleIncluded { get; set; } 
    }
}
