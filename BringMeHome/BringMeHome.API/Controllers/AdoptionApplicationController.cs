using BringMeHome.Models.Helpers;
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
    public class AdoptionApplicationController : ControllerBase
    {
        private readonly IAdoptionApplicationService _adoptionApplicationService;

        public AdoptionApplicationController(IAdoptionApplicationService adoptionApplicationService)
        {
            _adoptionApplicationService = adoptionApplicationService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<AdoptionApplicationResponse>>> Get([FromQuery] AdoptionApplicationSearchObject? search = null)
        {
            return await _adoptionApplicationService.GetAsync(search ?? new AdoptionApplicationSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AdoptionApplicationResponse>> GetById(int id)
        {
            var breed = await _adoptionApplicationService.GetByIdAsync(id);

            if (breed == null)
                return NotFound();
            return breed;
        }

        [HttpPost]
        public async Task<ActionResult<AdoptionApplicationResponse>> Create(AdoptionApplicationRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "Korisnički ID nije pronađen ili nije validan u tokenu." });
            }

            try
            {
                var adopterResponse = await _adoptionApplicationService.CreateAsync(userId, request);

                return Ok(adopterResponse);
            }
            catch (UnauthorizedAccessException ex) 
            {
                return Unauthorized(new { message = ex.Message });
            }
            catch (InvalidOperationException ex) 
            {
                return BadRequest(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Došlo je do interne serverske greške." });
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<AdoptionApplicationResponse>> Update(int id, AdoptionApplicationRequest request)
        {
            var updatedBreed = await _adoptionApplicationService.UpdateAsync(id, request);

            if (updatedBreed == null)
                return NotFound();

            return updatedBreed;
        }
    }
}
