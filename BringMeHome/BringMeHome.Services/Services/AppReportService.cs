using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
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
    public class AppReportService:IAppReportService
    {
        private readonly BringMeHomeDbContext _context;

        public AppReportService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<AppReportResponse> GenerateReportAsync(AppReportRequest request)
        {
            var totalAnimals = await Task.Run(() => _context.Animals.Count());
            var totalAdoptions = await Task.Run(() => _context.AdoptionApplications.Count());
            var totalActiveAdoptions = await Task.Run(() => _context.AdoptionApplications.Count(a => a.Status.StatusName == "Submitted"));
            var totalAnimalsBySpecies = await _context.Animals
                .GroupBy(z => z.Breed.Species)
                .Select(g => new { SpeciesName = g.Key.SpeciesName, Count = g.Count() })
                .ToDictionaryAsync(g => g.SpeciesName, g => g.Count);

            return new AppReportResponse
            {
                TotalAnimals = totalAnimals,
                TotalAdoptions = totalAdoptions,
                TotalActiveAdoptions = totalActiveAdoptions,
                TotalAnimalsBySpecies = totalAnimalsBySpecies
            };
        }
    }
}
