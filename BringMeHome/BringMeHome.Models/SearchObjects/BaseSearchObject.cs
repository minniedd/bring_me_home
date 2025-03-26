using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BringMeHome.Models.SearchObjects
{
    public class BaseSearchObject
    {
        public string? FTS { get; set; }

        public int PageNumber { get; set; } = 1;

        public int PageSize { get; set; } = 10;

        public string? SortBy { get; set; }

        public SortOrder SortOrder { get; set; } = SortOrder.Ascending;

        public int Skip => (PageNumber - 1) * PageSize;
    }

    public enum SortOrder
    {
        Ascending,
        Descending
    }
}

