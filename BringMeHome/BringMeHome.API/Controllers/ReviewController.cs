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
    public class ReviewController : ControllerBase
    {
        private readonly IReviewService _reviewService;

        public ReviewController(IReviewService reviewService)
        {
            _reviewService = reviewService;
        }

        [HttpGet]
        public async Task<ActionResult<PagedResult<ReviewResponse>>> Get([FromQuery] ReviewSearchObject? search = null)
        {
            return await _reviewService.GetAsync(search ?? new ReviewSearchObject());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ReviewResponse>> GetById(int id)
        {
            var status = await _reviewService.GetByIdAsync(id);

            if (status == null)
                return NotFound();
            return status;
        }

        [HttpPost]
        public async Task<ActionResult<ReviewResponse>> Create(ReviewRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "User ID not found or invalid" });
            }

            request.UserID = userId;

            var createdStatus = await _reviewService.CreateAsync(request);
            return CreatedAtAction(nameof(GetById), new { id = createdStatus.ReviewID }, createdStatus);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ReviewResponse>> Update(int id, ReviewRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "User ID not found or invalid" });
            }

            var updatedStatus = await _reviewService.UpdateAsync(id, request,userId);

            if (updatedStatus == null)
                return NotFound();

            return updatedStatus;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var deleted = await _reviewService.DeleteAsync(id);

            if (!deleted)
                return NotFound();

            return NoContent();
        }
    }
}
