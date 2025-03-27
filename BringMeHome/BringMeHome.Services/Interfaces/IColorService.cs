using BringMeHome.Models.Helpers;
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
    public interface IColorService
    {
        Task<PagedResult<ColorResponse>> GetAsync(ColorSearchObject search);
        Task<ColorResponse?> GetByIdAsync(int id);
        Task<ColorResponse> CreateAsync(ColorRequest request);
        Task<ColorResponse?> UpdateAsync(int id, ColorRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
