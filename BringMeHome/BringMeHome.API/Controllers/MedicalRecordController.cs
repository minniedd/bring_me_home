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
    public class MedicalRecordController : ControllerBase
    {
        private readonly IMedicalRecordService _medicalRecordService;

        public MedicalRecordController(IMedicalRecordService medicalRecordService)
        {
            _medicalRecordService = medicalRecordService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<MedicalRecordResponse>>> Get([FromQuery] MedicalRecordSearchObject? search = null)
        {
            return await _medicalRecordService.GetAsync(search ?? new MedicalRecordSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<MedicalRecordResponse>> GetById(int id)
        {
            var medRecord = await _medicalRecordService.GetByIdAsync(id);

            if (medRecord == null)
                return NotFound();
            return medRecord;
        }

        [HttpPost]
        public async Task<ActionResult<MedicalRecordResponse>> Create(MedicalRecordRequest request)
        {
            var createdMedRecord = await _medicalRecordService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdMedRecord.MedicalRecordID }, createdMedRecord);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<MedicalRecordResponse>> Update(int id, MedicalRecordRequest request)
        {
            var updatedMedRecord = await _medicalRecordService.UpdateAsync(id, request);

            if (updatedMedRecord == null)
                return NotFound();
            return updatedMedRecord;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _medicalRecordService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
