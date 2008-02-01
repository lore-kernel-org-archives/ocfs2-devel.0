From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri Feb  1 15:38:21 2008
Subject: [Ocfs2-devel] Re: [patch 4/5] ocfs2: Add check for const
	address_space_operations
In-Reply-To: <20080131204715.818833000@suse.com>
References: <20080131204634.478915000@suse.com>
	<20080131204715.818833000@suse.com>
Message-ID: <47A3AD28.6070902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff Mahoney wrote:
>  SLES10 doesn't have a const a_ops in struct address_space. This patch adds
>  a check.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>   

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


> ---
>
>  Config.make.in    |    1 +
>  configure.in      |    5 +++++
>  fs/ocfs2/Makefile |    4 ++++
>  fs/ocfs2/aops.c   |    4 ++++
>  fs/ocfs2/inode.h  |    4 ++++
>  5 files changed, 18 insertions(+)
>
> diff --git a/Config.make.in b/Config.make.in
> index dc5431b..98bf410 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -73,6 +73,7 @@ NO_GENERIC_SEGMENT_CHECKS = @NO_GENERIC_SEGMENT_CHECKS@
>  SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
>  IOP_IS_NOT_CONST = @IOP_IS_NOT_CONST@
>  FOP_IS_NOT_CONST = @FOP_IS_NOT_CONST@
> +AOPS_IS_NOT_CONST = @AOPS_IS_NOT_CONST@
>  NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
>  NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
>  OLD_BIO_END_IO = @OLD_BIO_END_IO@
> diff --git a/configure.in b/configure.in
> index 3d9e49f..a4b3f0e 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -310,6 +310,11 @@ OCFS2_CHECK_KERNEL([f_op declared as const in struct file in fs.h], fs.h,
>    , FOP_IS_NOT_CONST=yes, [^.*const struct file_operations.*\*f_op;])
>  AC_SUBST(FOP_IS_NOT_CONST)
>  
> +AOPS_IS_NOT_CONST=
> +OCFS2_CHECK_KERNEL([a_ops declared as const in struct address_space in fs.h], fs.h,
> +  , AOPS_IS_NOT_CONST=yes, [^.*const struct address_space_operations.*\*a_ops;])
> +AC_SUBST(AOPS_IS_NOT_CONST)
> +
>  NO_VECTORIZED_AIO=
>  OCFS2_CHECK_KERNEL([aio_read() in struct file_operations using iovec in fs.h], fs.h,
>    , NO_VECTORIZED_AIO=yes, [ssize_t (\*aio_read) (struct kiocb \*, const struct iovec \*, unsigned long, loff_t);])
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 5750280..c8a81c4 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -88,6 +88,10 @@ ifdef FOP_IS_NOT_CONST
>  EXTRA_CFLAGS += -DFOP_IS_NOT_CONST
>  endif
>  
> +ifdef AOPS_IS_NOT_CONST
> +EXTRA_CFLAGS += -DAOPS_IS_NOT_CONST
> +endif
> +
>  ifdef NO_VECTORIZED_AIO
>  CFLAGS_file.o += -DNO_VECTORIZED_AIO
>  endif
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 54dd079..9b2a743 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1953,7 +1953,11 @@ int ocfs2_write_end(struct file *file, struct address_space *mapping,
>  	return ret;
>  }
>  
> +#ifdef AOPS_IS_NOT_CONST
> +struct address_space_operations ocfs2_aops = {
> +#else
>  const struct address_space_operations ocfs2_aops = {
> +#endif
>  	.readpage	= ocfs2_readpage,
>  	.readpages	= ocfs2_readpages,
>  	.writepage	= ocfs2_writepage,
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 390a855..01437ca 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -111,7 +111,11 @@ static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
>  
>  extern struct kmem_cache *ocfs2_inode_cache;
>  
> +#ifdef AOPS_IS_NOT_CONST
> +extern struct address_space_operations ocfs2_aops;
> +#else
>  extern const struct address_space_operations ocfs2_aops;
> +#endif
>  
>  struct buffer_head *ocfs2_bread(struct inode *inode, int block,
>  				int *err, int reada);
>
>
>   
