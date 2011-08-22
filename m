From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 21 Aug 2011 21:26:37 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: free memory allocated by
	inode_init_security
In-Reply-To: <1306994676-14402-1-git-send-email-tiger.yang@oracle.com>
References: <1306994676-14402-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20110822042637.GD31134@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch is now in the fixes branch of ocfs2.git.

Joel

On Thu, Jun 02, 2011 at 02:04:36PM +0800, Tiger Yang wrote:
> The LSM security_inode_init_security() hook allocates memory
> for xattr name and value, expecting the caller to release
> the memory afterwards.
> 
> reported-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/xattr.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 81ecf9c..fcd77a0 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7185,12 +7185,11 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>  {
>  	int ret = 0;
>  	struct buffer_head *dir_bh = NULL;
> -	struct ocfs2_security_xattr_info si = {
> -		.enable = 1,
> -	};
> +	struct ocfs2_security_xattr_info si = {0, };
>  
>  	ret = ocfs2_init_security_get(inode, dir, qstr, &si);
>  	if (!ret) {
> +		si.enable = 1;
>  		ret = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
>  				      si.name, si.value, si.value_len,
>  				      XATTR_CREATE);
> @@ -7216,6 +7215,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>  	ocfs2_inode_unlock(dir, 0);
>  	brelse(dir_bh);
>  leave:
> +	if (si.enable) {
> +		kfree(si.name);
> +		kfree(si.value);
> +	}
>  	return ret;
>  }
>  /*
> -- 
> 1.7.4.4
> 

-- 

"Practice random acts of kindness and senseless acts of beauty."

 Oh, and don't forget where your towel is.

			http://www.jlbec.org/
			jlbec at evilplan.org
