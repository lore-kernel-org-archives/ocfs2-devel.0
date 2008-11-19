From: Tiger Yang <tiger.yang@oracle.com>
Date: Wed, 19 Nov 2008 22:25:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Restore not_found in xis.
In-Reply-To: <1227084522-5012-2-git-send-email-tao.ma@oracle.com>
References: <4923D3E5.1090209@oracle.com>	<1227084522-5012-1-git-send-email-tao.ma@oracle.com>
	<1227084522-5012-2-git-send-email-tao.ma@oracle.com>
Message-ID: <492421BC.7020304@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

how quickly you solve this problem! I also found this problem with my 
test script but forgot to tell you when you address the first problem.

thanks,
tiger

Tao Ma wrote:
> In xattr set, when we move a xattr which was stored in inode to
> the outside bucket, we have to delete it and it will use the old
> "xis->not_found", but it is removed by the ocfs2_calc_xattr_set_need.
> So restore it.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 1504c6b..7d6307f 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -2414,7 +2414,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  				    struct ocfs2_xattr_search *xbs,
>  				    struct ocfs2_xattr_set_ctxt *ctxt)
>  {
> -	int ret = 0, credits;
> +	int ret = 0, credits, old_found;
>  
>  	if (!xi->value) {
>  		/* Remove existing extended attribute */
> @@ -2433,6 +2433,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  			xi->value = NULL;
>  			xi->value_len = 0;
>  
> +			old_found = xis->not_found;
>  			xis->not_found = -ENODATA;
>  			ret = ocfs2_calc_xattr_set_need(inode,
>  							di,
> @@ -2442,6 +2443,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  							NULL,
>  							NULL,
>  							&credits);
> +			xis->not_found = old_found;
>  			if (ret) {
>  				mlog_errno(ret);
>  				goto out;
> @@ -2462,6 +2464,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  				if (ret)
>  					goto out;
>  
> +				old_found = xis->not_found;
>  				xis->not_found = -ENODATA;
>  				ret = ocfs2_calc_xattr_set_need(inode,
>  								di,
> @@ -2471,6 +2474,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>  								NULL,
>  								NULL,
>  								&credits);
> +				xis->not_found = old_found;
>  				if (ret) {
>  					mlog_errno(ret);
>  					goto out;
