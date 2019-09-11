From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 11 Sep 2019 09:32:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with inode
 cluster lock
In-Reply-To: <20190910173046.27360-1-junxiao.bi@oracle.com>
References: <20190910173046.27360-1-junxiao.bi@oracle.com>
Message-ID: <87ca68b3-cb98-8747-1502-9a540e94f3c2@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 19/9/11 01:30, Junxiao Bi wrote:
> Inode cluster lock should be acquired to avoid extent
> tree changed by other cluster nodes.
> 
Could you please elaborate more on the real issue?
IIUC, ocfs2_lock_get_block() will only be called under:
1) rw = READ;
2) rw = WRITE && overwrite.

Thanks,
Joseph

> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/aops.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index a4c905d6b575..5ae7253d04b0 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -127,9 +127,15 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
>  	int ret = 0;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  
> +	ret = ocfs2_inode_lock(inode, NULL, 0);
> +	if (ret) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
>  	down_read(&oi->ip_alloc_sem);
>  	ret = ocfs2_get_block(inode, iblock, bh_result, create);
>  	up_read(&oi->ip_alloc_sem);
> +	ocfs2_inode_unlock(inode, 0);
>  
>  	return ret;
>  }
> 
