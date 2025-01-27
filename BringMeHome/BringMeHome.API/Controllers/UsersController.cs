using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [ApiController]
    [Route("Users")]
    public class UsersController : BaseCRUDController<Users,UsersSearchObject,UserInsertRequest,UserUpdateRequest>
    {

        public UsersController(IUsersService service) : base(service)
        {
        }
        //[AllowAnonymous]
        [HttpPost("login")]
        public async Task<Users> Login(string username, string password)
        {
            return await (_service as IUsersService).Login(username, password);
        }

        //[AllowAnonymous]
        public override PageResult<Users> GetList([FromQuery] UsersSearchObject searchObject)
        {
            return base.GetList(searchObject);
        }
    }
}
