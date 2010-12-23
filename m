From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:59 +0800
Subject: [Ocfs2-devel] [PATCH 16/34] ocfs2: Remove masklog ML_INODE.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-16-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/inode.c and the masklog INODE.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/inode.c           |  107 +++++++++------------
 fs/ocfs2/ocfs2_trace.h     |  227 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 273 insertions(+), 63 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index c654038..1c1fa9d 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -99,7 +99,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
 	define_mask(NAMEI),
-	define_mask(INODE),
 	define_mask(VOTE),
 	define_mask(DCACHE),
 	define_mask(CONN),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index de412aa..d6dab10 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -101,7 +101,6 @@
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
 #define ML_NAMEI	0x0000000000400000ULL /* ocfs2 directory / namespace */
-#define ML_INODE	0x0000000000800000ULL /* ocfs2 inode manipulation */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_DCACHE	0x0000000002000000ULL /* ocfs2 dcache operations */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 361efd3..c3b9301 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -31,7 +31,6 @@
 
 #include <asm/byteorder.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -53,6 +52,7 @@
 #include "uptodate.h"
 #include "xattr.h"
 #include "refcounttree.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -131,7 +131,8 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
 
-	mlog(0, "(blkno = %llu)\n", (unsigned long long)blkno);
+	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
+			       sysfile_type);
 
 	/* Ok. By now we've either got the offsets passed to us by the
 	 * caller, or we just pulled them off the bh. Lets do some
@@ -157,8 +158,8 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 		mlog_errno(PTR_ERR(inode));
 		goto bail;
 	}
+	trace_ocfs2_iget5_locked(inode->i_state);
 	if (inode->i_state & I_NEW) {
-		mlog(0, "Inode was not in inode cache, reading it.\n");
 		ocfs2_read_locked_inode(inode, &args);
 		unlock_new_inode(inode);
 	}
@@ -170,9 +171,8 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 
 bail:
 	if (!IS_ERR(inode)) {
-		mlog(0, "returning inode with number %llu\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		mlog(0, "inode %p\n", inode);
+		trace_ocfs2_iget_end(inode, 
+			(unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
 
 	return inode;
@@ -192,12 +192,12 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
 
-	mlog(0, "(0x%p, %lu, 0x%p)\n", inode, inode->i_ino, opaque);
-
 	args = opaque;
 
 	mlog_bug_on_msg(!inode, "No inode in find actor!\n");
 
+	trace_ocfs2_find_actor(inode, inode->i_ino, opaque, args->fi_blkno);
+
 	if (oi->ip_blkno != args->fi_blkno)
 		goto bail;
 
@@ -217,8 +217,6 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
 				     ocfs2_file_ip_alloc_sem_key;
 
-	mlog(0, "inode = %p, opaque = %p\n", inode, opaque);
-
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
 	if (args->fi_sysfile_type != 0)
@@ -244,9 +242,6 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	struct ocfs2_super *osb;
 	int use_plocks = 1;
 
-	mlog(0, "(0x%p, size:%llu)\n", inode,
-	     (unsigned long long)le64_to_cpu(fe->i_size));
-
 	sb = inode->i_sb;
 	osb = OCFS2_SB(sb);
 
@@ -298,20 +293,20 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 
 	inode->i_nlink = ocfs2_read_links_count(fe);
 
+	trace_ocfs2_populate_inode(OCFS2_I(inode)->ip_blkno,
+				   le32_to_cpu(fe->i_flags));
 	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SYSTEM_FILE;
 		inode->i_flags |= S_NOQUOTA;
 	}
-
+  
 	if (fe->i_flags & cpu_to_le32(OCFS2_LOCAL_ALLOC_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
-		mlog(0, "local alloc inode: i_ino=%lu\n", inode->i_ino);
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_BITMAP_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_BITMAP;
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
 		inode->i_flags |= S_NOQUOTA;
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
-		mlog(0, "superblock inode: i_ino=%lu\n", inode->i_ino);
 		/* we can't actually hit this as read_inode can't
 		 * handle superblocks today ;-) */
 		BUG();
@@ -391,8 +386,6 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	int status, can_lock;
 	u32 generation = 0;
 
