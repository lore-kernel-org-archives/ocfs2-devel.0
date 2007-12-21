From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:39:20 2007
Subject: [Ocfs2-devel] [PATCH 10/30] ocfs2: Add helper drop_nlink
In-Reply-To: <1198193387-16606-9-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-9-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221193818.GD13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:27PM -0800, Sunil Mushran wrote:
> Commit 9a53c3a783c2fa9b969628e65695c11c3e51e673 in mainline added
> helper drop_nlink(). This patch allows one to build ocfs2 with kernels
> having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                         |    3 ++-
>  configure.in                     |    5 +++++
>  kapi-compat/include/drop_nlink.h |   22 ++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/drop_nlink.h
> 
> diff --git a/Makefile b/Makefile
> index 1595b90..2a97e00 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -14,7 +14,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/highmem.h \
>  	kapi-compat/include/fpath.h \
>  	kapi-compat/include/kmod.h \
> -	kapi-compat/include/inc_nlink.h
> +	kapi-compat/include/inc_nlink.h \
> +	kapi-compat/include/drop_nlink.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 554a0a4..81041fb 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -193,6 +193,11 @@ OCFS2_CHECK_KERNEL([inc_nlink() in fs.h], fs.h,
>    , inc_nlink_compat_header="inc_nlink.h", [^static inline void inc_nlink(])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $inc_nlink_compat_header"
>  
> +drop_nlink_compat_header=""
> +OCFS2_CHECK_KERNEL([drop_nlink() in fs.h], fs.h,
> +  , drop_nlink_compat_header="drop_nlink.h", [^static inline void drop_nlink(])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $drop_nlink_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/drop_nlink.h b/kapi-compat/include/drop_nlink.h
> new file mode 100644
> index 0000000..d54973b
> --- /dev/null
> +++ b/kapi-compat/include/drop_nlink.h
> @@ -0,0 +1,22 @@
> +#ifndef KAPI_DROP_NLINK_H
> +#define KAPI_DROP_NLINK_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * drop_nlink - directly drop an inode's link count
> + * @inode: inode
> + *
> + * This is a low-level filesystem helper to replace any
> + * direct filesystem manipulation of i_nlink.  In cases
> + * where we are attempting to track writes to the
> + * filesystem, a decrement to zero means an imminent
> + * write when the file is truncated and actually unlinked
> + * on the filesystem.
> + */
> +static inline void drop_nlink(struct inode *inode)
> +{
> +	inode->i_nlink--;
> +}
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

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
