From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:55:54 2007
Subject: [Ocfs2-devel] [PATCH 12/30] ocfs2: Define FS_RENAME_DOES_D_MOVE
In-Reply-To: <1198193387-16606-11-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-11-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221195521.GG13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:29PM -0800, Sunil Mushran wrote:
> Commit 349457ccf2592c14bdf13b6706170ae2e94931b1 in mainline defines macro
> FS_RENAME_DOES_D_MOVE to allow fs to call d_move() during rename().
> This patch allows one to build ocfs2 with kernels having/not having
> this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                     |    3 ++-
>  configure.in                 |    5 +++++
>  kapi-compat/include/fstype.h |    6 ++++++
>  3 files changed, 13 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/fstype.h
> 
> diff --git a/Makefile b/Makefile
> index ae5947b..5c22979 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -16,7 +16,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/kmod.h \
>  	kapi-compat/include/inc_nlink.h \
>  	kapi-compat/include/drop_nlink.h \
> -	kapi-compat/include/slab.h
> +	kapi-compat/include/slab.h \
> +	kapi-compat/include/fstype.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index cb91de1..f1ca3e3 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -204,6 +204,11 @@ OCFS2_CHECK_KERNEL([kmem_cache_create() with dtor arg in slab.h], slab.h,
>  AC_SUBST(KMEM_CACHE_CREATE_DTOR)
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS slab.h"
>  
> +fstype_compat_header=""
> +OCFS2_CHECK_KERNEL([flag FS_RENAME_DOES_D_MOVE in fs.h], fs.h,
> +  , fstype_compat_header="fstype.h", [FS_RENAME_DOES_D_MOVE])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $fstype_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/fstype.h b/kapi-compat/include/fstype.h
> new file mode 100644
> index 0000000..895ea86
> --- /dev/null
> +++ b/kapi-compat/include/fstype.h
> @@ -0,0 +1,6 @@
> +#ifndef KAPI_FSTYPE_H
> +#define KAPI_FSTYPE_H
> +
> +#define FS_RENAME_DOES_D_MOVE	FS_ODD_RENAME
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