-	mlog(0, "(0x%p, 0x%p)\n", inode, args);
-
 	status = -EINVAL;
 	if (inode == NULL || inode->i_sb == NULL) {
 		mlog(ML_ERROR, "bad inode\n");
@@ -440,6 +433,9 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 		&& !(args->fi_flags & OCFS2_FI_FLAG_ORPHAN_RECOVERY)
 		&& !ocfs2_mount_local(osb);
 
+	trace_ocfs2_read_locked_inode(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno, can_lock);
+
 	/*
 	 * To maintain backwards compatibility with older versions of
 	 * ocfs2-tools, we still store the generation value for system
@@ -689,8 +685,6 @@ static int ocfs2_check_orphan_recovery_state(struct ocfs2_super *osb,
 
 	spin_lock(&osb->osb_lock);
 	if (ocfs2_node_map_test_bit(osb, &osb->osb_recovering_orphan_dirs, slot)) {
-		mlog(0, "Recovery is happening on orphan dir %d, will skip "
-		     "this inode\n", slot);
 		ret = -EDEADLK;
 		goto out;
 	}
@@ -699,6 +693,7 @@ static int ocfs2_check_orphan_recovery_state(struct ocfs2_super *osb,
 	osb->osb_orphan_wipes[slot]++;
 out:
 	spin_unlock(&osb->osb_lock);
+	trace_ocfs2_check_orphan_recovery_state(slot, ret);
 	return ret;
 }
 
@@ -809,6 +804,10 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
+	trace_ocfs2_inode_is_valid_to_delete(current, osb->dc_task,
+					     (unsigned long long)oi->ip_blkno,
+					     oi->ip_flags);
+
 	/* We shouldn't be getting here for the root directory
 	 * inode.. */
 	if (inode == osb->root_inode) {
@@ -821,11 +820,8 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 	 * have to skip deleting this guy. That's OK though because
 	 * the node who's doing the actual deleting should handle it
 	 * anyway. */
-	if (current == osb->dc_task) {
-		mlog(0, "Skipping delete of %lu because we're currently "
-		     "in downconvert\n", inode->i_ino);
+	if (current == osb->dc_task)
 		goto bail;
-	}
 
 	spin_lock(&oi->ip_lock);
 	/* OCFS2 *never* deletes system files. This should technically
@@ -840,11 +836,8 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 	/* If we have allowd wipe of this inode for another node, it
 	 * will be marked here so we can safely skip it. Recovery will
 	 * cleanup any inodes we might inadvertantly skip here. */
-	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE) {
-		mlog(0, "Skipping delete of %lu because another node "
-		     "has done this for us.\n", inode->i_ino);
+	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE)
 		goto bail_unlock;
-	}
 
 	ret = 1;
 bail_unlock:
@@ -861,28 +854,27 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 				  struct buffer_head *di_bh,
 				  int *wipe)
 {
-	int status = 0;
+	int status = 0, reason = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di;
 
 	*wipe = 0;
 
+	trace_ocfs2_query_inode_wipe_begin((unsigned long long)oi->ip_blkno,
+					   inode->i_nlink);
+
 	/* While we were waiting for the cluster lock in
 	 * ocfs2_delete_inode, another node might have asked to delete
 	 * the inode. Recheck our flags to catch this. */
 	if (!ocfs2_inode_is_valid_to_delete(inode)) {
-		mlog(0, "Skipping delete of %llu because flags changed\n",
-		     (unsigned long long)oi->ip_blkno);
+		reason = 1;
 		goto bail;
 	}
 
 	/* Now that we have an up to date inode, we can double check
 	 * the link count. */
-	if (inode->i_nlink) {
-		mlog(0, "Skipping delete of %llu because nlink = %u\n",
-		     (unsigned long long)oi->ip_blkno, inode->i_nlink);
+	if (inode->i_nlink)
 		goto bail;
-	}
 
 	/* Do some basic inode verification... */
 	di = (struct ocfs2_dinode *) di_bh->b_data;
@@ -897,9 +889,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 		 * ORPHANED_FL not.
 		 */
 		if (di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) {
-			mlog(0, "Reflinked inode %llu is no longer orphaned.  "
-			     "it shouldn't be deleted\n",
-			     (unsigned long long)oi->ip_blkno);
+			reason = 2;
 			goto bail;
 		}
 
@@ -936,8 +926,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	status = ocfs2_try_open_lock(inode, 1);
 	if (status == -EAGAIN) {
 		status = 0;
-		mlog(0, "Skipping delete of %llu because it is in use on "
-		     "other nodes\n", (unsigned long long)oi->ip_blkno);
+		reason = 3;
 		goto bail;
 	}
 	if (status < 0) {
@@ -946,11 +935,10 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	}
 
 	*wipe = 1;
-	mlog(0, "Inode %llu is ok to wipe from orphan dir %u\n",
-	     (unsigned long long)oi->ip_blkno,
-	     le16_to_cpu(di->i_orphaned_slot));
+	trace_ocfs2_query_inode_wipe_succ(le16_to_cpu(di->i_orphaned_slot));
 
 bail:
+	trace_ocfs2_query_inode_wipe_end(status, reason);
 	return status;
 }
 
