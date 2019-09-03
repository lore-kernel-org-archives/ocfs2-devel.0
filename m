From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 3 Sep 2019 22:56:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Delete unnecessary checks before
	brelse()
In-Reply-To: <55cde320-394b-f985-56ce-1a2abea782aa@web.de>
References: <55cde320-394b-f985-56ce-1a2abea782aa@web.de>
Message-ID: <153d9e24-d79d-1ba6-da5f-824ec9d8070a@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Elfring <Markus.Elfring@web.de>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Jia-Ju Bai <baijiaju1990@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>



On 19/9/3 22:40, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 3 Sep 2019 16:33:32 +0200
> 
> The brelse() function tests whether its argument is NULL
> and then returns immediately.
> Thus the tests around the shown calls are not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmglue.c    | 7 ++-----
>  fs/ocfs2/extent_map.c | 3 +--
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index ad594fef2ab0..6e774c5ea13b 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2508,9 +2508,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
>  			ocfs2_inode_unlock(inode, ex);
>  	}
> 
> -	if (local_bh)
> -		brelse(local_bh);
> -
> +	brelse(local_bh);
>  	return status;
>  }
> 
> @@ -2593,8 +2591,7 @@ int ocfs2_inode_lock_atime(struct inode *inode,
>  		*level = 1;
>  		if (ocfs2_should_update_atime(inode, vfsmnt))
>  			ocfs2_update_inode_atime(inode, bh);
> -		if (bh)
> -			brelse(bh);
> +		brelse(bh);
>  	} else
>  		*level = 0;
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index e66a249fe07c..e3e2d1b2af51 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -590,8 +590,7 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
>  			*extent_flags = rec->e_flags;
>  	}
>  out:
> -	if (eb_bh)
> -		brelse(eb_bh);
> +	brelse(eb_bh);
>  	return ret;
>  }
> 
> --
> 2.23.0
> 
