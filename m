From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 03 Sep 2013 16:16:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: add necessary check in case
 sb_getblk fails
In-Reply-To: <1378191640-3844-2-git-send-email-rui.xiang@huawei.com>
References: <1378191640-3844-1-git-send-email-rui.xiang@huawei.com>
	<1378191640-3844-2-git-send-email-rui.xiang@huawei.com>
Message-ID: <52259AEC.9040205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/03/2013 03:00 PM, Rui Xiang wrote:

> Sb_getblk may retrun an err, so add a check for bh.
> 
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

> ---
>  fs/ocfs2/refcounttree.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 50c1796..22f3f19 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -612,6 +612,11 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
>  	}
>  
>  	new_bh = sb_getblk(inode->i_sb, first_blkno);
> +	if (!new_bh) {
> +		ret = -ENOMEM;
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
>  	ocfs2_set_new_buffer_uptodate(&new_tree->rf_ci, new_bh);
>  
>  	ret = ocfs2_journal_access_rb(handle, &new_tree->rf_ci, new_bh,
