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
    public interface IApplicationStatusService
    {
        Task<PagedResult<ApplicationStatusResponse>> GetAsync(ApplicationStatusSearchObject search);
        Task<ApplicationStatusResponse?> GetByIdAsync(int id);
        Task<ApplicationStatusResponse> CreateAsync(ApplicationStatusRequest request);
        Task<ApplicationStatusResponse?> UpdateAsync(int id, ApplicationStatusRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
