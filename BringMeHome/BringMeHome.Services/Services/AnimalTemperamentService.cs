using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Migrations;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class AnimalTemperamentService:IAnimalTemperamentService
    {
        public readonly BringMeHomeDbContext _context;

        public AnimalTemperamentService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<AnimalTemperamentResponse> CreateAsync(AnimalTemperamentRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
            {
                throw new ArgumentException("Name cannot be empty");
            }

            var existing = await _context.AnimalTemperaments
                .FirstOrDefaultAsync(r => r.Name.ToLower() == request.Name.ToLower());

            if (existing != null)
            {
                throw new InvalidOperationException($"Name {request.Name} already exists");
            }

            var temperament = new AnimalTemperament
            {
                Name = request.Name,
                Description = request.Description,
            };

            await _context.AnimalTemperaments.AddAsync(temperament);
            await _context.SaveChangesAsync();


            return MapToResponse(temperament);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var temperament = await _context.AnimalTemperaments.FindAsync(id);
            if (temperament == null)
            {
                return false;
            }

            _context.AnimalTemperaments.Remove(temperament);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<AnimalTemperamentResponse>> GetAsync(AnimalTemperamentSearchObject search)
        {
            var query = _context.AnimalTemperaments.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.Name.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var temperament = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<AnimalTemperamentResponse>
            {
                Items = temperament,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<AnimalTemperamentResponse?> GetByIdAsync(int id)
        {
            var temperament = await _context.AnimalTemperaments.FindAsync(id);

            if (temperament == null)
            {
                return null;
            }

            return MapToResponse(temperament);
        }

        public async Task<AnimalTemperamentResponse?> UpdateAsync(int id, AnimalTemperamentRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
            {
                throw new ArgumentException("Name cannot be empty");
            }

            var temperament = await _context.AnimalTemperaments.FindAsync(id);
            if (temperament == null)
            {
                return null;
            }

            var nameConflict = await _context.AnimalTemperaments
                .AnyAsync(r => r.TemperamentID != id && r.Name.ToLower() == request.Name.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Temperment with name {request.Name} already exists");
            }

            temperament.Name = request.Name;
            temperament.Description = request.Description;

            await _context.SaveChangesAsync();

            return MapToResponse(temperament);
        }

        private static AnimalTemperamentResponse MapToResponse(AnimalTemperament animalTemperament)
        {
            return new AnimalTemperamentResponse
            {
                TemperamentID = animalTemperament.TemperamentID,
                Name = animalTemperament.Name,
                Description = animalTemperament.Description,
            };
        }
    }
}
