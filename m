From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 17:08:36 2007
Subject: [Ocfs2-devel] [PATCH 2/2] Add online resize support for ocfs2,
	take 1
In-Reply-To: <20071116084153.GA3900@tma-pc1.cn.oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084153.GA3900@tma-pc1.cn.oracle.com>
Message-ID: <20071121010812.GJ28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 16, 2007 at 04:41:53PM +0800, tao.ma wrote:
> User can do offline resize using tunefs.ocfs2 when a volume isn't
> mounted. Now the support for online resize is added into ocfs2.
> 
> Please note that the node where online resize goes must already
> has the volume mounted. We don't mount it behind the user and the
> operation would fail if we find it isn't mounted. As for other
> nodes, we don't care whether the volume is mounted or not.
> 
> global_bitmap, super block and all the backups will be updated
> in the kernel. And if super block or backup's update fails, we
> just output some error message in dmesg and continue the work.

In your patch description, please also give a short description of how
userspace interfaces with the kernel.


> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> 
> ---
> 
>  fs/ocfs2/buffer_head_io.c |   61 +++++++
>  fs/ocfs2/buffer_head_io.h |    2 
>  fs/ocfs2/ioctl.c          |    3 
>  fs/ocfs2/journal.h        |    3 
>  fs/ocfs2/ocfs2_fs.h       |    4 
>  fs/ocfs2/suballoc.c       |  376 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/suballoc.h       |    1 
>  7 files changed, 449 insertions(+), 1 deletions(-)
> 
> 2d7923e5462d2506d2eab7631bf4282c5799c5fb
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index c903741..0f70288 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -280,3 +280,64 @@ bail:
>  	mlog_exit(status);
>  	return status;
>  }
> +
> +static inline void check_blkno(struct super_block *sb, sector_t blkno)

We probably want a more descriptive name for this function. Also, prefix
with 'ocfs2', please.


> +{
> +	int i;
> +	u64 backup_blkno;
> +
> +	if (blkno == OCFS2_SUPER_BLOCK_BLKNO)
> +		return;
> +
> +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> +		backup_blkno = ocfs2_backup_super_blkno(sb, i);
> +		if (backup_blkno == blkno)
> +			return;
> +	}
> +
> +	BUG();
> +}
> +/*
> + * Write super block and bakcups doesn't need to collaborate with journal,
> + * so we don't need to lock ip_io_mutex and inode doesn't need to bea passed
> + * into this function.
> + */
> +int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
> +				struct buffer_head *bh)
> +{
> +	int ret = 0;
> +
> +	mlog_entry_void();
> +
> +	BUG_ON(buffer_jbd(bh));
> +	check_blkno(osb->sb, bh->b_blocknr);
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
> +		ret = -EROFS;
> +		goto out;
> +	}
> +
> +	lock_buffer(bh);
> +	set_buffer_uptodate(bh);
> +
> +	/* remove from dirty list before I/O. */
> +	clear_buffer_dirty(bh);
> +
> +	get_bh(bh); /* for end_buffer_write_sync() */
> +	bh->b_end_io = end_buffer_write_sync;
> +	submit_bh(WRITE, bh);
> +
> +	wait_on_buffer(bh);
> +
> +	if (!buffer_uptodate(bh)) {
> +		/* We don't need to remove the clustered uptodate
> +		 * information for this bh as it's not marked locally
> +		 * uptodate. */

This comment doesn't make sense in this function (which doesn't make use of
the clustered uptodate code), so I'd just remove it completely.


