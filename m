From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 12 May 2010 14:01:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Wrap signal blocking in void
 functions.
In-Reply-To: <20100510190003.GD25670@mail.oracle.com>
References: <20100510185919.GC25670@mail.oracle.com>
	<20100510190003.GD25670@mail.oracle.com>
Message-ID: <4BEB171C.6070002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>


On 05/10/2010 12:00 PM, Joel Becker wrote:
> ocfs2 sometimes needs to block signals around dlm operations, but it
> currently does it with sigprocmask().  Even worse, it's checking the
> error code of sigprocmask().  The in-kernel sigprocmask() can only error
> if you get the SIG_* argument wrong.  We don't.
>
> Wrap the sigprocmask() calls with ocfs2_[un]block_signals().  These
> functions are void, but they will BUG() if somehow sigprocmask() returns
> an error.
>
> Signed-off-by: Joel Becker<joel.becker@oracle.com>
> ---
>   fs/ocfs2/inode.c |   14 +++-----------
>   fs/ocfs2/mmap.c  |   48 +++++++++---------------------------------------
>   fs/ocfs2/super.c |   20 ++++++++++++++++++++
>   fs/ocfs2/super.h |    7 +++++++
>   4 files changed, 39 insertions(+), 50 deletions(-)
>
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 9ee13f7..b7650cc 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -957,7 +957,7 @@ static void ocfs2_cleanup_delete_inode(struct inode *inode,
>   void ocfs2_delete_inode(struct inode *inode)
>   {
>   	int wipe, status;
> -	sigset_t blocked, oldset;
> +	sigset_t oldset;
>   	struct buffer_head *di_bh = NULL;
>
>   	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
> @@ -984,13 +984,7 @@ void ocfs2_delete_inode(struct inode *inode)
>   	 * messaging paths may return us -ERESTARTSYS. Which would
>   	 * cause us to exit early, resulting in inodes being orphaned
>   	 * forever. */
> -	sigfillset(&blocked);
> -	status = sigprocmask(SIG_BLOCK,&blocked,&oldset);
> -	if (status<  0) {
> -		mlog_errno(status);
> -		ocfs2_cleanup_delete_inode(inode, 1);
> -		goto bail;
> -	}
> +	ocfs2_block_signals(&oldset);
>
>   	/*
>   	 * Synchronize us against ocfs2_get_dentry. We take this in
> @@ -1064,9 +1058,7 @@ bail_unlock_nfs_sync:
>   	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0);
>
>   bail_unblock:
> -	status = sigprocmask(SIG_SETMASK,&oldset, NULL);
> -	if (status<  0)
> -		mlog_errno(status);
> +	ocfs2_unblock_signals(&oldset);
>   bail:
>   	clear_inode(inode);
>   	mlog_exit_void();
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 3973761..a61809f 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -42,44 +42,20 @@
>   #include "file.h"
>   #include "inode.h"
>   #include "mmap.h"
> +#include "super.h"
>
> -static inline int ocfs2_vm_op_block_sigs(sigset_t *blocked, sigset_t *oldset)
> -{
> -	/* The best way to deal with signals in the vm path is
> -	 * to block them upfront, rather than allowing the
> -	 * locking paths to return -ERESTARTSYS. */
> -	sigfillset(blocked);
> -
> -	/* We should technically never get a bad return value
> -	 * from sigprocmask */
> -	return sigprocmask(SIG_BLOCK, blocked, oldset);
> -}
> -
> -static inline int ocfs2_vm_op_unblock_sigs(sigset_t *oldset)
> -{
> -	return sigprocmask(SIG_SETMASK, oldset, NULL);
> -}
>
>   static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
>   {
> -	sigset_t blocked, oldset;
> -	int error, ret;
> +	sigset_t oldset;
> +	int ret;
>
>   	mlog_entry("(area=%p, page offset=%lu)\n", area, vmf->pgoff);
>
> -	error = ocfs2_vm_op_block_sigs(&blocked,&oldset);
> -	if (error<  0) {
> -		mlog_errno(error);
> -		ret = VM_FAULT_SIGBUS;
> -		goto out;
> -	}
> -
> +	ocfs2_block_signals(&oldset);
>   	ret = filemap_fault(area, vmf);
> +	ocfs2_unblock_signals(&oldset);
>
> -	error = ocfs2_vm_op_unblock_sigs(&oldset);
> -	if (error<  0)
> -		mlog_errno(error);
> -out:
>   	mlog_exit_ptr(vmf->page);
>   	return ret;
>   }
> @@ -159,14 +135,10 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>   	struct page *page = vmf->page;
>   	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
>   	struct buffer_head *di_bh = NULL;
> -	sigset_t blocked, oldset;
> -	int ret, ret2;
> +	sigset_t oldset;
> +	int ret;
>
> -	ret = ocfs2_vm_op_block_sigs(&blocked,&oldset);
> -	if (ret<  0) {
> -		mlog_errno(ret);
> -		return ret;
> -	}
> +	ocfs2_block_signals(&oldset);
>
>   	/*
>   	 * The cluster locks taken will block a truncate from another
> @@ -194,9 +166,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>   	ocfs2_inode_unlock(inode, 1);
>
>   out:
> -	ret2 = ocfs2_vm_op_unblock_sigs(&oldset);
> -	if (ret2<  0)
> -		mlog_errno(ret2);
> +	ocfs2_unblock_signals(&oldset);
>   	if (ret)
>   		ret = VM_FAULT_SIGBUS;
>   	return ret;
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 12c2203..cf6d87b 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2560,5 +2560,25 @@ void __ocfs2_abort(struct super_block* sb,
>   	ocfs2_handle_error(sb);
>   }
>
> +/*
> + * Void signal blockers, because in-kernel sigprocmask() only fails
> + * when SIG_* is wrong.
> + */
> +void ocfs2_block_signals(sigset_t *oldset)
> +{
> +	int rc;
> +	sigset_t blocked;
> +
> +	sigfillset(&blocked);
> +	rc = sigprocmask(SIG_BLOCK,&blocked, oldset);
> +	BUG_ON(rc);
> +}
> +
> +void ocfs2_unblock_signals(sigset_t *oldset)
> +{
> +	int rc = sigprocmask(SIG_SETMASK, oldset, NULL);
> +	BUG_ON(rc);
> +}
> +
>   module_init(ocfs2_init);
>   module_exit(ocfs2_exit);
> diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
> index 783f527..40c7de0 100644
> --- a/fs/ocfs2/super.h
> +++ b/fs/ocfs2/super.h
> @@ -45,4 +45,11 @@ void __ocfs2_abort(struct super_block *sb,
>
>   #define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
>
> +/*
> + * Void signal blockers, because in-kernel sigprocmask() only fails
> + * when SIG_* is wrong.
> + */
> +void ocfs2_block_signals(sigset_t *oldset);
> +void ocfs2_unblock_signals(sigset_t *oldset);
> +
>   #endif /* OCFS2_SUPER_H */
>    
