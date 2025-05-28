using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public class MlModelRetrainingService: BackgroundService
    {
        private readonly ILogger<MlModelRetrainingService> _logger;
        private readonly IServiceScopeFactory _scopeFactory;

        private readonly TimeSpan _retrainingInterval = TimeSpan.FromHours(24);

        public MlModelRetrainingService(ILogger<MlModelRetrainingService> logger, IServiceScopeFactory scopeFactory)
        {
            _logger = logger;
            _scopeFactory = scopeFactory;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("ML Model Retraining Service running.");

            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("ML Model Retraining Service: Waiting for next retraining cycle...");
                await Task.Delay(_retrainingInterval, stoppingToken);

                if (stoppingToken.IsCancellationRequested)
                {
                    break;
                }

                _logger.LogInformation("ML Model Retraining Service: Initiating model retraining.");

                using (var scope = _scopeFactory.CreateScope())
                {
                    try
                    {
                        var mlRecommendationService = scope.ServiceProvider.GetRequiredService<MlRecommendationService>();
                        mlRecommendationService.TrainAndSaveModel();
                        _logger.LogInformation("ML Model Retraining Service: Model retraining completed successfully.");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "ML Model Retraining Service: Error during model retraining.");
                    }
                }
            }

            _logger.LogInformation("ML Model Retraining Service stopped.");
        }
    }
}