using BringMeHome.Models.Helpers;
using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace BringMeHome.Services.Services
{
    public class AdoptionApplicationService: IAdoptionApplicationService
    {
        private readonly BringMeHomeDbContext _context;
        private readonly RabbitMQ.Client.IModel _channel;
        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

        public AdoptionApplicationService(BringMeHomeDbContext context)
        {
            _context = context;
            var factory = new ConnectionFactory
            {
                HostName = _host,
                UserName = _username,
                Password = _password,
                VirtualHost = _virtualhost
            };
            var connection = factory.CreateConnection();
            _channel = connection.CreateModel();

            _channel.QueueDeclare(queue: "adoptionQueue",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);
        }

        public async Task<AdoptionApplicationResponse> CreateAsync(int userId, AdoptionApplicationRequest request)
        {
            var existingUser = await _context.Users.FindAsync(userId);
            if (existingUser == null)
                throw new Exception($"User with ID {userId} not found.");

            var existingAnimal = await _context.Animals.FindAsync(request.AnimalID);
            if (existingAnimal == null)
                throw new Exception($"Animal with ID {request.AnimalID} not found.");

            if (request.ReasonId.HasValue &&
                await _context.Reasons.FindAsync(request.ReasonId.Value) == null)
            {
                throw new Exception($"Reason with ID {request.ReasonId.Value} not found.");
            }

            var adoptionApplication = new AdoptionApplication
            {
                AnimalID = request.AnimalID,
                ApplicationDate = DateTime.UtcNow,
                StatusID = 1, // in database status for this is 1
                Notes = request.Notes,
                LivingSituation = request.LivingSituation,
                IsAnimalAllowed = request.IsAnimalAllowed,
                UserID = userId,
                ReasonID = request.ReasonId
            };

            _context.AdoptionApplications.Add(adoptionApplication);
            await _context.SaveChangesAsync();

            var savedApplication = await _context.AdoptionApplications
                .Include(aa => aa.Reason)
                .FirstOrDefaultAsync(aa => aa.ApplicationID == adoptionApplication.ApplicationID)
                ?? throw new Exception("Failed to retrieve saved application for mapping.");

            await SendAdoptionNotification(userId);

            return MapToResponse(savedApplication);
        }

        private async Task SendAdoptionNotification(int userId)
        {
            try
            {
                var adopter = await _context.Adopters.FindAsync(userId);
                if (adopter?.User.Email == null) return;

                var message = $"Adoption application created for {adopter.User.Email}";
                var body = Encoding.UTF8.GetBytes(message);

                _channel.BasicPublish(
                    exchange: "",
                    routingKey: "adoptionQueue",
                    basicProperties: null,
                    body: body);

                Console.WriteLine($"Published message to RabbitMQ: {message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send adoption notification: {ex.Message}");
            }
        }
        public async Task<PagedResult<AdoptionApplicationResponse>> GetAsync(AdoptionApplicationSearchObject search)
        {
            var query = _context.AdoptionApplications
                .Include(aa => aa.User)
                .Include(aa => aa.Animal)
                    .ThenInclude(a => a.Breed)
                        .ThenInclude(b => b.Species)
                        .Include(aa => aa.Animal)
                        .ThenInclude(a => a.AnimalColors)
                            .ThenInclude(ac => ac.Color)
                            .Include(aa => aa.Animal)
                            .ThenInclude(a => a.AnimalTemperaments)
                                .ThenInclude(at => at.Temperament)
                                .Include(aa => aa.Status)
                                .Include(aa => aa.ReviewedBy)
                                .Include(aa => aa.Reason) 

            .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(r =>
                    r.User.Username.Contains(search.FTS) ||
                    r.Animal.Name.Contains(search.FTS)
                    );
            }

            var totalCount = await query.CountAsync();

            var adoptionApplication = await query
            .ApplySort(search)
            .ApplyPagination(search)
            .Select(r => MapToResponse(r))
            .ToListAsync();
            
            return new PagedResult<AdoptionApplicationResponse>
            {
                Items = adoptionApplication,
                TotalCount = totalCount,
                PageNumber = search.PageNumber,
                PageSize = search.PageSize
            };
        }

        public async Task<AdoptionApplicationResponse?> GetByIdAsync(int id)
        {
            var adoptionApplication = await _context.AdoptionApplications
                .Include(aa => aa.User)
                .Include(aa => aa.Animal)
                .Include(aa => aa.Status)
                .Include(aa => aa.ReviewedBy)
                .Include(aa => aa.Reason)
                .FirstOrDefaultAsync(aa => aa.ApplicationID == id);

            return adoptionApplication != null ? MapToResponse(adoptionApplication) : null;
        }

        public async Task<AdoptionApplicationResponse> UpdateAsync(int id, AdoptionApplicationRequest request)
        {
            var adoptionApplication = await _context.AdoptionApplications
                    .Include(aa => aa.Reason)
                    .Include(aa => aa.Status)
                    .FirstOrDefaultAsync(aa => aa.ApplicationID == id);

            if (adoptionApplication == null)
            {
                return null;
            }

            bool statusChanged = adoptionApplication.StatusID != request.StatusID;
            var oldStatus = adoptionApplication.Status?.StatusName;

            adoptionApplication.AnimalID = request.AnimalID;
            adoptionApplication.StatusID = request.StatusID;
            adoptionApplication.ReviewedByStaffID = request.ReviewedByStaffID;
            adoptionApplication.ReviewDate = request.ReviewDate ?? DateTime.UtcNow;
            adoptionApplication.Notes = request.Notes;
            adoptionApplication.LivingSituation = request.LivingSituation;
            adoptionApplication.IsAnimalAllowed = request.IsAnimalAllowed;
            adoptionApplication.ReasonID = request.ReasonId;


            await _context.SaveChangesAsync();
            return MapToResponse(adoptionApplication);

        }

        private static AdoptionApplicationResponse MapToResponse(AdoptionApplication adoptionApplication)
        {
            return new AdoptionApplicationResponse
            {
                ApplicationID = adoptionApplication.ApplicationID,
                UserID = adoptionApplication.UserID,
                AnimalID = adoptionApplication.AnimalID,
                ApplicationDate = adoptionApplication.ApplicationDate,
                StatusID = adoptionApplication.StatusID,
                ReviewedByStaffID = adoptionApplication.ReviewedByStaffID,
                ReviewDate = adoptionApplication.ReviewDate,
                Notes = adoptionApplication.Notes,
                LivingSituation = adoptionApplication.LivingSituation,
                IsAnimalAllowed = adoptionApplication.IsAnimalAllowed,
                ReasonId = adoptionApplication.ReasonID,
                ReasonName = adoptionApplication.Reason?.ReasonType
            };
        }
    }
}
