From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:57:59 2007
Subject: [Ocfs2-devel] [PATCH 14/30] ocfs2: Handles
	configfs_depend_item() and configfs_undepend_item()
In-Reply-To: <1198193387-16606-13-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-13-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221195724.GI13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:31PM -0800, Sunil Mushran wrote:
> Commit 631d1febab8e546e3bb800bdfe2c212b8adf87de in mainline introduces
> two new calls in configfs, configfs_depend_item() and configfs_undepend_item().
> This patch allows one to build ocfs2 with kernels having/not having
> this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Makefile                       |    3 ++-
>  configure.in                   |    5 +++++
>  kapi-compat/include/configfs.h |    7 +++++++
>  3 files changed, 14 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/configfs.h
> 
> diff --git a/Makefile b/Makefile
> index 6377ff9..71cd3c7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -18,7 +18,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/drop_nlink.h \
>  	kapi-compat/include/slab.h \
>  	kapi-compat/include/fstype.h \
> -	kapi-compat/include/sysctl.h
> +	kapi-compat/include/sysctl.h \
> +	kapi-compat/include/configfs.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index fdb188c..513585f 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -214,6 +214,11 @@ OCFS2_CHECK_KERNEL([enum FS_OCFS2 in sysctl.h], sysctl.h,
>    , sysctl_compat_header="sysctl.h", [FS_OCFS2])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $sysctl_compat_header"
>  
> +configfs_compat_header=""
> +OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
> +  , configfs_compat_header="configfs.h", [configfs_depend_item()])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/configfs.h b/kapi-compat/include/configfs.h
> new file mode 100644
> index 0000000..ff68e58
> --- /dev/null
> +++ b/kapi-compat/include/configfs.h
> @@ -0,0 +1,7 @@
> +#ifndef KAPI_CONFIGFS_H
> +#define KAPI_CONFIGFS_H
> +
> +#define configfs_depend_item(a, b)	0

	It's trivial, I know, but can we wrap that '0' in ()?

Joel

> +#define configfs_undepend_item(a, b)
> +
> +#endif
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
