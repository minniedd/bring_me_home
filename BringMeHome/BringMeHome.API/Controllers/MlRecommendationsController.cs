using BringMeHome.Services.Database;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MlRecommendationsController : ControllerBase
    {
        private readonly MlRecommendationService _mlRecommendationService;

        public MlRecommendationsController(MlRecommendationService mlRecommendationService)
        {
            _mlRecommendationService = mlRecommendationService;
        }

        [HttpGet("user/{userId}")]
        public ActionResult<List<Animal>> GetRecommendations(int userId, [FromQuery] int count = 5)
        {
            var recommendations = _mlRecommendationService.GetRecommendationsForUser(userId, count);
            if (!recommendations.Any())
            {
                return NotFound("Zero ML predictions.");
            }
            return Ok(recommendations);
        }
    }
}