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
    public interface IStaffService
    {
        Task<PagedResult<StaffResponse>> GetAsync(StaffSearchObject search);
        Task<StaffResponse?> GetByIdAsync(int id);
        Task<List<StaffResponse>> GetAllAsync();
        Task<StaffResponse> CreateAsync(StaffRequest request);
        Task<StaffResponse?> UpdateAsync(int id, StaffRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
