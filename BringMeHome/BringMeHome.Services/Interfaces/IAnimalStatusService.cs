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
    public interface IAnimalStatusService
    {
        Task<PagedResult<AnimalStatusResponse>> GetAsync(AnimalStatusSearchObject search);
        Task<List<AnimalStatusResponse>> GetAllAsync();
        Task<AnimalStatusResponse?> GetByIdAsync(int id);
        Task<AnimalStatusResponse> CreateAsync(AnimalStatusRequest request);
        Task<AnimalStatusResponse?> UpdateAsync(int id, AnimalStatusRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
