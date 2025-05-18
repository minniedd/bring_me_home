using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class ReviewService:IReviewService
    {
        private readonly BringMeHomeDbContext _context;

        public ReviewService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<ReviewResponse> CreateAsync(ReviewRequest request)
        {
            var shelter = await _context.Shelters.FindAsync(request.ShelterID);
            if (shelter == null)
                throw new ArgumentException("Shelter has not been found!");

            if (request.Rating <= 0 || request.Rating > 5) 
                throw new ArgumentException("Rating must be between 1 and 5!");

            var review = new Review
            {
                UserID = request.UserID,
                ShelterID = request.ShelterID,
                Rating = request.Rating,
                Comment = request.Comment,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();

            return MapToResponse(review);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
                return false;

            _context.Reviews.Remove(review);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<PagedResult<ReviewResponse>> GetAsync(ReviewSearchObject search)
        {
            var query = _context.Reviews.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.Comment.Contains(search.FTS)
                );
            }

            var totalCount = await query.CountAsync();

            var reviews = await query
            .Include(r => r.Shelter)
            .Include(r => r.User)
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<ReviewResponse>
            {
                Items = reviews,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<ReviewResponse?> GetByIdAsync(int id)
        {
            var review = await _context.Reviews.FindAsync(id);

            if (review == null)
            {
                return null;
            }

            return MapToResponse(review);
        }

        public async Task<ReviewResponse?> UpdateAsync(int id, ReviewRequest request, int authenticatedUserId)
        {
            var review = await _context.Reviews.FindAsync(id);
            if (review == null)
                throw new KeyNotFoundException("Review not found");

            if (review.UserID != authenticatedUserId)
            {
                throw new UnauthorizedAccessException("Only the original creator can update this review.");
            }

            if (request.ShelterID != review.ShelterID)
            {
                var shelter = await _context.Shelters.FindAsync(request.ShelterID);
                if (shelter == null)
                    throw new ArgumentException("Shelter has not been found!");
                review.ShelterID = request.ShelterID;
            }

            if (request.Rating <= 0 || request.Rating > 5)
                throw new ArgumentException("Rating must be between 1 and 5!");

            review.Rating = request.Rating;
            review.Comment = request.Comment;
            review.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return MapToResponse(review);
        }

        public static ReviewResponse MapToResponse(Review review)
        {
            return new ReviewResponse
            {
                ReviewID = review.ReviewID,
                UserID = review.UserID,
                ShelterName = review.Shelter?.Name,
                Rating = review.Rating,
                Comment = review.Comment,
                CreatedAt = review.CreatedAt,
                UpdatedAt = review.UpdatedAt,
                User = review.User != null ? new UserResponse
                {
                    Username = review.User.Username,
                    FirstName = review.User.FirstName,
                    LastName = review.User.LastName,
                } : null
            };
        }
    }
}
