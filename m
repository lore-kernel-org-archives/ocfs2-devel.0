From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Dec 2008 16:11:38 -0800
Subject: [Ocfs2-devel] [PATCH 23/56] ocfs2: Implementation of local and
 global quota file handling
In-Reply-To: <1229982517-3455-24-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-24-git-send-email-mfasheh@suse.com>
Message-ID: <20081222161138.779cbffa.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, jack@suse.cz

On Mon, 22 Dec 2008 13:48:04 -0800
Mark Fasheh <mfasheh@suse.com> wrote:

> From: Jan Kara <jack@suse.cz>
> 
> For each quota type each node has local quota file. In this file it stores
> changes users have made to disk usage via this node. Once in a while this
> information is synced to global file (and thus with other nodes) so that
> limits enforcement at least aproximately works.
> 
> Global quota files contain all the information about usage and limits. It's
> mostly handled by the generic VFS code (which implements a trie of structures
> inside a quota file). We only have to provide functions to convert structures
> from on-disk format to in-memory one. We also have to provide wrappers for
> various quota functions starting transactions and acquiring necessary cluster
> locks before the actual IO is really started.
> 
> +static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
> +{
> +	struct ocfs2_qinfo_lvb *lvb;
> +	struct ocfs2_mem_dqinfo *oinfo = ocfs2_lock_res_qinfo(lockres);
> +	struct mem_dqinfo *info = sb_dqinfo(oinfo->dqi_gi.dqi_sb,
> +					    oinfo->dqi_gi.dqi_type);
> +
> +	mlog_entry_void();
> +
> +	lvb = (struct ocfs2_qinfo_lvb *)ocfs2_dlm_lvb(&lockres->l_lksb);

Unneeded cast.

> +	lvb->lvb_version = OCFS2_QINFO_LVB_VERSION;
> +	lvb->lvb_bgrace = cpu_to_be32(info->dqi_bgrace);
> +	lvb->lvb_igrace = cpu_to_be32(info->dqi_igrace);
> +	lvb->lvb_syncms = cpu_to_be32(oinfo->dqi_syncms);
> +	lvb->lvb_blocks = cpu_to_be32(oinfo->dqi_gi.dqi_blocks);
> +	lvb->lvb_free_blk = cpu_to_be32(oinfo->dqi_gi.dqi_free_blk);
> +	lvb->lvb_free_entry = cpu_to_be32(oinfo->dqi_gi.dqi_free_entry);
> +
> +	mlog_exit_void();
> +}
> +
> +void ocfs2_qinfo_unlock(struct ocfs2_mem_dqinfo *oinfo, int ex)
> +{
> +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> +	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
> +	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> +
> +	mlog_entry_void();
> +	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
> +		ocfs2_cluster_unlock(osb, lockres, level);
> +	mlog_exit_void();
> +}
> +
> +static int ocfs2_refresh_qinfo(struct ocfs2_mem_dqinfo *oinfo)
> +{
> +	struct mem_dqinfo *info = sb_dqinfo(oinfo->dqi_gi.dqi_sb,
> +					    oinfo->dqi_gi.dqi_type);
> +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> +	struct ocfs2_qinfo_lvb *lvb = ocfs2_dlm_lvb(&lockres->l_lksb);

yeah, like that ;)

