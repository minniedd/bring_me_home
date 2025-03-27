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
    public class SpeciesService:ISpeciesService
    {
        private readonly BringMeHomeDbContext _context;

        public SpeciesService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<SpeciesResponse> CreateAsync(SpeciesRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.SpeciesName))
            {
                throw new ArgumentException("Species name cannot be empty");
            }

            var existingSpecies = await _context.Species
                .FirstOrDefaultAsync(r => r.SpeciesName.ToLower() == request.SpeciesName.ToLower());

            if (existingSpecies != null)
            {
                throw new InvalidOperationException($"Species with name {request.SpeciesName} already exists");
            }

            var species = new Species
            {
                SpeciesName = request.SpeciesName,
                Description = request.Description,
                AverageLifespan = request.AverageLifespan,
                CommonTraits = request.CommonTraits
            };

            await _context.Species.AddAsync(species);
            await _context.SaveChangesAsync();


            return MapToResponse(species);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var species = await _context.Species.FindAsync(id);
            if (species == null)
            {
                return false;
            }

            _context.Species.Remove(species);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<SpeciesResponse>> GetAsync(SpeciesSearchObject search)
        {
            var query = _context.Species.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.SpeciesName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var species = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<SpeciesResponse>
            {
                Items = species,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<SpeciesResponse?> GetByIdAsync(int id)
        {
            var species = await _context.Species.FindAsync(id);

            if (species == null)
            {
                return null;
            }

            return MapToResponse(species);
        }

        public async Task<SpeciesResponse?> UpdateAsync(int id, SpeciesRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.SpeciesName))
            {
                throw new ArgumentException("Species name cannot be empty");
            }

            var species = await _context.Species.FindAsync(id);
            if (species == null)
            {
                return null;
            }

            var nameConflict = await _context.Species
                .AnyAsync(r => r.SpeciesID != id && r.SpeciesName.ToLower() == request.SpeciesName.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Species with name {request.SpeciesName} already exists");
            }

            species.SpeciesName = request.SpeciesName;
            species.Description = request.Description;
            species.AverageLifespan = request.AverageLifespan;
            species.CommonTraits = request.CommonTraits;

            await _context.SaveChangesAsync();

            return MapToResponse(species);
        }

        private SpeciesResponse MapToResponse(Species species)
        {
            return new SpeciesResponse
            {
                SpeciesID = species.SpeciesID,
                SpeciesName = species.SpeciesName,
                Description = species.Description,
                AverageLifespan = species.AverageLifespan,
                CommonTraits = species.CommonTraits
            };
        }
    }
}