> +		ret = -EIO;
> +		brelse(bh);
> +	}
> +
> +out:
> +	mlog_exit(ret);
> +	return ret;
> +}
> diff --git a/fs/ocfs2/buffer_head_io.h b/fs/ocfs2/buffer_head_io.h
> index 6cc2093..9a5c2fc 100644
> --- a/fs/ocfs2/buffer_head_io.h
> +++ b/fs/ocfs2/buffer_head_io.h
> @@ -46,6 +46,8 @@ int ocfs2_read_blocks(struct ocfs2_super
>  		      struct buffer_head  *bhs[],
>  		      int                  flags,
>  		      struct inode        *inode);
> +int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
> +				struct buffer_head *bh);
>  
>  
>  #define OCFS2_BH_CACHED            1
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 87dcece..43ab5ea 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -20,6 +20,7 @@ #include "journal.h"
>  
>  #include "ocfs2_fs.h"
>  #include "ioctl.h"
> +#include "suballoc.h"
>  
>  #include <linux/ext2_fs.h>
>  
> @@ -140,6 +141,8 @@ int ocfs2_ioctl(struct inode * inode, st
>  			return -EFAULT;
>  
>  		return ocfs2_change_file_space(filp, cmd, &sr);
> +	case OCFS2_IOC_FSGROWFSDATA:
> +		return ocfs2_volume_resize(inode, arg);

You should do the user copy here, and then pass the result as a type checked
argument to ocfs2_volume_resize. This will keep it consistent with how we
handle ioctls.


> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 4b32e09..ae08951 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -278,6 +278,9 @@ int                  ocfs2_journal_dirty
>  /* simple file updates like chmod, etc. */
>  #define OCFS2_INODE_UPDATE_CREDITS 1
>  
> +/* onine resize. Just dinode + last group descriptor update. */
> +#define OCFS2_ONLINE_RESIZE_CREDITS (2)
> +
>  /* get one bit out of a suballocator: dinode + group descriptor +
>   * prev. group desc. if we relink. */
>  #define OCFS2_SUBALLOC_ALLOC (3)
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 6ef8767..099d984 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -27,7 +27,7 @@ #define _OCFS2_FS_H
>  
>  /* Version */
>  #define OCFS2_MAJOR_REV_LEVEL		0
> -#define OCFS2_MINOR_REV_LEVEL          	90
> +#define OCFS2_MINOR_REV_LEVEL          	91

This isn't needed.


>  /*
>   * An OCFS2 volume starts this way:
> @@ -231,6 +231,8 @@ #define OCFS2_IOC_FREESP64	_IOW ('X', 37
>  #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
>  #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
>  
> +#define OCFS2_IOC_FSGROWFSDATA	_IOW ('X', 110, struct ocfs2_dinode)

Ok, ocfs2_dinode is far too big to pass as an ioctl argument. It's also not
necessarily up to date, nor is it raw from disk as the kernel typically
expects (userspace has flipped it for us). What you need to do is take
whichever information that you require to do the online resize and put that
into an argument structure which will be passed through. Take a look at
"struct ext3_new_group_input" and how it's used in their ioctl. We shouldn't
copy it directly (because ocfs2 online resize is going to be much different
from what ext3 does), but definitely that's the approach you should take.

As far as new cluster group descriptors go, the kernel should be able to
figure out where those are and just read the ones it needs for linking.


> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 8f09f52..f355628 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1756,6 +1756,382 @@ int ocfs2_free_clusters(handle_t *handle
>  	return status;
>  }
>  
> +/*
> + * Check whether there are new backup superblocks exist
> + * in the last group. If there are some, mark them and modify
> + * the group information.
> + *
> + * The number of backups are recorded and returned, so
> + * we can modified the inode accordingly.
> + *
> + * We use the "new" cl_cpg stored in di to calculate the group_no
> + * since the "old" one may lead to the wrong result when there
> + * was only one group in the "old" volume.
> + */
> +static u16 ocfs2_add_new_backup_super(struct inode *inode,
> +				      struct ocfs2_dinode *di,
> +				      struct ocfs2_group_desc *gd,
> +				      uint32_t first_new_cluster)
> +{
> +	int i;
> +	u16 cl_cpg = di->id2.i_chain.cl_cpg, backups = 0;
> +	u32 group_no, cluster;
> +	u32 end_cluster = first_new_cluster + di->i_clusters;
> +	u64 blkno, gd_blkno, lgd_blkno = le64_to_cpu(gd->bg_blkno);
> +
> +	mlog_entry("update the last group=%llu\n", lgd_blkno);
> +
> +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> +		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
> +		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
> +
> +		if (cluster < first_new_cluster)
> +			continue;
> +		else if (cluster >= end_cluster)
> +			break;
> +
> +		group_no = cluster / cl_cpg;
> +		gd_blkno = ocfs2_clusters_to_blocks(inode->i_sb,
> +						    group_no * cl_cpg);
> +		if (gd_blkno < lgd_blkno)
> +			continue;
> +		else if (gd_blkno > lgd_blkno)
> +			break;
> +
> +		mlog(0, "Set cluster %u in the last group\n", cluster);
> +		ocfs2_set_bit(cluster % cl_cpg, (unsigned long *)gd->bg_bitmap);
> +		le16_add_cpu(&gd->bg_free_bits_count, -1);
> +		backups++;
> +	}
> +
> +	mlog_exit_void();
> +	return backups;
> +}
> +/*
> + * update the last group descriptor according to the new added clusters.
> + *
> + * chain: the chain the last group descriptor is in.
> + * backups: the new backup superblocks the last group descriptor has.
> + */
> +static int ocfs2_update_last_group(handle_t *handle,
> +				   struct inode *bm_inode,
> +				   struct buffer_head *bm_bh,
> +				   struct ocfs2_dinode *add_di,
> +				   uint16_t *chain,
> +				   uint16_t *backups)
> +{
> +	int status = 0;
> +	struct ocfs2_super *osb = OCFS2_SB(bm_inode->i_sb);
> +	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bm_bh->b_data;
> +	struct buffer_head *group_bh = NULL;
> +	struct ocfs2_group_desc *group;
> +	u16 cl_cpg, cl_bpc;
> +	u32 first_new_cluster, cluster_chunk;
> +	u32 num_new_clusters = add_di->i_clusters;
> +	u64 bg_blkno;
> +	u16 num_bits;
> +
> +	mlog_entry("(new_clusters=%u)\n", num_new_clusters);
> +
> +	if (!OCFS2_IS_VALID_DINODE(fe)) {
> +		OCFS2_RO_ON_INVALID_DINODE(bm_inode->i_sb, fe);
> +		status = -EIO;
> +		goto bail;
> +	}
> +
> +	first_new_cluster = le32_to_cpu(fe->i_clusters);
> +	bg_blkno = ocfs2_which_cluster_group(bm_inode, first_new_cluster - 1);
> +
> +	status = ocfs2_read_block(osb, bg_blkno, &group_bh, OCFS2_BH_CACHED,
> +				  bm_inode);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	group = (struct ocfs2_group_desc *) group_bh->b_data;
> +	status = ocfs2_check_group_descriptor(bm_inode->i_sb, fe, group);
> +	if (status) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	status = ocfs2_journal_access(handle, bm_inode, group_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	cl_cpg = add_di->id2.i_chain.cl_cpg;
> +	cl_bpc = add_di->id2.i_chain.cl_bpc;
> +	/* If possible round off the last group to cpg */
> +	cluster_chunk = min(num_new_clusters,
> +			    (u32)(cl_cpg - (le16_to_cpu(group->bg_bits)/cl_bpc)));
> +	if (cluster_chunk) {
> +		num_bits = cluster_chunk * cl_bpc;
> +
> +		le16_add_cpu(&group->bg_bits, num_bits);
> +		le16_add_cpu(&group->bg_free_bits_count, num_bits);
> +	}
> +
> +	/*
> +	 * check whether there are some new backup superblocks exist in
> +	 * this group.
> +	 */
> +	*backups = 0;
> +	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb,
> +				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
> +		*backups = ocfs2_add_new_backup_super(bm_inode, add_di, group,
> +						      first_new_cluster);
> +		if (*backups)
> +			*chain = le16_to_cpu(group->bg_chain);
> +	}
> +
> +	status = ocfs2_journal_dirty(handle, group_bh);
> +	if (status < 0)
> +		mlog_errno(status);
> +
> +bail:
> +	if (group_bh)
> +		brelse(group_bh);
> +
> +	mlog_exit(status);
> +	return status;
> +
> +}
> +
> +static void update_backups(struct inode * inode, u32 clusters, char *data)
> +{
> +	int i, status = 0;
> +	char *backup = NULL;
> +	struct ocfs2_dinode *backup_di = NULL;
> +	u64 blkno, backup_blknos[OCFS2_MAX_BACKUP_SUPERBLOCKS];
> +	struct buffer_head *backups[OCFS2_MAX_BACKUP_SUPERBLOCKS];

We shouldn't put this much on the kernel stack.

Why don't you kzalloc and iniitalize those arrays up in ocfs2_volume_resize
and just pass them through to the functions that need them. That way we've
only read each backup super block once (in ocfs2_volume_resize() for
existing ones, and ocfs2_update_last_group() for new ones) and then you can
just write them all at once here.


> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	u32 cluster;
> +
> +	memset(backups, 0, sizeof(backups));
> +	memset(backup_blknos, 0, sizeof(backup_blknos));
> +
> +	/* calculate the real backups we need to update. */
> +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> +		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
> +		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
> +		 if (cluster > clusters)
> +			break;
> +
> +		backup_blknos[i] = blkno;
> +	}
> +
> +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> +		if (backup_blknos[i] == 0ULL)
> +			break;
> +
> +		status = ocfs2_read_block(osb, backup_blknos[i] ,
> +					  &backups[i], 0, NULL);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto out;
> +		}
> +
> +		backup = backups[i]->b_data;
> +
> +		memcpy(backup, data, inode->i_sb->s_blocksize);
> +
> +		backup_di = (struct ocfs2_dinode *)backup;
> +		backup_di->i_blkno = cpu_to_le64(backup_blknos[i]);
> +
> +		status = ocfs2_write_super_or_backup(osb, backups[i]);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	for (i = 0; backups[i] != NULL; i++)
> +		brelse(backups[i]);
> +
> +	if (status) {
> +		mlog(status, "can't update backups."
> +			     "Please run fsck before next mount");
> +	}
> +}
> +/*
> + * ocfs2_volume_resize will update the global bitmap and the last group
> + * descriptor according to the arg.
> + *
> + * arg is organized as an ocfs2_dinode.
> + * di->i_clusters records the new clusters added to the volume.
> + * di->i_chain contains all the new group descriptors information.
> + *
> + * NOTE:
> + * di is already made endian safe by the ocfs2-tools, so we don't need
> + * endian operation for it.
> + */
> +int ocfs2_volume_resize(struct inode * inode, unsigned long arg)
> +{
> +	int status;
> +	handle_t *handle;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct buffer_head *super_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_dinode *di = NULL;
> +	struct ocfs2_dinode *fe = NULL;
> +	struct ocfs2_dinode *super_di = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_chain_list *cl;
> +	struct ocfs2_chain_rec *cr, *cr_new;
> +	u16 i, backups = 0, chain = 0;
> +	u32 clusters = 0;
> +
> +	mlog_entry_void();
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
> +	di = kmalloc(osb->sb->s_blocksize, GFP_KERNEL);
> +	if (!di)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(di, (int __user *) arg,
> +			   osb->sb->s_blocksize)) {
> +		status =  -EFAULT;
> +		goto out;
> +	}

