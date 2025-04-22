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
    public interface IAnimalService
    {
        Task<PagedResult<AnimalResponse>> GetAsync(AnimalSearchObject search);
        Task<AnimalResponse?> GetByIdAsync(int id);
        Task<AnimalResponse> CreateAsync(AnimalRequest request);
        Task<AnimalResponse?> UpdateAsync(int id, AnimalRequest request);
        Task<bool> DeleteAsync(int id);
        Task<bool> UpdateFavoriteStatusAsync(int animalId, int userId, bool isFavorite);
    }
}
