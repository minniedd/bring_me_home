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
    public class AnimalStatusService : IAnimalStatusService
    {
        private readonly BringMeHomeDbContext _context;

        public AnimalStatusService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<AnimalStatusResponse> CreateAsync(AnimalStatusRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.StatusName))
            {
                throw new ArgumentException("Status name cannot be empty");
            }

            var existingStatus = await _context.AnimalStatuses
                .FirstOrDefaultAsync(r => r.StatusName.ToLower() == request.StatusName.ToLower());

            if (existingStatus != null)
            {
                throw new InvalidOperationException($"Status with name {request.StatusName} already exists");
            }

            var status = new AnimalStatus
            {
                StatusName = request.StatusName,
                Description = request.Description,
            };

            await _context.AnimalStatuses.AddAsync(status);
            await _context.SaveChangesAsync();


            return MapToResponse(status);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var status = await _context.AnimalStatuses.FindAsync(id);
            if (status == null)
            {
                return false;
            }

            _context.AnimalStatuses.Remove(status);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<AnimalStatusResponse>> GetAsync(AnimalStatusSearchObject search)
        {
            var query = _context.AnimalStatuses.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.StatusName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var status = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<AnimalStatusResponse>
            {
                Items = status,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<AnimalStatusResponse?> GetByIdAsync(int id)
        {
            var status = await _context.AnimalStatuses.FindAsync(id);

            if (status == null)
            {
                return null;
            }

            return MapToResponse(status);
        }

        public async Task<AnimalStatusResponse?> UpdateAsync(int id, AnimalStatusRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.StatusName))
            {
                throw new ArgumentException("Status name cannot be empty");
            }

            var status = await _context.AnimalStatuses.FindAsync(id);
            if (status == null)
            {
                return null;
            }

            var nameConflict = await _context.AnimalStatuses
                .AnyAsync(r => r.StatusID != id && r.StatusName.ToLower() == request.StatusName.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Status with name {request.StatusName} already exists");
            }

            status.StatusName = request.StatusName;
            status.Description = request.Description;

            await _context.SaveChangesAsync();

            return MapToResponse(status);
        }

        private static AnimalStatusResponse MapToResponse(AnimalStatus animalStatus)
        {
            return new AnimalStatusResponse
            {
                StatusID = animalStatus.StatusID,
                StatusName = animalStatus.StatusName,
                Description = animalStatus.Description,
            };
        }
    }
}
