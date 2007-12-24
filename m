From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Dec 24 13:23:57 2007
Subject: [Ocfs2-devel] [PATCH 25/30] ocfs2: Handle missing const s_op
	in struct super_block
In-Reply-To: <1198193387-16606-24-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-24-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071224212244.GC7242@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:42PM -0800, Sunil Mushran wrote:
> Commit ee9b6d61a2a43c5952eb43283f8db284a4e70b8a in mainline marks
> struct super_operations as a const in struct super_block. This patch
> allows one to build with kernels having/not having this change.

	Can we reverse this test as well?

Joel

> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Config.make.in        |    1 +
>  configure.in          |    5 +++++
>  fs/ocfs2/Makefile     |    4 ++++
>  fs/ocfs2/dlm/Makefile |    4 ++++
>  fs/ocfs2/dlm/dlmfs.c  |    8 ++++++++
>  fs/ocfs2/super.c      |    4 ++++
>  6 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/Config.make.in b/Config.make.in
> index 96dbb7a..938ac53 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -69,6 +69,7 @@ FALLOCATE_DEFINED = @FALLOCATE_DEFINED@
>  SPLICE_HEADER = @SPLICE_HEADER@
>  GENERIC_SEGMENT_CHECKS = @GENERIC_SEGMENT_CHECKS@
>  FAULT_IN_VMOPS = @FAULT_IN_VMOPS@
> +SOP_IS_CONST = @SOP_IS_CONST@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/configure.in b/configure.in
> index b8b8001..3093542 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -272,6 +272,11 @@ OCFS2_CHECK_KERNEL([fault() in struct vm_operations_struct in mm.h], mm.h,
>    FAULT_IN_VMOPS=yes, , [^.*int (\*fault)])
>  AC_SUBST(FAULT_IN_VMOPS)
>  
> +SOP_IS_CONST=
> +OCFS2_CHECK_KERNEL([s_op declared as const in struct super_block in fs.h], fs.h,
> +  SOP_IS_CONST=yes, , [^.*const struct super_operations.*\*s_op;])
> +AC_SUBST(SOP_IS_CONST)
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 521888b..4ce2431 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -65,6 +65,10 @@ ifdef FAULT_IN_VMOPS
>  EXTRA_CFLAGS += -DFAULT_IN_VMOPS
>  endif
>  
> +ifdef SOPS_IS_CONST
> +EXTRA_CFLAGS += -DSOPS_IS_CONST
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
> index 5101f9c..2df255e 100644
> --- a/fs/ocfs2/dlm/Makefile
> +++ b/fs/ocfs2/dlm/Makefile
> @@ -28,6 +28,10 @@ ifdef STRUCT_SUBSYSTEM_DEFINED
>  EXTRA_CFLAGS += -DSTRUCT_SUBSYSTEM_DEFINED
>  endif
>  
> +ifdef SOP_IS_CONST
> +EXTRA_CFLAGS += -DSOP_IS_CONST
> +endif
> +
>  DLM_SOURCES =			\
>  	dlmast.c		\
>  	dlmconvert.c		\
> diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
> index dc43923..dc5b5a5 100644
> --- a/fs/ocfs2/dlm/dlmfs.c
> +++ b/fs/ocfs2/dlm/dlmfs.c
> @@ -60,7 +60,11 @@
>  #define MLOG_MASK_PREFIX ML_DLMFS
>  #include "cluster/masklog.h"
>  
> +#ifdef SOP_IS_CONST
>  static const struct super_operations dlmfs_ops;
> +#else
> +static struct super_operations dlmfs_ops;
> +#endif
>  static const struct file_operations dlmfs_file_operations;
>  static const struct inode_operations dlmfs_dir_inode_operations;
>  static const struct inode_operations dlmfs_root_inode_operations;
> @@ -556,7 +560,11 @@ static const struct inode_operations dlmfs_root_inode_operations = {
>  	.rmdir		= simple_rmdir,
>  };
>  
> +#ifdef SOP_IS_CONST
>  static const struct super_operations dlmfs_ops = {
> +#else
> +static struct super_operations dlmfs_ops = {
> +#endif
>  	.statfs		= simple_statfs,
>  	.alloc_inode	= dlmfs_alloc_inode,
>  	.destroy_inode	= dlmfs_destroy_inode,
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index f5c424d..176ae35 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -124,7 +124,11 @@ static void ocfs2_write_super(struct super_block *sb);
>  static struct inode *ocfs2_alloc_inode(struct super_block *sb);
>  static void ocfs2_destroy_inode(struct inode *inode);
>  
> +#ifdef SOP_IS_CONST
>  static const struct super_operations ocfs2_sops = {
> +#else
> +static struct super_operations ocfs2_sops = {
> +#endif
>  	.statfs		= ocfs2_statfs,
>  	.alloc_inode	= ocfs2_alloc_inode,
>  	.destroy_inode	= ocfs2_destroy_inode,
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"The question of whether computers can think is just like the question
 of whether submarines can swim."
	- Edsger W. Dijkstra

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
