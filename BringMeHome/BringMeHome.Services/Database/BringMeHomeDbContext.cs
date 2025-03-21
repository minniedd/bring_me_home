using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;
using System.Text;
using System.Threading.Tasks;
using static BringMeHome.Services.Database.Adopters;

namespace BringMeHome.Services.Database
{
    public class BringMeHomeDbContext: DbContext
    {
        public BringMeHomeDbContext(DbContextOptions<BringMeHomeDbContext> options) : base(options)
        {
        }

        public DbSet<Animal> Animals { get; set; }
        public DbSet<Shelter> Shelters { get; set; }
        public DbSet<Adopter> Adopters { get; set; }
        public DbSet<Staff> Staff { get; set; }
        public DbSet<AdoptionApplication> AdoptionApplications { get; set; }
        public DbSet<Donation> Donations { get; set; }
        public DbSet<Donor> Donors { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<Role>Roles { get; set; }
        public DbSet<Species> Species { get; set; }
        public DbSet<Breed> Breeds { get; set; }
        public DbSet<Color> Colors { get; set; }
        public DbSet<AnimalColor> AnimalColors { get; set; }
        public DbSet<AnimalStatus> AnimalStatuses { get; set; }
        public DbSet<ApplicationStatus> ApplicationStatuses { get; set; }
        public DbSet<AnimalTemperament> AnimalTemperaments { get; set; }
        public DbSet<AnimalTemperamentJunction> AnimalTemperamentJunctions { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<Canton> Cantons { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<DonationType> DonationTypes { get; set; }
        public DbSet<AdoptionReason> AdoptionReasons { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<MedicalRecord> MedicalRecords { get; set; }
        public DbSet<Feedback> Feedbacks { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();

            // Animal entity configuration
            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Species)
                .WithMany(s => s.Animals)
                .HasForeignKey(a => a.SpeciesID);

            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Breed)
                .WithMany(b => b.Animals)
                .HasForeignKey(a => a.BreedID);

            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Shelter)
                .WithMany(s => s.Animals)
                .HasForeignKey(a => a.ShelterID);

            modelBuilder.Entity<Animal>()
                .HasOne(a => a.Status)
                .WithMany(s => s.Animals)
                .HasForeignKey(a => a.StatusID);

            // Shelter entity configuration
            modelBuilder.Entity<Shelter>()
                .HasOne(s => s.City)
                .WithMany(c => c.Shelters)
                .HasForeignKey(s => s.CityID);

            modelBuilder.Entity<Shelter>()
                .HasOne(s => s.Canton)
                .WithMany(c => c.Shelters)
                .HasForeignKey(s => s.CantonID);

            // Adopter entity configuration
            modelBuilder.Entity<Adopter>()
                .HasOne(a => a.User)
                .WithMany()
                .HasForeignKey(a => a.UserID);

            modelBuilder.Entity<Adopter>()
                .HasOne(a => a.City)
                .WithMany(c => c.Adopters)
                .HasForeignKey(a => a.CityID);

            modelBuilder.Entity<Adopter>()
                .HasOne(a => a.Canton)
                .WithMany(c => c.Adopters)
                .HasForeignKey(a => a.CantonID);

            // AdoptionApplication entity configuration
            modelBuilder.Entity<AdoptionApplication>()
                .HasOne(aa => aa.Adopter)
                .WithMany()
                .HasForeignKey(aa => aa.AdopterID);

            modelBuilder.Entity<AdoptionApplication>()
                .HasOne(aa => aa.Animal)
                .WithMany()
                .HasForeignKey(aa => aa.AnimalID);

            modelBuilder.Entity<AdoptionApplication>()
                .HasOne(aa => aa.Status)
                .WithMany(s => s.Applications)
                .HasForeignKey(aa => aa.StatusID);

            modelBuilder.Entity<AdoptionApplication>()
                .HasOne(aa => aa.ReviewedBy)
                .WithMany()
                .HasForeignKey(aa => aa.ReviewedByStaffID);

            // Donation entity configuration
            modelBuilder.Entity<Donation>()
                .HasOne(d => d.Donor)
                .WithMany(dn => dn.Donations)
                .HasForeignKey(d => d.DonorID);

            modelBuilder.Entity<Donation>()
                .HasOne(d => d.DonationType)
                .WithMany(dt => dt.Donations)
                .HasForeignKey(d => d.DonationTypeID);

            modelBuilder.Entity<Donation>()
                .HasOne(d => d.AcknowledgedBy)
                .WithMany()
                .HasForeignKey(d => d.AcknowledgedByStaffID);

            // AnimalColor entity configuration
            modelBuilder.Entity<AnimalColor>()
                .HasOne(ac => ac.Animal)
                .WithMany()
                .HasForeignKey(ac => ac.AnimalID);

            modelBuilder.Entity<AnimalColor>()
                .HasOne(ac => ac.Color)
                .WithMany()
                .HasForeignKey(ac => ac.ColorID);

            // AnimalTemperamentJunction entity configuration
            modelBuilder.Entity<AnimalTemperamentJunction>()
                .HasOne(atj => atj.Animal)
                .WithMany()
                .HasForeignKey(atj => atj.AnimalID);

            modelBuilder.Entity<AnimalTemperamentJunction>()
                .HasOne(atj => atj.Temperament)
                .WithMany()
                .HasForeignKey(atj => atj.TemperamentID);

            modelBuilder.Entity<AnimalTemperamentJunction>()
                .HasOne(atj => atj.AssessedBy)
                .WithMany()
                .HasForeignKey(atj => atj.AssessedByID);
        }
    }
}
