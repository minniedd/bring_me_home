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
    public class ColorService : IColorService
    {
        private readonly BringMeHomeDbContext _context;

        public ColorService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<ColorResponse> CreateAsync(ColorRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.ColorName))
            {
                throw new ArgumentException("Color name cannot be empty");
            }

            var existingColor = await _context.Colors
                .FirstOrDefaultAsync(r => r.ColorName.ToLower() == request.ColorName.ToLower());

            if (existingColor != null)
            {
                throw new InvalidOperationException($"Color with name {request.ColorName} already exists");
            }

            var color = new Color
            {
                ColorName = request.ColorName,
                Description = request.Description,
            };

            await _context.Colors.AddAsync(color);
            await _context.SaveChangesAsync();


            return MapToResponse(color);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var color = await _context.Colors.FindAsync(id);
            if (color == null)
            {
                return false;
            }

            var colorInUse = await _context.AnimalColors.AnyAsync(ur => ur.ColorID == id);
            if (colorInUse)
            {
                throw new InvalidOperationException("Cannot delete color that is assigned to animal");
            }

            _context.Colors.Remove(color);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<ColorResponse>> GetAsync(ColorSearchObject search)
        {
            var query = _context.Colors.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.ColorName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var colors = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<ColorResponse>
            {
                Items = colors,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<ColorResponse?> GetByIdAsync(int id)
        {
            var color = await _context.Colors.FindAsync(id);

            if (color == null)
            {
                return null;
            }

            return MapToResponse(color);
        }

        public async Task<ColorResponse?> UpdateAsync(int id, ColorRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.ColorName))
            {
                throw new ArgumentException("Color name cannot be empty");
            }

            var color = await _context.Colors.FindAsync(id);
            if (color == null)
            {
                return null;
            }

            var nameConflict = await _context.Colors
                .AnyAsync(r => r.ColorID != id && r.ColorName.ToLower() == request.ColorName.ToLower());

            if (nameConflict)
            {
                throw new InvalidOperationException($"Color with name {request.ColorName} already exists");
            }

            color.ColorName = request.ColorName;
            color.Description = request.Description;

            await _context.SaveChangesAsync();

            return MapToResponse(color);
        }

        private static ColorResponse MapToResponse(Color color)
        {
            return new ColorResponse
            {
                ColorID = color.ColorID,
                ColorName = color.ColorName,
                Description = color.Description
            };
        }
    }
}
