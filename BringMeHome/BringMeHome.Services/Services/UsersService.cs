using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace BringMeHome.Services.Services
{
    public class UsersService : BaseCRUDService<Users, UsersSearchObject, Database.User, UserInsertRequest, UserUpdateRequest>, IUsersService
    {
        public UsersService(BringMeHomeDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<User> AddFilter(UsersSearchObject searchObject, IQueryable<User> query)
        {
            if (!string.IsNullOrWhiteSpace(searchObject?.UserFTS))
            {
                query = query.Where(x => x.FirstName.Contains(searchObject.UserFTS) || x.LastName.Contains(searchObject.UserFTS));
            }

            if (searchObject.isUserRoleIncluded == true)
            {
                query = query.Include(x => x.UserRoles).ThenInclude(x => x.Role);
            }

            return base.AddFilter(searchObject, query);
        }

        public override void BeforeInsert(UserInsertRequest request, User entity)
        {
            if (request.Password != request.PasswordRepeat)
            {
                throw new Exception("Passwords don't match!");
            }

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(UserUpdateRequest request, User entity)
        {
            base.BeforeUpdate(request, entity);

            if (request.Password != null)
            {

                if (request.Password != request.PasswordRepeat)
                {
                    throw new Exception("Passwords don't match!");
                }

                entity.PasswordSalt = GenerateSalt();
                entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
            }

        }


        public static string GenerateSalt()
        {
            var byteArray = RandomNumberGenerator.GetBytes(16);


            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }
    }
}
