From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Feb 2014 16:48:56 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlm: fix lock migration crash
In-Reply-To: <1393400857-12294-1-git-send-email-junxiao.bi@oracle.com>
References: <1393400857-12294-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20140226164856.a127c84a1df19a82dc24f21c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 26 Feb 2014 15:47:37 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> This issue was introduced by commit 800deef3 where it replaced list_for_each
> with list_for_each_entry. The variable "lock" will point to invalid data if
> "tmpq" list is empty and a panic will be triggered due to this.
> Sunil advised reverting it back, but the old version was also not right. At
> the end of the outer for loop, that list_for_each_entry will also set "lock"
> to an invalid data, then in the next loop, if the "tmpq" list is empty, "lock"
> will be an stale invalid data and cause the panic. So reverting the list_for_each
> back and reset "lock" to NULL to fix this issue.
> 
> ...
>
> Cc: <stable@vger.kernel.org>

800deef3 was back in 2007, so this doesn't seem a terribly urgent bugfix!

I think what I'll do is to target 3.15-rc1 to give people time to
review and test this.  But I'll retain the cc:stable so the fix gets
backported into 3.14.x and earlier kernels.

OK?
