From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 27 Jul 2020 15:15:04 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix unbalanced locking
In-Reply-To: <20200724124443.GA28164@duo.ucw.cz>
References: <20200724124443.GA28164@duo.ucw.cz>
Message-ID: <41de02bf-3c16-3492-6f9c-7ae4b519778e@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>, trivial@kernel.org, mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Junxiao Bi <junxiao.bi@oracle.com>, Andrew Morton <akpm@linux-foundation.org>



On 2020/7/24 20:44, Pavel Machek wrote:
> 
> Based on what fails, function can return with nfs_sync_rwlock either
> locked or unlocked. That can not be right.
> 
> Always return with lock unlocked on error.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Looks good.

Fixes: 4cd9973f9ff6 ("ocfs2: avoid inode removal while nfsd is accessing it")
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 751bc4dc7466..8e3a369086db 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2871,9 +2871,15 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
>  
>  	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
>  				    0, 0);
> -	if (status < 0)
> +	if (status < 0) {
>  		mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
>  
> +		if (ex)
> +			up_write(&osb->nfs_sync_rwlock);
> +		else
> +			up_read(&osb->nfs_sync_rwlock);
> +	}
> +
>  	return status;
>  }
>  
> 
