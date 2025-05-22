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
    public class CantonService:ICantonService
    {
        private readonly BringMeHomeDbContext _context;

        public CantonService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<CantonResponse> CreateAsync(CantonRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CantonName))
            {
                throw new ArgumentException("Canton name cannot be empty");
            }

            var existingCanton = await _context.Cantons
                .FirstOrDefaultAsync(r => r.CantonName.ToLower() == request.CantonName.ToLower());

            if (existingCanton != null)
            {
                throw new InvalidOperationException($"City with name {request.CantonName} already exists");
            }

            var canton = new Canton
            {
                CantonName = request.CantonName,
                CantonCode = request.CantonCode,
                CountryID = request.CountryID
            };

            await _context.Cantons.AddAsync(canton);
            await _context.SaveChangesAsync();


            return MapToResponse(canton);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var canton = await _context.Cantons.FindAsync(id);
            if (canton == null)
            {
                return false;
            }

            _context.Cantons.Remove(canton);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<CantonResponse>> GetAsync(CantonSearchObject search)
        {
            var query = _context.Cantons.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.CantonName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var cantons = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<CantonResponse>
            {
                Items = cantons,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<CantonResponse?> GetByIdAsync(int id)
        {
            var canton = await _context.Cantons.FindAsync(id);

            if (canton == null)
            {
                return null;
            }

            return MapToResponse(canton);
        }

        public async Task<CantonResponse?> UpdateAsync(int id, CantonRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CantonName))
            {
                throw new ArgumentException("Canton name cannot be empty");
            }

            var canton = await _context.Cantons.FindAsync(id);
            if (canton == null)
            {
                return null;
            }

            canton.CantonName = request.CantonName;
            canton.CantonCode = request.CantonCode;
            canton.CountryID = request.CountryID;

            await _context.SaveChangesAsync();

            return MapToResponse(canton);
        }

        public async Task<List<CantonResponse>> GetAllAsync()
        {
            var query = _context.Cantons.AsQueryable();

            var cantons = await query
               .Select(r => MapToResponse(r))
               .ToListAsync();

            return cantons;
        }

        private static CantonResponse MapToResponse(Canton canton)
        {
            return new CantonResponse
            {
                CantonID = canton.CantonID,
                CantonName = canton.CantonName,
                CantonCode = canton.CantonCode,
                CountryID = canton.CountryID
            };
        }
    }
}
