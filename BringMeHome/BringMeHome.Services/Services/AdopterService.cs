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
using static BringMeHome.Services.Database.Adopters;

namespace BringMeHome.Services.Services
{
    public class AdopterService:IAdopterService
    {
        private readonly BringMeHomeDbContext _context;

        public AdopterService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<AdopterResponse> CreateAsync(AdopterRequest request)
        {
            var adopter = new Adopter
            {
                UserID = request.UserID,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Phone = request.Phone,
                Address = request.Address,
                CityID = request.CityID,
                CantonID = request.CantonID,
                ZipCode = request.ZipCode,
                DateRegistered = DateTime.UtcNow
            };

            _context.Adopters.Add(adopter);
            await _context.SaveChangesAsync();

            return MapToResponse(adopter);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var adopter = await _context.Adopters.FindAsync(id);
            if (adopter == null)
                return false;

            _context.Adopters.Remove(adopter);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<List<AdopterResponse>> GetAsync(AdopterSearchObject search)
        {
            var query = _context.Adopters.AsQueryable();

            if (search.UserID.HasValue)
            {
                query = query.Where(u => u.UserID == search.UserID.Value);
            }

            if (!string.IsNullOrEmpty(search.FirstName))
            {
                query = query.Where(u => u.FirstName.Contains(search.FirstName));
            }

            if (!string.IsNullOrEmpty(search.LastName))
            {
                query = query.Where(u => u.LastName.Contains(search.LastName));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(search.FTS) ||
                    u.LastName.Contains(search.FTS) ||
                    u.Email.Contains(search.FTS));
            }

            var adopters = await query.ToListAsync();
            return adopters.Select(MapToResponse).ToList();
        }

        public async Task<AdopterResponse?> GetByIdAsync(int id)
        {
            var adopter = await _context.Adopters.FindAsync(id);
            return adopter != null ? MapToResponse(adopter) : null;
        }

        public async Task<AdopterResponse?> UpdateAsync(int id, AdopterRequest request)
        {
            var adopter = await _context.Adopters.FindAsync(id);
            if (adopter == null)
                return null;

            adopter.FirstName = request.FirstName;
            adopter.LastName = request.LastName;
            adopter.Email = request.Email;
            adopter.Phone = request.Phone;
            adopter.Address = request.Address;
            adopter.CityID = request.CityID;
            adopter.CantonID = request.CantonID;
            adopter.ZipCode = request.ZipCode;

            await _context.SaveChangesAsync();

            return MapToResponse(adopter);
        }

        private AdopterResponse MapToResponse(Adopter adopter)
        {
            return new AdopterResponse
            {
                UserID = adopter.UserID,
                FirstName = adopter.FirstName,
                LastName = adopter.LastName,
                Email = adopter.Email,
                Phone = adopter.Phone,
                Address = adopter.Address,
                CityID = adopter.CityID,
                CantonID = adopter.CantonID,
                ZipCode = adopter.ZipCode
            };
        }
    }
}
