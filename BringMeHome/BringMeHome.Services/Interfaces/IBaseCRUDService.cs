using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IBaseCRUDService<TModel,TSearch,TInsert, TUpdate>:IService<TModel, TSearch> where TModel : class where TSearch : BaseSearchObject

    {
        TModel Insert(TInsert request);
        TModel Update(int id, TUpdate request);
    }
}
