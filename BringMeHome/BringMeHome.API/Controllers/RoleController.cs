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
    public class RoleController : ControllerBase
    {
        public readonly IRoleService _roleService;

        public RoleController(IRoleService roleService)
        {
            _roleService = roleService;
        }


        [HttpGet]
        public async Task<ActionResult<PagedResult<RoleResponse>>> Get([FromQuery] RoleSearchObject? search = null)
        {
            return await _roleService.GetAsync(search ?? new RoleSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<RoleResponse>> GetById(int id)
        {
            var role = await _roleService.GetByIdAsync(id);

            if (role == null)
                return NotFound();
            return role;
        }

        [HttpPost]
        public async Task<ActionResult<RoleResponse>> Create(RoleRequest request)
        {
            var createdRole = await _roleService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdRole.RoleID }, createdRole);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<RoleResponse>> Update(int id, RoleRequest request)
        {
            var updatedRole = await _roleService.UpdateAsync(id, request);

            if (updatedRole == null)
                return NotFound();

            return updatedRole;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _roleService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
