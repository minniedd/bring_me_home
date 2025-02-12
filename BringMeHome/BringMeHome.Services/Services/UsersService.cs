using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Mapster;
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
    public class UserService : BaseCRUDService<Models.Model.Users, Database.User, Models.SearchObjects.UsersSearchObject, UserInsertRequest, UserUpdateRequest>, IUsersService
    {

        public UserService(BringMeHomeDbContext context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<User> AddFilter(IQueryable<User> query, UsersSearchObject? search = null)
        {

            if (!string.IsNullOrWhiteSpace(search?.UserFTS))
            {
                query = query.Where(x => x.FirstName.Contains(search.UserFTS) || x.LastName.Contains(search.UserFTS));
            }

            return base.AddFilter(query, search);
        }

        public override async Task<Models.Model.Users> Insert(UserInsertRequest insert)
        {
            return await base.Insert(insert);
        }

        public override async Task BeforeInsert(User entity, UserInsertRequest request)
        {
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);
        }

        public override async Task<Models.Model.Users> Update(int id, UserUpdateRequest update)
        {
            return await base.Update(id, update);
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UsersSearchObject? search = null)
        {
            query = query.Include("UserRoles.Role");

            return base.AddInclude(query, search);
        }

        public override async Task<User> AddIncludeId(IQueryable<User> query, int id)
        {
            query = query.Include("UserRoles.Role");
            var entity = await query.FirstOrDefaultAsync(x => x.UsersId == id);
            return entity;
        }

        public override async Task<Task> BeforeRemove(User db)
        {
            var entityRole = await _context.UserRoles.FirstOrDefaultAsync(x => x.UserId == db.UsersId);

            if (entityRole != null)
            {
                _context.UserRoles.Remove(entityRole);

                await _context.SaveChangesAsync();
            }

            return base.BeforeRemove(db);
        }

        public async Task<Models.Model.Users> Login(string email, string password)
        {
            var entity = await _context.Users.Include("UserRoles.Role").FirstOrDefaultAsync(x => x.UserEmail == email);

            if (entity == null)
                return null;

            var hash = GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                return null;
            }

            return _mapper.Map<Models.Model.Users>(entity);

        }
    }
}
