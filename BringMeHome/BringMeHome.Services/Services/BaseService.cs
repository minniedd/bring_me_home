using BringMeHome.Models.Model;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public BringMeHomeDbContext _context;
        public IMapper _mapper;

        public BaseService(BringMeHomeDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public TModel GetById(int id)
        {
            var entity = _context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return _mapper.Map<TModel>(entity);
            }
            else
            {
                return null;
            }
        }

        public PageResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();

            var filteredQuery = _context.Set<TDbEntity>().AsQueryable();

            filteredQuery = AddFilter(search, filteredQuery);

            int count = filteredQuery.Count();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                filteredQuery = filteredQuery.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = filteredQuery.ToList();

            result = _mapper.Map(list, result);

            PageResult<TModel> pagedResult = new PageResult<TModel>();

            pagedResult.Result = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> filter)
        {
            return filter;
        }
    }
}
