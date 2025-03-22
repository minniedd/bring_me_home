using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BringMeHome.Services.Migrations
{
    /// <inheritdoc />
    public partial class initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AnimalStatuses",
                columns: table => new
                {
                    StatusID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StatusName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalStatuses", x => x.StatusID);
                });

            migrationBuilder.CreateTable(
                name: "AnimalTemperaments",
                columns: table => new
                {
                    TemperamentID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalTemperaments", x => x.TemperamentID);
                });

            migrationBuilder.CreateTable(
                name: "ApplicationStatuses",
                columns: table => new
                {
                    StatusID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StatusName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ApplicationStatuses", x => x.StatusID);
                });

            migrationBuilder.CreateTable(
                name: "Colors",
                columns: table => new
                {
                    ColorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ColorName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Colors", x => x.ColorID);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    CountryID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CountryName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CountryCode = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.CountryID);
                });

            migrationBuilder.CreateTable(
                name: "DonationTypes",
                columns: table => new
                {
                    DonationTypeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TypeName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    TaxDeductible = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DonationTypes", x => x.DonationTypeID);
                });

            migrationBuilder.CreateTable(
                name: "Reason",
                columns: table => new
                {
                    ReasonID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ReasonType = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reason", x => x.ReasonID);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RoleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    PermissionLevel = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RoleID);
                });

            migrationBuilder.CreateTable(
                name: "Species",
                columns: table => new
                {
                    SpeciesID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SpeciesName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    AverageLifespan = table.Column<int>(type: "int", nullable: false),
                    CommonTraits = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Species", x => x.SpeciesID);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastLoginAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ResetPasswordToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ResetPasswordExpiration = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Cantons",
                columns: table => new
                {
                    CantonID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CantonName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CantonCode = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    CountryID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cantons", x => x.CantonID);
                    table.ForeignKey(
                        name: "FK_Cantons_Countries_CountryID",
                        column: x => x.CountryID,
                        principalTable: "Countries",
                        principalColumn: "CountryID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Breeds",
                columns: table => new
                {
                    BreedID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SpeciesID = table.Column<int>(type: "int", nullable: false),
                    BreedName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    SizeCategory = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    TemperamentNotes = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    SpecialNeeds = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    CommonHealthIssues = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Breeds", x => x.BreedID);
                    table.ForeignKey(
                        name: "FK_Breeds_Species_SpeciesID",
                        column: x => x.SpeciesID,
                        principalTable: "Species",
                        principalColumn: "SpeciesID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Donors",
                columns: table => new
                {
                    DonorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: true),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Address = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    DonorType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PreferredContactMethod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    TotalDonationsToDate = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Donors", x => x.DonorID);
                    table.ForeignKey(
                        name: "FK_Donors_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    UserRolesId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "RoleID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    CityID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CityName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CantonID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.CityID);
                    table.ForeignKey(
                        name: "FK_Cities_Cantons_CantonID",
                        column: x => x.CantonID,
                        principalTable: "Cantons",
                        principalColumn: "CantonID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Adopters",
                columns: table => new
                {
                    AdopterID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Address = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    CityID = table.Column<int>(type: "int", nullable: false),
                    CantonID = table.Column<int>(type: "int", nullable: false),
                    ZipCode = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    DateRegistered = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Adopters", x => x.AdopterID);
                    table.ForeignKey(
                        name: "FK_Adopters_Cantons_CantonID",
                        column: x => x.CantonID,
                        principalTable: "Cantons",
                        principalColumn: "CantonID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Adopters_Cities_CityID",
                        column: x => x.CityID,
                        principalTable: "Cities",
                        principalColumn: "CityID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Adopters_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Shelters",
                columns: table => new
                {
                    ShelterID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Address = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    CityID = table.Column<int>(type: "int", nullable: false),
                    CantonID = table.Column<int>(type: "int", nullable: false),
                    ZipCode = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Capacity = table.Column<int>(type: "int", nullable: false),
                    CurrentOccupancy = table.Column<int>(type: "int", nullable: false),
                    OperatingHours = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Shelters", x => x.ShelterID);
                    table.ForeignKey(
                        name: "FK_Shelters_Cantons_CantonID",
                        column: x => x.CantonID,
                        principalTable: "Cantons",
                        principalColumn: "CantonID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Shelters_Cities_CityID",
                        column: x => x.CityID,
                        principalTable: "Cities",
                        principalColumn: "CityID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Animals",
                columns: table => new
                {
                    AnimalID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    SpeciesID = table.Column<int>(type: "int", nullable: false),
                    BreedID = table.Column<int>(type: "int", nullable: false),
                    Age = table.Column<int>(type: "int", nullable: false),
                    Gender = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Weight = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DateArrived = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StatusID = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    HealthStatus = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    ShelterID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Animals", x => x.AnimalID);
                    table.ForeignKey(
                        name: "FK_Animals_AnimalStatuses_StatusID",
                        column: x => x.StatusID,
                        principalTable: "AnimalStatuses",
                        principalColumn: "StatusID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Animals_Breeds_BreedID",
                        column: x => x.BreedID,
                        principalTable: "Breeds",
                        principalColumn: "BreedID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Animals_Shelters_ShelterID",
                        column: x => x.ShelterID,
                        principalTable: "Shelters",
                        principalColumn: "ShelterID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Animals_Species_SpeciesID",
                        column: x => x.SpeciesID,
                        principalTable: "Species",
                        principalColumn: "SpeciesID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Events",
                columns: table => new
                {
                    EventID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    EventName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    EventDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Location = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ShelterID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Events", x => x.EventID);
                    table.ForeignKey(
                        name: "FK_Events_Shelters_ShelterID",
                        column: x => x.ShelterID,
                        principalTable: "Shelters",
                        principalColumn: "ShelterID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Staff",
                columns: table => new
                {
                    StaffID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Phone = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    Position = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Department = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    ShelterID = table.Column<int>(type: "int", nullable: false),
                    HireDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    AccessLevel = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Staff", x => x.StaffID);
                    table.ForeignKey(
                        name: "FK_Staff_Shelters_ShelterID",
                        column: x => x.ShelterID,
                        principalTable: "Shelters",
                        principalColumn: "ShelterID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Staff_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AnimalColors",
                columns: table => new
                {
                    AnimalColorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    ColorID = table.Column<int>(type: "int", nullable: false),
                    IsPrimary = table.Column<bool>(type: "bit", nullable: false),
                    AnimalID1 = table.Column<int>(type: "int", nullable: true),
                    ColorID1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalColors", x => x.AnimalColorID);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Animals_AnimalID1",
                        column: x => x.AnimalID1,
                        principalTable: "Animals",
                        principalColumn: "AnimalID");
                    table.ForeignKey(
                        name: "FK_AnimalColors_Colors_ColorID",
                        column: x => x.ColorID,
                        principalTable: "Colors",
                        principalColumn: "ColorID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalColors_Colors_ColorID1",
                        column: x => x.ColorID1,
                        principalTable: "Colors",
                        principalColumn: "ColorID");
                });

            migrationBuilder.CreateTable(
                name: "Feedbacks",
                columns: table => new
                {
                    FeedbackID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AdopterID = table.Column<int>(type: "int", nullable: false),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    ShelterID = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    FeedbackDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Feedbacks", x => x.FeedbackID);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Adopters_AdopterID",
                        column: x => x.AdopterID,
                        principalTable: "Adopters",
                        principalColumn: "AdopterID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Feedbacks_Shelters_ShelterID",
                        column: x => x.ShelterID,
                        principalTable: "Shelters",
                        principalColumn: "ShelterID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AdoptionApplications",
                columns: table => new
                {
                    ApplicationID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AdopterID = table.Column<int>(type: "int", nullable: false),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    ApplicationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StatusID = table.Column<int>(type: "int", nullable: false),
                    ReviewedByStaffID = table.Column<int>(type: "int", nullable: true),
                    ReviewDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Notes = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    LivingSituation = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsAnimalAllowed = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    AdoptionReasonId = table.Column<int>(type: "int", nullable: false),
                    AdopterID1 = table.Column<int>(type: "int", nullable: true),
                    AnimalID1 = table.Column<int>(type: "int", nullable: true),
                    StaffID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdoptionApplications", x => x.ApplicationID);
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Adopters_AdopterID",
                        column: x => x.AdopterID,
                        principalTable: "Adopters",
                        principalColumn: "AdopterID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Adopters_AdopterID1",
                        column: x => x.AdopterID1,
                        principalTable: "Adopters",
                        principalColumn: "AdopterID");
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Animals_AnimalID1",
                        column: x => x.AnimalID1,
                        principalTable: "Animals",
                        principalColumn: "AnimalID");
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_ApplicationStatuses_StatusID",
                        column: x => x.StatusID,
                        principalTable: "ApplicationStatuses",
                        principalColumn: "StatusID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Staff_ReviewedByStaffID",
                        column: x => x.ReviewedByStaffID,
                        principalTable: "Staff",
                        principalColumn: "StaffID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionApplications_Staff_StaffID",
                        column: x => x.StaffID,
                        principalTable: "Staff",
                        principalColumn: "StaffID");
                });

            migrationBuilder.CreateTable(
                name: "AnimalTemperamentJunctions",
                columns: table => new
                {
                    JunctionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    TemperamentID = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    Notes = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    AssessedByID = table.Column<int>(type: "int", nullable: true),
                    AssessmentDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AnimalID1 = table.Column<int>(type: "int", nullable: true),
                    AnimalTemperamentTemperamentID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AnimalTemperamentJunctions", x => x.JunctionID);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_AnimalTemperaments_AnimalTemperamentTemperamentID",
                        column: x => x.AnimalTemperamentTemperamentID,
                        principalTable: "AnimalTemperaments",
                        principalColumn: "TemperamentID");
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_AnimalTemperaments_TemperamentID",
                        column: x => x.TemperamentID,
                        principalTable: "AnimalTemperaments",
                        principalColumn: "TemperamentID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Animals_AnimalID1",
                        column: x => x.AnimalID1,
                        principalTable: "Animals",
                        principalColumn: "AnimalID");
                    table.ForeignKey(
                        name: "FK_AnimalTemperamentJunctions_Staff_AssessedByID",
                        column: x => x.AssessedByID,
                        principalTable: "Staff",
                        principalColumn: "StaffID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Donations",
                columns: table => new
                {
                    DonationID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DonorID = table.Column<int>(type: "int", nullable: true),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DonationTypeID = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    PaymentMethod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PayPalTransactionID = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PayPalPayerEmail = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PayPalStatus = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    AcknowledgedByStaffID = table.Column<int>(type: "int", nullable: true),
                    AcknowledgementDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TaxReceiptIssued = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Donations", x => x.DonationID);
                    table.ForeignKey(
                        name: "FK_Donations_DonationTypes_DonationTypeID",
                        column: x => x.DonationTypeID,
                        principalTable: "DonationTypes",
                        principalColumn: "DonationTypeID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Donations_Donors_DonorID",
                        column: x => x.DonorID,
                        principalTable: "Donors",
                        principalColumn: "DonorID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Donations_Staff_AcknowledgedByStaffID",
                        column: x => x.AcknowledgedByStaffID,
                        principalTable: "Staff",
                        principalColumn: "StaffID",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "MedicalRecords",
                columns: table => new
                {
                    MedicalRecordID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnimalID = table.Column<int>(type: "int", nullable: false),
                    ExaminationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Diagnosis = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Treatment = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    VeterinarianID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MedicalRecords", x => x.MedicalRecordID);
                    table.ForeignKey(
                        name: "FK_MedicalRecords_Animals_AnimalID",
                        column: x => x.AnimalID,
                        principalTable: "Animals",
                        principalColumn: "AnimalID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MedicalRecords_Staff_VeterinarianID",
                        column: x => x.VeterinarianID,
                        principalTable: "Staff",
                        principalColumn: "StaffID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AdoptionReasons",
                columns: table => new
                {
                    ApplicationID = table.Column<int>(type: "int", nullable: false),
                    ReasonID = table.Column<int>(type: "int", nullable: false),
                    ReasonID1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdoptionReasons", x => new { x.ApplicationID, x.ReasonID });
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_AdoptionApplications_ApplicationID",
                        column: x => x.ApplicationID,
                        principalTable: "AdoptionApplications",
                        principalColumn: "ApplicationID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_Reason_ReasonID",
                        column: x => x.ReasonID,
                        principalTable: "Reason",
                        principalColumn: "ReasonID",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_AdoptionReasons_Reason_ReasonID1",
                        column: x => x.ReasonID1,
                        principalTable: "Reason",
                        principalColumn: "ReasonID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Adopters_CantonID",
                table: "Adopters",
                column: "CantonID");

            migrationBuilder.CreateIndex(
                name: "IX_Adopters_CityID",
                table: "Adopters",
                column: "CityID");

            migrationBuilder.CreateIndex(
                name: "IX_Adopters_UserID",
                table: "Adopters",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AdopterID",
                table: "AdoptionApplications",
                column: "AdopterID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AdopterID1",
                table: "AdoptionApplications",
                column: "AdopterID1");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AnimalID",
                table: "AdoptionApplications",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_AnimalID1",
                table: "AdoptionApplications",
                column: "AnimalID1");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_ReviewedByStaffID",
                table: "AdoptionApplications",
                column: "ReviewedByStaffID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_StaffID",
                table: "AdoptionApplications",
                column: "StaffID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionApplications_StatusID",
                table: "AdoptionApplications",
                column: "StatusID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionReasons_ReasonID",
                table: "AdoptionReasons",
                column: "ReasonID");

            migrationBuilder.CreateIndex(
                name: "IX_AdoptionReasons_ReasonID1",
                table: "AdoptionReasons",
                column: "ReasonID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_AnimalID",
                table: "AnimalColors",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_AnimalID1",
                table: "AnimalColors",
                column: "AnimalID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_ColorID",
                table: "AnimalColors",
                column: "ColorID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalColors_ColorID1",
                table: "AnimalColors",
                column: "ColorID1");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_BreedID",
                table: "Animals",
                column: "BreedID");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_ShelterID",
                table: "Animals",
                column: "ShelterID");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_SpeciesID",
                table: "Animals",
                column: "SpeciesID");

            migrationBuilder.CreateIndex(
                name: "IX_Animals_StatusID",
                table: "Animals",
                column: "StatusID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalID1",
                table: "AnimalTemperamentJunctions",
                column: "AnimalID1");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AnimalTemperamentTemperamentID",
                table: "AnimalTemperamentJunctions",
                column: "AnimalTemperamentTemperamentID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_AssessedByID",
                table: "AnimalTemperamentJunctions",
                column: "AssessedByID");

            migrationBuilder.CreateIndex(
                name: "IX_AnimalTemperamentJunctions_TemperamentID",
                table: "AnimalTemperamentJunctions",
                column: "TemperamentID");

            migrationBuilder.CreateIndex(
                name: "IX_Breeds_SpeciesID",
                table: "Breeds",
                column: "SpeciesID");

            migrationBuilder.CreateIndex(
                name: "IX_Cantons_CountryID",
                table: "Cantons",
                column: "CountryID");

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CantonID",
                table: "Cities",
                column: "CantonID");

            migrationBuilder.CreateIndex(
                name: "IX_Donations_AcknowledgedByStaffID",
                table: "Donations",
                column: "AcknowledgedByStaffID");

            migrationBuilder.CreateIndex(
                name: "IX_Donations_DonationTypeID",
                table: "Donations",
                column: "DonationTypeID");

            migrationBuilder.CreateIndex(
                name: "IX_Donations_DonorID",
                table: "Donations",
                column: "DonorID");

            migrationBuilder.CreateIndex(
                name: "IX_Donors_UserID",
                table: "Donors",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Events_ShelterID",
                table: "Events",
                column: "ShelterID");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_AdopterID",
                table: "Feedbacks",
                column: "AdopterID");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_AnimalID",
                table: "Feedbacks",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_Feedbacks_ShelterID",
                table: "Feedbacks",
                column: "ShelterID");

            migrationBuilder.CreateIndex(
                name: "IX_MedicalRecords_AnimalID",
                table: "MedicalRecords",
                column: "AnimalID");

            migrationBuilder.CreateIndex(
                name: "IX_MedicalRecords_VeterinarianID",
                table: "MedicalRecords",
                column: "VeterinarianID");

            migrationBuilder.CreateIndex(
                name: "IX_Shelters_CantonID",
                table: "Shelters",
                column: "CantonID");

            migrationBuilder.CreateIndex(
                name: "IX_Shelters_CityID",
                table: "Shelters",
                column: "CityID");

            migrationBuilder.CreateIndex(
                name: "IX_Staff_ShelterID",
                table: "Staff",
                column: "ShelterID");

            migrationBuilder.CreateIndex(
                name: "IX_Staff_UserID",
                table: "Staff",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_Username",
                table: "Users",
                column: "Username",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdoptionReasons");

            migrationBuilder.DropTable(
                name: "AnimalColors");

            migrationBuilder.DropTable(
                name: "AnimalTemperamentJunctions");

            migrationBuilder.DropTable(
                name: "Donations");

            migrationBuilder.DropTable(
                name: "Events");

            migrationBuilder.DropTable(
                name: "Feedbacks");

            migrationBuilder.DropTable(
                name: "MedicalRecords");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "AdoptionApplications");

            migrationBuilder.DropTable(
                name: "Reason");

            migrationBuilder.DropTable(
                name: "Colors");

            migrationBuilder.DropTable(
                name: "AnimalTemperaments");

            migrationBuilder.DropTable(
                name: "DonationTypes");

            migrationBuilder.DropTable(
                name: "Donors");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Adopters");

            migrationBuilder.DropTable(
                name: "Animals");

            migrationBuilder.DropTable(
                name: "ApplicationStatuses");

            migrationBuilder.DropTable(
                name: "Staff");

            migrationBuilder.DropTable(
                name: "AnimalStatuses");

            migrationBuilder.DropTable(
                name: "Breeds");

            migrationBuilder.DropTable(
                name: "Shelters");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Species");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Cantons");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}
