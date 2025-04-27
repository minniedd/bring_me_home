using BringMeHome.Models.Models;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Security.Claims;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserFavoriteAnimalController : ControllerBase
    {
        private readonly IUserAnimalFavoritesService _userAnimalFavoritesService;
        private readonly BringMeHomeDbContext _context;

        public UserFavoriteAnimalController(IUserAnimalFavoritesService userAnimalFavoritesService, BringMeHomeDbContext context)
        {
            _userAnimalFavoritesService = userAnimalFavoritesService;
            _context = context;
        }

        [HttpPut("{id}/favorite")]
        public async Task<IActionResult> ToggleFavorite(int id, [FromBody] FavoriteAnimalRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "User ID not found or invalid" });
            }

            var result = await _userAnimalFavoritesService.UpdateFavoriteStatusAsync(id, userId, request.IsFavorite);

            if (result)
            {
                return Ok(new { success = true });
            }

            return NotFound(new { success = false, message = "Animal not found or update failed" });
        }

        [HttpGet("favorites")]
        public async Task<IActionResult> GetUserFavorites()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
            {
                return Unauthorized(new { message = "User ID not found or invalid" });
            }

            var favoriteAnimals = await _userAnimalFavoritesService.GetUserFavoriteAnimalsAsync(userId);

            return Ok(favoriteAnimals);
        }
    }
}
