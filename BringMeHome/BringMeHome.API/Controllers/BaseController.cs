using BringMeHome.Models.Model;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BringMeHome.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseController<TModel, TSearch> : ControllerBase where TSearch : BaseSearchObject
    {
        protected IService<TModel, TSearch> _service;

        public BaseController(IService<TModel, TSearch> service)
        {
            _service = service;
        }

        [Authorize]
        [HttpGet]
        public virtual PageResult<TModel> GetList([FromQuery] TSearch searchObject)
        {
            return _service.GetPaged(searchObject);
        }

        [Authorize]
        [HttpGet("{id}")]
        public virtual TModel GetById(int id)
        {
            return _service.GetById(id);
        }
    }
}
