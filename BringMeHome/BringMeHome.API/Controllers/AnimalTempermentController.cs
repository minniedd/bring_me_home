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
    public class AnimalTempermentController : ControllerBase
    {
        public readonly IAnimalTemperamentService _animalTempermentService;

        public AnimalTempermentController(IAnimalTemperamentService animalTempermentService)
        {
            _animalTempermentService = animalTempermentService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<AnimalTemperamentResponse>>> Get([FromQuery] AnimalTemperamentSearchObject? search = null)
        {
            return await _animalTempermentService.GetAsync(search ?? new AnimalTemperamentSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AnimalTemperamentResponse>> GetById(int id)
        {
            var temperment = await _animalTempermentService.GetByIdAsync(id);

            if (temperment == null)
                return NotFound();
            return temperment;
        }

        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<AnimalTemperamentResponse>>> GetAll()
        {
            return await _animalTempermentService.GetAllAsync();
        }

        [HttpPost]
        public async Task<ActionResult<AnimalTemperamentResponse>> Create(AnimalTemperamentRequest request)
        {
            var createdTemperment = await _animalTempermentService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdTemperment.TemperamentID }, createdTemperment);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<AnimalTemperamentResponse>> Update(int id, AnimalTemperamentRequest request)
        {
            var updatedTemperment = await _animalTempermentService.UpdateAsync(id, request);

            if (updatedTemperment == null)
                return NotFound();

            return updatedTemperment;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _animalTempermentService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
