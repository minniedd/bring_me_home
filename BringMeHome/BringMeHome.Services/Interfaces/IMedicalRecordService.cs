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
    public interface IMedicalRecordService
    {
        Task<PagedResult<MedicalRecordResponse>> GetAsync(MedicalRecordSearchObject search);
        Task<MedicalRecordResponse?> GetByIdAsync(int id);
        Task<MedicalRecordResponse> CreateAsync(MedicalRecordRequest request);
        Task<MedicalRecordResponse?> UpdateAsync(int id, MedicalRecordRequest request);
        Task<bool> DeleteAsync(int id);
    }
}
