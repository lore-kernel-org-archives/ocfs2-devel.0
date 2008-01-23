From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Jan 2008 22:06:08 -0000
Subject: [Ocfs2-devel] [PATCH 12/30] ocfs2: Add group extend for online
	resize
In-Reply-To: <1200609356-17788-13-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
	<1200609356-17788-13-git-send-email-mark.fasheh@oracle.com>
Message-ID: <20080123140548.95c5bbdf.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, tao.ma@oracle.com

> On Thu, 17 Jan 2008 14:35:38 -0800 Mark Fasheh <mark.fasheh@oracle.com> wrote:
> From: Tao Ma <tao.ma@oracle.com>
> 
> This patch adds the ability for a userspace program to request an extend of
> last cluster group on an Ocfs2 file system. The request is made via ioctl,
> OCFS2_IOC_GROUP_EXTEND. This is derived from EXT3_IOC_GROUP_EXTEND, but is
> obviously Ocfs2 specific.
> 
> tunefs.ocfs2 would call this for an online-resize operation if the last
> cluster group isn't full.
> 
> ...
>
> +/* Check whether the blkno is the super block or one of the backups. */
> +static inline void ocfs2_check_super_or_backup(struct super_block *sb,
> +					       sector_t blkno)
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

ow, harsh.

> +}

ocfs2_check_super_or_backup() is too large to inline.  As is
ocfs2_backup_super_blkno() and probably lots of other stuff.

Should ocfs2_backup_super_blkno() return sector_t?

The dual implementation of ocfs2_backup_super_blkno() is sad.

> +/*
> + * Write super block and bakcups doesn't need to collaborate with journal,

Sitll cnat tpye.

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
> +	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
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
> +		ret = -EIO;
> +		brelse(bh);

Only use brelse() when the bh might be NULL.  put_bh() is cleaner and quicker.

> +	}
> +
> +out:
> +	mlog_exit(ret);
> +	return ret;
> +}

Did we just reimplement sync_dirty_buffer()?

> +						     first_new_cluster,
> +						     cl_cpg, 1);
> +		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
> +	}
> +
> +	ret = ocfs2_journal_dirty(handle, group_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_rollback;
> +	}
> +
> +	/* update the inode accordingly. */
> +	ret = ocfs2_journal_access(handle, bm_inode, bm_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_rollback;
> +	}
> +
> +	chain = le16_to_cpu(group->bg_chain);
> +	cr = (&cl->cl_recs[chain]);
> +	le32_add_cpu(&cr->c_total, num_bits);
> +	le32_add_cpu(&cr->c_free, num_bits);
> +	le32_add_cpu(&fe->id1.bitmap1.i_total, num_bits);
> +	le32_add_cpu(&fe->i_clusters, new_clusters);
> +
> +	if (backups) {
> +		le32_add_cpu(&cr->c_free, -1 * backups);
> +		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
> +	}
> +
> +	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
> +	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> +	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
> +	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
> +	i_size_write(bm_inode, le64_to_cpu(fe->i_size));

Is i_mutex held here?  If not, i_size_write() can cause i_size_read()
deadlocks.

> +	ocfs2_journal_dirty(handle, bm_bh);
> +
> +out_rollback:
> +	if (ret < 0) {
> +		ocfs2_calc_new_backup_super(bm_inode,
> +					    group,
> +					    new_clusters,
> +					    first_new_cluster,
> +					    cl_cpg, 0);
> +		le16_add_cpu(&group->bg_free_bits_count, backups);
> +		le16_add_cpu(&group->bg_bits, -1 * num_bits);
> +		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
> +	}
> +out:
> +	mlog_exit(ret);
> +	return ret;
> +}
> +
> +static int update_backups(struct inode * inode, u32 clusters, char *data)
> +{
> +	int i, ret = 0;
> +	u32 cluster;
> +	u64 blkno;
> +	struct buffer_head *backup = NULL;
> +	struct ocfs2_dinode *backup_di = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	/* calculate the real backups we need to update. */
> +	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
> +		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
> +		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
> +		 if (cluster > clusters)

stray whitespace here.  checkpatch doesn't (probably can't) detect this. 
But you apparently don't run checkpatch anwyay..

