using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BreedController : ControllerBase
    {
        public readonly IBreedService _breedService;

        public BreedController(IBreedService breedService)
        {
            _breedService = breedService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<BreedResponse>>> Get([FromQuery] BreedSearchObject? search = null)
        {
            return await _breedService.GetAsync(search ?? new BreedSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BreedResponse>> GetById(int id)
        {
            var breed = await _breedService.GetByIdAsync(id);

            if (breed == null)
                return NotFound();
            return breed;
        }

        [HttpPost]
        public async Task<ActionResult<BreedResponse>> Create(BreedRequest request)
        {
            var createdBreed = await _breedService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdBreed.BreedID }, createdBreed);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<BreedResponse>> Update(int id, BreedRequest request)
        {
            var updatedBreed = await _breedService.UpdateAsync(id, request);

            if (updatedBreed == null)
                return NotFound();

            return updatedBreed;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _breedService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
