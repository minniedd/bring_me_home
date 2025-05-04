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
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class UserService : IUserService
    {
        private readonly BringMeHomeDbContext _context;
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;

        public UserService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<UserResponse> CreateAsync(UserRequest request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }

            if (await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                throw new InvalidOperationException("A user with this username already exists.");
            }

            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                Address = request.Address,
                PhoneNumber = request.PhoneNumber,
                IsActive = request.IsActive,
                CreatedAt = DateTime.UtcNow
            };

            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return MapToResponse(user);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<PagedResult<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrEmpty(search.Username))
            {
                query = query.Where(u => u.Username.Contains(search.Username));
            }

            if (!string.IsNullOrEmpty(search.Email))
            {
                query = query.Where(u => u.Email.Contains(search.Email));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(search.FTS) ||
                    u.LastName.Contains(search.FTS) ||
                    u.Username.Contains(search.FTS) ||
                    u.Email.Contains(search.FTS));
            }

            var totalCount = await query.CountAsync();

            var users = await query
                .ApplySort(search)
                .ApplyPagination(search)
                .Select(r => MapToResponse(r))
                .ToListAsync();

            return new PagedResult<UserResponse>
            {
                Items = users,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            return user != null ? MapToResponse(user) : null;
        }

        public async Task<UserResponse?> UpdateAsync(int id, UserRequest request)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return null;

            if (await _context.Users.AnyAsync(u => u.Email == request.Email && u.Id != id))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }

            if (await _context.Users.AnyAsync(u => u.Username == request.Username && u.Id != id))
            {
                throw new InvalidOperationException("A user with this username already exists.");
            }

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.Email = request.Email;
            user.Username = request.Username;
            user.Address = request.Address;
            user.PhoneNumber = request.PhoneNumber;
            user.IsActive = request.IsActive;

            // Handle password if provided
            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            await _context.SaveChangesAsync();
            return MapToResponse(user);
        }

        private static UserResponse MapToResponse(User user)
        {
            return new UserResponse
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Username = user.Username,
                Address = user.Address,
                PhoneNumber = user.PhoneNumber,
                IsActive = user.IsActive,
                CreatedAt = user.CreatedAt,
                LastLoginAt = user.LastLoginAt
            };
        }

        private string HashPassword(string password, out byte[] salt)
        {
            salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                return Convert.ToBase64String(pbkdf2.GetBytes(KeySize));
            }
        }
    }
}
