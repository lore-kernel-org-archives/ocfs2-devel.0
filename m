From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 29 Jun 2020 09:47:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: change slot number type s16 to u16
In-Reply-To: <20200627001259.19757-1-junxiao.bi@oracle.com>
References: <20200627001259.19757-1-junxiao.bi@oracle.com>
Message-ID: <ac7e598f-d6a3-33ac-709d-1f06412c9208@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/6/27 08:12, Junxiao Bi wrote:
> Dan Carpenter reported the following static checker warning.
> 
> 	fs/ocfs2/super.c:1269 ocfs2_parse_options() warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
> 	fs/ocfs2/suballoc.c:859 ocfs2_init_inode_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_inode_steal_slot'
> 	fs/ocfs2/suballoc.c:867 ocfs2_init_meta_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_meta_steal_slot'
> 
> That's because OCFS2_INVALID_SLOT is (u16)-1. Slot number in ocfs2 can be
> never negative, so change s16 to u16.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ocfs2.h    | 4 ++--
>  fs/ocfs2/suballoc.c | 4 ++--
>  fs/ocfs2/super.c    | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 2dd71d626196..7993d527edae 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -327,8 +327,8 @@ struct ocfs2_super
>  	spinlock_t osb_lock;
>  	u32 s_next_generation;
>  	unsigned long osb_flags;
> -	s16 s_inode_steal_slot;
> -	s16 s_meta_steal_slot;
> +	u16 s_inode_steal_slot;
> +	u16 s_meta_steal_slot;
>  	atomic_t s_num_inodes_stolen;
>  	atomic_t s_num_meta_stolen;
>  
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 45745cc3408a..8c8cf7f4eb34 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -879,9 +879,9 @@ static void __ocfs2_set_steal_slot(struct ocfs2_super *osb, int slot, int type)
>  {
>  	spin_lock(&osb->osb_lock);
>  	if (type == INODE_ALLOC_SYSTEM_INODE)
> -		osb->s_inode_steal_slot = slot;
> +		osb->s_inode_steal_slot = (u16)slot;
>  	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
> -		osb->s_meta_steal_slot = slot;
> +		osb->s_meta_steal_slot = (u16)slot;
>  	spin_unlock(&osb->osb_lock);
>  }
>  
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 71ea9ce71a6b..1d91dd1e8711 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -78,7 +78,7 @@ struct mount_options
>  	unsigned long	commit_interval;
>  	unsigned long	mount_opt;
>  	unsigned int	atime_quantum;
> -	signed short	slot;
> +	unsigned short	slot;
>  	int		localalloc_opt;
>  	unsigned int	resv_level;
>  	int		dir_resv_level;
> @@ -1349,7 +1349,7 @@ static int ocfs2_parse_options(struct super_block *sb,
>  				goto bail;
>  			}
>  			if (option)
> -				mopt->slot = (s16)option;
> +				mopt->slot = (u16)option;
>  			break;
>  		case Opt_commit:
>  			if (match_int(&args[0], &option)) {
> 
