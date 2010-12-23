From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:57 +0800
Subject: [Ocfs2-devel] [PATCH 14/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/file.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-14-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

This is the 2nd step to remove the debug info of INODE.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/file.c        |  190 ++++++++++++-------------
 fs/ocfs2/ocfs2_trace.h |  367 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/sysfile.c     |    1 -
 3 files changed, 460 insertions(+), 98 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 14f335d..868c686 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -38,7 +38,6 @@
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -61,6 +60,7 @@
 #include "acl.h"
 #include "quota.h"
 #include "refcounttree.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -99,8 +99,10 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog(0, "(0x%p, 0x%p, '%.*s')\n", inode, file,
-	     file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
+	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
+			      (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			      file->f_path.dentry->d_name.len,
+			      file->f_path.dentry->d_name.name, mode);
 
 	if (file->f_mode & FMODE_WRITE)
 		dquot_initialize(inode);
@@ -142,13 +144,15 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	mlog(0, "(0x%p, 0x%p, '%.*s')\n", inode, file,
-	     file->f_path.dentry->d_name.len,
-	     file->f_path.dentry->d_name.name);
-
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
 		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
+
+	trace_ocfs2_file_release(inode, file, file->f_path.dentry,
+				 oi->ip_blkno,
+				 file->f_path.dentry->d_name.len,
+				 file->f_path.dentry->d_name.name,
+				 oi->ip_open_count);
 	spin_unlock(&oi->ip_lock);
 
 	ocfs2_free_file_private(inode, file);
@@ -174,9 +178,11 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog(0, "(0x%p, %d, 0x%p, '%.*s')\n", file, datasync,
-	     file->f_path.dentry, file->f_path.dentry->d_name.len,
-	     file->f_path.dentry->d_name.name);
+	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
+			      OCFS2_I(inode)->ip_blkno,
+			      file->f_path.dentry->d_name.len,
+			      file->f_path.dentry->d_name.name,
+			      (unsigned long long)datasync);
 
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
 		/*
@@ -431,14 +437,14 @@ static int ocfs2_truncate_file(struct inode *inode,
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	mlog(0, "(inode = %llu, new_i_size = %llu\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     (unsigned long long)new_i_size);
-
 	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
 	 * already validated it */
 	fe = (struct ocfs2_dinode *) di_bh->b_data;
 
+	trace_ocfs2_truncate_file((unsigned long long)OCFS2_I(inode)->ip_blkno,
+				  (unsigned long long)le64_to_cpu(fe->i_size),
+				  (unsigned long long)new_i_size);
+
 	mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),
 			"Inode %llu, inode i_size = %lld != di "
 			"i_size = %llu, i_flags = 0x%x\n",
@@ -448,19 +454,14 @@ static int ocfs2_truncate_file(struct inode *inode,
 			le32_to_cpu(fe->i_flags));
 
 	if (new_i_size > le64_to_cpu(fe->i_size)) {
-		mlog(0, "asked to truncate file with size (%llu) to size (%llu)!\n",
-		     (unsigned long long)le64_to_cpu(fe->i_size),
-		     (unsigned long long)new_i_size);
+		trace_ocfs2_truncate_file_error(
+			(unsigned long long)le64_to_cpu(fe->i_size),
+			(unsigned long long)new_i_size);
 		status = -EINVAL;
 		mlog_errno(status);
 		goto bail;
 	}
 
-	mlog(0, "inode %llu, i_size = %llu, new_i_size = %llu\n",
-	     (unsigned long long)le64_to_cpu(fe->i_blkno),
-	     (unsigned long long)le64_to_cpu(fe->i_size),
-	     (unsigned long long)new_i_size);
-
 	/* lets handle the simple truncate cases before doing any more
 	 * cluster locking. */
 	if (new_i_size == le64_to_cpu(fe->i_size))
@@ -566,8 +567,6 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
 
