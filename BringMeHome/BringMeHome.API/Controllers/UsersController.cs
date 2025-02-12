using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<Users, UsersSearchObject, UserInsertRequest, UserUpdateRequest>
    {

        public UserController(ILogger<BaseController<Users, UsersSearchObject>> logger, IUsersService service)
            : base(logger, service)
        {
        }

        public override Task<Users> Insert([FromBody] UserInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
