From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 24 Jun 2015 08:36:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2:Make the function ocfs2_initxattrs
 static
In-Reply-To: <1435103331-16407-1-git-send-email-xerofoify@gmail.com>
References: <1435103331-16407-1-git-send-email-xerofoify@gmail.com>
Message-ID: <5589FBA8.7020204@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicholas Krause <xerofoify@gmail.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Nicholas,
It has already been staged as a part of the patch "ocfs2: mark local
functions as static" in the -mm tree.
Thanks all the same.

--
Joseph

On 2015/6/24 7:48, Nicholas Krause wrote:
> This makes the function ocfs2_initxattrs static now due
> to this function's only caller being in its own declaration
> and definition file of xattr.c.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d03bfbf..889f379 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7271,7 +7271,7 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
>  			       name, value, size, flags);
>  }
>  
> -int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		     void *fs_info)
>  {
>  	const struct xattr *xattr;
> 
