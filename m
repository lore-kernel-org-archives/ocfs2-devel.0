From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 12 Jan 2020 09:57:44 +0800
Subject: [Ocfs2-devel] [PATCH v2 2/2] ocfs2: use
 ocfs2_update_inode_fsync_trans() to access t_tid in handle->h_transaction
In-Reply-To: <6ff9a312-5f7d-0e27-fb51-bc4e062fcd97@huawei.com>
References: <03e750ab-9ade-83aa-b000-b9e81e34e539@huawei.com>
	<6ff9a312-5f7d-0e27-fb51-bc4e062fcd97@huawei.com>
Message-ID: <6b7430e2-627e-449a-a4ae-5be2d20fb090@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/1/11 16:47, wangyan wrote:
> For the uniform format, we use ocfs2_update_inode_fsync_trans()
> to access t_tid in handle->h_transaction
> 
> Signed-off-by: Yan Wang <wangyan122@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/namei.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 8ea51cf27b97..da65251ef815 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -586,8 +586,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>  			mlog_errno(status);
>  	}
> 
> -	oi->i_sync_tid = handle->h_transaction->t_tid;
> -	oi->i_datasync_tid = handle->h_transaction->t_tid;
> +	ocfs2_update_inode_fsync_trans(handle, inode, 1);
> 
>  leave:
>  	if (status < 0) {
> 
