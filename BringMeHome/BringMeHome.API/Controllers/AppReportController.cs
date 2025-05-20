using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Reflection.Metadata;
using QuestPDF.Fluent;
using Document = QuestPDF.Fluent.Document;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppReportController : ControllerBase
    {
        private readonly IAppReportService _appReportService;

        public AppReportController(IAppReportService appReportService)
        {
            _appReportService = appReportService;
        }

        [HttpGet]
        public async Task<ActionResult<AppReportResponse>> GetReport([FromQuery]AppReportRequest request)
        {
            var result = await _appReportService.GenerateReportAsync(request);
            return Ok(result);
        }

        [HttpPost("GetReportPdf")]
        public async Task<IActionResult> GetReportPdf([FromBody] AppReportRequest request)
        {
            var report = await _appReportService.GenerateReportAsync(request);

            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Margin(40);
                    page.Content().Column(col =>
                    {
                        col.Item().Text("App Report: BRINGMEHOME!").FontSize(24).Bold().AlignCenter();
                        col.Item().Text($"Date: {DateTime.Now:dd.MM.yyyy}");

                        col.Item().Text($"Total animals on the app: {report.TotalAnimals}");
                        col.Item().Text($"Total adoptions on the app: {report.TotalAdoptions}");
                        col.Item().Text($"Total active adoptions on the app: {report.TotalActiveAdoptions}");
                        foreach (var item in report.TotalAnimalsBySpecies)
                        {
                            col.Item().Text($"Species: {item.Key} — {item.Value}");
                        }
                    });
                });
            });

            var bytes = document.GeneratePdf();
            return File(bytes, "application/pdf", "Report.pdf");
        }
    }
}
