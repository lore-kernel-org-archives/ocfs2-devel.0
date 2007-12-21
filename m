From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 00:56:16 2007
Subject: [Ocfs2-devel] [PATCH 05/30] ocfs2: Handle macro zero_user_page()
In-Reply-To: <1198193387-16606-4-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221085436.GE18627@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:22PM -0800, Sunil Mushran wrote:
> Commit 01f2705daf5a36208e69d7cf95db9c330f843af6 in mainline introduced
> macro zero_user_page(). This patch allows one to build ocfs2 with
> kernels having/not having that change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Makefile                      |    3 ++-
>  configure.in                  |    5 +++++
>  kapi-compat/include/highmem.h |   22 ++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/highmem.h
> 
> diff --git a/Makefile b/Makefile
> index 21ff590..b7b86db 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,7 +10,8 @@ LINUX_INCLUDE_FILES =
>  
>  KAPI_COMPAT_FILES = \
>  	kapi-compat/include/workqueue.h \
> -	kapi-compat/include/compiler.h
> +	kapi-compat/include/compiler.h \
> +	kapi-compat/include/highmem.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 7faf363..47b0da0 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -167,6 +167,11 @@ OCFS2_CHECK_KERNEL([uninitialized_var() in compiler-gcc4.h], compiler-gcc4.h,
>    , compiler_compat_header="compiler.h", [uninitialized_var])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $compiler_compat_header"
>  
> +highmem_compat_header=""
> +OCFS2_CHECK_KERNEL([zero_user_page() in highmem.h], highmem.h,
> +  , highmem_compat_header="highmem.h", [zero_user_page])
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $highmem_compat_header"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/kapi-compat/include/highmem.h b/kapi-compat/include/highmem.h
> new file mode 100644
> index 0000000..a8c7e11
> --- /dev/null
> +++ b/kapi-compat/include/highmem.h
> @@ -0,0 +1,22 @@
> +#ifndef KAPI_HIGHMEM_H
> +#define KAPI_HIGHMEM_H
> +
> +/*
> + * Same but also flushes aliased cache contents to RAM.
> + *
> + * This must be a macro because KM_USER0 and friends aren't defined if
> + * !CONFIG_HIGHMEM
> + */
> +#define zero_user_page(page, offset, size, km_type)		\
> +	do {							\
> +		void *kaddr;					\
> +								\
> +		BUG_ON((offset) + (size) > PAGE_SIZE);		\
> +								\
> +		kaddr = kmap_atomic(page, km_type);		\
> +		memset((char *)kaddr + (offset), 0, (size));	\
> +		flush_dcache_page(page);			\
> +		kunmap_atomic(kaddr, (km_type));		\
> +	} while (0)
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

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
