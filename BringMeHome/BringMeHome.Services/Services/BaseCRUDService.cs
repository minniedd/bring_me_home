using BringMeHome.Models.Requests;
using BringMeHome.Models.SearchObjects;
using BringMeHome.Services.Database;
using BringMeHome.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Services.Services
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BringMeHomeDbContext _context;
        public IMapper _mapper;

        public BaseCRUDService(BringMeHomeDbContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
        }

        public TModel Insert(TInsert request)
        {
            TDbEntity entity = _mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            _context.Add(entity);
            _context.SaveChanges();

            return _mapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity)
        {

        }

        public TModel Update(int id, TUpdate request)
        {
            var set = _context.Set<TDbEntity>();

            var entity = set.Find(id);

            BeforeUpdate(request, entity);

            _mapper.Map(request, entity);

            _context.SaveChanges();

            return _mapper.Map<TModel>(entity);
        }

        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity)
        {

        }
    }
}