We have to do additional validation on the argument here (even after you
change it from being an ocfs2_dinode).

- Make sure that the requested size doesn't give us a block count which
  would exceed a u32 as JBD won't be able to address that.

- Check that the requested size isn't actually smaller than the existing
  one.

- If ypur code can only resize a certain amount at a time (adding only one
  cluster group, etc), then check that it's not requested that we resize more
  than is possible.

- Also, as discussed in the previous thread, we should compare bitmap_cpg
  against what it should be and refuse to resize if it's wrong.

Don't mlog if you see those by the way as we'll eventually move to JBD2 to
support larger volume sizes and online shrink might be a reality some day.




> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode) {
> +		status = -EINVAL;
> +		mlog_errno(status);
> +		goto out;
> +	}
> +
> +	mutex_lock(&main_bm_inode->i_mutex);
> +
> +	status = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_mutex;
> +	}
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_ONLINE_RESIZE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		mlog_errno(PTR_ERR(handle));
> +		handle = NULL;
> +		goto out_unlock;
> +	}
> +
> +	/* let the journal update the global bitmap immediately. */
/*
 * Let the journal update the global bitmap immediately. We do this so that
 * the bitmap update gets synced to disk before the super blocks are written
 * out.
 */


> +	handle->h_sync = 1;
> +
> +	/* update the last group descriptor according to di. */
> +	status = ocfs2_update_last_group(handle, main_bm_inode,
> +					 main_bm_bh, di, &chain, &backups);
> +	if (status) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	status = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
> +				      OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * update the chain_rec if there are new backups in the last group.
> +	 * update the global bitmap inode according to di.
> +	 */
> +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
> +	cl = &fe->id2.i_chain;
> +
> +	if (backups) {
> +		cr = (&cl->cl_recs[chain]);
> +		le32_add_cpu(&cr->c_free, -1 * backups);
> +		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
> +	}

