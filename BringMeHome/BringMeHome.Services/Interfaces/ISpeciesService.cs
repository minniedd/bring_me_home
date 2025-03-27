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
    public interface ISpeciesService
    {
        Task<PagedResult<SpeciesResponse>> GetAsync(SpeciesSearchObject search);
        Task<SpeciesResponse?> GetByIdAsync(int id);
        Task<SpeciesResponse> CreateAsync(SpeciesRequest request);
        Task<SpeciesResponse?> UpdateAsync(int id, SpeciesRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
