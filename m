From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 21 Aug 2011 21:43:14 -0700
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: ocfs2_dir_foreach returns the
 error turned by filldir
In-Reply-To: <201107291006.p6TA6J1Z010639@acsmt358.oracle.com>
References: <201107291006.p6TA6J1Z010639@acsmt358.oracle.com>
Message-ID: <20110822044313.GG31134@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 29, 2011 at 06:06:06PM +0800, Wengang Wang wrote:
> try to return the error turned by filldir in ocfs2_dir_foreach.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

	NAK.  No one returns it.  The wrapper vfs_readdir pulls
buf->error out just like you were trying to in this patch.

Joel

> ---
>  fs/ocfs2/dir.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 3302088..4b365a1 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -2004,8 +2004,10 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
>  
>  	if (ret > 0)
>  		ret = -EIO;
> +	if (!ret)
> +		ret = filldir_err;
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.7.5.2
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

			http://www.jlbec.org/
			jlbec at evilplan.org
