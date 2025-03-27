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
    public class AnimalStatusController : ControllerBase
    {
        public readonly IAnimalStatusService _animalStatusService;

        public AnimalStatusController(IAnimalStatusService animalStatusService)
        {
            _animalStatusService = animalStatusService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<AnimalStatusResponse>>> Get([FromQuery] AnimalStatusSearchObject? search = null)
        {
            return await _animalStatusService.GetAsync(search ?? new AnimalStatusSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AnimalStatusResponse>> GetById(int id)
        {
            var status = await _animalStatusService.GetByIdAsync(id);

            if (status == null)
                return NotFound();
            return status;
        }

        [HttpPost]
        public async Task<ActionResult<AnimalStatusResponse>> Create(AnimalStatusRequest request)
        {
            var createdStatus = await _animalStatusService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdStatus.StatusID }, createdStatus);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<AnimalStatusResponse>> Update(int id, AnimalStatusRequest request)
        {
            var updatedStatus = await _animalStatusService.UpdateAsync(id, request);

            if (updatedStatus == null)
                return NotFound();

            return updatedStatus;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _animalStatusService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
