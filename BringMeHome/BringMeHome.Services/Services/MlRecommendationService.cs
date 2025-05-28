using BringMeHome.Models.Models;
using BringMeHome.Models.Responses;
using BringMeHome.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using System.Linq;

namespace BringMeHome.Services.Services
{
    public class MlRecommendationService
    {
        private static MLContext _mlContext;
        private static ITransformer _model;
        private static object _lock = new object();
        private readonly BringMeHomeDbContext _context;
        private readonly ILogger<MlRecommendationService> _logger;

        private const string ModelPath = "recommendation_model.zip";

        public MlRecommendationService(BringMeHomeDbContext context, ILogger<MlRecommendationService> logger)
        {
            _context = context;
            _logger = logger;
            _mlContext = new MLContext(seed: 0); 
            EnsureModelIsLoadedOrTrained();
        }

        private void EnsureModelIsLoadedOrTrained()
        {
            lock (_lock)
            {
                if (_model == null)
                {
                    if (File.Exists(ModelPath))
                    {
                        try
                        {
                            _model = _mlContext.Model.Load(ModelPath, out var modelSchema);
                            _logger.LogInformation("ML model successfully loaded from {ModelPath}.", ModelPath);
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex, "Failed to load ML model from {ModelPath}. Attempting to retrain.", ModelPath);
                            TrainAndSaveModel();
                        }
                    }
                    else
                    {
                        _logger.LogInformation("ML model not found at {ModelPath}. Attempting to train.", ModelPath);
                        TrainAndSaveModel();
                    }
                }
            }
        }

        public void TrainAndSaveModel()
        {
            lock (_lock)
            {
                _logger.LogInformation("Starting ML model training...");

                var userFavorites = _context.UserAnimalFavorites
                                            .Select(fav => new AnimalInteraction
                                            {
                                                UserId = (uint)fav.UserId,
                                                AnimalId = (uint)fav.AnimalId,
                                                Label = 1.0f
                                            }).ToList();

                if (!userFavorites.Any())
                {
                    _logger.LogWarning("No user favorites found for ML model training. Model will not be trained.");
                    _model = null;
                    return;
                }

                var trainingDataView = _mlContext.Data.LoadFromEnumerable(userFavorites);

                var options = new MatrixFactorizationTrainer.Options
                {
                    MatrixColumnIndexColumnName = nameof(AnimalInteraction.UserId),
                    MatrixRowIndexColumnName = nameof(AnimalInteraction.AnimalId),
                    LabelColumnName = nameof(AnimalInteraction.Label),
                    LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                    Alpha = 0.01,
                    Lambda = 0.025,
                    NumberOfIterations = 100,
                    Quiet = true
                };

                var pipeline = _mlContext.Recommendation().Trainers.MatrixFactorization(options);

                _model = pipeline.Fit(trainingDataView);
                _logger.LogInformation("ML model training finished.");

                _mlContext.Model.Save(_model, trainingDataView.Schema, ModelPath);
                _logger.LogInformation("ML model saved to {ModelPath}.", ModelPath);
            }
        }

        public List<AnimalResponse> GetRecommendationsForUser(int userId, int numberOfRecommendations)
        {
            if (_model == null)
            {
                _logger.LogWarning("ML model not available for predictions. Returning empty list.");
                return new List<AnimalResponse>();
            }

            var predictionEngine = _mlContext.Model.CreatePredictionEngine<AnimalInteraction, AnimalRecommendationPrediction>(_model);

            var userFavoritedAnimalIds = _context.UserAnimalFavorites
                                                .Where(f => f.UserId == userId)
                                                .Select(f => f.AnimalId)
                                                .ToHashSet();

            var availableAnimals = _context.Animals
                .Include(a => a.Breed)
                    .ThenInclude(b => b.Species)
                .Include(a => a.Shelter)
                .Include(a => a.Status)
                .Include(a => a.Color)
                .Include(a => a.AnimalTemperament)
                .Where(a => !userFavoritedAnimalIds.Contains(a.AnimalID) && a.StatusID == GetAvailableStatusId())
                .ToList();

            if (!availableAnimals.Any())
            {
                _logger.LogInformation("No available animals for user {UserId} after filtering favorited ones.", userId);
                return new List<AnimalResponse>();
            }

            var predictions = new List<(Animal Animal, float Score)>();

            foreach (var animal in availableAnimals)
            {
                var prediction = predictionEngine.Predict(new AnimalInteraction
                {
                    UserId = (uint)userId,
                    AnimalId = (uint)animal.AnimalID
                });
                predictions.Add((animal, prediction.Score));
            }

            var recommendedAnimals = predictions
                .OrderByDescending(p => p.Score)
                .Select(p => MapToResponse(p.Animal))
                .Take(numberOfRecommendations)
                .ToList();

            _logger.LogInformation("Generated {Count} recommendations for user {UserId}.", recommendedAnimals.Count, userId);
            return recommendedAnimals;
        }

        private int GetAvailableStatusId()
        {
            var status = _context.AnimalStatuses.FirstOrDefault(s => s.StatusName == "Available");
            if (status == null)
            {
                _logger.LogError("Animal status 'Available' not found in database. Check AnimalStatuses table.");
                return -1;
            }
            return status.StatusID;
        }

        private static AnimalResponse MapToResponse(Animal animal)
        {
            return new AnimalResponse
            {
                AnimalID = animal.AnimalID,
                Name = animal.Name,
                Description = animal.Description,
                AnimalImage = animal.AnimalImage != null ? Convert.ToBase64String(animal.AnimalImage) : null,
                SpeciesID = animal.Breed?.SpeciesID ?? 0,
                SpeciesName = animal.Breed?.Species?.SpeciesName,
                BreedID = animal.BreedID,
                BreedName = animal.Breed?.BreedName,
                Age = animal.Age,
                Gender = animal.Gender,
                Weight = animal.Weight,
                DateArrived = animal.DateArrived,
                StatusID = animal.StatusID,
                HealthStatus = animal.HealthStatus,
                ShelterID = animal.ShelterID,
                ShelterName = animal.Shelter?.Name,
                ColorID = animal.ColorID ?? 0,
                ColorName = animal.Color?.ColorName,
                TempermentID = animal.TempermentID ?? 0,
                TemperamentName = animal.AnimalTemperament?.Name
            };
        }
    }
}