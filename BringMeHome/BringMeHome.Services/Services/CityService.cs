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
    public class CityService : ICityService
    {
        public readonly BringMeHomeDbContext _context;

        public CityService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<CityResponse> CreateAsync(CityRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CityName))
            {
                throw new ArgumentException("City name cannot be empty");
            }

            var existingColor = await _context.Cities
                .FirstOrDefaultAsync(r => r.CityName.ToLower() == request.CityName.ToLower());

            if (existingColor != null)
            {
                throw new InvalidOperationException($"City with name {request.CityName} already exists");
            }

            var city = new City
            {
                CityName = request.CityName,
                CantonID = request.CantonID,
            };

            await _context.Cities.AddAsync(city);
            await _context.SaveChangesAsync();


            return MapToResponse(city);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var city = await _context.Cities.FindAsync(id);
            if (city == null)
            {
                return false;
            }

            _context.Cities.Remove(city);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<CityResponse>> GetAsync(CitySearchObject search)
        {
            var query = _context.Cities.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.CityName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var cities = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<CityResponse>
            {
                Items = cities,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<CityResponse?> GetByIdAsync(int id)
        {
            var city = await _context.Cities.FindAsync(id);

            if (city == null)
            {
                return null;
            }

            return MapToResponse(city);
        }

        public async Task<CityResponse?> UpdateAsync(int id, CityRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CityName))
            {
                throw new ArgumentException("City name cannot be empty");
            }

            var city = await _context.Cities.FindAsync(id);
            if (city == null)
            {
                return null;
            }

            city.CityName = request.CityName;
            city.CantonID = request.CantonID;

            await _context.SaveChangesAsync();

            return MapToResponse(city);
        }

        private CityResponse MapToResponse(City city)
        {
            return new CityResponse
            {
                CityID = city.CityID,
                CityName = city.CityName,
                CantonID = city.CantonID,
            };
        }
    }
}
