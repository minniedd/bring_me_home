using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class UserInsertRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string UserEmail { get; set; } = null!;

        public string Username { get; set; } = null!;

        public string UserPhone { get; set; } = null!;

        public string Password { get; set; } = null!; 

        public string PasswordRepeat { get; set; } = null!;

        public bool? UserStatus { get; set; }
    }
}
