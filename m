From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Sep 2008 23:33:29 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add security xattr support in
	ocfs2
In-Reply-To: <1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
References: <48D3725A.1030701@oracle.com>
	<1221817353-11111-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080923063329.GU4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 19, 2008 at 05:42:33PM +0800, Tiger Yang wrote:
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 505fb40..d57cfae 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -81,9 +81,7 @@ struct xattr_handler *ocfs2_xattr_handlers[] = {
>  	&ocfs2_xattr_acl_default_handler,
>  #endif
>  	&ocfs2_xattr_trusted_handler,
> -#ifdef CONFIG_OCFS2_FS_SECURITY
>  	&ocfs2_xattr_security_handler,
> -#endif
>  	NULL
>  };
>  
> @@ -96,9 +94,7 @@ static struct xattr_handler *ocfs2_xattr_handler_map[] = {
>  					= &ocfs2_xattr_acl_default_handler,
>  #endif
>  	[OCFS2_XATTR_INDEX_TRUSTED]	= &ocfs2_xattr_trusted_handler,
> -#ifdef CONFIG_OCFS2_FS_SECURITY
>  	[OCFS2_XATTR_INDEX_SECURITY]	= &ocfs2_xattr_security_handler,
> -#endif
>  };

Oh, almost missed this actually. Isn't it customary to allow the user to
select whether to compile in support for security attributes, or acls? You
can pretty much copy the code from any other file system really.


Also, would you mind rebasing these against the latest xattrs branch in
ocfs2.git? The only change was that I removed the code in '#ifdef
CONFIG_OCFS2_FS_SECURITY' and '#ifdef CONFIG_OCFS2_FS_ACL' because we
weren't ever defining those yet. Obviously, you get to add them back now  :)
	--Mark

--
Mark Fasheh
