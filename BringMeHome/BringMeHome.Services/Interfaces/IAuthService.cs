using BringMeHome.Models.Models;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace BringMeHome.Services.Interfaces
{
    public interface IAuthService
    {
        Task<UserRegistrationResponse?> RegisterAsync(UserRequest request);
        Task<TokenResponse?> LoginAsync(UserDto request);
        Task<TokenResponse?> RefreshTokenAsync(RefreshTokenRequest request);
    }
}
