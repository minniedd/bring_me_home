using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShelterController : ControllerBase
    {
        private readonly IShelterService _shelterService;

        public ShelterController(IShelterService shelterService)
        {
            _shelterService = shelterService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<ShelterResponse>>> Get([FromQuery] ShelterSearchObject? search = null)
        {
            return await _shelterService.GetAsync(search ?? new ShelterSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ShelterResponse>> GetById(int id)
        {
            var shelter = await _shelterService.GetByIdAsync(id);

            if (shelter == null)
                return NotFound();
            return shelter;
        }

        [HttpPost]
        public async Task<ActionResult<ShelterResponse>> Create(ShelterRequest request)
        {
            var createdShelter = await _shelterService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdShelter.ShelterID }, createdShelter);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ShelterResponse>> Update(int id, ShelterRequest request)
        {
            var updatedShelter = await _shelterService.UpdateAsync(id, request);

            if (updatedShelter == null)
                return NotFound();
            return updatedShelter;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _shelterService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
