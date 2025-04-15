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
    public class CountryService:ICountryService
    {
        private readonly BringMeHomeDbContext _context;

        public CountryService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<CountryResponse> CreateAsync(CountryRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CountryName))
            {
                throw new ArgumentException("Country name cannot be empty");
            }

            var existingCountry = await _context.Countries
                .FirstOrDefaultAsync(r => r.CountryName.ToLower() == request.CountryName.ToLower());

            if (existingCountry != null)
            {
                throw new InvalidOperationException($"Country with name {request.CountryName} already exists");
            }

            var country = new Country
            {
                CountryName = request.CountryName,
                CountryCode = request.CountryCode, 
            };

            await _context.Countries.AddAsync(country);
            await _context.SaveChangesAsync();


            return MapToResponse(country);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var country = await _context.Countries.FindAsync(id);
            if (country == null)
            {
                return false;
            }

            _context.Countries.Remove(country);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<CountryResponse>> GetAsync(CountrySearchObject search)
        {
            var query = _context.Countries.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.CountryName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var countries = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<CountryResponse>
            {
                Items = countries,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<CountryResponse?> GetByIdAsync(int id)
        {
            var country = await _context.Countries.FindAsync(id);

            if (country == null)
            {
                return null;
            }

            return MapToResponse(country);
        }

        public async Task<CountryResponse?> UpdateAsync(int id, CountryRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.CountryName))
            {
                throw new ArgumentException("Country name cannot be empty");
            }

            var country = await _context.Countries.FindAsync(id);
            if (country == null)
            {
                return null;
            }

            country.CountryName = request.CountryName;
            country.CountryCode = request.CountryCode;

            await _context.SaveChangesAsync();

            return MapToResponse(country);
        }

        private static CountryResponse MapToResponse(Country country)
        {
            return new CountryResponse
            {
                CountryID = country.CountryID,
                CountryName = country.CountryName,
                CountryCode = country.CountryCode
            };
        }
    }
}
