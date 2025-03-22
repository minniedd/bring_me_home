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
    public interface IAdopterService
    {
        Task<List<AdopterResponse>> GetAsync(AdopterSearchObject search);
        Task<AdopterResponse?> GetByIdAsync(int id);
        Task<AdopterResponse> CreateAsync(AdopterRequest request);
        Task<AdopterResponse?> UpdateAsync(int id, AdopterRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
