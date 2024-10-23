using BringMeHome.Models.Model;
using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IAnimalsService : IBaseCRUDService<Users, UsersSearchObject, UserInsertRequest, UserUpdateRequest>
    {
    }
}
