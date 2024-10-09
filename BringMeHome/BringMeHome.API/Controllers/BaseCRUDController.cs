using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch>where TSearch : BaseSearchObject where TModel : class
    {
        protected new IBaseCRUDService<TModel, TSearch, TInsert, TUpdate> _service;

        public BaseCRUDController(IBaseCRUDService<TModel, TSearch,TInsert,TUpdate> service) : base(service)
        {
            _service = service;
        }

        [HttpPost]
        public virtual TModel Insert(TInsert request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public virtual TModel Update(int id, TUpdate request)
        {
            return _service.Update(id, request);
        }
    }
}
