using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class EventController : ControllerBase
    {
        public readonly IEventService _eventService;

        public EventController(IEventService eventService)
        {
            _eventService = eventService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<EventResponse>>> Get([FromQuery] EventSearchObject? search = null)
        {
            return await _eventService.GetAsync(search ?? new EventSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<EventResponse>> GetById(int id)
        {
            var events = await _eventService.GetByIdAsync(id);

            if (events == null)
                return NotFound();
            return events;
        }

        [HttpPost]
        public async Task<ActionResult<EventResponse>> Create(EventRequest request)
        {
            var createdEvent = await _eventService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdEvent.EventID }, createdEvent);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<EventResponse>> Update(int id, EventRequest request)
        {
            var updatedEvent = await _eventService.UpdateAsync(id, request);

            if (updatedEvent == null)
                return NotFound();

            return updatedEvent;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _eventService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
