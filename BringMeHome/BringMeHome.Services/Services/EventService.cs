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
    public class EventService:IEventService
    {
        private readonly BringMeHomeDbContext _context;

        public EventService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<EventResponse> CreateAsync(EventRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.EventName))
            {
                throw new ArgumentException("Event name cannot be empty");
            }

            var events = new Event
            {
                EventName = request.EventName,
                EventDate = request.EventDate,
                Location = request.Location,
                Description = request.Description,
                ShelterID = request.ShelterID
            };

            await _context.Events.AddAsync(events);
            await _context.SaveChangesAsync();


            return MapToResponse(events);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var events = await _context.Events.FindAsync(id);
            if (events == null)
            {
                return false;
            }

            _context.Events.Remove(events);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<EventResponse>> GetAsync(EventSearchObject search)
        {
            var query = _context.Events.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.EventName.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var events = await query
             .Include(r => r.Shelter)
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<EventResponse>
            {
                Items = events,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<EventResponse?> GetByIdAsync(int id)
        {
            var events = await _context.Events.FindAsync(id);

            if (events == null)
            {
                return null;
            }

            return MapToResponse(events);
        }

        public async Task<EventResponse?> UpdateAsync(int id, EventRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.EventName))
            {
                throw new ArgumentException("Event name cannot be empty");
            }

            var events = await _context.Events.FindAsync(id);
            if (events == null)
            {
                return null;
            }

            events.EventName = request.EventName;
            events.EventDate = request.EventDate;
            events.Location = request.Location;
            events.Description = request.Description;
            events.ShelterID = request.ShelterID;

            await _context.SaveChangesAsync();

            return MapToResponse(events);
        }

        private static EventResponse MapToResponse(Event status)
        {
            return new EventResponse
            {
                EventID = status.EventID,
                EventName = status.EventName,
                EventDate = status.EventDate,
                Location = status.Location,
                Description = status.Description,
                ShelterID = status.ShelterID,
                ShelterName = status.Shelter?.Name
            };
        }
    }
}
