using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class SpeciesController : ControllerBase
    {
        public readonly ISpeciesService _speciesService;

        public SpeciesController(ISpeciesService speciesService)
        {
            _speciesService = speciesService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<SpeciesResponse>>> Get([FromQuery] SpeciesSearchObject? search = null)
        {
            return await _speciesService.GetAsync(search ?? new SpeciesSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<SpeciesResponse>> GetById(int id)
        {
            var species = await _speciesService.GetByIdAsync(id);

            if (species == null)
                return NotFound();
            return species;
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<SpeciesResponse>>> GetAll()
        {
            return await _speciesService.GetAllAsync();
        }

        [HttpPost]
        public async Task<ActionResult<SpeciesResponse>> Create(SpeciesRequest request)
        {
            var createdSpecies = await _speciesService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdSpecies.SpeciesID }, createdSpecies);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<SpeciesResponse>> Update(int id, SpeciesRequest request)
        {
            var updatedSpecies = await _speciesService.UpdateAsync(id, request);

            if (updatedSpecies == null)
                return NotFound();

            return updatedSpecies;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _speciesService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
