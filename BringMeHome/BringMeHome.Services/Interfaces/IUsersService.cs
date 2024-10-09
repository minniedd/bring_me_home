using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IUsersService:IBaseCRUDService<Users,UsersSearchObject,UserInsertRequest,UserUpdateRequest>
    {

    }
}