> +			break;
> +
> +		ret = ocfs2_read_block(osb, blkno, &backup, 0, NULL);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		}
> +
> +		memcpy(backup->b_data, data, inode->i_sb->s_blocksize);
> +
> +		backup_di = (struct ocfs2_dinode *)backup->b_data;
> +		backup_di->i_blkno = cpu_to_le64(blkno);
> +
> +		ret = ocfs2_write_super_or_backup(osb, backup);
> +		brelse(backup);
> +		backup = NULL;
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void ocfs2_update_super_and_backups(struct inode *inode,
> +					   int new_clusters)
> +{
> +	int ret;
> +	u32 clusters = 0;
> +	struct buffer_head *super_bh = NULL;
> +	struct ocfs2_dinode *super_di = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	/*
> +	 * update the superblock last.
> +	 * It doesn't matter if the write failed.
> +	 */
> +	ret = ocfs2_read_block(osb, OCFS2_SUPER_BLOCK_BLKNO,
> +			       &super_bh, 0, NULL);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	super_di = (struct ocfs2_dinode *)super_bh->b_data;
> +	le32_add_cpu(&super_di->i_clusters, new_clusters);
> +	clusters = le32_to_cpu(super_di->i_clusters);
> +
> +	ret = ocfs2_write_super_or_backup(osb, super_bh);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (OCFS2_HAS_COMPAT_FEATURE(osb->sb, OCFS2_FEATURE_COMPAT_BACKUP_SB))
> +		ret = update_backups(inode, clusters, super_bh->b_data);
> +
> +out:
> +	if (super_bh)
> +		brelse(super_bh);

brelse() already checks for non-NULL.

> +	if (ret)
> +		printk(KERN_WARNING "ocfs2: Failed to update super blocks on %s"
> +			" during fs resize. This condition is not fatal,"
> +			" but fsck.ocfs2 should be run to fix it\n",
> +			osb->dev_str);
> +	return;
> +}
> +
> +/*
> + * Extend the filesystem to the new number of clusters specified.  This entry
> + * point is only used to extend the current filesystem to the end of the last
> + * existing group.
> + */
> +int ocfs2_group_extend(struct inode * inode, int new_clusters)
> +{
> +	int ret;
> +	handle_t *handle;
> +	struct buffer_head *main_bm_bh = NULL;
> +	struct buffer_head *group_bh = NULL;
> +	struct inode *main_bm_inode = NULL;
> +	struct ocfs2_dinode *fe = NULL;
> +	struct ocfs2_group_desc *group = NULL;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	u16 cl_bpc;
> +	u32 first_new_cluster;
> +	u64 lgd_blkno;
> +
> +	mlog_entry_void();
> +
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
> +	if (new_clusters < 0)
> +		return -EINVAL;
> +	else if (new_clusters == 0)
> +		return 0;
> +
> +	main_bm_inode = ocfs2_get_system_file_inode(osb,
> +						    GLOBAL_BITMAP_SYSTEM_INODE,
> +						    OCFS2_INVALID_SLOT);
> +	if (!main_bm_inode) {
> +		ret = -EINVAL;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	mutex_lock(&main_bm_inode->i_mutex);
> +
> +	ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		goto out_mutex;
> +	}
> +
> +	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;

No space

> +	group = (struct ocfs2_group_desc *) group_bh->b_data;

Space.

no-space is more-common/preferred.

> +	ret = ocfs2_check_group_descriptor(inode->i_sb, fe, group);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_unlock;
> +	}
> +
> +	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> +	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
> +		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	mlog(0, "extend the last group at %llu, new clusters = %d\n",
> +	     le64_to_cpu(group->bg_blkno), new_clusters);
> +
> +	handle = ocfs2_start_trans(osb, OCFS2_GROUP_EXTEND_CREDITS);
> +	if (IS_ERR(handle)) {
> +		mlog_errno(PTR_ERR(handle));
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* update the last group descriptor and inode. */
> +	ret = ocfs2_update_last_group_and_inode(handle, main_bm_inode,
> +						main_bm_bh, group_bh,
> +						first_new_cluster,
> +						new_clusters);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	ocfs2_update_super_and_backups(main_bm_inode, new_clusters);
> +
> +out_commit:
> +	ocfs2_commit_trans(osb, handle);
> +out_unlock:
> +	if (group_bh)
> +		brelse(group_bh);
> +
> +	if (main_bm_bh)
> +		brelse(main_bm_bh);

see above.

> +	ocfs2_inode_unlock(main_bm_inode, 1);
> +
> +out_mutex:
> +	mutex_unlock(&main_bm_inode->i_mutex);
> +	iput(main_bm_inode);
> +
> +out:
> +	mlog_exit_void();
> +	return ret;
> +}
