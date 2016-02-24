From: Gang He <ghe@suse.com>
Date: Wed, 24 Feb 2016 00:47:09 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock inode if deleting inode
 from orphan fail
In-Reply-To: <56CD1247.9020806@huawei.com>
References: <56CD1247.9020806@huawei.com>
Message-ID: <56CDD07D020000F90002AECF@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

looks good, thanks.

Reviewed-by: Gang He <ghe@suse.com>


>>> 
> From: Guozhonghua <guozhonghua@h3c.com>
> 
> When doing append direct io cleanup, if deleting inode fails, it goes
> out without unlocking inode, which will cause the inode deadlock.
> This issue was introduced by commit cf1776a9e834("ocfs2: fix a tiny
> race when truncate dio orohaned entry").
> 
> Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: <stable@vger.kernel.org>	[4.2+]
> ---
>  fs/ocfs2/aops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 7f60472..e6795c7 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -956,6 +956,7 @@ clean_orphan:
>  		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
>  				update_isize, end);
>  		if (tmp_ret < 0) {
> +			ocfs2_inode_unlock(inode, 1);
>  			ret = tmp_ret;
>  			mlog_errno(ret);
>  			brelse(di_bh);
> -- 
> 1.8.4.3
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
