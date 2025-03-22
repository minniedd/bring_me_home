using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IUserService
    {
        Task<List<UserResponse>> GetAsync(UserSearchObject search);
        Task<UserResponse?> GetByIdAsync(int id);
        Task<UserResponse> CreateAsync(UserRequest request);
        Task<UserResponse?> UpdateAsync(int id, UserRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
