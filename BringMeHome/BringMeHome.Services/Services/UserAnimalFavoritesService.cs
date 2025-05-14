using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

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

        public async Task<List<AnimalResponse>> GetUserFavoriteAnimalsAsync(int userId)
        {
            var favoriteAnimalIds = await GetUserFavoriteAnimalIdsAsync(userId);

            return await _context.Animals
                .Where(a => favoriteAnimalIds.Contains(a.AnimalID))
                .Include(a => a.Shelter)
                .Include(a => a.Breed)
                    .ThenInclude(b => b.Species)
                .Include(a => a.Color)
                .Include(a => a.AnimalTemperament)
                .Select(animal => MapToResponse(animal)) .ToListAsync();
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

        private static AnimalResponse MapToResponse(Animal animal)
        {
            return new AnimalResponse
            {
                AnimalID = animal.AnimalID,
                Name = animal.Name,
                Description = animal.Description,
                SpeciesID = animal.Breed?.SpeciesID ?? 0,
                SpeciesName = animal.Breed?.Species?.SpeciesName,
                BreedID = animal.BreedID,
                BreedName = animal.Breed?.BreedName,
                Age = animal.Age,
                Gender = animal.Gender,
                Weight = animal.Weight,
                DateArrived = animal.DateArrived,
                StatusID = animal.StatusID,
                HealthStatus = animal.HealthStatus,
                ShelterID = animal.ShelterID,
                ShelterName = animal.Shelter?.Name,
                ColorID = animal.ColorID ?? 0,
                ColorName = animal.Color?.ColorName,
                TempermentID = animal.TempermentID ?? 0,
                TemperamentName = animal.AnimalTemperament?.Name
            };
        }
    }
}
