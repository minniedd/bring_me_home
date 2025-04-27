using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class AnimalService:IAnimalService
    {
        private readonly BringMeHomeDbContext _context;

        public AnimalService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<AnimalResponse> CreateAsync(AnimalRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
                throw new ArgumentException("Name cannot be empty");

            var animal = new Animal
            {
                Name = request.Name,
                Description = request.Description,
                BreedID = request.BreedID,
                Age = request.Age,
                Gender = request.Gender,
                Weight = request.Weight,
                DateArrived = request.DateArrived,
                StatusID = request.StatusID,
                HealthStatus = request.HealthStatus,
                ShelterID = request.ShelterID
            };

            await _context.Animals.AddAsync(animal);
            await _context.SaveChangesAsync();

            if (request.Colors != null && request.Colors.Any())
            {
                foreach (var colorRequest in request.Colors)
                {
                    _context.AnimalColors.Add(new Database.AnimalColor
                    {
                        AnimalID = animal.AnimalID,
                        ColorID = colorRequest.ColorID,
                        IsPrimary = colorRequest.IsPrimary
                    });
                }
            }

            if (request.TemperamentIDs != null && request.TemperamentIDs.Any())
            {
                foreach (var tempId in request.TemperamentIDs)
                {
                    _context.AnimalTemperamentJunctions.Add(new AnimalTemperamentJunction
                    {
                        AnimalID = animal.AnimalID,
                        TemperamentID = tempId,
                        Notes = string.Empty
                    });
                }
            }

            if ((request.Colors != null && request.Colors.Any()) ||
                (request.TemperamentIDs != null && request.TemperamentIDs.Any()))
            {
                await _context.SaveChangesAsync();
            }

            var response = new AnimalResponse
            {
                AnimalID = animal.AnimalID,
                Name = request.Name,
                Description = request.Description,
                BreedID = request.BreedID,
                Age = request.Age,
                Gender = request.Gender,
                Weight = request.Weight,
                DateArrived = request.DateArrived,
                StatusID = request.StatusID,
                HealthStatus = request.HealthStatus,
                ShelterID = request.ShelterID
            };

            return response;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var animalColors = await _context.AnimalColors
                .Where(ac => ac.AnimalID == id)
                .ToListAsync();
            _context.AnimalColors.RemoveRange(animalColors);

            var temperamentJunctions = await _context.AnimalTemperamentJunctions
                .Where(atj => atj.AnimalID == id)
                .ToListAsync();
            _context.AnimalTemperamentJunctions.RemoveRange(temperamentJunctions);

            var hasApplications = await _context.AdoptionApplications
                .AnyAsync(aa => aa.AnimalID == id);

            if (hasApplications)
            {
                throw new InvalidOperationException("Cannot delete animal with existing adoption applications");
            }

            await _context.SaveChangesAsync();

            var animal = await _context.Animals.FindAsync(id);
            if (animal == null)
            {
                return false;
            }

            _context.Animals.Remove(animal);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<AnimalResponse>> GetAsync(AnimalSearchObject search)
        {
            var query = _context.Animals
            .Include(a => a.Breed.Species)
            .Include(a => a.Breed)
            .Include(a => a.Shelter)
            .Include(a => a.AnimalColors)
                .ThenInclude(ac => ac.Color)
            .Include(a => a.AnimalTemperaments)
                .ThenInclude(at => at.Temperament)
            .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.Name.Contains(search.FTS) ||
                    r.AnimalColors.Any(ac => ac.Color.ColorName.Contains(search.FTS)) ||
                    r.Breed.Species.SpeciesName.Contains(search.FTS) ||
                    r.Breed.BreedName.Contains(search.FTS)
                    );
            }

            if (search.ColorID.HasValue)
            {
                query = query.Where(a => a.AnimalColors.Any(ac => ac.ColorID == search.ColorID.Value));
            }

            if (search.TemperamentID.HasValue)
            {
                query = query.Where(a => a.AnimalTemperaments.Any(at => at.TemperamentID == search.TemperamentID.Value));
            }

            if (search.SpeciesID.HasValue)
            {
                query = query.Where(a => a.Breed.SpeciesID == search.SpeciesID.Value);
            }

            if (search.BreedID.HasValue)
            {
                query = query.Where(a => a.BreedID == search.BreedID.Value);
            }

            if (search.ShelterID.HasValue)
            {
                query = query.Where(a => a.ShelterID == search.ShelterID.Value);
            }

            if(search.SpeciesName != null)
            {
                query = query.Where(a => a.Breed.Species.SpeciesName.Contains(search.SpeciesName));
            }

            if (search.BreedName != null)
            {
                query = query.Where(a => a.Breed.BreedName.Contains(search.BreedName));
            }

            var totalCount = await query.CountAsync();

            var animal = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<AnimalResponse>
            {
                Items = animal,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<AnimalResponse?> GetByIdAsync(int id)
        {
            var animal = await _context.Animals
                .Include(a => a.Breed.Species)
                .Include(a => a.Breed)
                .Include(a => a.Status)
                .Include(a => a.Shelter)
                .Include(a => a.Shelter)
                .Include(a => a.AnimalColors)
                    .ThenInclude(ac => ac.Color)
                .Include(a => a.AnimalTemperaments)
                    .ThenInclude(at => at.Temperament)
                .FirstOrDefaultAsync(a => a.AnimalID == id);

            if (animal == null)
            {
                return null;
            }

            return MapToResponse(animal);
        }

        public async Task<AnimalResponse?> UpdateAsync(int id, AnimalRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
            {
                throw new ArgumentException("Name cannot be empty");
            }

            var animal = await _context.Animals
                .Include(a => a.AnimalColors)
                .Include(a => a.AnimalTemperaments)
                .FirstOrDefaultAsync(a => a.AnimalID == id);

            if (animal == null)
            {
                return null;
            }

            animal.Name = request.Name;
            animal.Description = request.Description;
            animal.BreedID = request.BreedID;
            animal.Age = request.Age;
            animal.Gender = request.Gender;
            animal.Weight = request.Weight;
            animal.DateArrived = request.DateArrived;
            animal.StatusID = request.StatusID;
            animal.HealthStatus = request.HealthStatus;
            animal.ShelterID = request.ShelterID;

            if (request.Colors != null)
            {
                _context.AnimalColors.RemoveRange(animal.AnimalColors);
                await _context.SaveChangesAsync();

                animal.AnimalColors = request.Colors.Select(colorRequest => new Database.AnimalColor
                {
                    AnimalID = animal.AnimalID,
                    ColorID = colorRequest.ColorID,
                    IsPrimary = colorRequest.IsPrimary
                }).ToList();
            }

            if (request.TemperamentIDs != null)
            {
                _context.AnimalTemperamentJunctions.RemoveRange(animal.AnimalTemperaments);
                await _context.SaveChangesAsync();

                animal.AnimalTemperaments = request.TemperamentIDs.Select(tempId => new AnimalTemperamentJunction
                {
                    AnimalID = animal.AnimalID,
                    TemperamentID = tempId
                }).ToList();
            }

            await _context.SaveChangesAsync();

            return await GetByIdAsync(animal.AnimalID);
        }

        private static AnimalResponse MapToResponse(Animal animal)
        {
            return new AnimalResponse
            {
                AnimalID = animal.AnimalID,
                Name = animal.Name,
                Description = animal.Description,
                SpeciesID = animal.Breed.SpeciesID,
                SpeciesName = animal.Breed.Species.SpeciesName,
                BreedID = animal.BreedID,
                BreedName = animal.Breed.BreedName,
                Age = animal.Age,
                Gender = animal.Gender,
                Weight = animal.Weight,
                DateArrived = animal.DateArrived,
                StatusID = animal.StatusID,
                HealthStatus = animal.HealthStatus,
                ShelterID = animal.ShelterID,
                ShelterName = animal.Shelter?.Name,
                Colors = animal.AnimalColors?.Select(ac => new ColorResponse
                {
                    ColorID = ac.ColorID,
                    ColorName = ac.Color?.ColorName
                }).ToList(),
                Temperaments = animal.AnimalTemperaments?.Select(at => new AnimalTemperamentResponse
                {
                    TemperamentID = at.TemperamentID,
                    Name = at.Temperament?.Name
                }).ToList()
            };
        }
    }
}
