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
    public interface ICityService
    {
        Task<PagedResult<CityResponse>> GetAsync(CitySearchObject search);
        Task<List<CityResponse>> GetAllAsync();
        Task<CityResponse?> GetByIdAsync(int id);
        Task<CityResponse> CreateAsync(CityRequest request);
        Task<CityResponse?> UpdateAsync(int id, CityRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
