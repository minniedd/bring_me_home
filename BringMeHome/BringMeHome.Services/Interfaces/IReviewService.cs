﻿using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IReviewService
    {
        Task<PagedResult<ReviewResponse>> GetAsync(ReviewSearchObject search);
        Task<ReviewResponse?> GetByIdAsync(int id);
        Task<ReviewResponse> CreateAsync(ReviewRequest request);
        Task<ReviewResponse?> UpdateAsync(int id, ReviewRequest request, int authenticatedUserId);
        Task<bool> DeleteAsync(int id);
    }
}
