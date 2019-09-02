From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 2 Sep 2019 18:06:47 +0800
Subject: [Ocfs2-devel] [PATCH][V2] ocfs2: remove deadcode on variable
	tmp_oh check
In-Reply-To: <20190902093434.27739-1-colin.king@canonical.com>
References: <20190902093434.27739-1-colin.king@canonical.com>
Message-ID: <3ea5b370-8373-8ea7-9c2b-49218fcd0fd4@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org



On 19/9/2 17:34, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> At the end of ocfs2_inode_lock_tracker tmp_oh is true because an
> earlier check on tmp_oh being false returns out of the function.
> Since tmp_oh is true, the function will always return 1 so remove
> the redundant check and return of 0.
> 
> Also update description in comment, return -EINVAL and not -1.
> 
> Addresses-Coverity: ("Logically dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> 
> V2: Fix typo of function name in description.
>     Update description in comment as noted by Joseph Qi
> 
> ---
>  fs/ocfs2/dlmglue.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index ad594fef2ab0..640eee2bb903 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2626,7 +2626,8 @@ void ocfs2_inode_unlock(struct inode *inode,
>   *
>   * return < 0 on error, return == 0 if there's no lock holder on the stack
>   * before this call, return == 1 if this call would be a recursive locking.
> - * return == -1 if this lock attempt will cause an upgrade which is forbidden.
> + * return == -EINVAL if this lock attempt will cause an upgrade which is
> + * forbidden.
>   *
>   * When taking lock levels into account,we face some different situations.
>   *
> @@ -2712,7 +2713,7 @@ int ocfs2_inode_lock_tracker(struct inode *inode,
>  			return status;
>  		}
>  	}
> -	return tmp_oh ? 1 : 0;
> +	return 1;
>  }
>  
>  void ocfs2_inode_unlock_tracker(struct inode *inode,
> 
