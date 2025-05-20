using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IAppReportService
    {
        Task<AppReportResponse> GenerateReportAsync(AppReportRequest request);
    }
}
