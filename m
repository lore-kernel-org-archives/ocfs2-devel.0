From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:06 -0700
Subject: [Ocfs2-devel] [patch 08/25] ocfs2: code clean up for direct io
Message-ID: <56f2f896.0VtEZG156dvTdkfW%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: code clean up for direct io

Clean up ocfs2_file_write_iter & ocfs2_prepare_inode_for_write:
* remove append dio check: it will be checked in ocfs2_direct_IO()
* remove file hole check: file hole is supported for now
* remove inline data check: it will be checked in ocfs2_direct_IO()
* remove the full_coherence check when append dio: we will get the inode_lock
  in ocfs2_dio_get_block, there is no need to fall back to buffer io to ensure
  the coherence semantics.

Now the drop dio procedure is gone. :)

[akpm at linux-foundation.org: remove unused label]
Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c        |  138 +--------------------------------------
 fs/ocfs2/ocfs2_trace.h |   16 +---
 2 files changed, 10 insertions(+), 144 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-code-clean-up-for-direct-io fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-code-clean-up-for-direct-io
+++ a/fs/ocfs2/file.c
@@ -1381,44 +1381,6 @@ out:
 	return ret;
 }
 
-/*
- * Will look for holes and unwritten extents in the range starting at
- * pos for count bytes (inclusive).
- */
-static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
-				       size_t count)
-{
-	int ret = 0;
-	unsigned int extent_flags;
-	u32 cpos, clusters, extent_len, phys_cpos;
-	struct super_block *sb = inode->i_sb;
-
-	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
-	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
-
-	while (clusters) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
-					 &extent_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-
-		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = 1;
-			break;
-		}
-
-		if (extent_len > clusters)
-			extent_len = clusters;
-
-		clusters -= extent_len;
-		cpos += extent_len;
-	}
-out:
-	return ret;
-}
-
 static int ocfs2_write_remove_suid(struct inode *inode)
 {
 	int ret;
@@ -2129,18 +2091,12 @@ out:
 
 static int ocfs2_prepare_inode_for_write(struct file *file,
 					 loff_t pos,
-					 size_t count,
-					 int appending,
-					 int *direct_io,
-					 int *has_refcount)
+					 size_t count)
 {
 	int ret = 0, meta_level = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = d_inode(dentry);
 	loff_t end;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	int full_coherency = !(osb->s_mount_opt &
-		OCFS2_MOUNT_COHERENCY_BUFFERED);
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2189,10 +2145,6 @@ static int ocfs2_prepare_inode_for_write
 							       pos,
 							       count,
 							       &meta_level);
-			if (has_refcount)
-				*has_refcount = 1;
-			if (direct_io)
-				*direct_io = 0;
 		}
 
 		if (ret < 0) {
@@ -2200,67 +2152,12 @@ static int ocfs2_prepare_inode_for_write
 			goto out_unlock;
 		}
 
-		/*
-		 * Skip the O_DIRECT checks if we don't need
-		 * them.
-		 */
-		if (!direct_io || !(*direct_io))
-			break;
-
-		/*
-		 * There's no sane way to do direct writes to an inode
-		 * with inline data.
-		 */
-		if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-			*direct_io = 0;
-			break;
-		}
-
-		/*
-		 * Allowing concurrent direct writes means
-		 * i_size changes wouldn't be synchronized, so
-		 * one node could wind up truncating another
-		 * nodes writes.
-		 */
-		if (end > i_size_read(inode) && !full_coherency) {
-			*direct_io = 0;
-			break;
-		}
-
-		/*
-		 * Fallback to old way if the feature bit is not set.
-		 */
-		if (end > i_size_read(inode) &&
-				!ocfs2_supports_append_dio(osb)) {
-			*direct_io = 0;
-			break;
-		}
-
-		/*
-		 * We don't fill holes during direct io, so
-		 * check for them here. If any are found, the
-		 * caller will have to retake some cluster
-		 * locks and initiate the io as buffered.
-		 */
-		ret = ocfs2_check_range_for_holes(inode, pos, count);
-		if (ret == 1) {
-			/*
-			 * Fallback to old way if the feature bit is not set.
-			 * Otherwise try dio first and then complete the rest
-			 * request through buffer io.
-			 */
-			if (!ocfs2_supports_append_dio(osb))
-				*direct_io = 0;
-			ret = 0;
-		} else if (ret < 0)
-			mlog_errno(ret);
 		break;
 	}
 
 out_unlock:
 	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
