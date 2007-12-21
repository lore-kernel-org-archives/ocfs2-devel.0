From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:39:23 2007
Subject: [Ocfs2-devel] [PATCH 09/30] ocfs2: Add helper inc_nlink
In-Reply-To: <1198193387-16606-8-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-8-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221193740.GC13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:26PM -0800, Sunil Mushran wrote:
> Commit d8c76e6f45c111c32a4b3e50a2adc9210737b0d8 in mainline introduced
> helper inc_nlink(). This patch allows one to build ocfs2 with kernels
> having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                        |    3 ++-
>  configure.in                    |    5 +++++
>  kapi-compat/include/inc_nlink.h |   19 +++++++++++++++++++
>  3 files changed, 26 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/inc_nlink.h
> 
> diff --git a/Makefile b/Makefile
> index 088d0e1..1595b90 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,7 +13,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/compiler.h \
>  	kapi-compat/include/highmem.h \
>  	kapi-compat/include/fpath.h \
> -	kapi-compat/include/kmod.h
> +	kapi-compat/include/kmod.h \
> +	kapi-compat/include/inc_nlink.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 94937cd..554a0a4 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -188,6 +188,11 @@ OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
>    , kmod_compat_header="kmod.h", [umh_wait])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
>  
> +inc_nlink_compat_header=""
> +OCFS2_CHECK_KERNEL([inc_nlink() in fs.h], fs.h,
> +  , inc_nlink_compat_header="inc_nlink.h", [^static inline void inc_nlink(])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $inc_nlink_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/inc_nlink.h b/kapi-compat/include/inc_nlink.h
> new file mode 100644
> index 0000000..26ddaac
> --- /dev/null
> +++ b/kapi-compat/include/inc_nlink.h
> @@ -0,0 +1,19 @@
> +#ifndef KAPI_INC_NLINK_H
> +#define KAPI_INC_NLINK_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * inc_nlink - directly increment an inode's link count
> + * @inode: inode
> + *
> + * This is a low-level filesystem helper to replace any
> + * direct filesystem manipulation of i_nlink.  Currently,
> + * it is only here for parity with dec_nlink().
> + */
> +static inline void inc_nlink(struct inode *inode)
> +{
> +	inode->i_nlink++;
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

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
