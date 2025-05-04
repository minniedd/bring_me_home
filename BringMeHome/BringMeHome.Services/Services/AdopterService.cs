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

        public async Task<AdopterResponse> CreateAsync(int userId, AdopterRequest request)
        {
            var adopter = await _context.Adopters
                               .Include(a => a.User)
                               .Include(a => a.City)
                               .FirstOrDefaultAsync(a => a.UserID == userId);

            var user = await _context.Users.FindAsync(userId);

            if (adopter == null)
            {
                if (user == null)
                {
                    throw new InvalidOperationException($"User has not been found!");
                }
            }

            adopter = new Adopter
            {
                UserID = userId,
                Address = request.Address,
                CityID = request.CityID,

                User = user
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
                query = query.Where(u => u.User.FirstName.Contains(search.FirstName));
            }

            if (!string.IsNullOrEmpty(search.LastName))
            {
                query = query.Where(u => u.User.LastName.Contains(search.LastName));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.User.FirstName.Contains(search.FTS) ||
                    u.User.LastName.Contains(search.FTS) ||
                    u.User.Email.Contains(search.FTS));
            }

            var adopters = await query.ToListAsync();
            return adopters.Select(MapToResponse).ToList();
        }

        public async Task<AdopterResponse?> GetByIdAsync(int id)
        {
            var adopter = await _context.Adopters
                               .Include(a => a.User)
                               .Include(a => a.City)
                               .FirstOrDefaultAsync(a => a.UserID == id);
            return adopter != null ? MapToResponse(adopter) : null;
        }

        public async Task<AdopterResponse?> UpdateAsync(int id, AdopterRequest request)
        {
            var adopter = await _context.Adopters.FindAsync(id);
            if (adopter == null)
                return null;

            adopter.User.FirstName = request.FirstName;
            adopter.User.LastName = request.LastName;
            adopter.User.Email = request.Email;
            adopter.Address = request.Address;
            adopter.City.CityID = request.CityID;


            await _context.SaveChangesAsync();

            return MapToResponse(adopter);
        }

        private AdopterResponse MapToResponse(Adopter adopter)
        {
            return new AdopterResponse
            {
                FirstName = adopter.User.FirstName,
                LastName = adopter.User.LastName,
                Address = adopter.Address,
                City = adopter.City.CityName,
                Email = adopter.User.Email,
            };
        }
    }
}
