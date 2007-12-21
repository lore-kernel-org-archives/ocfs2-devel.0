From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 15:12:37 2007
Subject: [Ocfs2-devel] [PATCH 20/30] ocfs2: Handle splice.h
In-Reply-To: <1198193387-16606-19-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-19-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221231155.GD15533@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:37PM -0800, Sunil Mushran wrote:
> Commit d6b29d7cee064f28ca097e906de7453541351095 in mainline moves the splice
> structures from pipe_fs_i.h to splice.h. This patch allows one to build
> ocfs2 with kernels having/not having this change.

Test is reversed.

Joel

> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Config.make.in    |    1 +
>  configure.in      |    5 +++++
>  fs/ocfs2/Makefile |    4 ++++
>  fs/ocfs2/file.c   |    2 ++
>  4 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Config.make.in b/Config.make.in
> index 3818cd5..788c156 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -66,6 +66,7 @@ REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
>  SU_MUTEX_DEFINED = @SU_MUTEX_DEFINED@
>  STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
>  FALLOCATE_DEFINED = @FALLOCATE_DEFINED@
> +SPLICE_HEADER = @SPLICE_HEADER@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/configure.in b/configure.in
> index 74337ee..931cf2c 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -247,6 +247,11 @@ OCFS2_CHECK_KERNEL([fallocate() in fs.h], fs.h,
>    FALLOCATE_DEFINED=yes, , [^.*long (\*fallocate)])
>  AC_SUBST(FALLOCATE_DEFINED)
>  
> +SPLICE_HEADER=
> +OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
> +  SPLICE_HEADER=yes, , [^struct splice_desc ])
> +AC_SUBST(SPLICE_HEADER)
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 6f21960..3cc7c74 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -49,6 +49,10 @@ ifdef FALLOCATE_DEFINED
>  EXTRA_CFLAGS += -DFALLOCATE_DEFINED
>  endif
>  
> +ifdef SPLICE_HEADER
> +EXTRA_CFLAGS += -DSPLICE_HEADER
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index ce18447..1c179fc 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -31,7 +31,9 @@
>  #include <linux/pagemap.h>
>  #include <linux/uio.h>
>  #include <linux/sched.h>
> +#ifdef SPLICE_HEADER
>  #include <linux/splice.h>
> +#endif
>  #include <linux/mount.h>
>  #include <linux/writeback.h>
>  #ifdef FALLOCATE_DEFINED
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
