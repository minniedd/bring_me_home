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
    public class ColorController : ControllerBase
    {
        public readonly IColorService _colorService;

        public ColorController(IColorService colorService)
        {
            _colorService = colorService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<ColorResponse>>> Get([FromQuery] ColorSearchObject? search = null)
        {
            return await _colorService.GetAsync(search ?? new ColorSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ColorResponse>> GetById(int id)
        {
            var color = await _colorService.GetByIdAsync(id);

            if (color == null)
                return NotFound();
            return color;
        }

        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<ColorResponse>>> GetAll()
        {
            return await _colorService.GetAllAsync();
        }

        [HttpPost]
        public async Task<ActionResult<ColorResponse>> Create(ColorRequest request)
        {
            var createdColor = await _colorService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdColor.ColorID }, createdColor);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ColorResponse>> Update(int id, ColorRequest request)
        {
            var updatedColor = await _colorService.UpdateAsync(id, request);

            if (updatedColor == null)
                return NotFound();

            return updatedColor;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _colorService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
