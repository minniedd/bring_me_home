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
    public class ShelterService:IShelterService
    {
        private readonly BringMeHomeDbContext _context;

        public ShelterService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<ShelterResponse> CreateAsync(ShelterRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
            {
                throw new ArgumentException("Shelter name cannot be empty");
            }

            var shelter = new Shelter
            {
                Name = request.Name,
                Address = request.Address,
                CityID = request.CityID,
                ZipCode = request.ZipCode,
                Phone = request.Phone,
                Email = request.Email,
                Capacity = request.Capacity,
                OperatingHours = request.OperatingHours
            };

            await _context.Shelters.AddAsync(shelter);
            shelter.CurrentOccupancy = await _context.Animals.CountAsync(a => a.ShelterID == shelter.ShelterID);
            await _context.SaveChangesAsync();


            return MapToResponse(shelter);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var shelter = await _context.Shelters.FindAsync(id);
            if (shelter == null)
            {
                return false;
            }

            _context.Shelters.Remove(shelter);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<ShelterResponse>> GetAsync(ShelterSearchObject search)
        {
            var query = _context.Shelters.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.Name.Contains(search.FTS) ||
                    r.City.CityName.Contains(search.FTS) ||
                    r.City.Canton.CantonName.Contains(search.FTS)
                );
            }

            if (search.CityID.HasValue)
            {
                query = query.Where(a => a.CityID == search.CityID.Value);
            }

            if (search.CantonID.HasValue)
            {
                query = query.Where(a => a.City.CantonID == search.CantonID.Value);
            }

            var totalCount = await query.CountAsync();

            var shelter = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<ShelterResponse>
            {
                Items = shelter,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<ShelterResponse?> GetByIdAsync(int id)
        {
            var shelter = await _context.Shelters.FindAsync(id);

            if (shelter == null)
            {
                return null;
            }

            return MapToResponse(shelter);
        }

        public async Task<ShelterResponse?> UpdateAsync(int id, ShelterRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Name))
            {
                throw new ArgumentException("Shelter name cannot be empty");
            }

            var shelter = await _context.Shelters.FindAsync(id);
            if (shelter == null)
            {
                return null;
            }

            shelter.Name = request.Name;
            shelter.Address = request.Address;
            shelter.CityID = request.CityID;
            shelter.ZipCode = request.ZipCode;
            shelter.Phone = request.Phone;
            shelter.Email = request.Email;
            shelter.Capacity = request.Capacity;
            shelter.OperatingHours = request.OperatingHours;

            shelter.CurrentOccupancy = await _context.Animals.CountAsync(a => a.ShelterID == id);
            await _context.SaveChangesAsync();

            return MapToResponse(shelter);
        }

        private static ShelterResponse MapToResponse(Shelter shelter)
        {
            return new ShelterResponse
            {
                ShelterID = shelter.ShelterID,
                Name = shelter.Name,
                Address = shelter.Address,
                CityID = shelter.CityID,
                ZipCode = shelter.ZipCode,
                Phone = shelter.Phone,
                Email = shelter.Email,
                Capacity = shelter.Capacity,
                CurrentOccupancy = shelter.CurrentOccupancy,
                OperatingHours = shelter.OperatingHours
            };
        }
    }
}
