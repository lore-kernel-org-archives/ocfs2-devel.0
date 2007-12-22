From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat Dec 22 03:51:34 2007
Subject: [Ocfs2-devel] [PATCH 23/30] ocfs2: Handle missing export
	generic_segment_checks()
In-Reply-To: <1198193387-16606-22-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-22-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071222112957.GB11437@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:40PM -0800, Sunil Mushran wrote:
> Commit 0ceb331433e8aad9c5f441a965d7c681f8b9046f in mainline wraps
> common segment checks in generic_segment_checks(). This patch allows
> one to build ocfs2 with kernels having/not having this change.

Let's move this to kapi-compat/include/generic-segment-checks.h and do

ifdef NO_GENERIC_SEGMENT_CHECKS
CPPFLAGS_file.o += -DNO_GENERIC_SEGMENT_CHECKS
endif

like the previous patch.

Joel
 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Config.make.in    |    1 +
>  configure.in      |    5 +++++
>  fs/ocfs2/Makefile |    4 ++++
>  fs/ocfs2/file.c   |   40 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 50 insertions(+), 0 deletions(-)
> 
> diff --git a/Config.make.in b/Config.make.in
> index 788c156..c1ca1d9 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -67,6 +67,7 @@ SU_MUTEX_DEFINED = @SU_MUTEX_DEFINED@
>  STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
>  FALLOCATE_DEFINED = @FALLOCATE_DEFINED@
>  SPLICE_HEADER = @SPLICE_HEADER@
> +GENERIC_SEGMENT_CHECKS = @GENERIC_SEGMENT_CHECKS@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/configure.in b/configure.in
> index 472e01a..a311d3f 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -262,6 +262,11 @@ OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
>    SHOULD_REMOVE_SUID=yes, , [should_remove_suid()])
>  AC_SUBST(SHOULD_REMOVE_SUID)
>  
> +GENERIC_SEGMENT_CHECKS=
> +OCFS2_CHECK_KERNEL([generic_segment_checks() in fs.h], fs.h,
> +  GENERIC_SEGMENT_CHECKS=yes, , [generic_segment_checks()])
> +AC_SUBST(GENERIC_SEGMENT_CHECKS)
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index a80a9fc..7434d6d 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -57,6 +57,10 @@ ifdef SHOULD_REMOVE_SUID
>  EXTRA_CFLAGS += -DSHOULD_REMOVE_SUID
>  endif
>  
> +ifdef GENERIC_SEGMENT_CHECKS
> +EXTRA_CFLAGS += -DGENERIC_SEGMENT_CHECKS
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index cee10ae..dd074af 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1809,6 +1809,46 @@ static long ocfs2_fallocate(struct inode *inode, int mode, loff_t offset,
>  }
>  #endif
>  
> +#ifndef GENERIC_SEGMENT_CHECKS
> +/*
> + * Performs necessary checks before doing a write
> + * @iov:	io vector request
> + * @nr_segs:	number of segments in the iovec
> + * @count:	number of bytes to write
> + * @access_flags: type of access: %VERIFY_READ or %VERIFY_WRITE
> + *
> + * Adjust number of segments and amount of bytes to write (nr_segs should be
> + * properly initialized first). Returns appropriate error code that caller
> + * should return or zero in case that write should be allowed.
> + */
> +int generic_segment_checks(const struct iovec *iov,
> +			unsigned long *nr_segs, size_t *count, int access_flags)
> +{
> +	unsigned long   seg;
> +	size_t cnt = 0;
> +	for (seg = 0; seg < *nr_segs; seg++) {
> +		const struct iovec *iv = &iov[seg];
> +
> +		/*
> +		 * If any segment has a negative length, or the cumulative
> +		 * length ever wraps negative then return -EINVAL.
> +		 */
> +		cnt += iv->iov_len;
> +		if (unlikely((ssize_t)(cnt|iv->iov_len) < 0))
> +			return -EINVAL;
> +		if (access_ok(access_flags, iv->iov_base, iv->iov_len))
> +			continue;
> +		if (seg == 0)
> +			return -EFAULT;
> +		*nr_segs = seg;
> +		cnt -= iv->iov_len;	/* This segment is no good */
> +		break;
> +	}
> +	*count = cnt;
> +	return 0;
> +}
> +#endif
> +
>  static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  					 loff_t *ppos,
>  					 size_t count,
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
