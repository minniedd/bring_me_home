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
    public class CantonController : ControllerBase
    {
        public readonly ICantonService _cantonService;

        public CantonController(ICantonService cantonService)
        {
            _cantonService = cantonService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<CantonResponse>>> Get([FromQuery] CantonSearchObject? search = null)
        {
            return await _cantonService.GetAsync(search ?? new CantonSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CantonResponse>> GetById(int id)
        {
            var canton = await _cantonService.GetByIdAsync(id);

            if (canton == null)
                return NotFound();
            return canton;
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<CantonResponse>>> GetAll()
        {
            return await _cantonService.GetAllAsync();
        }

        [HttpPost]
        public async Task<ActionResult<CantonResponse>> Create(CantonRequest request)
        {
            var createdCanton = await _cantonService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdCanton.CantonID }, createdCanton);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<CantonResponse>> Update(int id, CantonRequest request)
        {
            var updatedCanton = await _cantonService.UpdateAsync(id, request);

            if (updatedCanton == null)
                return NotFound();

            return updatedCanton;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _cantonService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
