using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [ApiController]
    [Route("Users")]
    public class UsersController : BaseCRUDController<Users,UsersSearchObject,UserInsertRequest,UserUpdateRequest>
    {

        public UsersController(IUsersService service):base(service) 
        {
        }

    }
}
