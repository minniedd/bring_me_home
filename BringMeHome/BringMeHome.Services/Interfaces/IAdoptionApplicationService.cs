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
    public interface IAdoptionApplicationService
    {
        Task<AdoptionApplicationResponse> CreateAsync(int id, AdoptionApplicationRequest request);
        Task<AdoptionApplicationResponse?> UpdateAsync(int id, AdoptionApplicationRequest request);
        Task<AdoptionApplicationResponse?> GetByIdAsync(int id);
        Task<List<AdoptionApplicationResponse>> GetAppointmentsByAnimal(int animalId);
        Task<PagedResult<AdoptionApplicationResponse>> GetAsync(int? userId, AdoptionApplicationSearchObject search);
    }
}
