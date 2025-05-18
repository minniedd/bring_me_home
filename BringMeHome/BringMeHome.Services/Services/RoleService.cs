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
    public class RoleService : IRoleService
    {
        private readonly BringMeHomeDbContext _context;

        public RoleService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<RoleResponse> CreateAsync(RoleRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.RoleName))
            {
                throw new ArgumentException("Role name cannot be empty");
            }

            var existingRole = await _context.Roles
                .FirstOrDefaultAsync(r => r.RoleName.ToLower() == request.RoleName.ToLower());

            if (existingRole != null)
            {
                throw new InvalidOperationException($"Role with name {request.RoleName} already exists");
            }

            var role = new Role
            {
                RoleName = request.RoleName,
                Description = request.Description,
                CreatedDate = DateTime.UtcNow
            };

            await _context.Roles.AddAsync(role);
            await _context.SaveChangesAsync();


            return MapToResponse(role);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var role = await _context.Roles.FindAsync(id);
            if (role == null)
            {
                return false;
            }

            var roleInUse = await _context.UserRoles.AnyAsync(ur => ur.RoleId == id);
            if (roleInUse)
            {
                throw new InvalidOperationException("Cannot delete role that is assigned to users");
            }

            _context.Roles.Remove(role);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<RoleResponse>> GetAsync(RoleSearchObject search)
        {
            var query = _context.Roles.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.RoleName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var roles = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<RoleResponse>
            {
                Items = roles,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };

        }

        public async Task<RoleResponse?> GetByIdAsync(int id)
        {
            var role = await _context.Roles.FindAsync(id);

            if (role == null)
            {
                return null;
            }

            return MapToResponse(role);
        }

        public async Task<RoleResponse?> UpdateAsync(int id, RoleRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.RoleName))
            {
                throw new ArgumentException("Role name cannot be empty");
            }

            var role = await _context.Roles.FindAsync(id);
            if (role == null)
            {
                return null;
            }

            var nameConflict = await _context.Roles
                .AnyAsync(r => r.RoleID != id && r.RoleName.ToLower() == request.RoleName.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Role with name {request.RoleName} already exists");
            }

            role.RoleName = request.RoleName;
            role.Description = request.Description;
            role.UpdatedDate = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return MapToResponse(role);
        }

        private static RoleResponse MapToResponse(Role role)
        {
            return new RoleResponse
            {
                RoleID = role.RoleID,
                RoleName = role.RoleName,
                Description = role.Description
            };
        }

    }
}
