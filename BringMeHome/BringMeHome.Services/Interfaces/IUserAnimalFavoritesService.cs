using BringMeHome.Models.Helpers;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IUserAnimalFavoritesService
    {
        Task<bool> UpdateFavoriteStatusAsync(int animalId, int userId, bool isFavorite);
        Task<List<int>> GetUserFavoriteAnimalIdsAsync(int userId);
    }
}