@@ -960,8 +948,8 @@ bail:
 static void ocfs2_cleanup_delete_inode(struct inode *inode,
 				       int sync_data)
 {
-	mlog(0, "Cleanup inode %llu, sync = %d\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, sync_data);
+	trace_ocfs2_cleanup_delete_inode(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno, sync_data);
 	if (sync_data)
 		write_inode_now(inode, 1);
 	truncate_inode_pages(&inode->i_data, 0);
@@ -973,15 +961,15 @@ static void ocfs2_delete_inode(struct inode *inode)
 	sigset_t oldset;
 	struct buffer_head *di_bh = NULL;
 
-	mlog(0, "(inode->i_ino = %lu)\n", inode->i_ino);
+	trace_ocfs2_delete_inode(inode->i_ino,
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				 is_bad_inode(inode));
 
 	/* When we fail in read_inode() we mark inode as bad. The second test
 	 * catches the case when inode allocation fails before allocating
 	 * a block for inode. */
-	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno) {
-		mlog(0, "Skipping delete of bad inode\n");
+	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno)
 		goto bail;
-	}
 
 	dquot_initialize(inode);
 
@@ -1082,8 +1070,8 @@ static void ocfs2_clear_inode(struct inode *inode)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	end_writeback(inode);
-	mlog(0, "Clearing inode: %llu, nlink = %u\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_nlink);
+	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
+				inode->i_nlink);
 
 	mlog_bug_on_msg(OCFS2_SB(inode->i_sb) == NULL,
 			"Inode=%lu\n", inode->i_ino);
@@ -1193,8 +1181,8 @@ int ocfs2_drop_inode(struct inode *inode)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int res;
 
-	mlog(0, "Drop inode %llu, nlink = %u, ip_flags = 0x%x\n",
-	     (unsigned long long)oi->ip_blkno, inode->i_nlink, oi->ip_flags);
+	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
+				inode->i_nlink, oi->ip_flags);
 
 	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
 		res = 1;
@@ -1212,11 +1200,11 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	int status = 0;
 
-	mlog(0, "(inode = 0x%p, ino = %llu)\n", inode,
-	     inode ? (unsigned long long)OCFS2_I(inode)->ip_blkno : 0ULL);
+	trace_ocfs2_inode_revalidate(inode,
+		inode ? (unsigned long long)OCFS2_I(inode)->ip_blkno : 0ULL,
+		inode ? (unsigned long long)OCFS2_I(inode)->ip_flags : 0);
 
 	if (!inode) {
-		mlog(0, "eep, no inode!\n");
 		status = -ENOENT;
 		goto bail;
 	}
@@ -1224,7 +1212,6 @@ int ocfs2_inode_revalidate(struct dentry *dentry)
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED) {
 		spin_unlock(&OCFS2_I(inode)->ip_lock);
-		mlog(0, "inode deleted!\n");
 		status = -ENOENT;
 		goto bail;
 	}
@@ -1255,8 +1242,7 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	int status;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
 
