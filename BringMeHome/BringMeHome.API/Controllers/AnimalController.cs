using BringMeHome.Models.Helpers;
using BringMeHome.Models.Models;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnimalController : ControllerBase
    {
        private readonly IAnimalService _animalService;

        public AnimalController(IAnimalService animalService)
        {
            _animalService = animalService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<AnimalResponse>>> Get([FromQuery] AnimalSearchObject? search = null)
        {
            return await _animalService.GetAsync(search ?? new AnimalSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AnimalResponse>> GetById(int id)
        {
            var animal = await _animalService.GetByIdAsync(id);

            if (animal == null)
                return NotFound();
            return animal;
        }

        [HttpPost]
        public async Task<ActionResult<AnimalResponse>> Create(AnimalRequest request)
        {
            var createdAnimal = await _animalService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdAnimal.AnimalID }, createdAnimal);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<AnimalResponse>> Update(int id, AnimalRequest request)
        {
            var updatedAnimal = await _animalService.UpdateAsync(id, request);

            if (updatedAnimal == null)
                return NotFound();
            return updatedAnimal;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _animalService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
