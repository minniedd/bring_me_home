﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Requests
{
    public class UserRequest
    {
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string? LastName { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Username { get; set; } = string.Empty;

        public byte[]? UserImage { get; set; }

        [MaxLength(20)]
        public string? PhoneNumber { get; set; }

        public string? Address { get; set; }

        public int? CityID { get; set; }

        public bool IsActive { get; set; } = true;

        // Only used when creating a new user
        [MinLength(6)]
        public string? Password { get; set; }
    }
}
