using BringMeHome.Models.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Helpers
{
    public static class QueryableExtensions
    {
        public static IOrderedQueryable<T> ApplySort<T>(this IQueryable<T> query, BaseSearchObject searchObject)
        {
            if (string.IsNullOrWhiteSpace(searchObject.SortBy))
            {
                return query.OrderBy(x => 1);
            }

            var parameter = Expression.Parameter(typeof(T), "x");
            var property = Expression.Property(parameter, searchObject.SortBy);
            var lambda = Expression.Lambda(property, parameter);

            string methodName = searchObject.SortOrder == SortOrder.Ascending
                ? "OrderBy"
                : "OrderByDescending";

            var result = typeof(Queryable).GetMethods()
                .Single(method =>
                    method.Name == methodName &&
                    method.IsGenericMethodDefinition &&
                    method.GetGenericArguments().Length == 2 &&
                    method.GetParameters().Length == 2)
                .MakeGenericMethod(typeof(T), property.Type)
                .Invoke(null, new object[] { query, lambda });

            return (IOrderedQueryable<T>)result;
        }

        public static IQueryable<T> ApplyPagination<T>(this IQueryable<T> query, BaseSearchObject searchObject)
        {
            return query
                .Skip(searchObject.Skip)
                .Take(searchObject.PageSize);
        }
    }

}
