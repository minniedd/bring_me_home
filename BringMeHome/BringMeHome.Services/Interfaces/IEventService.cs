using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IEventService
    {
        Task<PagedResult<EventResponse>> GetAsync(EventSearchObject search);
        Task<EventResponse?> GetByIdAsync(int id);
        Task<EventResponse> CreateAsync(EventRequest request);
        Task<EventResponse?> UpdateAsync(int id, EventRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
