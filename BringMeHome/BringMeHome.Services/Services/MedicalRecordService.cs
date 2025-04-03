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
    public class MedicalRecordService : IMedicalRecordService
    {
        private readonly BringMeHomeDbContext _context;

        public MedicalRecordService(BringMeHomeDbContext context)
        {
            _context = context;
        }

        public async Task<MedicalRecordResponse> CreateAsync(MedicalRecordRequest request)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            if (request.AnimalID <= 0)
                throw new ArgumentException("Invalid AnimalID", nameof(request.AnimalID));

            if (string.IsNullOrWhiteSpace(request.Diagnosis))
                throw new ArgumentException("Diagnosis is required", nameof(request.Diagnosis));

            var medRecord = new MedicalRecord
            {
                AnimalID = request.AnimalID,
                Diagnosis = request.Diagnosis,
                Treatment = request.Treatment,
                Notes = request.Notes,
                VeterinarianID = request.VeterinarianID,
                ExaminationDate = DateTime.UtcNow
            };

            await _context.MedicalRecords.AddAsync(medRecord);
            await _context.SaveChangesAsync();


            return MapToResponse(medRecord);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var medRecord = await _context.MedicalRecords.FindAsync(id);
            if(medRecord == null)
            {
                return false;
            }

            _context.MedicalRecords.Remove(medRecord);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<PagedResult<MedicalRecordResponse>> GetAsync(MedicalRecordSearchObject search)
        {
            var query = _context.MedicalRecords.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.Diagnosis.Contains(search.FTS) ||
                    r.Treatment.Contains(search.FTS) ||
                    r.Notes.Contains(search.FTS)
                );
            }

            if (search.AnimalId > 0)
            {
                query = query.Where(r => r.AnimalID == search.AnimalId);
            }

            var totalCount = await query.CountAsync();

            var medRecords = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();

            return new PagedResult<MedicalRecordResponse>
            {
                Items = medRecords,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<MedicalRecordResponse?> GetByIdAsync(int id)
        {
            var medRecords = await _context.MedicalRecords.FindAsync(id);
            if(medRecords == null)
            {
                return null;
            }

            return MapToResponse(medRecords);
        }

        public async Task<MedicalRecordResponse?> UpdateAsync(int id, MedicalRecordRequest request)
        {
            var medRecords = await _context.MedicalRecords.FindAsync(id);
            if (medRecords == null)
            {
                return null;
            }

            medRecords.AnimalID = request.AnimalID;
            medRecords.Diagnosis = request.Diagnosis;
            medRecords.Treatment = request.Treatment;
            medRecords.Notes = request.Notes;
            medRecords.VeterinarianID = request.VeterinarianID;

            await _context.SaveChangesAsync();

            return MapToResponse(medRecords);
        }

        private MedicalRecordResponse MapToResponse(MedicalRecord medicalRecord)
        {
            return new MedicalRecordResponse
            {
                MedicalRecordID = medicalRecord.MedicalRecordID,
                AnimalID = medicalRecord.AnimalID,
                ExaminationDate = medicalRecord.ExaminationDate,
                Diagnosis = medicalRecord.Diagnosis,
                Treatment = medicalRecord.Treatment,
                Notes = medicalRecord.Notes,
                VeterinarianID = medicalRecord.VeterinarianID
            };
        }
    }
}