-	mlog(0, "(clusters_to_add = %u)\n", clusters_to_add);
-
 	/*
 	 * This function only exists for file systems which don't
 	 * support holes.
@@ -584,11 +583,6 @@ static int __ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
 restart_all:
 	BUG_ON(le32_to_cpu(fe->i_clusters) != OCFS2_I(inode)->ip_clusters);
 
-	mlog(0, "extend inode %llu, i_size = %lld, di->i_clusters = %u, "
-	     "clusters_to_add = %u\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     (long long)i_size_read(inode), le32_to_cpu(fe->i_clusters),
-	     clusters_to_add);
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), bh);
 	status = ocfs2_lock_allocators(inode, &et, clusters_to_add, 0,
 				       &data_ac, &meta_ac);
@@ -608,6 +602,12 @@ restart_all:
 	}
 
 restarted_transaction:
+	trace_ocfs2_extend_allocation(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		(unsigned long long)i_size_read(inode),
+		le32_to_cpu(fe->i_clusters), clusters_to_add,
+		why, restart_func);
+
 	status = dquot_alloc_space_nodirty(inode,
 			ocfs2_clusters_to_bytes(osb->sb, clusters_to_add));
 	if (status)
@@ -654,13 +654,11 @@ restarted_transaction:
 
 	if (why != RESTART_NONE && clusters_to_add) {
 		if (why == RESTART_META) {
-			mlog(0, "restarting function.\n");
 			restart_func = 1;
 			status = 0;
 		} else {
 			BUG_ON(why != RESTART_TRANS);
 
-			mlog(0, "restarting transaction.\n");
 			/* TODO: This can be more intelligent. */
 			credits = ocfs2_calc_extend_credits(osb->sb,
 							    &fe->id2.i_list,
@@ -677,11 +675,11 @@ restarted_transaction:
 		}
 	}
 
