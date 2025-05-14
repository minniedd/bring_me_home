using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
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
    public class BreedService : IBreedService
    {
        private readonly BringMeHomeDbContext _context;

        public BreedService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<BreedResponse> CreateAsync(BreedRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.BreedName))
            {
                throw new ArgumentException("Breed name cannot be empty");
            }

            var existingBreed = await _context.Breeds
                .FirstOrDefaultAsync(r => r.BreedName.ToLower() == request.BreedName.ToLower());

            if (existingBreed != null)
            {
                throw new InvalidOperationException($"Breed with name {request.BreedName} already exists");
            }

            var breed = new Breed
            {
                SpeciesID = request.SpeciesID,
                BreedName = request.BreedName,
                Description = request.Description,
                SizeCategory = request.SizeCategory,
                TemperamentNotes = request.TemperamentNotes,
                SpecialNeeds = request.SpecialNeeds,
                CommonHealthIssues = request.CommonHealthIssues

            };

            await _context.Breeds.AddAsync(breed);
            await _context.SaveChangesAsync();


            return MapToResponse(breed);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var breed = await _context.Breeds.FindAsync(id);
            if (breed == null)
            {
                return false;
            }

            _context.Breeds.Remove(breed);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<BreedResponse>> GetAsync(BreedSearchObject search)
        {
            var query = _context.Breeds.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.BreedName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var breed = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<BreedResponse>
            {
                Items = breed,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<BreedResponse?> GetByIdAsync(int id)
        {
            var breed = await _context.Breeds.FindAsync(id);

            if (breed == null)
            {
                return null;
            }

            return MapToResponse(breed);
        }

        public async Task<BreedResponse?> UpdateAsync(int id, BreedRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.BreedName))
            {
                throw new ArgumentException("Breed name cannot be empty");
            }

            var breed = await _context.Breeds.FindAsync(id);
            if (breed == null)
            {
                return null;
            }

            var nameConflict = await _context.Breeds
                .AnyAsync(r => r.BreedID != id && r.BreedName.ToLower() == request.BreedName.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Breed with name {request.BreedName} already exists");
            }

            breed.BreedName = request.BreedName;
            breed.Description = request.Description;
            breed.SizeCategory = request.SizeCategory;
            breed.TemperamentNotes = request.TemperamentNotes;
            breed.SpecialNeeds = request.SpecialNeeds;
            breed.CommonHealthIssues = request.CommonHealthIssues;

            await _context.SaveChangesAsync();

            return MapToResponse(breed);
        }

        public async Task<List<BreedResponse>> GetAllAsync()
        {
            var query = _context.Breeds.AsQueryable();

            var breeds = await query
               .Select(r => MapToResponse(r))
               .ToListAsync();

            return breeds;
        }

        public async Task<List<BreedResponse>> GetBreedBySpieces(int speciesId)
        {
            var query = _context.Breeds.Where(b => b.SpeciesID == speciesId).AsQueryable();
            var breeds = await query
                .Select(r => MapToResponse(r))
                .ToListAsync();
            return breeds;
        }

        private static BreedResponse MapToResponse(Breed breed)
        {
            return new BreedResponse
            {
                BreedID = breed.BreedID,
                SpeciesID = breed.SpeciesID,
                BreedName = breed.BreedName,
                Description = breed.Description,
                SizeCategory = breed.SizeCategory,
                TemperamentNotes = breed.TemperamentNotes,
                SpecialNeeds = breed.SpecialNeeds,
                CommonHealthIssues = breed.CommonHealthIssues,
            };
        }
    } 
}
