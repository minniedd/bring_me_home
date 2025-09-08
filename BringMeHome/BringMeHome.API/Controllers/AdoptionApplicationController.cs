using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class AdoptionApplicationController : ControllerBase
    {
        private readonly IAdoptionApplicationService _adoptionApplicationService;

        public AdoptionApplicationController(IAdoptionApplicationService adoptionApplicationService)
        {
            _adoptionApplicationService = adoptionApplicationService;
        }

        [HttpGet("history")]
        public async Task<ActionResult<PagedResult<AdoptionApplicationResponse>>> GetHistory([FromQuery]AdoptionApplicationSearchObject? search = null)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "User ID not found or invalid" });
            }

            var result = await _adoptionApplicationService.GetAsync(userId, search);
            return Ok(result);
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<AdoptionApplicationResponse>>> Get([FromQuery] AdoptionApplicationSearchObject? search = null)
        {
            var result = await _adoptionApplicationService.GetAsync(null, search);
            return Ok(result);
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<AdoptionApplicationResponse>> GetById(int id)
        {
            var breed = await _adoptionApplicationService.GetByIdAsync(id);

            if (breed == null)
                return NotFound();
            return breed;
        }

        [HttpGet("animal/{animalId}")]
        public async Task<ActionResult<List<AdoptionApplicationResponse>>> GetByAnimalId(int animalId)
        {
            var animal = await _adoptionApplicationService.GetAppointmentsByAnimal(animalId);
            if (animal == null)
                return NotFound();
            return animal;
        }

        [Authorize(Roles = "Shelter Staff, Admin")]
        [HttpPut("Reject")]
        public async Task<ActionResult<AdoptionApplicationResponse>> Reject(AdoptionApplicationRequest request)
        {
            var updatedBreed = await _adoptionApplicationService.RejectAsync(request);
            if (updatedBreed == null)
                return NotFound();
            return updatedBreed;
        }

        [Authorize(Roles = "Shelter Staff, Admin")]
        [HttpPut("Approve")]
        public async Task<ActionResult<AdoptionApplicationResponse>> Approve(AdoptionApplicationRequest request)
        {
            var updatedBreed = await _adoptionApplicationService.ApproveAsync(request);
            if (updatedBreed == null)
                return NotFound();
            return updatedBreed;
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

        [HttpGet("GetApplicationCount/{animalId}")]
        public async Task<ActionResult<int>> GetApplicationCount(int animalId)
        {
            var count = await _adoptionApplicationService.GetApplicationCountAsync(animalId);
            return Ok(count);
        }
    }
}
