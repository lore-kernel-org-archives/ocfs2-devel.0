From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:37:25 2007
Subject: [Ocfs2-devel] [PATCH 08/30] ocfs2: Define enum umh_wait
In-Reply-To: <1198193387-16606-7-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-7-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221193711.GB13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:25PM -0800, Sunil Mushran wrote:
> Commit 86313c488a6848b7ec2ba04e74f25f79dd32a0b7 in mainline introduced
> enum umh_wait. This patch allows one to build ocfs2 with kernels having/
> not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                   |    3 ++-
>  configure.in               |    5 +++++
>  kapi-compat/include/kmod.h |   10 ++++++++++
>  3 files changed, 17 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/kmod.h
> 
> diff --git a/Makefile b/Makefile
> index b00a6c4..088d0e1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -12,7 +12,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/workqueue.h \
>  	kapi-compat/include/compiler.h \
>  	kapi-compat/include/highmem.h \
> -	kapi-compat/include/fpath.h
> +	kapi-compat/include/fpath.h \
> +	kapi-compat/include/kmod.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 907c90f..94937cd 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -183,6 +183,11 @@ OCFS2_CHECK_KERNEL([f_path in fs.h], fs.h,
>  AC_SUBST(HAS_F_PATH_DEFINED)
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS fpath.h"
>  
> +kmod_compat_header=""
> +OCFS2_CHECK_KERNEL([enum umh_wait in kmod.h], kmod.h,
> +  , kmod_compat_header="kmod.h", [umh_wait])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $kmod_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/kmod.h b/kapi-compat/include/kmod.h
> new file mode 100644
> index 0000000..42a082b
> --- /dev/null
> +++ b/kapi-compat/include/kmod.h
> @@ -0,0 +1,10 @@
> +#ifndef KAPI_KMOD_H
> +#define KAPI_KMOD_H
> +
> +enum umh_wait {
> +	UMH_NO_WAIT = -1,	/* don't wait at all */
> +	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
> +	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
> +};
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

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
