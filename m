From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 23 Sep 2008 00:11:18 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add posix ACL support in ocfs2
	v1
In-Reply-To: <1221817381-11133-1-git-send-email-tiger.yang@oracle.com>
References: <48D3725A.1030701@oracle.com>
	<1221817381-11133-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080923071118.GV4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 19, 2008 at 05:43:01PM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index edcdd39..96a53eb 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -56,6 +56,7 @@
>  #include "suballoc.h"
>  #include "super.h"
>  #include "xattr.h"
> +#include "acl.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -1031,7 +1032,7 @@ int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
>  		goto out;
>  	}
>  
> -	ret = generic_permission(inode, mask, NULL);
> +	ret = generic_permission(inode, mask, ocfs2_check_acl);
>  
>  	ocfs2_inode_unlock(inode, 0);
>  out:

I think we also need some acl-specific handling of chmod in ocfs2_setattr.
See ext3_acl_chmod, where it's called and what it does.


> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 76d1d13..9f8f313 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -61,6 +61,7 @@
>  #include "sysfile.h"
>  #include "uptodate.h"
>  #include "xattr.h"
> +#include "acl.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -328,6 +329,8 @@ leave:
>  	if (status == -ENOSPC)
>  		mlog(0, "Disk is full\n");
>  
> +	status = ocfs2_init_acl(inode, dir);

Err, this is a pretty bad place for a call which must do work only if we're
succesfull in creating the inode. A better place would be a few lines up,
maybe even just before the call to 'ocfs2_add_entry()', so that an acl
failure won't result in a non-acl-copied inode which is accessible from a
directory.
	

> +
>  	if (new_fe_bh)
>  		brelse(new_fe_bh);
>  
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d57cfae..1daff4f 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -76,10 +76,8 @@ static struct ocfs2_xattr_def_value_root def_xv = {
>  
>  struct xattr_handler *ocfs2_xattr_handlers[] = {
>  	&ocfs2_xattr_user_handler,
> -#ifdef CONFIG_OCFS2_FS_POSIX_ACL
>  	&ocfs2_xattr_acl_access_handler,
>  	&ocfs2_xattr_acl_default_handler,
> -#endif
>  	&ocfs2_xattr_trusted_handler,
>  	&ocfs2_xattr_security_handler,
>  	NULL
> @@ -87,12 +85,10 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
>  
>  static struct xattr_handler *ocfs2_xattr_handler_map[] = {
>  	[OCFS2_XATTR_INDEX_USER]	= &ocfs2_xattr_user_handler,
> -#ifdef CONFIG_OCFS2_FS_POSIX_ACL
>  	[OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS]
>  					= &ocfs2_xattr_acl_access_handler,
>  	[OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT]
>  					= &ocfs2_xattr_acl_default_handler,
> -#endif
>  	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
>  	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
>  };

Same as before about the #ifdef's, and adding a proper Kconfig item for
this.
	--Mark

--
Mark Fasheh
