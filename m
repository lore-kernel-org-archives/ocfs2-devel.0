From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Dec 24 13:32:05 2007
Subject: [Ocfs2-devel] [PATCH 30/30] ocfs2: Handle missing exportfs.h
In-Reply-To: <1198193387-16606-29-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-29-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071224213019.GH7242@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:47PM -0800, Sunil Mushran wrote:
> Commit a569425512253992cc64ebf8b6d00a62f986db3e in mainline
> moved struct export_operation from fs.h to exportfs.h. This
> patch allows one to build ocfs2 with kernels having/not having
> this change.

	Please reverse the test.

Joel

> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Config.make.in    |    1 +
>  configure.in      |    5 +++++
>  fs/ocfs2/Makefile |    4 ++++
>  fs/ocfs2/export.h |    2 ++
>  4 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Config.make.in b/Config.make.in
> index f22473c..90e4472 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -74,6 +74,7 @@ IOP_IS_CONST = @IOP_IS_CONST@
>  VECTORED_FILE_AIO = @VECTORED_FILE_AIO@
>  SPLICE_FROM_PIPE = @SPLICE_FROM_PIPE@
>  OLD_BIO_END_IO = @OLD_BIO_END_IO@
> +EXPORTFS_HEADER = @EXPORTFS_HEADER@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/configure.in b/configure.in
> index 60fd68f..d4f3c97 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -297,6 +297,11 @@ OCFS2_CHECK_KERNEL([old bio_end_io_t in bio.h], bio.h,
>    OLD_BIO_END_IO=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
>  AC_SUBST(OLD_BIO_END_IO)
>  
> +EXPORTFS_HEADER=
> +OCFS2_CHECK_KERNEL([exportfs.h], exportfs.h,
> +  EXPORTFS_HEADER=yes, , [^struct export_operations {])
> +AC_SUBST(EXPORTFS_HEADER)
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index e4296d3..8f8458e 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -81,6 +81,10 @@ ifdef SPLICE_FROM_PIPE
>  EXTRA_CFLAGS += -DSPLICE_FROM_PIPE
>  endif
>  
> +ifdef EXPORTFS_HEADER
> +EXTRA_CFLAGS += -DEXPORTFS_HEADER
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> diff --git a/fs/ocfs2/export.h b/fs/ocfs2/export.h
> index e08bed9..f81edb5 100644
> --- a/fs/ocfs2/export.h
> +++ b/fs/ocfs2/export.h
> @@ -26,7 +26,9 @@
>  #ifndef OCFS2_EXPORT_H
>  #define OCFS2_EXPORT_H
>  
> +#ifdef EXPORTFS_HEADER
>  #include <linux/exportfs.h>
> +#endif
>  
>  extern struct export_operations ocfs2_export_ops;
>  
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
