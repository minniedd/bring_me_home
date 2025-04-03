using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IReasonService
    {
        Task<ReasonResponse> CreateAsync(ReasonRequest request);
        Task<ReasonResponse?> UpdateAsync(int id, ReasonRequest request);
        Task<ReasonResponse?> GetByIdAsync(int id);
        Task<List<ReasonResponse>> GetAsync();
    }
}
