From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 01 Sep 2009 10:47:49 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: invalidate dentry if its
 dentry_lock isn't initialized.
In-Reply-To: <1251355616-6779-1-git-send-email-tao.ma@oracle.com>
References: <1251355616-6779-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4A9D5E45.9050404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Tao Ma wrote:
> In commit a5a0a630922a2f6a774b6dac19f70cb5abd86bb0, when
> ocfs2_attch_dentry_lock fails, we call an extra iput and reset
> dentry->d_fsdata to NULL. This resolve a bug, but it isn't
> completed and the dentry is still there. When we want to use
> it again, ocfs2_dentry_revalidate doesn't catch it and return
> true. That make future ocfs2_dentry_lock panic out.
> One bug is http://oss.oracle.com/bugzilla/show_bug.cgi?id=1162.
>
> The resolution is to add a check for dentry->d_fsdata in
> revalidate process and return false if dentry->d_fsdata is NULL,
> so that a new ocfs2_lookup will be called again.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/dcache.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index 2f28b7d..b4957c7 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -85,6 +85,17 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * If the last lookup failed to create dentry lock, let us
> +	 * redo it.
> +	 */
> +	if (!dentry->d_fsdata) {
> +		mlog(0, "Inode %llu doesn't have dentry lock, "
> +		     "returning false\n",
> +		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		goto bail;
> +	}
> +
>  	ret = 1;
>  
>  bail:
>   
