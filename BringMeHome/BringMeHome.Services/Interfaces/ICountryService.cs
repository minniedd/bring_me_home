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
    public interface ICountryService
    {
        Task<PagedResult<CountryResponse>> GetAsync(CountrySearchObject search);
        Task<CountryResponse?> GetByIdAsync(int id);
        Task<CountryResponse> CreateAsync(CountryRequest request);
        Task<CountryResponse?> UpdateAsync(int id, CountryRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
