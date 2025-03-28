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
    public class CountryController : ControllerBase
    {
        public readonly ICountryService _countryService;

        public CountryController(ICountryService countryService)
        {
            _countryService = countryService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<CountryResponse>>> Get([FromQuery] CountrySearchObject? search = null)
        {
            return await _countryService.GetAsync(search ?? new CountrySearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CountryResponse>> GetById(int id)
        {
            var country = await _countryService.GetByIdAsync(id);

            if (country == null)
                return NotFound();
            return country;
        }

        [HttpPost]
        public async Task<ActionResult<CountryResponse>> Create(CountryRequest request)
        {
            var createdCountry = await _countryService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdCountry.CountryID }, createdCountry);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<CountryResponse>> Update(int id, CountryRequest request)
        {
            var updatedCountry = await _countryService.UpdateAsync(id, request);

            if (updatedCountry == null)
                return NotFound();

            return updatedCountry;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _countryService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
