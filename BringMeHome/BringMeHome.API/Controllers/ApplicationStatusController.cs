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
    public class ApplicationStatusController : ControllerBase
    {
        public readonly IApplicationStatusService _applicationStatusService;

        public ApplicationStatusController(IApplicationStatusService applicationStatusService)
        {
            _applicationStatusService = applicationStatusService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<ApplicationStatusResponse>>> Get([FromQuery] ApplicationStatusSearchObject? search = null)
        {
            return await _applicationStatusService.GetAsync(search ?? new ApplicationStatusSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ApplicationStatusResponse>> GetById(int id)
        {
            var status = await _applicationStatusService.GetByIdAsync(id);

            if (status == null)
                return NotFound();
            return status;
        }

        [HttpPost]
        public async Task<ActionResult<ApplicationStatusResponse>> Create(ApplicationStatusRequest request)
        {
            var createdStatus = await _applicationStatusService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdStatus.StatusID }, createdStatus);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ApplicationStatusResponse>> Update(int id, ApplicationStatusRequest request)
        {
            var updatedStatus = await _applicationStatusService.UpdateAsync(id, request);

            if (updatedStatus == null)
                return NotFound();

            return updatedStatus;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _applicationStatusService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
