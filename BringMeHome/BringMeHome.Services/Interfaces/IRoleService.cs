using BringMeHome.Models.Helpers;
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
    public interface IRoleService
    {
        Task<PagedResult<RoleResponse>> GetAsync(RoleSearchObject search);
        Task<RoleResponse?> GetByIdAsync(int id);
        Task<RoleResponse> CreateAsync(RoleRequest request);
        Task<RoleResponse?> UpdateAsync(int id, RoleRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
