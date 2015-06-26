From: WeiWei Wang <wangww631@huawei.com>
Date: Fri, 26 Jun 2015 15:17:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix race between dio and recover
 orphan
In-Reply-To: <558CE8B4.8070904@huawei.com>
References: <558CE8B4.8070904@huawei.com>
Message-ID: <558CFC79.5050808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/6/26 13:52, Joseph Qi wrote:
> During direct io the inode will be added to orphan first and then
> deleted from orphan. There is a race window that the orphan entry will
> be deleted twice and thus trigger the BUG when validating
> OCFS2_DIO_ORPHANED_FL in ocfs2_del_inode_from_orphan.
> 
> ocfs2_direct_IO_write
>     ...
>     ocfs2_add_inode_to_orphan
>     >>>>>>>> race window, another node may rm the file and then down,
>              this node take care of orphan recovery and clear flag
>              OCFS2_DIO_ORPHANED_FL
>     ocfs2_del_inode_from_orphan
> 
> Take inode mutex lock to fix this race case.
> 
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>

Reviewed-by: Weiwei Wang <wangww631@huawei.com>
> ---
>  fs/ocfs2/journal.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 8017032..f8206d1 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -2172,6 +2172,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
>  		iter = oi->ip_next_orphan;
>  		oi->ip_next_orphan = NULL;
> 
> +		mutex_lock(&inode->i_mutex);
>  		ret = ocfs2_rw_lock(inode, 1);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> @@ -2218,6 +2219,7 @@ unlock_inode:
>  unlock_rw:
>  		ocfs2_rw_unlock(inode, 1);
>  next:
> +		mutex_unlock(&inode->i_mutex);
>  		iput(inode);
>  		brelse(di_bh);
>  		di_bh = NULL;
> 
