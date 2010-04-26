From: Li Dongyang <lidongyang@novell.com>
Date: Mon, 26 Apr 2010 17:59:04 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: use
	OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_mknod error path
In-Reply-To: <20100423195900.GQ17187@wotan.suse.de>
References: <201004221611.30029.lidongyang@novell.com>
	<20100423195900.GQ17187@wotan.suse.de>
Message-ID: <201004261759.05093.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Saturday 24 April 2010 03:59:00 Mark Fasheh wrote:
> On Thu, Apr 22, 2010 at 04:11:29PM +0800, Li Dongyang wrote:
> > mark the inode with flag OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_mknod,
> > so we can kill the inode in case of error.
> >
> > Signed-off-by: Li Dongyang <lidongyang@novell.com>
> > ---
> >  fs/ocfs2/namei.c |   16 +++++++++++-----
> >  1 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > index 4ce4416..f989823 100644
> > --- a/fs/ocfs2/namei.c
> > +++ b/fs/ocfs2/namei.c
> > @@ -447,11 +447,6 @@ leave:
> >
> >  	ocfs2_free_dir_lookup_result(&lookup);
> >
> > -	if ((status < 0) && inode) {
> > -		clear_nlink(inode);
> > -		iput(inode);
> > -	}
> > -
> >  	if (inode_ac)
> >  		ocfs2_free_alloc_context(inode_ac);
> >
> > @@ -461,6 +456,17 @@ leave:
> >  	if (meta_ac)
> >  		ocfs2_free_alloc_context(meta_ac);
> >
> > +	/*
> > +	We should call iput after the i_mutex of the bitmap
> > +	been unlocked in ocfs2_free_alloc_context, or the ocfs2_delete_inode
> > +	will mutex_lock again.
> > +	*/
> 
> Comment style here is wrong. It should look like:
> 
> 	/*
> 	 * We should call iput after the i_mutex of the bitmap been
> 	 * unlocked in ocfs2_free_alloc_context, or the
> 	 * ocfs2_delete_inode will mutex_lock again.
> 	 */
> 
> > +	if ((status < 0) && inode) {
> > +		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SKIP_ORPHAN_DIR;
> > +		clear_nlink(inode);
> > +		iput(inode);
> > +	}
> 
> So, I realized that this doesn't fix all the issues we have.
> 
> If you look at symlink and mknod, you'll see that we can get here _after_
> the inode name has been added to the directory. Removing the inode then
> would leave a dangling directory reference. The following patch tries to
>  fix the issue. Can you please confirm that it works?
> 
Thanks for pointing out this and fixing the comment style and the description,
I've tested with your patch and it works for me.
Br,
Li Dongyang
> 
> If you want to pull the whole set of patches (with some cleanups by me),
>  you can get it at:
> 
> git pull
>  git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2-mark.git
>  skip_delete_inode ---Mark
> 
> --
> Mark Fasheh
> 
> From: Mark Fasheh <mfasheh@suse.com>
> 
> ocfs2: Add directory entry later in ocfs2_symlink() and ocfs2_mknod()
> 
> If we get a failure during creation of an inode we'll allow the orphan code
> to remove the inode, which is correct. However, we need to ensure that we
> don't get any errors after the call to ocfs2_add_entry(), otherwise we
>  could leave a dangling directory reference. The solution is simple - in
>  both cases, all I had to do was move ocfs2_dentry_attach_lock() above the
>  ocfs2_add_entry() call.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/namei.c |   40 +++++++++++++++++++++++++---------------
>  1 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 8ff035e..4cbb18f 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -408,23 +408,28 @@ static int ocfs2_mknod(struct inode *dir,
>  		}
>  	}
> 
> -	status = ocfs2_add_entry(handle, dentry, inode,
> -				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
> -				 &lookup);
> -	if (status < 0) {
> +	/*
> +	 * Do this before adding the entry to the directory. We add
> +	 * also set d_op after success so that ->d_iput() will cleanup
> +	 * the dentry lock even if ocfs2_add_entry() fails below.
> +	 */
> +	status = ocfs2_dentry_attach_lock(dentry, inode,
> +					  OCFS2_I(dir)->ip_blkno);
> +	if (status) {
>  		mlog_errno(status);
>  		goto leave;
>  	}
> +	dentry->d_op = &ocfs2_dentry_ops;
> 
> -	status = ocfs2_dentry_attach_lock(dentry, inode,
> -					  OCFS2_I(dir)->ip_blkno);
> -	if (status) {
> +	status = ocfs2_add_entry(handle, dentry, inode,
> +				 OCFS2_I(inode)->ip_blkno, parent_fe_bh,
> +				 &lookup);
> +	if (status < 0) {
>  		mlog_errno(status);
>  		goto leave;
>  	}
> 
>  	insert_inode_hash(inode);
> -	dentry->d_op = &ocfs2_dentry_ops;
>  	d_instantiate(dentry, inode);
>  	status = 0;
>  leave:
> @@ -1777,22 +1782,27 @@ static int ocfs2_symlink(struct inode *dir,
>  		}
>  	}
> 
> -	status = ocfs2_add_entry(handle, dentry, inode,
> -				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
> -				 &lookup);
> -	if (status < 0) {
> +	/*
> +	 * Do this before adding the entry to the directory. We add
> +	 * also set d_op after success so that ->d_iput() will cleanup
> +	 * the dentry lock even if ocfs2_add_entry() fails below.
> +	 */
> +	status = ocfs2_dentry_attach_lock(dentry, inode, OCFS2_I(dir)->ip_blkno);
> +	if (status) {
>  		mlog_errno(status);
>  		goto bail;
>  	}
> +	dentry->d_op = &ocfs2_dentry_ops;
> 
> -	status = ocfs2_dentry_attach_lock(dentry, inode, OCFS2_I(dir)->ip_blkno);
> -	if (status) {
> +	status = ocfs2_add_entry(handle, dentry, inode,
> +				 le64_to_cpu(fe->i_blkno), parent_fe_bh,
> +				 &lookup);
> +	if (status < 0) {
>  		mlog_errno(status);
>  		goto bail;
>  	}
> 
>  	insert_inode_hash(inode);
> -	dentry->d_op = &ocfs2_dentry_ops;
>  	d_instantiate(dentry, inode);
>  bail:
>  	if (status < 0 && did_quota)
> 
