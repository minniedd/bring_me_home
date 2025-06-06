﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Database
{
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Username { get; set; } = string.Empty;

        public string? Address { get; set; }

        public byte[]? UserImage { get; set; }

        [MaxLength(20)]
        public string? PhoneNumber { get; set; }

        public int? CityID { get; set; }

        public string PasswordHash { get; set; } = string.Empty;

        public string PasswordSalt { get; set; } = string.Empty;

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? LastLoginAt { get; set; }

        public string? ResetPasswordToken { get; set; } 

        public DateTime? ResetPasswordExpiration { get; set; }

        public string? RefreshToken { get; set; }

        public DateTime? RefreshTokenExpiryTime { get; set; }

        [ForeignKey("CityID")]
        public virtual City? City { get; set; }

        public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

        public virtual ICollection<AdoptionApplication> AdoptionApplications { get; set; }
    }
}
