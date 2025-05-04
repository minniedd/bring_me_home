using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
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
    public class ReasonService:IReasonService
    {
        private readonly BringMeHomeDbContext _context;

        public ReasonService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<ReasonResponse> CreateAsync(ReasonRequest request)
        {
            var reason = new Reason
            {
                ReasonType = request.ReasonType,
            };

            _context.Reasons.Add(reason);
            await _context.SaveChangesAsync();

            return MapToResponse(reason);
        }

        public async Task<List<ReasonResponse>> GetAsync()
        {
            var reasons = await _context.Reasons.ToListAsync();

            return reasons.Select(MapToResponse).ToList(); ;
        }

        public async Task<ReasonResponse?> GetByIdAsync(int id)
        {
            var reason = await _context.Reasons.FindAsync(id);
            if (reason == null)
            {
                return null;
            }

            return MapToResponse(reason);
        }

        public async Task<ReasonResponse?> UpdateAsync(int id, ReasonRequest request)
        {
            var reason = await _context.Reasons.FindAsync(id);
            if (reason == null)
            {
                return null;
            }

            reason.ReasonType = request.ReasonType;

            _context.Reasons.Update(reason);
            await _context.SaveChangesAsync();

            return MapToResponse(reason);
        }

        private static ReasonResponse MapToResponse(Reason reason)
        {
            return new ReasonResponse
            {
                ReasonID = reason.ReasonID,
                ReasonType = reason.ReasonType,
            };
        }
    }
}
