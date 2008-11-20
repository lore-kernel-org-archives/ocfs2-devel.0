From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Nov 2008 17:51:52 +0100
Subject: [Ocfs2-devel] [PATCH 28/29] ocfs2: Implement quota recovery
In-Reply-To: <20081106005227.GZ15154@wotan.suse.de>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861051546-git-send-email-jack@suse.cz>
	<20081106005227.GZ15154@wotan.suse.de>
Message-ID: <20081120165152.GE20118@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 05-11-08 16:52:27, Mark Fasheh wrote:
> On Sat, Oct 25, 2008 at 12:08:21AM +0200, Jan Kara wrote:
> > Implement functions for recovery after a crash. Functions just
> > read local quota file and sync info to global quota file.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/journal.c      |  105 +++++++++---
> >  fs/ocfs2/journal.h      |    1 +
> >  fs/ocfs2/ocfs2.h        |    4 +-
> >  fs/ocfs2/quota.h        |   21 +++
> >  fs/ocfs2/quota_global.c |    1 -
> >  fs/ocfs2/quota_local.c  |  430 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  6 files changed, 530 insertions(+), 32 deletions(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index f3d7c15..d928db9 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -45,6 +45,7 @@
> >  #include "slot_map.h"
> >  #include "super.h"
> >  #include "sysfile.h"
> > +#include "quota.h"
> >  
> >  #include "buffer_head_io.h"
> >  
> > @@ -52,7 +53,7 @@ DEFINE_SPINLOCK(trans_inc_lock);
> >  
> >  static int ocfs2_force_read_journal(struct inode *inode);
> >  static int ocfs2_recover_node(struct ocfs2_super *osb,
> > -			      int node_num);
> > +			      int node_num, int slot_num);
> >  static int __ocfs2_recovery_thread(void *arg);
> >  static int ocfs2_commit_cache(struct ocfs2_super *osb);
> >  static int ocfs2_wait_on_mount(struct ocfs2_super *osb);
> > @@ -877,6 +878,7 @@ struct ocfs2_la_recovery_item {
> >  	int			lri_slot;
> >  	struct ocfs2_dinode	*lri_la_dinode;
> >  	struct ocfs2_dinode	*lri_tl_dinode;
> > +	struct ocfs2_quota_recovery *lri_qrec;
> >  };
> >  
> >  /* Does the second half of the recovery process. By this point, the
> > @@ -897,6 +899,7 @@ void ocfs2_complete_recovery(struct work_struct *work)
> >  	struct ocfs2_super *osb = journal->j_osb;
> >  	struct ocfs2_dinode *la_dinode, *tl_dinode;
> >  	struct ocfs2_la_recovery_item *item, *n;
> > +	struct ocfs2_quota_recovery *qrec;
> >  	LIST_HEAD(tmp_la_list);
> >  
> >  	mlog_entry_void();
> > @@ -942,6 +945,16 @@ void ocfs2_complete_recovery(struct work_struct *work)
> >  		if (ret < 0)
> >  			mlog_errno(ret);
> >  
> > +		qrec = item->lri_qrec;
> > +		if (qrec) {
> > +			mlog(0, "Recovering quota files");
> > +			ret = ocfs2_finish_quota_recovery(osb, qrec,
> > +							  item->lri_slot);
> > +			if (ret < 0)
> > +				mlog_errno(ret);
> > +			/* Recovery info is already freed now */
> > +		}
> > +
> >  		kfree(item);
> >  	}
> >  
> > @@ -955,7 +968,8 @@ void ocfs2_complete_recovery(struct work_struct *work)
> >  static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
> >  					    int slot_num,
> >  					    struct ocfs2_dinode *la_dinode,
> > -					    struct ocfs2_dinode *tl_dinode)
> > +					    struct ocfs2_dinode *tl_dinode,
> > +					    struct ocfs2_quota_recovery *qrec)
> >  {
> >  	struct ocfs2_la_recovery_item *item;
> >  
> > @@ -970,6 +984,9 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
> >  		if (tl_dinode)
> >  			kfree(tl_dinode);
> >  
> > +		if (qrec)
> > +			ocfs2_free_quota_recovery(qrec);
> > +
> >  		mlog_errno(-ENOMEM);
> >  		return;
> >  	}
> > @@ -978,6 +995,7 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
> >  	item->lri_la_dinode = la_dinode;
> >  	item->lri_slot = slot_num;
> >  	item->lri_tl_dinode = tl_dinode;
> > +	item->lri_qrec = qrec;
> >  
> >  	spin_lock(&journal->j_lock);
> >  	list_add_tail(&item->lri_list, &journal->j_la_cleanups);
> > @@ -997,6 +1015,7 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
> >  		ocfs2_queue_recovery_completion(journal,
> >  						osb->slot_num,
> >  						osb->local_alloc_copy,
> > +						NULL,
> >  						NULL);
> >  		ocfs2_schedule_truncate_log_flush(osb, 0);
> >  
> > @@ -1005,11 +1024,26 @@ void ocfs2_complete_mount_recovery(struct ocfs2_super *osb)
> >  	}
> >  }
> >  
> > +void ocfs2_complete_quota_recovery(struct ocfs2_super *osb)
> > +{
> > +	if (osb->quota_rec) {
> > +		ocfs2_queue_recovery_completion(osb->journal,
> > +						osb->slot_num,
> > +						NULL,
> > +						NULL,
> > +						osb->quota_rec);
> > +		osb->quota_rec = NULL;
> > +	}
> > +}
> > +
> >  static int __ocfs2_recovery_thread(void *arg)
> >  {
> > -	int status, node_num;
> > +	int status, node_num, slot_num;
> >  	struct ocfs2_super *osb = arg;
> >  	struct ocfs2_recovery_map *rm = osb->recovery_map;
> > +	int *rm_quota = NULL;
> > +	int rm_quota_used = 0, i;
> > +	struct ocfs2_quota_recovery *qrec;
> >  
> >  	mlog_entry_void();
> >  
> > @@ -1018,6 +1052,11 @@ static int __ocfs2_recovery_thread(void *arg)
> >  		goto bail;
> >  	}
> >  
> > +	rm_quota = kzalloc(osb->max_slots * sizeof(int), GFP_NOFS);
> > +	if (!rm_quota) {
> > +		status = -ENOMEM;
> > +		goto bail;
> > +	}
> >  restart:
> >  	status = ocfs2_super_lock(osb, 1);
> >  	if (status < 0) {
> > @@ -1031,8 +1070,28 @@ restart:
> >  		 * clear it until ocfs2_recover_node() has succeeded. */
> >  		node_num = rm->rm_entries[0];
> >  		spin_unlock(&osb->osb_lock);
> > -
> > -		status = ocfs2_recover_node(osb, node_num);
> > +		mlog(0, "checking node %d\n", node_num);
> > +		slot_num = ocfs2_node_num_to_slot(osb, node_num);
> > +		if (slot_num == -ENOENT) {
> > +			status = 0;
> > +			mlog(0, "no slot for this node, so no recovery"
> > +			     "required.\n");
> > +			goto skip_recovery;
> > +		}
> > +		mlog(0, "node %d was using slot %d\n", node_num, slot_num);
> > +
> > +		/* It is a bit subtle with quota recovery. We cannot do it
> > +		 * immediately because we have to obtain cluster locks from
> > +		 * quota files and we also don't want to just skip it because
> > +		 * then quota usage would be out of sync until some node takes
> > +		 * the slot. So we remember which nodes need quota recovery
> > +		 * and when everything else is done, we recover quotas. */
> > +		for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
> > +		if (i == rm_quota_used)
> > +			rm_quota[rm_quota_used++] = slot_num;
> > +
> > +		status = ocfs2_recover_node(osb, node_num, slot_num);
> > +skip_recovery:
> >  		if (!status) {
> >  			ocfs2_recovery_map_clear(osb, node_num);
> >  		} else {
> > @@ -1056,11 +1115,22 @@ restart:
> >  
> >  	ocfs2_super_unlock(osb, 1);
> >  
> > +	/* Now it is right time to recover quotas... */
> > +	for (i = 0; i < rm_quota_used; i++) {
> > +		qrec = ocfs2_begin_quota_recovery(osb, rm_quota[i]);
> > +		if (IS_ERR(qrec)) {
> > +			status = PTR_ERR(qrec);
> > +			mlog_errno(status);
> > +		}
> > +		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
> > +						NULL, NULL, qrec);
> > +	}
> 
> I think we want to do this *within* the super block cluster lock. What if a
> node mounts and then crashes (with quota file changes in it's journal) in
> between ocfs2_super_unlock(osb, 1) and the call in
> ocfs2_begin_quota_recovery()? We'd get the cluster lock, but the quota file
> info would be stale because we'd have an unrecovered slot.
  I'm not sure I see the problem (which is probably because I miss
something in the recovery code). When node is using its local quota file,
it has a cluster lock from it. So as soon as it has some modifications of
it in its journal, it also holds its lock. So I thought that if this node
crashes, noone can obtain lock from the quota file before the journal of
the node is replayed. Or is it otherwise?
  The only problem I can see is that if node doing recovery crashes in the
place you describe, data in the local quota file will remain unsynced
until somebody starts using the slot. Maybe you meant this bug. But then I
don't see how moving inside super block cluster lock will help it. Argh,
this is nasty. Probably we'll have to do what you once proposed - i.e.,
scanning all slots in the cluster and check whether quota files don't need
recovery in them...

> Also, we call ocfs2_queue_recovery_completion() here even when quota isn't
> enabled on the file system. Perhaps ocfs2_begin_quota_recovery() should
> return NULL in that case and we can skip the recovery_completion. Otherwise
> I think we're just running it against an empty qrec, which seems like a bug
> too.
  This might be slightly suboptimal but is handled just fine AFAICS.

> > +/* Load information we need for quota recovery into memory */
> > +struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
> > +						struct ocfs2_super *osb,
> > +						int slot_num)
> > +{
> > +	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
> > +					    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
> > +	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
> > +					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
> > +	struct super_block *sb = osb->sb;
> > +	struct ocfs2_local_disk_dqinfo *ldinfo;
> > +	struct inode *lqinode;
> > +	struct buffer_head *bh;
> > +	int type;
> > +	int status;
> > +	struct ocfs2_quota_recovery *rec;
> > +
> > +	mlog(ML_NOTICE, "Beginning quota recovery in slot %u\n", slot_num);
> > +	rec = ocfs2_alloc_quota_recovery();
> > +	if (!rec)
> > +		return ERR_PTR(-ENOMEM);
> > +	/* First init... */
> > +
> > +	for (type = 0; type < MAXQUOTAS; type++) {
> > +		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
> > +			continue;
> > +		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
> > +		if (!lqinode) {
> > +			status = -ENOENT;
> > +			goto out;
> > +		}
> 
> Can we add a comment here saying that we've already recovered the journal, so local
> quota file meta data is up to date and can be trusted?
  OK.

> > +		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
> > +						       OCFS2_META_LOCK_NOQUEUE);
> 
> I think you also want to add OCFS2_META_LOCK_RECOVERY here, otherwise we'll
> hang if another node dies before we get the lock.
  Because our recovery thread would get stuck waiting for recovery, I see.
But I really have to be sure that the journal for the slot has been
replayed... OK, but when this is done under super block cluster lock, noone
can really start using the slot before we get to
ocfs2_begin_quota_recovery() so that should be fine. We even should not
need NOQUEUE because if someone starts using the slot, we would not start
recovering it and thus would not get to ocfs2_begin_quota_recovery().

> > +		/* Someone else is holding the lock? Then he must be
> > +		 * doing the recovery. Just skip the file... */
> > +		if (status == -EAGAIN) {
> > +			mlog(ML_NOTICE, "skipping quota recovery for slot %d "
> > +			     "because quota file is locked.\n", slot_num);
> > +			status = 0;
> > +			goto out_put;
> > +		} else if (status < 0) {
> > +			mlog_errno(status);
> > +			goto out_put;
> > +		}
> > +		/* Now read local header */
> > +		bh = ocfs2_read_quota_block(lqinode, 0, &status);
> > +		if (!bh) {
> > +			mlog_errno(status);
> > +			mlog(ML_ERROR, "failed to read quota file info header "
> > +				"(slot=%d type=%d)\n", slot_num, type);
> > +			goto out_lock;
> > +		}
> > +		ldinfo = (struct ocfs2_local_disk_dqinfo *)(bh->b_data +
> > +							OCFS2_LOCAL_INFO_OFF);
> > +		status = ocfs2_recovery_load_quota(lqinode, ldinfo, type,
> > +						   &rec->r_list[type]);
> > +		brelse(bh);
> > +out_lock:
> > +		ocfs2_inode_unlock(lqinode, 1);
> > +out_put:
> > +		iput(lqinode);
> > +		if (status < 0)
> > +			break;
> > +	}
> > +out:
> > +	if (status < 0) {
> > +		ocfs2_free_quota_recovery(rec);
> > +		rec = ERR_PTR(status);
> > +	}
> > +	return rec;
> > +}
> > +
> > +/* Sync changes in local quota file into global quota file and
> > + * reinitialize local quota file.
> > + * The function expects local quota file to be already locked and
> > + * dqonoff_mutex locked. */
> > +static int ocfs2_recover_local_quota_file(struct inode *lqinode,
> > +					  int type,
> > +					  struct ocfs2_quota_recovery *rec)
> > +{
> > +	struct super_block *sb = lqinode->i_sb;
> > +	struct ocfs2_mem_dqinfo *oinfo = sb_dqinfo(sb, type)->dqi_priv;
> > +	struct ocfs2_local_disk_chunk *dchunk;
> > +	struct ocfs2_local_disk_dqblk *dqblk;
> > +	struct dquot *dquot;
> > +	handle_t *handle;
> > +	struct buffer_head *hbh = NULL, *qbh = NULL;
> > +	int status = 0;
> > +	int bit, chunk;
> > +	struct ocfs2_recovery_chunk *rchunk, *next;
> > +	qsize_t spacechange, inodechange;
> > +
> > +	mlog_entry("ino=%lu type=%u", (unsigned long)lqinode->i_ino, type);
> > +
> > +	status = ocfs2_lock_global_qf(oinfo, 1);
> > +	if (status < 0)
> > +		goto out;
> > +
> > +	list_for_each_entry_safe(rchunk, next, &(rec->r_list[type]), rc_list) {
> > +		chunk = rchunk->rc_chunk;
> > +		hbh = ocfs2_read_quota_block(lqinode,
> > +					     ol_quota_chunk_block(sb, chunk),
> > +					     &status);
> > +		if (!hbh) {
> > +			mlog_errno(status);
> > +			break;
> > +		}
> > +		dchunk = (struct ocfs2_local_disk_chunk *)hbh->b_data;
> > +		for_each_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
> > +			qbh = ocfs2_read_quota_block(lqinode,
> > +						ol_dqblk_block(sb, chunk, bit),
> > +						&status);
> > +			if (!qbh) {
> > +				mlog_errno(status);
> > +				break;
> > +			}
> > +			dqblk = (struct ocfs2_local_disk_dqblk *)(qbh->b_data +
> > +				ol_dqblk_block_off(sb, chunk, bit));
> > +			dquot = dqget(sb, le64_to_cpu(dqblk->dqb_id), type);
> > +			if (!dquot) {
> > +				status = -EIO;
> > +				mlog(ML_ERROR, "Failed to get quota structure "
> > +				     "for id %u, type %d. Cannot finish quota "
> > +				     "file recovery.\n",
> > +				     (unsigned)le64_to_cpu(dqblk->dqb_id),
> > +				     type);
> > +				goto out_put_bh;
> > +			}
> > +			handle = ocfs2_start_trans(OCFS2_SB(sb),
> > +						   OCFS2_QSYNC_CREDITS);
> > +			if (IS_ERR(handle)) {
> > +				status = PTR_ERR(handle);
> > +				mlog_errno(status);
> > +				goto out_put_dquot;
> > +			}
> > +			mutex_lock(&sb_dqopt(sb)->dqio_mutex);
> > +			spin_lock(&dq_data_lock);
> > +			/* Add usage from quota entry into quota changes
> > +			 * of our node. Auxiliary variables are important
> > +			 * due to signedness */
> > +			spacechange = le64_to_cpu(dqblk->dqb_spacemod);
> > +			inodechange = le64_to_cpu(dqblk->dqb_inodemod);
> > +			dquot->dq_dqb.dqb_curspace += spacechange;
> > +			dquot->dq_dqb.dqb_curinodes += inodechange;
> > +			spin_unlock(&dq_data_lock);
> > +			/* We want to drop reference held by the crashed
> > +			 * node. Since we have our own reference we know
> > +			 * global structure actually won't be freed. */
> > +			status = ocfs2_global_release_dquot(dquot);
> > +			if (status < 0) {
> > +				mlog_errno(status);
> > +				goto out_commit;
> > +			}
> > +			/* Release local quota file entry */
> > +			status = ocfs2_journal_access(handle, lqinode,
> > +					qbh, OCFS2_JOURNAL_ACCESS_WRITE);
> > +			if (status < 0) {
> > +				mlog_errno(status);
> > +				goto out_commit;
> > +			}
> > +			lock_buffer(qbh);
> > +			WARN_ON(!ocfs2_test_bit(bit, dchunk->dqc_bitmap));
> > +			ocfs2_clear_bit(bit, dchunk->dqc_bitmap);
> > +			le32_add_cpu(&dchunk->dqc_free, 1);
> > +			unlock_buffer(qbh);
> > +			status = ocfs2_journal_dirty(handle, qbh);
> > +			if (status < 0)
> > +				mlog_errno(status);
> > +out_commit:
> > +			mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
> > +			ocfs2_commit_trans(OCFS2_SB(sb), handle);
> > +out_put_dquot:
> > +			dqput(dquot);
> > +out_put_bh:
> > +			brelse(qbh);
> > +			if (status < 0)
> > +				break;
> > +		}
> > +		brelse(hbh);
> > +		list_del(&rchunk->rc_list);
> > +		kfree(rchunk->rc_bitmap);
> > +		kfree(rchunk);
> > +		if (status < 0)
> > +			break;
> > +	}
> > +	ocfs2_unlock_global_qf(oinfo, 1);
> > +out:
> > +	if (status < 0)
> > +		free_recovery_list(&(rec->r_list[type]));
> > +	mlog_exit(status);
> > +	return status;
> > +}
> > +
> > +/* Recover local quota files for given node different from us */
> > +int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
> > +				struct ocfs2_quota_recovery *rec,
> > +				int slot_num)
> > +{
> > +	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
> > +					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
> > +	struct super_block *sb = osb->sb;
> > +	struct ocfs2_local_disk_dqinfo *ldinfo;
> > +	struct buffer_head *bh;
> > +	handle_t *handle;
> > +	int type;
> > +	int status = 0;
> > +	struct inode *lqinode;
> > +	unsigned int flags;
> > +
> > +	mlog(ML_NOTICE, "Finishing quota recovery in slot %u\n", slot_num);
> > +	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
> > +	for (type = 0; type < MAXQUOTAS; type++) {
> > +		if (list_empty(&(rec->r_list[type])))
> > +			continue;
> > +		mlog(0, "Recovering quota in slot %d\n", slot_num);
> > +		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
> > +		if (!lqinode) {
> > +			status = -ENOENT;
> > +			goto out;
> > +		}
> > +		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
> > +						       OCFS2_META_LOCK_NOQUEUE);
> > +		/* Someone else is holding the lock? Then he must be
> > +		 * doing the recovery. Just skip the file... */
> 
> Hmm, given that we have to do this for quota recovery completion, what's the
> point of all the work we do in ocfs2_begin_quota_recovery() ?
  I case we are recovering our own slot, we have to know, which entries in
local quota file are just stale entries (used by the node before the crash)
and which are really currently used because we sync and release stale entries
while fs is mounted and node is normally using quota files...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
