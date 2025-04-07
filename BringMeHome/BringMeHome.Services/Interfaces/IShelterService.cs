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
    public interface IShelterService
    {
        Task<PagedResult<ShelterResponse>> GetAsync(ShelterSearchObject search);
        Task<ShelterResponse?> GetByIdAsync(int id);
        Task<ShelterResponse> CreateAsync(ShelterRequest request);
        Task<ShelterResponse?> UpdateAsync(int id, ShelterRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
