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
    public class AdopterController : ControllerBase
    {
        public readonly IAdopterService _adopterService;

        public AdopterController(IAdopterService adopterService)
        {
            _adopterService = adopterService;
        }

        [HttpGet]
        public async Task<ActionResult<List<AdopterResponse>>> Get([FromQuery] AdopterSearchObject? search = null)
        {
            return await _adopterService.GetAsync(search ?? new AdopterSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AdopterResponse>> GetById(int id)
        {
            var user = await _adopterService.GetByIdAsync(id);

            if (user == null)
                return NotFound();
            return user;
        }

        [HttpPost]
        public async Task<ActionResult<AdopterResponse>> Create(AdopterRequest request)
        {
            var createdAdopter = await _adopterService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdAdopter.UserID }, createdAdopter);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<AdopterResponse>> Update(int id, AdopterRequest request)
        {
            var updatedAdopter = await _adopterService.UpdateAsync(id, request);

            if (updatedAdopter == null)
                return NotFound();
            return updatedAdopter;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _adopterService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