-	mlog(0, "(inode %llu)\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	trace_ocfs2_mark_inode_dirty((unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), bh,
 					 OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1328,8 +1314,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	int rc;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
-	mlog(0, "Validating dinode %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_inode_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 79df9e0..d9b13c1 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -114,6 +114,25 @@ DECLARE_EVENT_CLASS(ocfs2__ull_uint,
 	TP_printk("%llu %u", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_int,
+
+	TP_PROTO(unsigned long long value1, int value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1	)
+		__field(	int,			value2	)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%llu %d", __entry->value1, __entry->value2)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__ull_ull,
 
 	TP_PROTO(unsigned long long value1, unsigned long long value2),
@@ -2025,6 +2044,214 @@ DEFINE_EVENT(ocfs2__int, generic_file_aio_read_ret,
 );
 /* End of trace events for fs/ocfs2/file.c. */
 
+/* Trace events for fs/ocfs2/inode.c. */
+TRACE_EVENT(ocfs2_iget_begin,
+
+	TP_PROTO(unsigned long long ino, unsigned int flags, int sysfile_type),
+
+	TP_ARGS(ino, flags, sysfile_type),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		flags		)
+		__field(	int,			sysfile_type	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->flags		= flags;
+		__entry->sysfile_type	= sysfile_type;
+	),
+
+	TP_printk("%llu %u %d", __entry->ino,
+		  __entry->flags, __entry->sysfile_type)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_iget5_locked,
+
+	TP_PROTO(unsigned long long state),
+
+	TP_ARGS(state)
+);
+
+TRACE_EVENT(ocfs2_iget_end,
+
+	TP_PROTO(void *inode, unsigned long long ino),
+
+	TP_ARGS(inode, ino),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	unsigned long long,	ino		)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->ino		= ino;
+	),
+
+	TP_printk("%p %llu", __entry->inode, __entry->ino)
+);
+
+TRACE_EVENT(ocfs2_find_actor,
+
+	TP_PROTO(void *inode, unsigned long long ino,
+		 void *args,  unsigned long long fi_blkno),
+
+	TP_ARGS(inode, ino, args, fi_blkno),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	unsigned long long,	ino		)
+		__field(	void *,			args		)
+		__field(	unsigned long long,	fi_blkno	)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->ino		= ino;
+		__entry->args		= args;
+		__entry->fi_blkno	= fi_blkno;
+	),
+
+	TP_printk("%p %llu %p %llu", __entry->inode, __entry->ino,
+		  __entry->args, __entry->fi_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_populate_inode,
+
+	TP_PROTO(unsigned long long ino, unsigned int flags),
+
+	TP_ARGS(ino, flags)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_read_locked_inode,
+
+	TP_PROTO(unsigned long long ino, int can_lock),
+
+	TP_ARGS(ino, can_lock)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_check_orphan_recovery_state,
+
+	TP_PROTO(int slot, int ret),
+
+	TP_ARGS(slot, ret)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_inode_block,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+TRACE_EVENT(ocfs2_inode_is_valid_to_delete,
+
+	TP_PROTO(void *task, void *dc_task, unsigned long long ino,
+		 unsigned int flags),
+
+	TP_ARGS(task, dc_task, ino, flags),
+
+	TP_STRUCT__entry(
+		__field(	void *,			task		)
+		__field(	void *,			dc_task		)
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		flags		)
+	),
+
+	TP_fast_assign(
+		__entry->task		= task;
+		__entry->dc_task	= dc_task;
+		__entry->ino		= ino;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("%p %p %llu %u", __entry->task, __entry->dc_task,
+		  __entry->ino, __entry->flags)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_query_inode_wipe_begin,
+
+	TP_PROTO(unsigned long long ino, unsigned int nlink),
+
+	TP_ARGS(ino, nlink)
+);
+
+DEFINE_EVENT(ocfs2__uint, ocfs2_query_inode_wipe_succ,
+
+	TP_PROTO(unsigned int slot),
+
+	TP_ARGS(slot)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_query_inode_wipe_end,
+
+	TP_PROTO(int status, int reason),
+
+	TP_ARGS(status, reason)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_cleanup_delete_inode,
+
+	TP_PROTO(unsigned long long ino, int sync_data),
+
+	TP_ARGS(ino, sync_data)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_delete_inode,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned long long ip_blkno, unsigned int is_bad_inode),
+
+	TP_ARGS(ino, ip_blkno, is_bad_inode)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_clear_inode,
+
+	TP_PROTO(unsigned long long ino, unsigned int nlink),
+
+	TP_ARGS(ino, nlink)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_drop_inode,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned int n_link, unsigned int ip_flags),
+
+	TP_ARGS(ino, n_link, ip_flags)
+);
+
+TRACE_EVENT(ocfs2_inode_revalidate,
+
+	TP_PROTO(void *inode, unsigned long long ino,
+		 unsigned int flags),
+
+	TP_ARGS(inode, ino, flags),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		flags		)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->ino		= ino;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("%p %llu %u", __entry->inode, __entry->ino, __entry->flags)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_mark_inode_dirty,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+/* End of trace events for fs/ocfs2/inode.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
