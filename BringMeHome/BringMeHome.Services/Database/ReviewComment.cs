using System;
using System.Collections.Generic;

namespace BringMeHome.Services.Database;

public partial class ReviewComment
{
    public int ReviewCommentId { get; set; }

    public int? ReviewId { get; set; }

    public int? UserId { get; set; }

    public string? Comment { get; set; }

    public DateTime? ReplyDate { get; set; }

    public virtual Review? Review { get; set; }

    public virtual User? User { get; set; }
}
