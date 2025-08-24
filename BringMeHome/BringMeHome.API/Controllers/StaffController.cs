using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class StaffController : ControllerBase
    {
        private readonly IStaffService _staffService;

        public StaffController(IStaffService staffService)
        {
            _staffService = staffService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<StaffResponse>>> Get([FromQuery] StaffSearchObject? search = null)
        {
            return await _staffService.GetAsync(search ?? new StaffSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<StaffResponse>> GetById(int id)
        {
            var staff = await _staffService.GetByIdAsync(id);

            if (staff == null)
                return NotFound();
            return staff;
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<StaffResponse>>> GetAll()
        {
            return await _staffService.GetAllAsync();
        }

        [HttpPost]
        public async Task<ActionResult<StaffResponse>> Create(StaffRequest request)
        {
            var createdStaff = await _staffService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdStaff.StaffID }, createdStaff);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<StaffResponse>> Update(int id, StaffRequest request)
        {
            var updatedStaff = await _staffService.UpdateAsync(id, request);

            if (updatedStaff == null)
                return NotFound();
            return updatedStaff;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _staffService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
