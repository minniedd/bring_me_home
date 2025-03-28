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
    public class CityController : ControllerBase
    {
        public readonly ICityService _cityService;

        public CityController(ICityService cityService)
        {
            _cityService = cityService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<CityResponse>>> Get([FromQuery] CitySearchObject? search = null)
        {
            return await _cityService.GetAsync(search ?? new CitySearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CityResponse>> GetById(int id)
        {
            var city = await _cityService.GetByIdAsync(id);

            if (city == null)
                return NotFound();
            return city;
        }

        [HttpPost]
        public async Task<ActionResult<CityResponse>> Create(CityRequest request)
        {
            var createdCity = await _cityService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdCity.CityID }, createdCity);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<CityResponse>> Update(int id, CityRequest request)
        {
            var updatedCity = await _cityService.UpdateAsync(id, request);

            if (updatedCity == null)
                return NotFound();

            return updatedCity;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _cityService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
