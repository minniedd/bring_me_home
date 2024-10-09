using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace BringMeHome.Services.Database;

public partial class BringMeHomeDbContext : DbContext
{
    public BringMeHomeDbContext()
    {
    }

    public BringMeHomeDbContext(DbContextOptions<BringMeHomeDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AdoptionReason> AdoptionReasons { get; set; }

    public virtual DbSet<Animal> Animals { get; set; }

    public virtual DbSet<AnimalType> AnimalTypes { get; set; }

    public virtual DbSet<Application> Applications { get; set; }

    public virtual DbSet<ApplicationAnswer> ApplicationAnswers { get; set; }

    public virtual DbSet<Breed> Breeds { get; set; }

    public virtual DbSet<Canton> Cantons { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<Favourite> Favourites { get; set; }

    public virtual DbSet<Review> Reviews { get; set; }

    public virtual DbSet<ReviewComment> ReviewComments { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<Shelter> Shelters { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.;Database=BringMeHomeDB;Trusted_Connection=True; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AdoptionReason>(entity =>
        {
            entity.ToTable("AdoptionReason");

            entity.Property(e => e.IsOther)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.OtherText)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.ReasonText)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Animal>(entity =>
        {
            entity.HasKey(e => e.AnimalsId).HasName("PK_Animal");

            entity.Property(e => e.About).HasMaxLength(500);
            entity.Property(e => e.Age).HasMaxLength(50);
            entity.Property(e => e.Gender).HasMaxLength(50);
            entity.Property(e => e.IsAdopted)
                .HasMaxLength(50)
                .HasColumnName("isAdopted");
            entity.Property(e => e.IsDeleted)
                .HasMaxLength(50)
                .HasColumnName("isDeleted");
            entity.Property(e => e.Name).HasMaxLength(50);
            entity.Property(e => e.RegistrationDate).HasColumnType("datetime");
            entity.Property(e => e.ShelterId).HasColumnName("ShelterID");
            entity.Property(e => e.Weight).HasMaxLength(50);

            entity.HasOne(d => d.AnimalType).WithMany(p => p.Animals)
                .HasForeignKey(d => d.AnimalTypeId)
                .HasConstraintName("FK_Animal_AnimalType");

            entity.HasOne(d => d.Breed).WithMany(p => p.Animals)
                .HasForeignKey(d => d.BreedId)
                .HasConstraintName("FK_Animal_Breed");

            entity.HasOne(d => d.City).WithMany(p => p.Animals)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK_Animal_City");

            entity.HasOne(d => d.Shelter).WithMany(p => p.Animals)
                .HasForeignKey(d => d.ShelterId)
                .HasConstraintName("FK_Animal_Shelter");
        });

        modelBuilder.Entity<AnimalType>(entity =>
        {
            entity.ToTable("AnimalType");

            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Application>(entity =>
        {
            entity.ToTable("Application");

            entity.Property(e => e.IsAnimalAllowed)
                .HasMaxLength(20)
                .HasColumnName("isAnimalAllowed");
            entity.Property(e => e.IsApproved)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("Is_Approved");
            entity.Property(e => e.LivingSituation).HasMaxLength(200);

            entity.HasOne(d => d.AdoptionReason).WithMany(p => p.Applications)
                .HasForeignKey(d => d.AdoptionReasonId)
                .HasConstraintName("FK_Application_AdoptionReason");

            entity.HasOne(d => d.Animals).WithMany(p => p.Applications)
                .HasForeignKey(d => d.AnimalsId)
                .HasConstraintName("FK_Application_Animal");

            entity.HasOne(d => d.Customers).WithMany(p => p.Applications)
                .HasForeignKey(d => d.CustomersId)
                .HasConstraintName("FK_Application_Customer");
        });

        modelBuilder.Entity<ApplicationAnswer>(entity =>
        {
            entity.ToTable("ApplicationAnswer");

            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.VisitDate).HasColumnType("datetime");

            entity.HasOne(d => d.Application).WithMany(p => p.ApplicationAnswers)
                .HasForeignKey(d => d.ApplicationId)
                .HasConstraintName("FK_Application");
        });

        modelBuilder.Entity<Breed>(entity =>
        {
            entity.ToTable("Breed");

            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Canton>(entity =>
        {
            entity.ToTable("Canton");

            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.ToTable("City");

            entity.Property(e => e.Name).HasMaxLength(50);

            entity.HasOne(d => d.Canton).WithMany(p => p.Cities)
                .HasForeignKey(d => d.CantonId)
                .HasConstraintName("FK_Canton");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.CustomersId).HasName("PK_Customer");

            entity.Property(e => e.Address).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.PasswordHash).HasMaxLength(50);
            entity.Property(e => e.PasswordSalt).HasMaxLength(50);
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.Username).HasMaxLength(50);

            entity.HasOne(d => d.City).WithMany(p => p.Customers)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK_Customer_City");
        });

        modelBuilder.Entity<Favourite>(entity =>
        {
            entity.HasKey(e => e.FavouritesId).HasName("PK_Favourite");

            entity.Property(e => e.DateLiked).HasColumnType("datetime");
            entity.Property(e => e.IsLiked).HasMaxLength(20);
            entity.Property(e => e.ModifiedBy).HasMaxLength(50);
            entity.Property(e => e.ModifiedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Animals).WithMany(p => p.Favourites)
                .HasForeignKey(d => d.AnimalsId)
                .HasConstraintName("FK_Favourite_Animal");

            entity.HasOne(d => d.Customers).WithMany(p => p.Favourites)
                .HasForeignKey(d => d.CustomersId)
                .HasConstraintName("FK_Favourite_Customer");
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.ToTable("Review");

            entity.Property(e => e.ReviewDate).HasColumnType("datetime");
            entity.Property(e => e.ReviewText).HasMaxLength(500);

            entity.HasOne(d => d.Customers).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.CustomersId)
                .HasConstraintName("FK_Review_Customer");

            entity.HasOne(d => d.Shelter).WithMany(p => p.Reviews)
                .HasForeignKey(d => d.ShelterId)
                .HasConstraintName("FK_Review_Shelter");
        });

        modelBuilder.Entity<ReviewComment>(entity =>
        {
            entity.ToTable("ReviewComment");

            entity.Property(e => e.Comment).HasMaxLength(500);
            entity.Property(e => e.ReplyDate).HasColumnType("datetime");

            entity.HasOne(d => d.Review).WithMany(p => p.ReviewComments)
                .HasForeignKey(d => d.ReviewId)
                .HasConstraintName("FK_ReviewComment_Review");

            entity.HasOne(d => d.User).WithMany(p => p.ReviewComments)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_ReviewComment_User");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RolesId).HasName("PK_Role");

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.Name).HasMaxLength(50);
        });

        modelBuilder.Entity<Shelter>(entity =>
        {
            entity.ToTable("Shelter");

            entity.Property(e => e.ShelterId).HasColumnName("ShelterID");
            entity.Property(e => e.CityId).HasColumnName("CityID");
            entity.Property(e => e.Name).HasMaxLength(100);
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UsersId);

            entity.ToTable("User");

            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.PasswordHash).HasMaxLength(50);
            entity.Property(e => e.PasswordSalt).HasMaxLength(50);
            entity.Property(e => e.UserEmail)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.UserPhone)
                .HasMaxLength(15)
                .IsUnicode(false);
            entity.Property(e => e.UserStatus)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.UserRolesId);

            entity.ToTable("UserRole");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK_UserRole_Role");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_UserRole_User");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
