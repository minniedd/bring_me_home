using BringMeHome.Models.Model;
using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Interfaces
{
    public interface IService<T, TSearch> where TSearch : class
    {
        Task<PageResult<T>> Get(TSearch search = null);
        Task<T> GetById(int id);
    }
}
