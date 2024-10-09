using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.Model
{
    public class PageResult<T>
    {
        public int? Count { get; set; }

        public IList<T> Result { get; set; }
    }
}
