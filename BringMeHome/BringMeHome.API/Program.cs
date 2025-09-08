using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using QuestPDF.Infrastructure;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Serialization;
using static BringMeHome.Services.Database.Adopters;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IAdopterService, AdopterService>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddTransient<IAdoptionApplicationService, AdoptionApplicationService>();
builder.Services.AddTransient<IAnimalStatusService, AnimalStatusService>();
builder.Services.AddTransient<IBreedService, BreedService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<ICantonService, CantonService>();
builder.Services.AddTransient<IAnimalTemperamentService, AnimalTemperamentService>();
builder.Services.AddTransient<IColorService, ColorService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<ISpeciesService, SpeciesService>();
builder.Services.AddTransient<ICountryService, CountryService>();
builder.Services.AddTransient<IEventService, EventService>();
builder.Services.AddTransient<IMedicalRecordService, MedicalRecordService>();
builder.Services.AddTransient<IReasonService, ReasonService>();
builder.Services.AddTransient<IAnimalService, AnimalService>();
builder.Services.AddTransient<IShelterService, ShelterService>();
builder.Services.AddTransient<IUserAnimalFavoritesService, UserAnimalFavoritesService>();
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<IApplicationStatusService, ApplicationStatusService>();
builder.Services.AddTransient<IStaffService, StaffService>();
builder.Services.AddTransient<IAppReportService, AppReportService>();
builder.Services.AddScoped<MlRecommendationService>();
builder.Services.AddHostedService<MlModelRetrainingService>();
builder.Services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();


// logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

QuestPDF.Settings.License = LicenseType.Community;

// Configure database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDatabaseServices(connectionString);

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
        if (builder.Environment.IsDevelopment())
        {
            options.JsonSerializerOptions.WriteIndented = true;
        }
    });

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["AppSettings:Issuer"],
            ValidAudience = builder.Configuration["AppSettings:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["AppSettings:Token"]!))
        };
    });

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "BringMeHome API", Version = "v1" });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT Authorization header using the Bearer scheme. Enter 'Bearer' [space] and then your token in the text input below."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();


