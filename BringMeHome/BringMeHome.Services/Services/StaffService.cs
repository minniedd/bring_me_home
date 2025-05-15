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
    public class StaffService:IStaffService
    {
        private readonly BringMeHomeDbContext _context;

        public StaffService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<StaffResponse> CreateAsync(StaffRequest request)
        {
            var staff = new Staff
            {
                UserID = request.UserID,
                Position = request.Position,
                Department = request.Department,
                ShelterID = request.ShelterID,
                HireDate = request.HireDate,
                Status = request.Status,
                AccessLevel = request.AccessLevel
            };

            await _context.Staff.AddAsync(staff);
            await _context.SaveChangesAsync();


            return MapToResponse(staff);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var staff = await _context.Staff.FindAsync(id);

            if (staff == null)
            {
                return false;
            }

            _context.Staff.Remove(staff);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<PagedResult<StaffResponse>> GetAsync(StaffSearchObject search)
        {
            var query = _context.Staff.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.UserID.ToString().Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var staff = await query
                .ApplySort(search)
                .ApplyPagination(search)
                .Select(r => MapToResponse(r))
                .ToListAsync();

            return new PagedResult<StaffResponse>
            {
                Items = staff,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<StaffResponse?> GetByIdAsync(int id)
        {
            var staff = await _context.Staff
                .Where(r => r.StaffID == id)
                .Select(r => MapToResponse(r))
                .FirstOrDefaultAsync();

            return staff;
        }

        public async Task<StaffResponse?> UpdateAsync(int id, StaffRequest request)
        {
            var staff = await _context.Staff.FindAsync(id);
            if (staff == null)
            {
                return null;
            }

            staff.UserID = request.UserID;
            staff.Position = request.Position;
            staff.Department = request.Department;
            staff.ShelterID = request.ShelterID;
            staff.HireDate = request.HireDate;
            staff.Status = request.Status;
            staff.AccessLevel = request.AccessLevel;
            _context.Staff.Update(staff);
            await _context.SaveChangesAsync();

            return MapToResponse(staff);
        }

        public async Task<List<StaffResponse>> GetAllAsync()
        {
            var staff = await _context.Staff
                .Include(s=>s.User)
                .Select(r => MapToResponse(r))
                .ToListAsync();
            return staff;
        }

        private static StaffResponse MapToResponse(Staff staff)
        {
            return new StaffResponse
            {
                StaffID = staff.StaffID,
                UserID = staff.UserID,
                Position = staff.Position,
                Department = staff.Department,
                ShelterID = staff.ShelterID,
                HireDate = staff.HireDate,
                Status = staff.Status,
                AccessLevel = staff.AccessLevel,
                User = staff.User != null ? new UserResponse
                {
                    FirstName = staff.User.FirstName,
                    LastName = staff.User.LastName,
                } : null
            };
        }
    }
}
