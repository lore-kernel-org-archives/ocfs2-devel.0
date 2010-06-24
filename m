From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 24 Jun 2010 16:03:23 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries v2
In-Reply-To: <AANLkTiljvXu-QqcflpaSb-5EC-cLBZT8l6KBF2qoU4Ef@mail.gmail.com>
References: <AANLkTiljvXu-QqcflpaSb-5EC-cLBZT8l6KBF2qoU4Ef@mail.gmail.com>
Message-ID: <20100624230323.GL28091@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,

	The patch looks pretty good so far - thanks for taking on this task!
My comments are inlined.

On Wed, Jun 23, 2010 at 08:45:10PM -0500, Goldwyn Rodrigues wrote:
> Track negative dentries by recording the generation number of the parent
> directory in d_fsdata. The generation number for the parent directory is
> recorded in the inode_info, which increments every time the lock on the
> directory is dropped.
> 
> If the generation number of the parent directory and the negative dentry
> matches, there is no need to perform the revalidate, else a revalidate
> is forced. This improves performance in situations where nodes look for
> the same non-existent file multiple times.
> 
> Thanks Mark for explaining the DLM sequence.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> ---
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index b4957c7..6db61a3 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -40,6 +40,16 @@
>  #include "inode.h"
>  #include "super.h"
> 
> +/* Attach a generation number to a negative dentry */
> +void ocfs2_dentry_attach_gen(struct dentry *dentry)
> +{
> +	unsigned long gen = OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
> +	/* Specifically for negative dentries */

> +	if (dentry->d_inode)
> +		BUG();

You should turn those two lines into:
	BUG_ON(dentry->d_inode);


> +	dentry->d_fsdata = (void *)gen;
> +}
> +
> 
>  static int ocfs2_dentry_revalidate(struct dentry *dentry,
>  				   struct nameidata *nd)
> @@ -51,11 +61,22 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
>  	mlog_entry("(0x%p, '%.*s')\n", dentry,
>  		   dentry->d_name.len, dentry->d_name.name);
> 
> -	/* Never trust a negative dentry - force a new lookup. */

Btw, it occurs to me that we could also optimize away local mounts in a
seperate patch by always trusting the dentry passed in that case.


> +	/* For a negative dentry -
> +	   check the generation number of the parent and compare with the
> +	   one stored in the inode.
> +	   */

The preferred style for long (multi-line) comments is:

	/*
	 * line one
	 * line two
	 */


>  	if (inode == NULL) {
> -		mlog(0, "negative dentry: %.*s\n", dentry->d_name.len,
> -		     dentry->d_name.name);
> -		goto bail;
> +		unsigned long gen = (unsigned long) dentry->d_fsdata;
> +		unsigned long pgen =
> +			OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
> +		mlog(0, "negative dentry: %.*s parent gen: %lu "
> +			"dentry gen: %lu\n",
> +			dentry->d_name.len, dentry->d_name.name, pgen, gen);
> +		if (gen != pgen) {
> +			dentry->d_fsdata = (void *) pgen;
> +			goto bail;
> +		}

What are you setting the dentry generation here? We should only be
doing that when under cluster lock when we are guaranteed that the dentry is
negative.


> +		goto valid;
>  	}
> 
>  	BUG_ON(!osb);
> @@ -96,6 +117,7 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
>  		goto bail;
>  	}
> 
> +valid:
>  	ret = 1;
> 
>  bail:
> @@ -227,6 +249,12 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>  	if (!inode)
>  		return 0;
> 
> +	if (!dentry->d_inode && dentry->d_fsdata) {
> +		/* Converting a negative dentry to positive
> +		   Clear dentry->d_fsdata */
> +		dentry->d_fsdata = dl = NULL;
> +	}
> +
>  	if (dl) {
>  		mlog_bug_on_msg(dl->dl_parent_blkno != parent_blkno,
>  				" \"%.*s\": old parent: %llu, new: %llu\n",
> @@ -451,6 +479,7 @@ static void ocfs2_dentry_iput(struct dentry
> *dentry, struct inode *inode)
>  	ocfs2_dentry_lock_put(OCFS2_SB(dentry->d_sb), dl);
> 
>  out:
> +	ocfs2_dentry_attach_gen(dentry);

Why the call to ocfs2_dentry_attach_gen() here?


>  	iput(inode);
>  }
> 
> diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
> index f5dd178..b79eff7 100644
> --- a/fs/ocfs2/dcache.h
> +++ b/fs/ocfs2/dcache.h
> @@ -64,5 +64,6 @@ void ocfs2_dentry_move(struct dentry *dentry, struct
> dentry *target,
>  		       struct inode *old_dir, struct inode *new_dir);
> 
>  extern spinlock_t dentry_attach_lock;
> +void ocfs2_dentry_attach_gen(struct dentry *dentry);
> 
>  #endif /* OCFS2_DCACHE_H */
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 39eb16a..bf79dcf 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3635,10 +3635,18 @@ static int ocfs2_data_convert_worker(struct
> ocfs2_lock_res *lockres,
>  {
>  	struct inode *inode;
>  	struct address_space *mapping;
> +	struct ocfs2_inode_info *oi;
> 
>         	inode = ocfs2_lock_res_inode(lockres);
>  	mapping = inode->i_mapping;
> 
> +	if (S_ISDIR(inode->i_mode)) {
> +		oi = OCFS2_I(inode);
> +		oi->ip_generation++;
> +		mlog(0, "generation: %u\n", oi->ip_generation);
> +		goto out;
> +	}
> +
>  	if (!S_ISREG(inode->i_mode))
>  		goto out;
> 
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 9f5f5fc..34bad2c 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -70,6 +70,7 @@ struct ocfs2_inode_info
>  	/* Only valid if the inode is the dir. */
>  	u32				ip_last_used_slot;
>  	u64				ip_last_used_group;
> +	u32				ip_generation; /*for -ve dentry */

Comment doesn't make sense  :)   Also, can you pick something we're less
likely to confuse with i_generation? Maybe ip_dir_lock_gen?

Also, it should be initialized to a nonzero value in when we're initializing
the directory inode under cluster lock in ocfs2_read_locked_inode().
	--Mark

--
Mark Fasheh
