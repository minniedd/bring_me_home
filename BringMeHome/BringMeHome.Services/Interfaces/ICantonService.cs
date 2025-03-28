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
    public interface ICantonService
    {
        Task<PagedResult<CantonResponse>> GetAsync(CantonSearchObject search);
        Task<CantonResponse?> GetByIdAsync(int id);
        Task<CantonResponse> CreateAsync(CantonRequest request);
        Task<CantonResponse?> UpdateAsync(int id, CantonRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
