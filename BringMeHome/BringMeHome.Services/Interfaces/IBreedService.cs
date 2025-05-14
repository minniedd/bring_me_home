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
    public interface IBreedService
    {
        Task<PagedResult<BreedResponse>> GetAsync(BreedSearchObject search);
        Task<List<BreedResponse>> GetAllAsync();
        Task<BreedResponse?> GetByIdAsync(int id);
        Task<List<BreedResponse>> GetBreedBySpieces(int speciesId);
        Task<BreedResponse> CreateAsync(BreedRequest request);
        Task<BreedResponse?> UpdateAsync(int id, BreedRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