> +	struct buffer_head *bh;
> +	struct ocfs2_global_disk_dqinfo *gdinfo;
> +	int status = 0;
> +
> +	if (lvb->lvb_version == OCFS2_QINFO_LVB_VERSION) {
> +		info->dqi_bgrace = be32_to_cpu(lvb->lvb_bgrace);
> +		info->dqi_igrace = be32_to_cpu(lvb->lvb_igrace);
> +		oinfo->dqi_syncms = be32_to_cpu(lvb->lvb_syncms);
> +		oinfo->dqi_gi.dqi_blocks = be32_to_cpu(lvb->lvb_blocks);
> +		oinfo->dqi_gi.dqi_free_blk = be32_to_cpu(lvb->lvb_free_blk);
> +		oinfo->dqi_gi.dqi_free_entry =
> +					be32_to_cpu(lvb->lvb_free_entry);
> +	} else {
> +		bh = ocfs2_read_quota_block(oinfo->dqi_gqinode, 0, &status);
> +		if (!bh) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +		gdinfo = (struct ocfs2_global_disk_dqinfo *)
> +					(bh->b_data + OCFS2_GLOBAL_INFO_OFF);
> +		info->dqi_bgrace = le32_to_cpu(gdinfo->dqi_bgrace);
> +		info->dqi_igrace = le32_to_cpu(gdinfo->dqi_igrace);
> +		oinfo->dqi_syncms = le32_to_cpu(gdinfo->dqi_syncms);
> +		oinfo->dqi_gi.dqi_blocks = le32_to_cpu(gdinfo->dqi_blocks);
> +		oinfo->dqi_gi.dqi_free_blk = le32_to_cpu(gdinfo->dqi_free_blk);
> +		oinfo->dqi_gi.dqi_free_entry =
> +					le32_to_cpu(gdinfo->dqi_free_entry);
> +		brelse(bh);

put_bh() is more efficient and modern, in the case where bh is known to
not be NULL.

> +		ocfs2_track_lock_refresh(lockres);
> +	}
> +
> +bail:
> +	return status;
> +}
> +
> +/* Lock quota info, this function expects at least shared lock on the quota file
> + * so that we can safely refresh quota info from disk. */
> +int ocfs2_qinfo_lock(struct ocfs2_mem_dqinfo *oinfo, int ex)
> +{
> +	struct ocfs2_lock_res *lockres = &oinfo->dqi_gqlock;
> +	struct ocfs2_super *osb = OCFS2_SB(oinfo->dqi_gi.dqi_sb);
> +	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> +	int status = 0;
> +
> +	mlog_entry_void();
> +
> +	/* On RO devices, locking really isn't needed... */
> +	if (ocfs2_is_hard_readonly(osb)) {
> +		if (ex)
> +			status = -EROFS;
> +		goto bail;
> +	}
> +	if (ocfs2_mount_local(osb))
> +		goto bail;

This is not an error case?

> +
> +	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +	if (!ocfs2_should_refresh_lock_res(lockres))
> +		goto bail;

ditto?

> +	/* OK, we have the lock but we need to refresh the quota info */
> +	status = ocfs2_refresh_qinfo(oinfo);
> +	if (status)
> +		ocfs2_qinfo_unlock(oinfo, ex);
> +	ocfs2_complete_lock_res_refresh(lockres, status);
> +bail:
> +	mlog_exit(status);
> +	return status;
> +}
> +
>
> ...
>
> +ssize_t ocfs2_quota_read(struct super_block *sb, int type, char *data,
> +			 size_t len, loff_t off)
> +{
> +	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
> +	struct inode *gqinode = oinfo->dqi_gqinode;
> +	loff_t i_size = i_size_read(gqinode);
> +	int offset = off & (sb->s_blocksize - 1);
> +	sector_t blk = off >> sb->s_blocksize_bits;
> +	int err = 0;
> +	struct buffer_head *bh;
> +	size_t toread, tocopy;
> +
> +	if (off > i_size)
> +		return 0;
> +	if (off + len > i_size)
> +		len = i_size - off;
> +	toread = len;
> +	while (toread > 0) {
> +		tocopy = min((size_t)(sb->s_blocksize - offset), toread);

min_t is preferred.

> +		bh = ocfs2_read_quota_block(gqinode, blk, &err);
> +		if (!bh) {
> +			mlog_errno(err);
> +			return err;
> +		}
> +		memcpy(data, bh->b_data + offset, tocopy);
> +		brelse(bh);
> +		offset = 0;
> +		toread -= tocopy;
> +		data += tocopy;
> +		blk++;
> +	}
> +	return len;
> +}
> +
> +/* Write to quotafile (we know the transaction is already started and has
> + * enough credits) */
> +ssize_t ocfs2_quota_write(struct super_block *sb, int type,
> +			  const char *data, size_t len, loff_t off)
> +{
> +	struct mem_dqinfo *info = sb_dqinfo(sb, type);
> +	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
> +	struct inode *gqinode = oinfo->dqi_gqinode;
> +	int offset = off & (sb->s_blocksize - 1);
> +	sector_t blk = off >> sb->s_blocksize_bits;

does ocfs2 attempt to support CONFIG_LBD=n?

> +	int err = 0, new = 0;
> +	struct buffer_head *bh;
> +	handle_t *handle = journal_current_handle();
> +
>
> ...
>
> +	lock_buffer(bh);
> +	if (new)
> +		memset(bh->b_data, 0, sb->s_blocksize);
> +	memcpy(bh->b_data + offset, data, len);
> +	flush_dcache_page(bh->b_page);
> +	unlock_buffer(bh);
> +	ocfs2_set_buffer_uptodate(gqinode, bh);
> +	err = ocfs2_journal_dirty(handle, bh);
> +	brelse(bh);

lots of put_bh()'s

> +	if (err < 0)
> +		goto out;
> +out:
> +	if (err) {
> +		mutex_unlock(&gqinode->i_mutex);
> +		mlog_errno(err);
> +		return err;
> +	}
> +	gqinode->i_version++;
> +	ocfs2_mark_inode_dirty(handle, gqinode, oinfo->dqi_gqi_bh);
> +	mutex_unlock(&gqinode->i_mutex);
> +	return len;
> +}
> +
>
> ...
>

gee, what a lot of code.