-	mlog(0, "fe: i_clusters = %u, i_size=%llu\n",
+	trace_ocfs2_extend_allocation_end(OCFS2_I(inode)->ip_blkno,
 	     le32_to_cpu(fe->i_clusters),
-	     (unsigned long long)le64_to_cpu(fe->i_size));
-	mlog(0, "inode: ip_clusters=%u, i_size=%lld\n",
-	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
+	     (unsigned long long)le64_to_cpu(fe->i_size),
+	     OCFS2_I(inode)->ip_clusters,
+	     (unsigned long long)i_size_read(inode));
 
 leave:
 	if (status < 0 && did_quota)
@@ -772,10 +770,11 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	if (!zero_to)
 		zero_to = PAGE_CACHE_SIZE;
 
-	mlog(0,
-	     "abs_from = %llu, abs_to = %llu, index = %lu, zero_from = %u, zero_to = %u\n",
-	     (unsigned long long)abs_from, (unsigned long long)abs_to,
-	     index, zero_from, zero_to);
+	trace_ocfs2_write_zero_page(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)abs_from,
+			(unsigned long long)abs_to,
+			index, zero_from, zero_to);
 
 	/* We know that zero_from is block aligned */
 	for (block_start = zero_from; block_start < zero_to;
@@ -915,9 +914,10 @@ static int ocfs2_zero_extend_range(struct inode *inode, u64 range_start,
 	u64 next_pos;
 	u64 zero_pos = range_start;
 
-	mlog(0, "range_start = %llu, range_end = %llu\n",
-	     (unsigned long long)range_start,
-	     (unsigned long long)range_end);
+	trace_ocfs2_zero_extend_range(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)range_start,
+			(unsigned long long)range_end);
 	BUG_ON(range_start >= range_end);
 
 	while (zero_pos < range_end) {
@@ -949,9 +949,9 @@ int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 	struct super_block *sb = inode->i_sb;
 
 	zero_start = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
-	mlog(0, "zero_start %llu for i_size %llu\n",
-	     (unsigned long long)zero_start,
-	     (unsigned long long)i_size_read(inode));
+	trace_ocfs2_zero_extend((unsigned long long)OCFS2_I(inode)->ip_blkno,
+				(unsigned long long)zero_start,
+				(unsigned long long)i_size_read(inode));
 	while (zero_start < zero_to_size) {
 		ret = ocfs2_zero_extend_get_range(inode, di_bh, zero_start,
 						  zero_to_size,
@@ -1100,30 +1100,20 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
 
-	mlog(0, "(0x%p, '%.*s')\n", dentry,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_setattr(inode, dentry,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    dentry->d_name.len, dentry->d_name.name,
+			    attr->ia_valid, attr->ia_mode,
+			    attr->ia_uid, attr->ia_gid);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
 		attr->ia_valid &= ~ATTR_SIZE;
 
-	if (attr->ia_valid & ATTR_MODE)
-		mlog(0, "mode change: %d\n", attr->ia_mode);
-	if (attr->ia_valid & ATTR_UID)
-		mlog(0, "uid change: %d\n", attr->ia_uid);
-	if (attr->ia_valid & ATTR_GID)
-		mlog(0, "gid change: %d\n", attr->ia_gid);
-	if (attr->ia_valid & ATTR_SIZE)
-		mlog(0, "size change...\n");
-	if (attr->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_CTIME))
-		mlog(0, "time change...\n");
-
 #define OCFS2_VALID_ATTRS (ATTR_ATIME | ATTR_MTIME | ATTR_CTIME | ATTR_SIZE \
 			   | ATTR_GID | ATTR_UID | ATTR_MODE)
-	if (!(attr->ia_valid & OCFS2_VALID_ATTRS)) {
-		mlog(0, "can't handle attrs: 0x%x\n", attr->ia_valid);
+	if (!(attr->ia_valid & OCFS2_VALID_ATTRS))
 		return 0;
-	}
 
 	status = inode_change_ok(inode, attr);
 	if (status)
@@ -1315,8 +1305,9 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di;
 
-	mlog(0, "(Inode %llu, mode 0%o)\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
+	trace_ocfs2_write_remove_suid(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 	if (IS_ERR(handle)) {
@@ -1522,8 +1513,9 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 	 * partial clusters here. There's no need to worry about
 	 * physical allocation - the zeroing code knows to skip holes.
 	 */
-	mlog(0, "byte start: %llu, end: %llu\n",
-	     (unsigned long long)start, (unsigned long long)end);
+	trace_ocfs2_zero_partial_clusters(
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		(unsigned long long)start, (unsigned long long)end);
 
 	/*
 	 * If both edges are on a cluster boundary then there's no
@@ -1547,8 +1539,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 	if (tmpend > end)
 		tmpend = end;
 
-	mlog(0, "1st range: start: %llu, tmpend: %llu\n",
-	     (unsigned long long)start, (unsigned long long)tmpend);
+	trace_ocfs2_zero_partial_clusters_range1((unsigned long long)start,
+						 (unsigned long long)tmpend);
 
 	ret = ocfs2_zero_range_for_truncate(inode, handle, start, tmpend);
 	if (ret)
@@ -1562,8 +1554,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 		 */
 		start = end & ~(osb->s_clustersize - 1);
 
-		mlog(0, "2nd range: start: %llu, end: %llu\n",
-		     (unsigned long long)start, (unsigned long long)end);
+		trace_ocfs2_zero_partial_clusters_range2(
+			(unsigned long long)start, (unsigned long long)end);
 
 		ret = ocfs2_zero_range_for_truncate(inode, handle, start, end);
 		if (ret)
@@ -1663,6 +1655,11 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
+	trace_ocfs2_remove_inode_range(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			(unsigned long long)byte_start,
+			(unsigned long long)byte_len);
+
 	if (byte_len == 0)
 		return 0;
 
@@ -1709,11 +1706,6 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	trunc_end = (byte_start + byte_len) >> osb->s_clustersize_bits;
 	cluster_in_el = trunc_end;
 
-	mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, cend: %u\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     (unsigned long long)byte_start,
-	     (unsigned long long)byte_len, trunc_start, trunc_end);
-
 	ret = ocfs2_zero_partial_clusters(inode, byte_start, byte_len);
 	if (ret) {
 		mlog_errno(ret);
@@ -2064,7 +2056,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	int ret = 0, meta_level = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	loff_t saved_pos, end;
+	loff_t saved_pos = 0, end;
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2103,12 +2095,10 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 
 		/* work on a copy of ppos until we're sure that we won't have
 		 * to recalculate it due to relocking. */
-		if (appending) {
+		if (appending)
 			saved_pos = i_size_read(inode);
-			mlog(0, "O_APPEND: inode->i_size=%llu\n", saved_pos);
-		} else {
+		else
 			saved_pos = *ppos;
-		}
 
 		end = saved_pos + count;
 
@@ -2179,6 +2169,10 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		*ppos = saved_pos;
 
 out_unlock:
+	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
+					    saved_pos, appending, count,
+					    direct_io, has_refcount);
+
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
 
@@ -2204,10 +2198,11 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 
-	mlog(0, "(0x%p, %u, '%.*s')\n", file,
-	     (unsigned int)nr_segs,
-	     file->f_path.dentry->d_name.len,
-	     file->f_path.dentry->d_name.name);
+	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
+		(unsigned long long)OCFS2_I(inode)->ip_blkno,
+		file->f_path.dentry->d_name.len,
+		file->f_path.dentry->d_name.name,
+		(unsigned int)nr_segs);
 
 	if (iocb->ki_left == 0)
 		return 0;
@@ -2402,10 +2397,11 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		.u.file = out,
 	};
 
-	mlog(0, "(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
-	     (unsigned int)len,
-	     out->f_path.dentry->d_name.len,
-	     out->f_path.dentry->d_name.name);
+
+	trace_ocfs2_file_splice_write(inode, out, out->f_path.dentry,
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			out->f_path.dentry->d_name.len,
+			out->f_path.dentry->d_name.name, len);
 
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
@@ -2461,10 +2457,10 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	int ret = 0, lock_level = 0;
 	struct inode *inode = in->f_path.dentry->d_inode;
 
-	mlog(0, "(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
-	     (unsigned int)len,
-	     in->f_path.dentry->d_name.len,
-	     in->f_path.dentry->d_name.name);
+	trace_ocfs2_file_splice_read(inode, in, in->f_path.dentry,
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			in->f_path.dentry->d_name.len,
+			in->f_path.dentry->d_name.name, len);
 
 	/*
 	 * See the comment in ocfs2_file_aio_read()
@@ -2491,10 +2487,11 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 
-	mlog(0, "(0x%p, %u, '%.*s')\n", filp,
-	     (unsigned int)nr_segs,
-	     filp->f_path.dentry->d_name.len,
-	     filp->f_path.dentry->d_name.name);
+	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			filp->f_path.dentry->d_name.len,
+			filp->f_path.dentry->d_name.name, nr_segs);
+
 
 	if (!inode) {
 		ret = -EINVAL;
@@ -2537,8 +2534,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 	ocfs2_inode_unlock(inode, lock_level);
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
-	if (ret == -EINVAL)
-		mlog(0, "generic_file_aio_read returned -EINVAL\n");
+	trace_generic_file_aio_read_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index efda83e..79df9e0 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -201,6 +201,29 @@ DECLARE_EVENT_CLASS(ocfs2__uint_uint_uint,
 	TP_printk("%u %u %u", __entry->value1, __entry->value2, __entry->value3)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__ull_ull_ull,
+
+	TP_PROTO(unsigned long long value1,
+		 unsigned long long value2, unsigned long long value3),
+
+	TP_ARGS(value1, value2, value3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	value1		)
+		__field(	unsigned long long,	value2		)
+		__field(	unsigned long long,	value3		)
+	),
+
+	TP_fast_assign(
+		__entry->value1		= value1;
+		__entry->value2		= value2;
+		__entry->value3		= value3;
+	),
+
+	TP_printk("%llu %llu %llu",
+		  __entry->value1, __entry->value2, __entry->value3)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__ull_int_int_int,
 
 	TP_PROTO(unsigned long long ull, int value1, int value2, int value3),
@@ -1658,6 +1681,350 @@ TRACE_EVENT(ocfs2_fault,
 );
 /* End of trace events for fs/ocfs2/mmap.c. */
 
+/* Trace events for fs/ocfs2/file.c. */
+DECLARE_EVENT_CLASS(ocfs2__file_ops,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long para),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, para),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	void *,			file		)
+		__field(	void *,			dentry		)
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		d_len		)
+		__field(	const unsigned char *,	d_name		)
+		__field(	unsigned long long,	para		)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->file		= file;
+		__entry->dentry		= dentry;
+		__entry->ino		= ino;
+		__entry->d_len		= d_len;
+		__entry->d_name		= d_name;
+		__entry->para		= para;
+	),
+
+	TP_printk("%p %p %p %llu %llu %.*s", __entry->inode, __entry->file,
+		  __entry->dentry, __entry->ino, __entry->para,
+		  __entry->d_len, __entry->d_name)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_open,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long mode),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, mode)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_release,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long open_count),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, open_count)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_sync_file,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long datasync),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, datasync)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_ull, ocfs2_truncate_file,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long size,
+		 unsigned long long new_size),
+
+	TP_ARGS(ip_blkno, size, new_size)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_truncate_file_error,
+
+	TP_PROTO(unsigned long long i_size, unsigned long long new_size),
+
+	TP_ARGS(i_size, new_size)
+);
+
+TRACE_EVENT(ocfs2_extend_allocation,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long size,
+		 unsigned int clusters, unsigned int clusters_to_add,
+		 int why, int restart_func),
+
+	TP_ARGS(ip_blkno, size, clusters, clusters_to_add, why, restart_func),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ip_blkno	)
+		__field(	unsigned long long,	size		)
+		__field(	unsigned int,		clusters	)
+		__field(	unsigned int,		clusters_to_add	)
+		__field(	int,			why		)
+		__field(	int,			restart_func	)
+	),
+
+	TP_fast_assign(
+		__entry->ip_blkno		= ip_blkno;
+		__entry->size			= size;
+		__entry->clusters		= clusters;
+		__entry->clusters_to_add	= clusters_to_add;
+		__entry->why			= why;
+		__entry->restart_func		= restart_func;
+	),
+
+	TP_printk("%llu %llu %u %u %d %d",
+		  __entry->ip_blkno, __entry->size, __entry->clusters,
+		  __entry->clusters_to_add, __entry->why, __entry->restart_func)
+);
+
+TRACE_EVENT(ocfs2_extend_allocation_end,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned int di_clusters, unsigned long long di_size,
+		 unsigned int ip_clusters, unsigned long long i_size),
+
+	TP_ARGS(ino, di_clusters, di_size, ip_clusters, i_size),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		di_clusters	)
+		__field(	unsigned long long,	di_size		)
+		__field(	unsigned int,		ip_clusters	)
+		__field(	unsigned long long,	i_size		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->di_clusters	= di_clusters;
+		__entry->di_size	= di_size;
+		__entry->ip_clusters	= ip_clusters;
+		__entry->i_size		= i_size;
+	),
+
+	TP_printk("%llu %u %llu %u %llu", __entry->ino, __entry->di_clusters,
+		  __entry->di_size, __entry->ip_clusters, __entry->i_size)
+);
+
+TRACE_EVENT(ocfs2_write_zero_page,
+
+	TP_PROTO(unsigned long long ino,
+		 unsigned long long abs_from, unsigned long long abs_to,
+		 unsigned long index, unsigned int zero_from,
+		 unsigned int zero_to),
+
+	TP_ARGS(ino, abs_from, abs_to, index, zero_from, zero_to),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned long long,	abs_from	)
+		__field(	unsigned long long,	abs_to		)
+		__field(	unsigned long,		index		)
+		__field(	unsigned int,		zero_from	)
+		__field(	unsigned int,		zero_to		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->abs_from	= abs_from;
+		__entry->abs_to		= abs_to;
+		__entry->index		= index;
+		__entry->zero_from	= zero_from;
+		__entry->zero_to	= zero_to;
+	),
+
+	TP_printk("%llu %llu %llu %lu %u %u", __entry->ino,
+		  __entry->abs_from, __entry->abs_to,
+		  __entry->index, __entry->zero_from, __entry->zero_to)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_ull, ocfs2_zero_extend_range,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long range_start,
+		 unsigned long long range_end),
+
+	TP_ARGS(ip_blkno, range_start, range_end)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_ull, ocfs2_zero_extend,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long zero_start,
+		 unsigned long long i_size),
+
+	TP_ARGS(ip_blkno, zero_start, i_size)
+);
+
+TRACE_EVENT(ocfs2_setattr,
+
+	TP_PROTO(void *inode, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned int ia_valid, unsigned int ia_mode,
+		 unsigned int ia_uid, unsigned int ia_gid),
+
+	TP_ARGS(inode, dentry, ino, d_len, d_name,
+		ia_valid, ia_mode, ia_uid, ia_gid),
+
+	TP_STRUCT__entry(
+		__field(	void *,			inode		)
+		__field(	void *,			dentry		)
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned int,		d_len		)
+		__field(	const unsigned char *,	d_name		)
+		__field(	unsigned int,		ia_valid	)
+		__field(	unsigned int,		ia_mode		)
+		__field(	unsigned int,		ia_uid		)
+		__field(	unsigned int,		ia_gid		)
+	),
+
+	TP_fast_assign(
+		__entry->inode		= inode;
+		__entry->dentry		= dentry;
+		__entry->ino		= ino;
+		__entry->d_len		= d_len;
+		__entry->d_name		= d_name;
+		__entry->ia_valid	= ia_valid;
+		__entry->ia_mode	= ia_mode;
+		__entry->ia_uid		= ia_uid;
+		__entry->ia_gid		= ia_gid;
+	),
+
+	TP_printk("%p %p %llu %.*s %u %u %u %u", __entry->inode,
+		  __entry->dentry, __entry->ino, __entry->d_len,
+		  __entry->d_name, __entry->ia_valid, __entry->ia_mode,
+		  __entry->ia_uid, __entry->ia_gid)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_write_remove_suid,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned int mode),
+
+	TP_ARGS(ip_blkno, mode)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_ull, ocfs2_zero_partial_clusters,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long start,
+		 unsigned long long end),
+
+	TP_ARGS(ip_blkno, start, end)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_zero_partial_clusters_range1,
+
+	TP_PROTO(unsigned long long start, unsigned long long end),
+
+	TP_ARGS(start, end)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_zero_partial_clusters_range2,
+
+	TP_PROTO(unsigned long long start, unsigned long long end),
+
+	TP_ARGS(start, end)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_ull, ocfs2_remove_inode_range,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long start,
+		 unsigned long long end),
+
+	TP_ARGS(ip_blkno, start, end)
+);
+
+TRACE_EVENT(ocfs2_prepare_inode_for_write,
+
+	TP_PROTO(unsigned long long ino, unsigned long long saved_pos,
+		 int appending, unsigned long count,
+		 int *direct_io, int *has_refcount),
+
+	TP_ARGS(ino, saved_pos, appending, count, direct_io, has_refcount),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	unsigned long long,	saved_pos	)
+		__field(	int,			appending	)
+		__field(	unsigned long,		count		)
+		__field(	int,			direct_io	)
+		__field(	int,			has_refcount	)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= ino;
+		__entry->saved_pos	= saved_pos;
+		__entry->appending	= appending;
+		__entry->count		= count;
+		__entry->direct_io	= direct_io ? *direct_io : -1;
+		__entry->has_refcount	= has_refcount ? *has_refcount : -1;
+	),
+
+	TP_printk("%llu %llu %d %lu %d %d", __entry->ino,
+		  __entry->saved_pos, __entry->appending, __entry->count,
+		  __entry->direct_io, __entry->has_refcount)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_aio_write,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long nr_segs),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, nr_segs)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_splice_write,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long len),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, len)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_splice_read,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long len),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, len)
+);
+
+DEFINE_EVENT(ocfs2__file_ops, ocfs2_file_aio_read,
+
+	TP_PROTO(void *inode, void *file, void *dentry,
+		 unsigned long long ino,
+		 unsigned int d_len, const unsigned char *d_name,
+		 unsigned long long nr_segs),
+
+	TP_ARGS(inode, file, dentry, ino, d_len, d_name, nr_segs)
+);
+
+DEFINE_EVENT(ocfs2__int, generic_file_aio_read_ret,
+
+	TP_PROTO(int ret),
+
+	TP_ARGS(ret)
+);
+/* End of trace events for fs/ocfs2/file.c. */
+
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 902efb2..3d635f4 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/highmem.h>
 
-#define MLOG_MASK_PREFIX ML_INODE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
-- 
1.7.0.4
