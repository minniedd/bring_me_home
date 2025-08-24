using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ReasonController : ControllerBase
    {
        private readonly IReasonService _reasonService;

        public ReasonController(IReasonService reasonService)
        {
            _reasonService = reasonService;
        }

        [HttpPost]
        public async Task<ActionResult<ReasonResponse>> CreateAsync([FromBody] ReasonRequest request)
        {
            var createdResponse = await _reasonService.CreateAsync(request);
            return CreatedAtAction(nameof(GetByIdAsync), new { id = createdResponse.ReasonID }, createdResponse);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ReasonResponse>> UpdateAsync(int id, [FromBody] ReasonRequest request)
        {
            var updatedResponse = await _reasonService.UpdateAsync(id, request);
            if (updatedResponse == null)
            {
                return NotFound();
            }
            return Ok(updatedResponse);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ReasonResponse>> GetByIdAsync(int id)
        {
            var reason = await _reasonService.GetByIdAsync(id);
            if (reason == null)
            {
                return NotFound();
            }
            return Ok(reason);
        }

        [HttpGet]
        public async Task<ActionResult<List<ReasonResponse>>> GetAsync()
        {
            var response = await _reasonService.GetAsync();
            return Ok(response);
        }
    }
}
