From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 3 Nov 2014 13:01:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: improve code readability
In-Reply-To: <1414758561-30022-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1414758561-30022-1-git-send-email-sudipm.mukherjee@gmail.com>
Message-ID: <54570C1C.9080508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

You are right. Actually Andrew has already fixed this in mm tree.
Thanks.

On 2014/10/31 20:29, Sudip Mukherjee wrote:
> code was getting confusing as the priority of both the
> operators ! and & are same.
> this change is done to just to improve the readability
> of the code.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> hi,
> i hope this is the way Weiwei Wang has thought of the logic when giving that BUG_ON,
> please discard this patch if this assumption was worng.
> 
> 
>  fs/ocfs2/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 62620ab..1a05574 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2764,7 +2764,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>  		goto bail_unlock_orphan;
>  	}
>  
> -	BUG_ON(!di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL));
> +	BUG_ON(!(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)));
>  
>  	/* Only delete entry if OCFS2_ORPHANED_FL not set, or
>  	 * there are two entries added */
> 
