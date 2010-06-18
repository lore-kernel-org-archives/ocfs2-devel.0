From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 18 Jun 2010 09:06:00 -0700
Subject: [Ocfs2-devel] [PATCH] Track negative dentries
In-Reply-To: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
References: <AANLkTilwWhweSS4BxXZCQxCAicETuZ2rjFb_BHMM3YGZ@mail.gmail.com>
Message-ID: <4C1B9968.6020805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks for taking on this task.

One overall comment about comments. Instead of sprinkling
the same line everywhere, add the full description in one place.
Maybe atop ocfs2_attach_dentry_gen(). Describe it fully. And then
let the code speak for itself.

Also, do remember to run the patch thru scripts/checkpatch.pl.

On 06/18/2010 08:02 AM, Goldwyn Rodrigues wrote:
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
> Signed-off-by: Goldwyn Rodrigues<rgoldwyn@suse.de>
> ---
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index b4957c7..f29095b 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -40,6 +40,16 @@
>   #include "inode.h"
>   #include "super.h"
>
> +void ocfs2_dentry_attach_gen(struct dentry *dentry)
> +{
> +	int *gen = (int *)kmalloc(sizeof(int), GFP_KERNEL);
> +	*gen = OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
> +	/* Generation numbers are specifically for negative dentries */
> +	if (dentry->d_inode)
> +		BUG();
> +	dentry->d_fsdata = (void *)gen;
> +}
> +
>    

kmalloc()s can fail. If this is just an int, why not just store it
directly in d_fsdata. Add appropriate casts.

Also, are you sure about the locking when reading the parent's
generation.

>   static int ocfs2_dentry_revalidate(struct dentry *dentry,
>   				   struct nameidata *nd)
> @@ -51,10 +61,21 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
>   	mlog_entry("(0x%p, '%.*s')\n", dentry,
>   		   dentry->d_name.len, dentry->d_name.name);
>
> -	/* Never trust a negative dentry - force a new lookup. */
> +	/* For a negative dentry -
> +	   check the generation number of the parent and compare with the
> +	   one stored in the inode.
> +	   */
>   	if (inode == NULL) {
> -		mlog(0, "negative dentry: %.*s\n", dentry->d_name.len,
> -		     dentry->d_name.name);
> +		int *gen = (int *)dentry->d_fsdata;
> +		int parent_gen =
> +			OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
> +		mlog(0, "negative dentry: %.*s parent gen: %u dentry gen: %u\n",
> +				dentry->d_name.len, dentry->d_name.name,
> +				parent_gen, *gen);
> +		if (*gen == parent_gen)
> +			ret = 1;
> +		else
> +			*gen = parent_gen;
>   		goto bail;
>   	}
>    

Code is hard to read. See one possible rewrite below. This rewrite
requires adding a "revalidated" label above ret = 1.

+		int *gen = (int *)dentry->d_fsdata;
+		int pgen = OCFS2_I(dentry->d_parent->d_inode)->ip_generation;
+
+		mlog(0, "negative dentry: %.*s parent gen: %u dentry gen: %u\n",
+				dentry->d_name.len, dentry->d_name.name,
+				parent_gen, *gen);
+
+		if (*gen != pgen) {
+			*gen = pgen;
+			goto bail;
+		}
+
+ 		goto revalidated;
    	}




> @@ -227,6 +248,13 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   	if (!inode)
>   		return 0;
>
> +	if (!dentry->d_inode&&  dentry->d_fsdata) {
> +		/* Converting a negative dentry to positive
> +		   Clear dentry->d_fsdata */
> +		kfree(dentry->d_fsdata);
> +		dentry->d_fsdata = dl = NULL;
> +	}
> +
>    


>   	if (dl) {
>   		mlog_bug_on_msg(dl->dl_parent_blkno != parent_blkno,
>   				" \"%.*s\": old parent: %llu, new: %llu\n",
> @@ -451,6 +479,8 @@ static void ocfs2_dentry_iput(struct dentry
> *dentry, struct inode *inode)
>   	ocfs2_dentry_lock_put(OCFS2_SB(dentry->d_sb), dl);
>
>   out:
> +	/* Attach generation number to dentry */
> +	ocfs2_dentry_attach_gen(dentry);
>   	iput(inode);
>   }
>    

Remove comment. Code is clear.

> @@ -500,7 +530,15 @@ out_move:
>   	d_move(dentry, target);
>   }
>
> +static void ocfs2_dentry_release(struct dentry *dentry)
> +{
> +	/* Free the generation number stored in negative dentry */
> +	if (!dentry->d_inode&&  dentry->d_fsdata)
> +		kfree(dentry->d_fsdata);
> +}
>    

Shouldn't you be setting d_fsdata to NULL.

> +
>   const struct dentry_operations ocfs2_dentry_ops = {
>   	.d_revalidate		= ocfs2_dentry_revalidate,
>   	.d_iput			= ocfs2_dentry_iput,
> +	.d_release		= ocfs2_dentry_release,
>   };
> diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
> index f5dd178..b79eff7 100644
> --- a/fs/ocfs2/dcache.h
> +++ b/fs/ocfs2/dcache.h
> @@ -64,5 +64,6 @@ void ocfs2_dentry_move(struct dentry *dentry, struct
> dentry *target,
>   		       struct inode *old_dir, struct inode *new_dir);
>
>   extern spinlock_t dentry_attach_lock;
> +void ocfs2_dentry_attach_gen(struct dentry *dentry);
>
>   #endif /* OCFS2_DCACHE_H */
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 39eb16a..d5fb79b 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2565,7 +2565,6 @@ void ocfs2_inode_unlock(struct inode *inode,
>   	if (!ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb))&&
>   	!ocfs2_mount_local(osb))
>   		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
> -
>   	mlog_exit_void();
>   }
>    

??

> @@ -3635,10 +3634,18 @@ static int ocfs2_data_convert_worker(struct
> ocfs2_lock_res *lockres,
>   {
>   	struct inode *inode;
>   	struct address_space *mapping;
> +	struct ocfs2_inode_info *oi;
>
>          	inode = ocfs2_lock_res_inode(lockres);
>   	mapping = inode->i_mapping;
>
> +	if (S_ISDIR(inode->i_mode)) {
> +		oi = OCFS2_I(inode);
> +		oi->ip_generation++;
> +		mlog(0, "generation: %u\n", oi->ip_generation);
> +		goto out;
> +	}
> +
>   	if (!S_ISREG(inode->i_mode))
>   		goto out;
>
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index 9f5f5fc..529729c 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -70,6 +70,8 @@ struct ocfs2_inode_info
>   	/* Only valid if the inode is the dir. */
>   	u32				ip_last_used_slot;
>   	u64				ip_last_used_group;
> +	/* Generation number for negative inodes */
> +	u32				ip_generation;
>
>   	struct ocfs2_alloc_reservation	ip_la_data_resv;
>   };
>    

Move the comment to the right. The comment above holds valid
for this field too.

> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index f171b51..c06753a 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -172,6 +172,8 @@ bail_add:
>   			goto bail_unlock;
>   		}
>   	}
> +	else /* Attach generation number for negative dentry */
> +		ocfs2_dentry_attach_gen(dentry);
>    

Remove comment. Code is clear. Also, else needs to be in the same
line as }.

>   bail_unlock:
>   	/* Don't drop the cluster lock until *after* the d_add --
>
>    