-					    pos, appending, count,
-					    direct_io, has_refcount);
+					    pos, count);
 
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
@@ -2272,18 +2169,16 @@ out:
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
-	int direct_io, appending, rw_level;
-	int can_do_direct, has_refcount = 0;
+	int direct_io, rw_level;
 	ssize_t written = 0;
 	ssize_t ret;
-	size_t count = iov_iter_count(from), orig_count;
+	size_t count = iov_iter_count(from);
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
-	int dropped_dio = 0;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
 
@@ -2296,12 +2191,10 @@ static ssize_t ocfs2_file_write_iter(str
 	if (count == 0)
 		return 0;
 
-	appending = iocb->ki_flags & IOCB_APPEND ? 1 : 0;
 	direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 
 	inode_lock(inode);
 
-relock:
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2334,7 +2227,6 @@ relock:
 		ocfs2_inode_unlock(inode, 1);
 	}
 
-	orig_count = iov_iter_count(from);
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0) {
 		if (ret)
@@ -2343,9 +2235,7 @@ relock:
 	}
 	count = ret;
 
-	can_do_direct = direct_io;
-	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count, appending,
-					    &can_do_direct, &has_refcount);
+	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -2354,22 +2244,6 @@ relock:
 	if (direct_io && !is_sync_kiocb(iocb))
 		unaligned_dio = ocfs2_is_io_unaligned(inode, count, iocb->ki_pos);
 
-	/*
-	 * We can't complete the direct I/O as requested, fall back to
-	 * buffered I/O.
-	 */
-	if (direct_io && !can_do_direct) {
-		ocfs2_rw_unlock(inode, rw_level);
-
-		rw_level = -1;
-
-		direct_io = 0;
-		iocb->ki_flags &= ~IOCB_DIRECT;
-		iov_iter_reexpand(from, orig_count);
-		dropped_dio = 1;
-		goto relock;
-	}
-
 	if (unaligned_dio) {
 		/*
 		 * Wait on previous unaligned aio to complete before
@@ -2405,7 +2279,7 @@ relock:
 		goto no_sync;
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) ||
-	    IS_SYNC(inode) || dropped_dio) {
+	    IS_SYNC(inode)) {
 		ret = filemap_fdatawrite_range(file->f_mapping,
 					       iocb->ki_pos - written,
 					       iocb->ki_pos - 1);
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-code-clean-up-for-direct-io fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-code-clean-up-for-direct-io
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1450,28 +1450,20 @@ DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_rem
 
 TRACE_EVENT(ocfs2_prepare_inode_for_write,
 	TP_PROTO(unsigned long long ino, unsigned long long saved_pos,
-		 int appending, unsigned long count,
-		 int *direct_io, int *has_refcount),
-	TP_ARGS(ino, saved_pos, appending, count, direct_io, has_refcount),
+		 unsigned long count),
+	TP_ARGS(ino, saved_pos, count),
 	TP_STRUCT__entry(
 		__field(unsigned long long, ino)
 		__field(unsigned long long, saved_pos)
-		__field(int, appending)
 		__field(unsigned long, count)
-		__field(int, direct_io)
-		__field(int, has_refcount)
 	),
 	TP_fast_assign(
 		__entry->ino = ino;
 		__entry->saved_pos = saved_pos;
-		__entry->appending = appending;
 		__entry->count = count;
-		__entry->direct_io = direct_io ? *direct_io : -1;
-		__entry->has_refcount = has_refcount ? *has_refcount : -1;
 	),
-	TP_printk("%llu %llu %d %lu %d %d", __entry->ino,
-		  __entry->saved_pos, __entry->appending, __entry->count,
-		  __entry->direct_io, __entry->has_refcount)
+	TP_printk("%llu %llu %lu", __entry->ino,
+		  __entry->saved_pos, __entry->count)
 );
 
 DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
_
