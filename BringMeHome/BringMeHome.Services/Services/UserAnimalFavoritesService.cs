using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class UserAnimalFavoritesService : IUserAnimalFavoritesService
    {
        private readonly BringMeHomeDbContext _context;

        public UserAnimalFavoritesService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<List<int>> GetUserFavoriteAnimalIdsAsync(int userId)
        {
            return await _context.UserAnimalFavorites
                .Where(f => f.UserId == userId)
                .Select(f => f.AnimalId)
                .ToListAsync();
        }

        public async Task<bool> UpdateFavoriteStatusAsync(int animalId, int userId, bool isFavorite)
        {
            var favorite = await _context.UserAnimalFavorites
                .FirstOrDefaultAsync(f => f.AnimalId == animalId && f.UserId == userId);

            if (isFavorite)
            {
                if (favorite == null)
                {
                    _context.UserAnimalFavorites.Add(new UserAnimalFavorite
                    {
                        AnimalId = animalId,
                        UserId = userId,
                        DateFavorited = DateTime.UtcNow
                    });
                }
            }
            else
            {
                if (favorite != null)
                {
                    _context.UserAnimalFavorites.Remove(favorite);
                }
            }

            var saveResult = await _context.SaveChangesAsync();
            return saveResult > 0;
        }
    }
}
