From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 2 Sep 2019 10:06:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove deadcode on variable tmp_oh
	check
In-Reply-To: <20190830111621.8929-1-colin.king@canonical.com>
References: <20190830111621.8929-1-colin.king@canonical.com>
Message-ID: <37278619-3d48-4287-28d2-c5bc5af1d90f@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org



On 19/8/30 19:16, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> At the end of cfs2_inode_lock_tracker tmp_oh is true because an

s/cfs2_inode_lock_tracker/ocfs2_inode_lock_tracker/
BTW, could you please correct the following description of this
function as well?
"return == -1 if this lock attempt will cause an upgrade which is forbidden."
In fact, it returns -EINVAL.

Thanks,
Joseph

> earlier check on tmp_oh being false returns out of the function.
> Since tmp_oh is true, the function will always return 1 so remove
> the redundant check and return of 0.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/ocfs2/dlmglue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index ad594fef2ab0..ff0cf851c9e6 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2712,7 +2712,7 @@ int ocfs2_inode_lock_tracker(struct inode *inode,
>  			return status;
>  		}
>  	}
> -	return tmp_oh ? 1 : 0;
> +	return 1;
>  }
>  
>  void ocfs2_inode_unlock_tracker(struct inode *inode,
> 
