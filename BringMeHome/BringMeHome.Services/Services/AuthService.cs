using BringMeHome.Models.Models;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace BringMeHome.Services.Services
{
    public class AuthService : IAuthService
    {
        private readonly BringMeHomeDbContext _dbContext;
        private readonly IConfiguration _configuration;

        public AuthService(BringMeHomeDbContext dbContext, IConfiguration configuration)
        {
            _dbContext = dbContext;
            _configuration = configuration;
        }

        public async Task<TokenResponse?> LoginAsync(UserDto request)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

            if (user is null)
            {
                return null;
            }
            if (new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, request.Password) == PasswordVerificationResult.Failed)
            {
                return null;
            }

            return await CreateTokenResponseAsync(user);
        }

        private async Task<TokenResponse> CreateTokenResponseAsync(User user)
        {
            return new TokenResponse
            {
                AccessToken = CreateToken(user),
                RefreshToken = await GenerateAndSaveRefreshTokenAsync(user)
            };
        }

        public async Task<UserRegistrationResponse?> RegisterAsync(UserRequest request)
        {
            if (await _dbContext.Users.AnyAsync(u => u.Username == request.Username))
            {
                return null;
            }

            if (await _dbContext.Users.AnyAsync(u => u.Email == request.Email))
            {
                return null;
            }

            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                PhoneNumber = request.PhoneNumber,
                Address = request.Address,
                CityID = request.CityID,
                IsActive = request.IsActive,
                CreatedAt = DateTime.UtcNow,
                UserRoles = new List<UserRole>()
            };

            var hashedPassword = new PasswordHasher<User>().HashPassword(user, request.Password);
            user.PasswordHash = hashedPassword;

            var adopterRole = await _dbContext.Roles.FirstOrDefaultAsync(r => r.RoleName == "Adopter");

            if (adopterRole != null)
            {
                user.UserRoles.Add(new UserRole
                {
                    Role = adopterRole,
                    RoleId = adopterRole.RoleID,
                    User = user 
                });
            }

            await _dbContext.Users.AddAsync(user);
            await _dbContext.SaveChangesAsync();

            var userResponse = new UserRegistrationResponse
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Username = user.Username,
                PhoneNumber = user.PhoneNumber,
                IsActive = user.IsActive,
                Roles = user.UserRoles?.Select(ur => ur.Role.RoleName).ToList() ?? new List<string>()
            };

            return userResponse;
        }

        private async Task<User?> ValidateRefreshTokenAsync(int userId, string refreshToken)
        {
            var user = await _dbContext.Users.FindAsync(userId);
            if (user is null || user.RefreshToken != refreshToken || user.RefreshTokenExpiryTime <= DateTime.UtcNow)
            {
                return null;
            }
            return user;
        }

        private string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }

        private async Task<string> GenerateAndSaveRefreshTokenAsync(User user)
        {
            var refreshToken = GenerateRefreshToken();
            user.RefreshToken = refreshToken;
            user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);
            await _dbContext.SaveChangesAsync();
            return refreshToken;
        }

        private string CreateToken(User user)
        {
            var userRoles = _dbContext.UserRoles
                .Where(ur => ur.UserId == user.Id)
                .Select(ur => ur.Role.RoleName)
                .ToList();

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())
            };

            foreach (var role in userRoles)
            {
                claims.Add(new Claim(ClaimTypes.Role, role));
            }

            // Change this line
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["AppSettings:Token"]!));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512);

            var tokenDescriptor = new JwtSecurityToken(
                issuer: _configuration["AppSettings:Issuer"],
                audience: _configuration["AppSettings:Audience"],
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(tokenDescriptor);
        }

        public async Task<TokenResponse?> RefreshTokenAsync(RefreshTokenRequest request)
        {
            var user = await ValidateRefreshTokenAsync(request.UserId, request.RefreshToken);

            if (user == null) { return null; }

            return await CreateTokenResponseAsync(user);
        }
    }
}
