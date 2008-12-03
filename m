From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Dec 2008 13:19:34 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Always updating ctime
	in	xattr set.
In-Reply-To: <1228286432-13654-1-git-send-email-tao.ma@oracle.com>
References: <1228286432-13654-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20081203211934.GB14496@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 03, 2008 at 02:40:32PM +0800, Tao Ma wrote:
> In xattr set, we should always update ctime if the operation goes
> sucessfully. The old one mistakenly put it in ocfs2_xattr_set_entry
> which is only called when we set xattr in inode or xattr block. The
> side benefit is that it resolve the bug 1052 since in that scenario,
> ocfs2_calc_xattr_set_need only calc out the xattr set credits while
> ocfs2_xattr_set_entry update the inode also which isn't concerned with
> the process of xattr set.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 7e0d62a..fa24067 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1621,10 +1621,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  	oi->ip_dyn_features |= flag;
>  	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
>  	spin_unlock(&oi->ip_lock);
> -	/* Update inode ctime */
> -	inode->i_ctime = CURRENT_TIME;
> -	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
> -	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
>  
>  	ret = ocfs2_journal_dirty(handle, xs->inode_bh);
>  	if (ret < 0)
> @@ -2528,6 +2524,20 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  		}
>  	}
>  
> +	if (!ret) {
> +		/* Update inode ctime. */
> +		ret = ocfs2_journal_access(ctxt->handle, inode, xis->inode_bh,
> +					   OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		inode->i_ctime = CURRENT_TIME;
> +		di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
> +		di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
> +		ocfs2_journal_dirty(ctxt->handle, xis->inode_bh);
> +	}
>  out:
>  	return ret;
>  }

	As I stated on the bug, I think you should be doing the
journal_access up at the top of __ocfs2_xattr_set_handle() before you
modify the xattr buffers.  But otherwise, this looks good.

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
