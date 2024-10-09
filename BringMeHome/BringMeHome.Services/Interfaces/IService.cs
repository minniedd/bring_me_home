using BringMeHome.Models.Model;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public PageResult<TModel> GetPaged(TSearch search);

        public TModel GetById(int id);
    }
}
