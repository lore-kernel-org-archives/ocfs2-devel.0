From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 19 Dec 2019 20:12:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove unneeded semicolon
In-Reply-To: <1576751977-32823-1-git-send-email-zhengbin13@huawei.com>
References: <1576751977-32823-1-git-send-email-zhengbin13@huawei.com>
Message-ID: <6ee3aa16-9078-30b1-df3f-22064950bd98@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 19/12/19 18:39, zhengbin wrote:
> Fixes coccicheck warning:
> 
> fs/ocfs2/cluster/quorum.c:76:2-3: Unneeded semicolon
> fs/ocfs2/dlmglue.c:573:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/cluster/quorum.c | 2 +-
>  fs/ocfs2/dlmglue.c        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
> index 5c424a0..1ef2457 100644
> --- a/fs/ocfs2/cluster/quorum.c
> +++ b/fs/ocfs2/cluster/quorum.c
> @@ -73,7 +73,7 @@ static void o2quo_fence_self(void)
>  		       "system by restarting ***\n");
>  		emergency_restart();
>  		break;
> -	};
> +	}
>  }
> 
>  /* Indicate that a timeout occurred on a heartbeat region write. The
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 1c4c51f..46aa09d 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -570,7 +570,7 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
>  			mlog_bug_on_msg(1, "type: %d\n", type);
>  			ops = NULL; /* thanks, gcc */
>  			break;
> -	};
> +	}
> 
>  	ocfs2_build_lock_name(type, OCFS2_I(inode)->ip_blkno,
>  			      generation, res->l_name);
> --
> 2.7.4
> 