I think it'd be more clear if you handled this in ocfs2_update_last_group().
Don't forget to also move the journal_access call for main_bm_inode before it though.


> +	for (i = 0; i < le16_to_cpu(cl->cl_count); i++) {
> +		cr = &(cl->cl_recs[i]);
> +		cr_new = &(di->id2.i_chain.cl_recs[i]);
> +		le32_add_cpu(&cr->c_total, cr_new->c_total);
> +		le32_add_cpu(&cr->c_free, cr_new->c_free);
> +		cr->c_blkno = cpu_to_le64(cr_new->c_blkno);
> +	}
> +	cl->cl_next_free_rec = cpu_to_le16(di->id2.i_chain.cl_next_free_rec);
> +	cl->cl_cpg = cpu_to_le16(di->id2.i_chain.cl_cpg);
> +
> +	le32_add_cpu(&fe->id1.bitmap1.i_total, di->id1.bitmap1.i_total);
> +	le32_add_cpu(&fe->id1.bitmap1.i_used, di->id1.bitmap1.i_used);
> +	le32_add_cpu(&fe->i_clusters, di->i_clusters);
> +	le64_add_cpu(&fe->i_size, di->i_size);
> +
> +	status = ocfs2_journal_dirty(handle, main_bm_bh);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
> +	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> +	clusters = le32_to_cpu(fe->i_clusters);
> +	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
> +
> +	status = ocfs2_commit_trans(osb, handle);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * update the superblock last.
> +	 * It doesn't matter if the write failed.
> +	 */
> +	status = ocfs2_read_block(osb, OCFS2_SUPER_BLOCK_BLKNO,
> +				  &super_bh, 0, NULL);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	super_di = (struct ocfs2_dinode *)super_bh->b_data;
> +	le32_add_cpu(&super_di->i_clusters, di->i_clusters);
> +
> +	status = ocfs2_write_super_or_backup(osb, super_bh);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out_unlock;
> +	}
> +
> +	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_COMPAT_BACKUP_SB))
> +		update_backups(main_bm_inode, clusters, super_bh->b_data);
> +
> +out_unlock:
> +	if (super_bh)
> +		brelse(super_bh);
> +
> +	if (main_bm_bh)
> +		brelse(main_bm_bh);
> +
> +	ocfs2_meta_unlock(main_bm_inode, 1);
> +
> +out_mutex:
> +	mutex_unlock(&main_bm_inode->i_mutex);
> +	iput(main_bm_inode);
> +
> +out:
> +	if (di)
> +		kfree(di);
> +
> +	mlog_exit_void();
> +	return status;
> +}
> +
>  static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg)
>  {
>  	printk("Block Group:\n");
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index cafe937..6d6fe36 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -147,4 +147,5 @@ static inline int ocfs2_is_cluster_bitma
>  int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
>  				      struct ocfs2_alloc_context *ac);
>  
> +int ocfs2_volume_resize(struct inode * inode, unsigned long arg);
>  #endif /* _CHAINALLOC_H_ */
> -- 
> 1.3.3
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
