﻿using BringMeHome.Models.Requests;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public async Task<AdoptionApplicationResponse> CreateAsync(AdoptionApplicationRequest request)
        {
            var adoptionApplication = new AdoptionApplication
            {
                AdopterID = request.AdopterID,
                AnimalID = request.AnimalID,
                ApplicationDate = request.ApplicationDate,
                StatusID = request.StatusID,
                ReviewedByStaffID = request.ReviewedByStaffID,
                ReviewDate = request.ReviewDate,
                Notes = request.Notes,
                LivingSituation = request.LivingSituation,
                IsAnimalAllowed = request.IsAnimalAllowed,
                AdoptionReasons = request.AdoptionReasonIds.Select(id => new AdoptionReason { ReasonID = id }).ToList()
            };

            _context.AdoptionApplications.Add(adoptionApplication);
            await _context.SaveChangesAsync();

            var adopter = await _context.Adopters.FindAsync(request.AdopterID);
            if (adopter != null && !string.IsNullOrEmpty(adopter.Email))
            {
                var message = $"Adoption application created for {adopter.Email}";
                var body = Encoding.UTF8.GetBytes(message);

                _channel.BasicPublish(exchange: "",
                                      routingKey: "adoptionQueue",
                                      basicProperties: null,
                                      body: body);

                Console.WriteLine($"Published message to RabbitMQ: {message}");
            }

            return MapToResponse(adoptionApplication);
        }

        public async Task<List<AdoptionApplicationResponse>> GetAsync()
        {
            var adoptionApplications = await _context.AdoptionApplications
                .Include(aa => aa.Adopter)
                .Include(aa => aa.Animal)
                .Include(aa => aa.Status)
                .Include(aa => aa.ReviewedBy)
                .Include(aa => aa.AdoptionReasons)
                .ThenInclude(ar => ar.Reason)
                .ToListAsync();

            return adoptionApplications.Select(MapToResponse).ToList();
        }

        public async Task<AdoptionApplicationResponse?> GetByIdAsync(int id)
        {
            var adoptionApplication = await _context.AdoptionApplications
                .Include(aa => aa.Adopter)
                .Include(aa => aa.Animal)
                .Include(aa => aa.Status)
                .Include(aa => aa.ReviewedBy)
                .Include(aa => aa.AdoptionReasons)
                .ThenInclude(ar => ar.Reason)
                .FirstOrDefaultAsync(aa => aa.ApplicationID == id);

            return adoptionApplication != null ? MapToResponse(adoptionApplication) : null;
        }

        public async Task<AdoptionApplicationResponse?> UpdateAsync(int id, AdoptionApplicationRequest request)
        {
            var adoptionApplication = await _context.AdoptionApplications
                .Include(aa => aa.AdoptionReasons)
                .FirstOrDefaultAsync(aa => aa.ApplicationID == id);

            if (adoptionApplication == null)
                return null;

            adoptionApplication.AdopterID = request.AdopterID;
            adoptionApplication.AnimalID = request.AnimalID;
            adoptionApplication.ApplicationDate = request.ApplicationDate;
            adoptionApplication.StatusID = request.StatusID;
            adoptionApplication.ReviewedByStaffID = request.ReviewedByStaffID;
            adoptionApplication.ReviewDate = request.ReviewDate;
            adoptionApplication.Notes = request.Notes;
            adoptionApplication.LivingSituation = request.LivingSituation;
            adoptionApplication.IsAnimalAllowed = request.IsAnimalAllowed;

            // update adoption reasons
            adoptionApplication.AdoptionReasons.Clear();
            adoptionApplication.AdoptionReasons = request.AdoptionReasonIds.Select(id => new AdoptionReason { ReasonID = id }).ToList();

            await _context.SaveChangesAsync();

            return MapToResponse(adoptionApplication);
        }

        private AdoptionApplicationResponse MapToResponse(AdoptionApplication adoptionApplication)
        {
            return new AdoptionApplicationResponse
            {
                ApplicationID = adoptionApplication.ApplicationID,
                AdopterID = adoptionApplication.AdopterID,
                AnimalID = adoptionApplication.AnimalID,
                ApplicationDate = adoptionApplication.ApplicationDate,
                StatusID = adoptionApplication.StatusID,
                ReviewedByStaffID = adoptionApplication.ReviewedByStaffID,
                ReviewDate = adoptionApplication.ReviewDate,
                Notes = adoptionApplication.Notes,
                LivingSituation = adoptionApplication.LivingSituation,
                IsAnimalAllowed = adoptionApplication.IsAnimalAllowed,
                AdoptionReasonIds = adoptionApplication.AdoptionReasons.Select(ar => ar.ReasonID).ToList()
            };
        }
    }
}
