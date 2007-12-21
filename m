From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 00:56:13 2007
Subject: [Ocfs2-devel] [PATCH 04/30] ocfs2: Handle macro uninitialized_var
In-Reply-To: <1198193387-16606-3-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221085422.GD18627@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:21PM -0800, Sunil Mushran wrote:
> Commit 9490991482a2091a828d997adbc088e24c310a4d in mainline introduced
> macro uninitialized_var(). This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                       |    3 ++-
>  configure.in                   |    5 +++++
>  kapi-compat/include/compiler.h |   10 ++++++++++
>  3 files changed, 17 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/compiler.h
> 
> diff --git a/Makefile b/Makefile
> index 4752593..21ff590 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -9,7 +9,8 @@ SUBDIRS = fs vendor
>  LINUX_INCLUDE_FILES =
>  
>  KAPI_COMPAT_FILES = \
> -	kapi-compat/include/workqueue.h
> +	kapi-compat/include/workqueue.h \
> +	kapi-compat/include/compiler.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 72567b5..7faf363 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -162,6 +162,11 @@ OCFS2_CHECK_KERNEL([struct delayed_work in workqueue.h], workqueue.h,
>  AC_SUBST(DELAYED_WORK_DEFINED)
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS workqueue.h"
>  
> +compiler_compat_header=""
> +OCFS2_CHECK_KERNEL([uninitialized_var() in compiler-gcc4.h], compiler-gcc4.h,
> +  , compiler_compat_header="compiler.h", [uninitialized_var])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $compiler_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/compiler.h b/kapi-compat/include/compiler.h
> new file mode 100644
> index 0000000..c104ed1
> --- /dev/null
> +++ b/kapi-compat/include/compiler.h
> @@ -0,0 +1,10 @@
> +#ifndef KAPI_COMPILER_H
> +#define KAPI_COMPILER_H
> +
> +/*
> + * A trick to suppress uninitialized variable warning without generating any
> + * code
> + */
> +#define uninitialized_var(x) x = x
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

"The opposite of a correct statement is a false statement. The
 opposite of a profound truth may well be another profound truth."
         - Niels Bohr 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
