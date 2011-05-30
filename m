From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Mon, 30 May 2011 05:54:43 -0400
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: free memory allocated by
 security_inode_init_security
In-Reply-To: <1306737569-3919-1-git-send-email-tiger.yang@oracle.com>
References: <1306737569-3919-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <1306749283.3128.6.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 2011-05-30 at 14:39 +0800, Tiger Yang wrote:
> The LSM security_inode_init_security() hook allocates memory
> for xattr name and value, expecting the caller to release
> the memory afterwards.
> 
> reported-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

Hi Tiger,

Thanks for taking a look.  For the normal case, the memory is now freed,
but not on failure.

thanks,

Mimi

> ---
>  fs/ocfs2/xattr.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 81ecf9c..e9b031e 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7215,6 +7215,8 @@ int ocfs2_init_security_and_acl(struct inode *dir,
> 
>  	ocfs2_inode_unlock(dir, 0);
>  	brelse(dir_bh);
> +	kfree(si.name);
> +	kfree(si.value);
>  leave:
>  	return ret;
>  }