using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<BringMeHomeDbContext>();
    try
    {
        var pendingMigrations = dbContext.Database.GetPendingMigrations().ToList();

        if (pendingMigrations.Any())
        {
            dbContext.Database.Migrate();
        }
        else
        {
            Console.WriteLine("No pending migrations.");
        }

        if (!dbContext.Countries.Any())
        {
            dbContext.Countries.Add(new Country { CountryName = "Bosna i Hercegovina", CountryCode = "BiH" });
            dbContext.SaveChanges();
        }

        if (!dbContext.Cantons.Any())
        {
            var country = dbContext.Countries.First(c => c.CountryCode == "BiH");
            dbContext.Cantons.AddRange(
                new Canton { CantonName = "Unsko-sanski kanton", CantonCode = "USK", Country = country },
                new Canton { CantonName = "Posavski kanton", CantonCode = "PK", Country = country },
                new Canton { CantonName = "Tuzlanski kanton", CantonCode = "TK", Country = country },
                new Canton { CantonName = "Zenicko-dobojski kanton", CantonCode = "ZDK", Country = country },
                new Canton { CantonName = "Bosansko-podrinjski kanton", CantonCode = "BPK", Country = country },
                new Canton { CantonName = "Srednjobosanski kanton", CantonCode = "SBK", Country = country },
                new Canton { CantonName = "Hercegovacko-neretvanski kanton", CantonCode = "HNK", Country = country },
                new Canton { CantonName = "Zapadnohercegovacki kanton", CantonCode = "ZHK", Country = country },
                new Canton { CantonName = "Kanton Sarajevo", CantonCode = "KS", Country = country },
                new Canton { CantonName = "Kanton 10", CantonCode = "K10", Country = country },
                new Canton { CantonName = "Brcko distrikt", CantonCode = "BD", Country = country }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Cities.Any())
        {
            var cantons = dbContext.Cantons.ToDictionary(c => c.CantonCode!, c => c);
            dbContext.Cities.AddRange(
                 new City { CityName = "Bihac", Canton = cantons["USK"] },
                 new City { CityName = "Cazin", Canton = cantons["USK"] },
                 new City { CityName = "Velika Kladusa", Canton = cantons["USK"] },
                 new City { CityName = "Bosanska Krupa", Canton = cantons["USK"] },
                 new City { CityName = "Orasje", Canton = cantons["PK"] },
                 new City { CityName = "Domaljevac", Canton = cantons["PK"] },
                 new City { CityName = "Odzak", Canton = cantons["PK"] },
                 new City { CityName = "Tuzla", Canton = cantons["TK"] },
                 new City { CityName = "Zivinice", Canton = cantons["TK"] },
                 new City { CityName = "Lukavac", Canton = cantons["TK"] },
                 new City { CityName = "Srebrenik", Canton = cantons["TK"] },
                 new City { CityName = "Zenica", Canton = cantons["ZDK"] },
                 new City { CityName = "Doboj Jug", Canton = cantons["ZDK"] },
                 new City { CityName = "Zavidovici", Canton = cantons["ZDK"] },
                 new City { CityName = "Visoko", Canton = cantons["ZDK"] },
                 new City { CityName = "Gorazde", Canton = cantons["BPK"] },
                 new City { CityName = "Foca-Ustikolina", Canton = cantons["BPK"] },
                 new City { CityName = "Pale-Praca", Canton = cantons["BPK"] },
                 new City { CityName = "Travnik", Canton = cantons["SBK"] },
                 new City { CityName = "Bugojno", Canton = cantons["SBK"] },
                 new City { CityName = "Vitez", Canton = cantons["SBK"] },
                 new City { CityName = "Jajce", Canton = cantons["SBK"] },
                 new City { CityName = "Mostar", Canton = cantons["HNK"] },
                 new City { CityName = "Capljina", Canton = cantons["HNK"] },
                 new City { CityName = "Konjic", Canton = cantons["HNK"] },
                 new City { CityName = "Jablanica", Canton = cantons["HNK"] },
                 new City { CityName = "Siroki Brijeg", Canton = cantons["ZHK"] },
                 new City { CityName = "Grude", Canton = cantons["ZHK"] },
                 new City { CityName = "Posusje", Canton = cantons["ZHK"] },
                 new City { CityName = "Ljubuski", Canton = cantons["ZHK"] },
                 new City { CityName = "Sarajevo", Canton = cantons["KS"] },
                 new City { CityName = "Ilidza", Canton = cantons["KS"] },
                 new City { CityName = "Vogosca", Canton = cantons["KS"] },
                 new City { CityName = "Hadzici", Canton = cantons["KS"] },
                 new City { CityName = "Livno", Canton = cantons["K10"] },
                 new City { CityName = "Tomislavgrad", Canton = cantons["K10"] },
                 new City { CityName = "Drvar", Canton = cantons["K10"] },
                 new City { CityName = "Kupres", Canton = cantons["K10"] }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.AnimalStatuses.Any())
        {
            dbContext.AnimalStatuses.AddRange(
                new AnimalStatus { StatusName = "Available", Description = "Animal is ready for adoption" },
                new AnimalStatus { StatusName = "Pending", Description = "Adoption in process but not finalized" },
                new AnimalStatus { StatusName = "Adopted", Description = "Animal has found a permanent home" },
                new AnimalStatus { StatusName = "On Hold", Description = "Temporarily unavailable (medical reasons, behavior assessment, etc.)" },
                new AnimalStatus { StatusName = "Quarantine", Description = "Under observation for health issues" },
                new AnimalStatus { StatusName = "Medical Treatment", Description = "Currently receiving medical care" },
                new AnimalStatus { StatusName = "Processing", Description = "Recently arrived, being evaluated" },
                new AnimalStatus { StatusName = "Not Available", Description = "Not ready for adoption yet" },
                new AnimalStatus { StatusName = "Withdrawn", Description = "No longer available for adoption" },
                new AnimalStatus { StatusName = "Returned", Description = "Previously adopted but returned to shelter" },
                new AnimalStatus { StatusName = "Special Needs", Description = "Has ongoing medical/behavioral requirements" },
                new AnimalStatus { StatusName = "Senior", Description = "Elderly animal that may need special consideration" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Species.Any())
        {
            dbContext.Species.AddRange(
                new Species { SpeciesName = "Dog", Description = "Loyal, social animals with hundreds of breeds for companionship, work, or sport.", AverageLifespan = 12, CommonTraits = "Playful, protective, trainable" },
                new Species { SpeciesName = "Cat", Description = "Independent but affectionate pets that groom themselves and love to nap.", AverageLifespan = 15, CommonTraits = "Curious, agile, territorial" },
                new Species { SpeciesName = "Parakeet", Description = "Small, colorful birds that can mimic sounds and love social interaction.", AverageLifespan = 8, CommonTraits = "Vocal, playful, intelligent" },
                new Species { SpeciesName = "Hamster", Description = "Tiny, nocturnal rodents that store food in their cheeks and love running on wheels.", AverageLifespan = 3, CommonTraits = "Solitary, energetic, burrowers" },
                new Species { SpeciesName = "Cockatiel", Description = "Small Australian parrots with distinctive crests, known for their whistling and affectionate nature.", AverageLifespan = 15, CommonTraits = "Crest expressive, social, excellent whistlers, prone to night frights" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Breeds.Any())
        {
            var species = dbContext.Species.ToDictionary(s => s.SpeciesName, s => s);
            dbContext.Breeds.AddRange(
                new Breed { Species = species["Dog"], BreedName = "Labrador Retriever", Description = "Friendly, outgoing family dogs known for intelligence and trainability.", SizeCategory = "Large", TemperamentNotes = "Gentle, patient, excellent with children", SpecialNeeds = "Regular exercise to prevent obesity", CommonHealthIssues = "Hip dysplasia, ear infections" },
                new Breed { Species = species["Dog"], BreedName = "German Shepherd", Description = "Highly intelligent working dogs often used in police/military roles.", SizeCategory = "Large", TemperamentNotes = "Loyal, protective, needs mental stimulation", SpecialNeeds = "Advanced training, socialization", CommonHealthIssues = "Hip dysplasia, degenerative myelopathy" },
                new Breed { Species = species["Dog"], BreedName = "Golden Retriever", Description = "Popular family dogs with golden coats and loving personalities.", SizeCategory = "Large", TemperamentNotes = "Friendly, tolerant, eager to please", SpecialNeeds = "Frequent grooming", CommonHealthIssues = "Cancer, heart conditions" },
                new Breed { Species = species["Dog"], BreedName = "French Bulldog", Description = "Small companion dogs with bat-like ears and affectionate nature.", SizeCategory = "Small", TemperamentNotes = "Playful, adaptable, good for apartments", SpecialNeeds = "Heat/cold sensitivity", CommonHealthIssues = "Breathing problems, spinal disorders" },
                new Breed { Species = species["Dog"], BreedName = "Bulldog", Description = "Stocky, wrinkled dogs with gentle dispositions.", SizeCategory = "Medium", TemperamentNotes = "Docile, stubborn, affectionate", SpecialNeeds = "Air-conditioned environments", CommonHealthIssues = "Respiratory issues, skin infections" },
                new Breed { Species = species["Dog"], BreedName = "Beagle", Description = "Compact scent hounds with merry personalities.", SizeCategory = "Small", TemperamentNotes = "Curious, food-motivated, vocal", SpecialNeeds = "Secure fencing (prone to wandering)", CommonHealthIssues = "Obesity, epilepsy" },
                new Breed { Species = species["Dog"], BreedName = "Poodle", Description = "Elegant, hypoallergenic dogs available in three sizes.", SizeCategory = "Varies (Toy/Miniature/Standard)", TemperamentNotes = "Highly intelligent, active, proud", SpecialNeeds = "Professional grooming", CommonHealthIssues = "Addison's disease, eye problems" },
                new Breed { Species = species["Dog"], BreedName = "Rottweiler", Description = "Powerful working dogs with natural guarding instincts.", SizeCategory = "Large", TemperamentNotes = "Confident, calm, needs strong leadership", SpecialNeeds = "Early socialization", CommonHealthIssues = "Joint dysplasia, heart conditions" },
                new Breed { Species = species["Dog"], BreedName = "Yorkshire Terrier", Description = "Petite companion dogs with long, silky coats.", SizeCategory = "Toy", TemperamentNotes = "Bold, energetic, affectionate", SpecialNeeds = "Frequent coat care", CommonHealthIssues = "Dental disease, fragile bones" },
                new Breed { Species = species["Dog"], BreedName = "Boxer", Description = "Energetic, muscular dogs with playful personalities.", SizeCategory = "Large", TemperamentNotes = "Goofy, loyal, good with families", SpecialNeeds = "Vigorous daily exercise", CommonHealthIssues = "Heart conditions, cancer" },
                new Breed { Species = species["Cat"], BreedName = "Maine Coon", Description = "Massive, fluffy cats with tufted ears and dog-like personalities.", SizeCategory = "Large", TemperamentNotes = "Friendly, playful, good with kids", SpecialNeeds = "Regular brushing", CommonHealthIssues = "Hip dysplasia, heart disease" },
                new Breed { Species = species["Cat"], BreedName = "Persian", Description = "Long-haired cats with flat faces and calm personalities.", SizeCategory = "Medium", TemperamentNotes = "Quiet, gentle, enjoys lounging", SpecialNeeds = "Daily grooming, eye cleaning", CommonHealthIssues = "Respiratory problems, polycystic kidney disease" },
                new Breed { Species = species["Cat"], BreedName = "Bengal", Description = "Exotic-looking cats with leopard-like spots and high energy.", SizeCategory = "Medium", TemperamentNotes = "Active, curious, loves water", SpecialNeeds = "Interactive toys, vertical space", CommonHealthIssues = "Heart disease, eye problems" },
                new Breed { Species = species["Cat"], BreedName = "Siamese", Description = "Vocal, sleek cats with striking blue eyes and color-point coats.", SizeCategory = "Medium", TemperamentNotes = "Talkative, demanding, highly social", SpecialNeeds = "Mental stimulation, warm environment", CommonHealthIssues = "Dental issues, crossed eyes" },
                new Breed { Species = species["Cat"], BreedName = "Ragdoll", Description = "Large, docile cats that go limp when held.", SizeCategory = "Large", TemperamentNotes = "Relaxed, affectionate, follows owners", SpecialNeeds = "Indoor-only (lack of self-preservation)", CommonHealthIssues = "Bladder stones, heart disease" },
                new Breed { Species = species["Cat"], BreedName = "Sphynx", Description = "Hairless cats with warm, wrinkled skin and extroverted personalities.", SizeCategory = "Medium", TemperamentNotes = "Attention-seeking, energetic, clownish", SpecialNeeds = "Sun protection, weekly baths", CommonHealthIssues = "Skin conditions, heart disease" },
                new Breed { Species = species["Cat"], BreedName = "Scottish Fold", Description = "Cats with folded ears and owl-like expressions.", SizeCategory = "Medium", TemperamentNotes = "Sweet-tempered, adaptable, quiet", SpecialNeeds = "Ear cleaning (due to folded shape)", CommonHealthIssues = "Joint cartilage defects" },
                new Breed { Species = species["Cat"], BreedName = "Abyssinian", Description = "Slender, ticked-coat cats resembling ancient Egyptian felines.", SizeCategory = "Small", TemperamentNotes = "Playful, mischievous, loves heights", SpecialNeeds = "Interactive playtime", CommonHealthIssues = "Gingivitis, kidney disease" },
                new Breed { Species = species["Cat"], BreedName = "British Shorthair", Description = "Stocky cats with dense coats and round faces (inspiration for Cheshire Cat).", SizeCategory = "Medium", TemperamentNotes = "Calm, independent, not clingy", SpecialNeeds = "Weight management", CommonHealthIssues = "Obesity, heart conditions" },
                new Breed { Species = species["Cat"], BreedName = "Russian Blue", Description = "Elegant silver-blue cats with green eyes and shy demeanors.", SizeCategory = "Medium", TemperamentNotes = "Reserved with strangers, loyal to family", SpecialNeeds = "Quiet environment", CommonHealthIssues = "Urinary tract issues" },
                new Breed { Species = species["Parakeet"], BreedName = "Budgerigar (Common Parakeet)", Description = "Small, colorful Australian birds with playful personalities.", SizeCategory = "Small", TemperamentNotes = "Social, intelligent, can learn words", SpecialNeeds = "Daily interaction, cuttlebone for beak health", CommonHealthIssues = "Scaly face mites, egg-binding in females" },
                new Breed { Species = species["Cockatiel"], BreedName = "Normal Grey", Description = "Classic wild-type coloring with yellow face and orange cheek patches.", SizeCategory = "Small", TemperamentNotes = "Curious, affectionate, excellent whistlers", SpecialNeeds = "Nightlight (prone to night frights)", CommonHealthIssues = "Respiratory infections, egg-binding in females" },
                new Breed { Species = species["Hamster"], BreedName = "Syrian (Golden)", Description = "Largest pet hamster species, must live alone due to aggression toward others.", SizeCategory = "Large (6-8 inches)", TemperamentNotes = "Docile with handling, nocturnal", SpecialNeeds = "Large wheel (8+ inches), deep bedding for burrowing", CommonHealthIssues = "Wet tail (stress-induced diarrhea), diabetes" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Colors.Any())
        {
            dbContext.Colors.AddRange(
                new BringMeHome.Services.Database.Color { ColorName = "Black", Description = "The darkest color, resulting from the absence or complete absorption of visible light" },
                new BringMeHome.Services.Database.Color { ColorName = "White", Description = "The color of fresh snow or milk, resulting from reflection of all visible wavelengths of light" },
                new BringMeHome.Services.Database.Color { ColorName = "Brown", Description = "A composite color made by combining red, yellow, and blue pigments" },
                new BringMeHome.Services.Database.Color { ColorName = "Gray", Description = "A neutral color between black and white, often associated with balance and neutrality" },
                new BringMeHome.Services.Database.Color { ColorName = "Red", Description = "A primary color that is often associated with passion, love, and energy" },
                new BringMeHome.Services.Database.Color { ColorName = "Blue", Description = "A primary color that is often associated with calmness, stability, and trust" },
                new BringMeHome.Services.Database.Color { ColorName = "Green", Description = "A secondary color made by combining blue and yellow, often associated with nature and growth" },
                new BringMeHome.Services.Database.Color { ColorName = "Yellow", Description = "A primary color that is often associated with happiness, sunshine, and energy" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.AnimalTemperaments.Any())
        {
            dbContext.AnimalTemperaments.AddRange(
                new AnimalTemperament { Name = "Aggressive", Description = "Prone to hostility or violence, often territorial or easily provoked" },
                new AnimalTemperament { Name = "Docile", Description = "Gentle and easy to handle, rarely shows aggression" },
                new AnimalTemperament { Name = "Playful", Description = "Energetic and enjoys interactive activities, often curious" },
                new AnimalTemperament { Name = "Timid", Description = "Shy and easily frightened, may avoid interaction" },
                new AnimalTemperament { Name = "Independent", Description = "Self-reliant, prefers solitude over social interaction" },
                new AnimalTemperament { Name = "Social", Description = "Enjoys companionship, thrives in groups or pairs" },
                new AnimalTemperament { Name = "Territorial", Description = "Defends its space aggressively against intruders" },
                new AnimalTemperament { Name = "Curious", Description = "Explores surroundings actively, investigates new stimuli" },
                new AnimalTemperament { Name = "Lazy", Description = "Low energy, prefers resting over activity" },
                new AnimalTemperament { Name = "High-strung", Description = "Easily stressed or anxious, reacts strongly to changes" },
                new AnimalTemperament { Name = "Affectionate", Description = "Seeks physical contact and bonding with humans or other animals" },
                new AnimalTemperament { Name = "Stubborn", Description = "Resists training or commands, strong-willed" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Shelters.Any())
        {
            var cities = dbContext.Cities.ToDictionary(c => c.CityName, c => c);
            dbContext.Shelters.AddRange(
                new Shelter { Name = "Sapa Spas Animal Shelter", Address = "Ulica Branilaca 45", City = cities["Sarajevo"], ZipCode = "71000", Phone = "+387 33 123 456", Email = "info@sapaspas.ba", Capacity = 75, CurrentOccupancy = 0, OperatingHours = "Mon-Fri: 9:00-17:00, Sat: 10:00-15:00, Sun: Closed" },
                new Shelter { Name = "Bihac Pet Haven", Address = "Bosanska 112", City = cities["Bihac"], ZipCode = "77000", Phone = "+387 37 222 333", Email = "contact@bihachaven.ba", Capacity = 40, CurrentOccupancy = 0, OperatingHours = "Daily: 8:00-19:00" },
                new Shelter { Name = "Mostar Animal Rescue", Address = "Kneza Domagoja 18", City = cities["Mostar"], ZipCode = "88000", Phone = "+387 36 555 789", Email = "rescue@mostaranimals.ba", Capacity = 120, CurrentOccupancy = 0, OperatingHours = "Mon-Sat: 8:30-18:00, Sun: 10:00-14:00" },
                new Shelter { Name = "Tuzla Cat Sanctuary", Address = "Marsala Tita 22", City = cities["Tuzla"], ZipCode = "75000", Phone = "+387 35 987 654", Email = "cats@tuzlasanctuary.ba", Capacity = 60, CurrentOccupancy = 0, OperatingHours = "Mon-Fri: 10:00-16:00, Weekends: By appointment" },
                new Shelter { Name = "Zenica Wildlife Rehabilitation Center", Address = "Travnicka cesta 83z", City = cities["Zenica"], ZipCode = "72000", Phone = "+387 32 444 777", Email = "wildlife@zenicacenter.ba", Capacity = 100, CurrentOccupancy = 0, OperatingHours = "24/7 for emergencies, Visiting hours: 11:00-15:00 daily" },
                new Shelter { Name = "Ilidza Paws Rescue", Address = "Rustempasina 29", City = cities["Ilidza"], ZipCode = "71210", Phone = "+387 33 876 543", Email = "rescue@ilidzapaws.ba", Capacity = 45, CurrentOccupancy = 0, OperatingHours = "Mon-Fri: 9:00-18:00, Sat: 9:00-16:00, Sun: Closed" },
                new Shelter { Name = "Travnik Animal Haven", Address = "Bosanska 87", City = cities["Travnik"], ZipCode = "72270", Phone = "+387 30 511 223", Email = "info@travnikhaven.ba", Capacity = 35, CurrentOccupancy = 0, OperatingHours = "Mon-Sat: 8:00-16:30, Sun: 10:00-13:00" },
                new Shelter { Name = "Livno Wildlife Sanctuary", Address = "Splitska 15", City = cities["Livno"], ZipCode = "80101", Phone = "+387 34 202 303", Email = "contact@livnowildlife.ba", Capacity = 80, CurrentOccupancy = 0, OperatingHours = "Daily: 7:30-20:00" },
                new Shelter { Name = "Konjic Shelter for Strays", Address = "Trg dravnosti 44", City = cities["Konjic"], ZipCode = "88400", Phone = "+387 36 712 832", Email = "help@konjicstrays.ba", Capacity = 55, CurrentOccupancy = 0, OperatingHours = "Mon-Fri: 8:30-17:00, Weekends: 9:00-15:00" },
                new Shelter { Name = "Vitez Pet Rescue Center", Address = "Stjepana Radica 103", City = cities["Vitez"], ZipCode = "72250", Phone = "+387 30 718 920", Email = "rescue@vitezpets.ba", Capacity = 65, CurrentOccupancy = 0, OperatingHours = "Mon-Thu: 9:00-17:00, Fri-Sat: 9:00-19:00, Sun: 12:00-16:00" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.ApplicationStatuses.Any())
        {
            dbContext.ApplicationStatuses.AddRange(
                new ApplicationStatus { StatusName = "Pending", Description = "Application received, awaiting review" },
                new ApplicationStatus { StatusName = "Under Review", Description = "Application being evaluated by staff" },
                new ApplicationStatus { StatusName = "Rejected", Description = "Application not approved, reasons provided" },
                new ApplicationStatus { StatusName = "Accepted", Description = "Application has been accepted" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Roles.Any())
        {
            dbContext.Roles.AddRange(
                new Role { RoleName = "Adopter", Description = "A user looking to adopt a pet, able to browse animals, submit applications, and communicate with shelters." },
                new Role { RoleName = "Shelter Staff", Description = "A staff member from an animal shelter who can manage pet listings, review applications, and interact with adopters." },
                new Role { RoleName = "Admin", Description = "An administrator with full access to manage users, roles, app settings, and resolve disputes." },
                new Role { RoleName = "Veterinarian", Description = "A veterinary professional who can provide medical records, health assessments, and advice on animal care." }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Users.Any())
        {
            var cities = dbContext.Cities.ToDictionary(c => c.CityName, c => c);
            var user1 = CreateUser(1, "Admin", "Admin", "admin@skloniste.ba", "admin", "admin123456", cities["Gorazde"].CityID);
            var user2 = CreateUser(2, "Zaposlenik", "Zaposlenikovic", "zaposlenik@skloniste.ba", "zaposlenik", "zaposlenik123", cities["Sarajevo"].CityID);
            var user3 = CreateUser(3, "Petar", "Petrovic", "petar@gmail.com", "petar", "petar123", cities["Tuzla"].CityID);

            dbContext.Users.AddRange(user1, user2, user3);
            dbContext.SaveChanges();
            var roles = dbContext.Roles.ToDictionary(r => r.RoleName, r => r);
            dbContext.UserRoles.AddRange(
                new UserRole { User = user1, Role = roles["Admin"] },
                new UserRole { User = user2, Role = roles["Shelter Staff"] },
                new UserRole { User = user3, Role = roles["Adopter"] }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Staff.Any())
        {
            var staffUser = dbContext.Users.Single(u => u.Username == "zaposlenik");
            var shelter = dbContext.Shelters.Single(s => s.Name == "Sapa Spas Animal Shelter");
            dbContext.Staff.Add(new Staff { User = staffUser, Position = "Veterinarian", Department = "Medical Wing", Shelter = shelter, HireDate = DateTime.Now.AddYears(-2), Status = "Active", AccessLevel = 2 });
            dbContext.SaveChanges();
        }

        if (!dbContext.Adopters.Any())
        {
            var adopterUser = dbContext.Users.Single(u => u.Username == "petar");
            var city = dbContext.Cities.Single(c => c.CityName == "Tuzla");
            dbContext.Adopters.Add(new Adopter { User = adopterUser, Phone = "+387 61 987 654", Address = "Safeta Zajke 12", City = city });
            dbContext.SaveChanges();
        }

        if (!dbContext.Animals.Any())
        {
            var breeds = dbContext.Breeds.ToDictionary(b => b.BreedName, b => b);
            var shelters = dbContext.Shelters.ToDictionary(s => s.Name, s => s);
            var statuses = dbContext.AnimalStatuses.ToDictionary(s => s.StatusName, s => s);
            var colors = dbContext.Colors.ToDictionary(c => c.ColorName, c => c);
            var temperaments = dbContext.AnimalTemperaments.ToDictionary(t => t.Name, t => t);

            dbContext.Animals.AddRange(
                new Animal { Name = "Rex", Breed = breeds["Labrador Retriever"], Age = 5, Gender = "Male", Weight = 30.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Available"], Description = "Friendly and energetic Labrador Retriever", HealthStatus = "Healthy", Shelter = shelters["Sapa Spas Animal Shelter"], Color = colors["Blue"], AnimalTemperament = temperaments["Social"] },
                new Animal { Name = "Bella", Breed = breeds["Golden Retriever"], Age = 3, Gender = "Female", Weight = 28.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Processing"], Description = "Loving Golden Retriever, great with families", HealthStatus = "Healthy, vaccinated", Shelter = shelters["Bihac Pet Haven"], Color = colors["Yellow"], AnimalTemperament = temperaments["Social"] },
                new Animal { Name = "Anakin", Breed = breeds["German Shepherd"], Age = 4, Gender = "Male", Weight = 35.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Available"], Description = "Anakin is a majestic and powerful German Shepherd...", HealthStatus = "Healthy", Shelter = shelters["Mostar Animal Rescue"], Color = colors["Brown"], AnimalTemperament = temperaments["Curious"] },
                new Animal { Name = "Luna", Breed = breeds["Bulldog"], Age = 1, Gender = "Female", Weight = 25.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Pending"], Description = "Charming Bulldog with a gentle disposition", HealthStatus = "Healthy", Shelter = shelters["Tuzla Cat Sanctuary"], Color = colors["Brown"], AnimalTemperament = temperaments["Social"] },
                new Animal { Name = "Charlie", Breed = breeds["Poodle"], Age = 3, Gender = "Male", Weight = 24.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Quarantine"], Description = "Playful Poodle, loves to socialize", HealthStatus = "Healthy, vaccinated", Shelter = shelters["Zenica Wildlife Rehabilitation Center"], Color = colors["Brown"], AnimalTemperament = temperaments["Social"] },
                new Animal { Name = "Milo", Breed = breeds["Beagle"], Age = 2, Gender = "Male", Weight = 18.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Medical Treatment"], Description = "Beagle, loves to explore and follow scents", HealthStatus = "Under medical treatment", Shelter = shelters["Ilidza Paws Rescue"], Color = colors["Brown"], AnimalTemperament = temperaments["Curious"] },
                new Animal { Name = "Sadie", Breed = breeds["Yorkshire Terrier"], Age = 1, Gender = "Female", Weight = 5.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Processing"], Description = "Cute and energetic Yorkshire Terrier", HealthStatus = "Healthy", Shelter = shelters["Travnik Animal Haven"], Color = colors["Brown"], AnimalTemperament = temperaments["Social"] },
                new Animal { Name = "Rocky", Breed = breeds["Rottweiler"], Age = 4, Gender = "Male", Weight = 40.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["On Hold"], Description = "Rottweiler with guarding instincts", HealthStatus = "Healthy", Shelter = shelters["Livno Wildlife Sanctuary"], Color = colors["Brown"], AnimalTemperament = temperaments["Curious"] },
                new Animal { Name = "Zoey", Breed = breeds["Boxer"], Age = 2, Gender = "Female", Weight = 30.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Not Available"], Description = "Boxer with playful nature", HealthStatus = "Healthy", Shelter = shelters["Konjic Shelter for Strays"], Color = colors["Brown"], AnimalTemperament = temperaments["Curious"] },
                new Animal { Name = "Misty", Breed = breeds["Persian"], Age = 3, Gender = "Female", Weight = 5.00m, DateArrived = DateTime.Parse("2025-04-15"), Status = statuses["Pending"], Description = "Persian cat with calm demeanor", HealthStatus = "Healthy", Shelter = shelters["Vitez Pet Rescue Center"], Color = colors["Brown"], AnimalTemperament = temperaments["Social"] }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Reasons.Any())
        {
            dbContext.Reasons.AddRange(
                new Reason { ReasonType = "Friend For A Child" },
                new Reason { ReasonType = "Friend For Another Pet" },
                new Reason { ReasonType = "Friend For Myself" },
                new Reason { ReasonType = "Service Animal" },
                new Reason { ReasonType = "Safety" },
                new Reason { ReasonType = "House Pet" }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.MedicalRecords.Any())
        {
            var animal = dbContext.Animals.First(a => a.Name == "Rex");
            var vetStaffID = dbContext.Staff.First(s => s.Position == "Veterinarian").StaffID;
            dbContext.MedicalRecords.Add(new MedicalRecord { Animal = animal, ExaminationDate = DateTime.Now.AddMonths(-1), Diagnosis = "Examination", Treatment = "Vaccination", Notes = "Animal is healthy!", VeterinarianID = vetStaffID });
            dbContext.SaveChanges();
        }

        if (!dbContext.AdoptionApplications.Any())
        {
            var statuses = dbContext.ApplicationStatuses.ToDictionary(s => s.StatusName, s => s);
            var reasons = dbContext.Reasons.ToDictionary(r => r.ReasonType, r => r);
            var users = dbContext.Users.ToDictionary(u => u.Username, u => u);
            var animals = dbContext.Animals.ToDictionary(a => a.Name, a => a);

            dbContext.AdoptionApplications.AddRange(
                new AdoptionApplication { Animal = animals["Milo"], User = users["admin"], ApplicationDate = DateTime.Now.AddDays(-2), Status = statuses["Pending"], Reason = reasons["Friend For A Child"], Notes = "Looking for a friendly dog for my family." },
                new AdoptionApplication { Animal = animals["Zoey"], User = users["zaposlenik"], ApplicationDate = DateTime.Now.AddDays(-10), Status = statuses["Under Review"], Reason = reasons["Friend For Another Pet"], Notes = "Want a companion for my existing dog." }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.UserAnimalFavorites.Any())
        {
            var user = dbContext.Users.Single(u => u.Username == "petar");
            var animals = dbContext.Animals.Where(a => a.Name == "Milo" || a.Name == "Zoey").ToList();
            dbContext.UserAnimalFavorites.AddRange(
                new UserAnimalFavorite { User = user, Animal = animals[0] },
                new UserAnimalFavorite { User = user, Animal = animals[1] }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Reviews.Any())
        {
            var user = dbContext.Users.Single(u => u.Username == "petar");
            var shelters = dbContext.Shelters.ToDictionary(s => s.Name, s => s);
            dbContext.Reviews.AddRange(
                new Review { Shelter = shelters["Sapa Spas Animal Shelter"], User = user, Rating = 5, Comment = "Great shelter with caring staff!", CreatedAt = DateTime.Now.AddDays(-5) },
                new Review { Shelter = shelters["Bihac Pet Haven"], User = user, Rating = 4, Comment = "Good selection of animals, friendly staff.", CreatedAt = DateTime.Now.AddDays(-3) },
                new Review { Shelter = shelters["Mostar Animal Rescue"], User = user, Rating = 5, Comment = "Amazing place! The staff really care about the animals.", CreatedAt = DateTime.Now.AddDays(-1) }
            );
            dbContext.SaveChanges();
        }

        if (!dbContext.Events.Any())
        {
            var shelter = dbContext.Shelters.Single(s => s.Name == "Sapa Spas Animal Shelter");
            dbContext.Events.Add(new Event { EventName = "Open Door Day!", EventDate = DateTime.Now.AddDays(30), Location = "Sarajevo", Description = "Visit us and our animals", Shelter = shelter });
            dbContext.SaveChanges();
        }
    }
    catch (Exception ex)
    {
        if (ex.InnerException != null)
        {
            Console.WriteLine($"Inner exception: {ex.InnerException.Message}");
        }

        Console.WriteLine($"Stack trace: {ex.StackTrace}");

        try
        {
            dbContext.Database.EnsureCreated();
        }
        catch (Exception ensureEx)
        {
            Console.WriteLine($"Failed to ensure database: {ensureEx.Message}");
        }
    }
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.UseCors("AllowAll");

app.MapControllers();

app.Run();

static User CreateUser(int id, string firstName, string lastName, string email, string username, string password, int cityId)
{
    var passwordHasher = new PasswordHasher<User>();
    var user = new User
    {
        FirstName = firstName,
        LastName = lastName,
        Email = email,
        Username = username,
        IsActive = true,
        CreatedAt = DateTime.Now.AddDays(-id * 10),
        CityID = cityId,
        UserImage = null
    };
    
    user.PasswordHash = passwordHasher.HashPassword(user, password);
    
    return user;
}

static string GenerateSalt()
{
    return Convert.ToBase64String(RandomNumberGenerator.GetBytes(16));
}

static string GenerateHash(string salt, string password)
{
    string saltedPassword = salt + password;
    using (var sha256 = SHA256.Create())
    {
        byte[] saltedPasswordBytes = Encoding.UTF8.GetBytes(saltedPassword);
        byte[] hashBytes = sha256.ComputeHash(saltedPasswordBytes);
        return Convert.ToBase64String(hashBytes);
    }
}