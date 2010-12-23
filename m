From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:12 +0800
Subject: [Ocfs2-devel] [PATCH 29/34] ocfs2: Remove masklog ML_EXPORT.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-29-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/export.c and the masklog EXPORT.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/export.c          |   47 +++++++---------
 fs/ocfs2/ocfs2_trace.h     |  135 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 29 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 15f6f03..a229ede 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -99,7 +99,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(VOTE),
 	define_mask(CONN),
 	define_mask(QUORUM),
-	define_mask(EXPORT),
 	define_mask(BASTS),
 	define_mask(ERROR),
 	define_mask(NOTICE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 7e76559..5d358c1 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -101,7 +101,6 @@
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
 #define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
-#define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
 #define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 190158b..c01aee5 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -26,7 +26,6 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
-#define MLOG_MASK_PREFIX ML_EXPORT
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -40,6 +39,7 @@
 
 #include "buffer_head_io.h"
 #include "suballoc.h"
+#include "ocfs2_trace.h"
 
 struct ocfs2_inode_handle
 {
@@ -56,10 +56,9 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	int status, set;
 	struct dentry *result;
 
-	mlog(0, "(0x%p, 0x%p)\n", sb, handle);
+	trace_ocfs2_get_dentry_begin(sb, handle, (unsigned long long)blkno);
 
 	if (blkno == 0) {
-		mlog(0, "nfs wants inode with blkno: 0\n");
 		result = ERR_PTR(-ESTALE);
 		goto bail;
 	}
@@ -83,6 +82,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	}
 
 	status = ocfs2_test_inode_bit(osb, blkno, &set);
+	trace_ocfs2_get_dentry_test_bit(status, set);
 	if (status < 0) {
 		if (status == -EINVAL) {
 			/*
@@ -90,18 +90,14 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 			 * as an inode, we return -ESTALE to be
 			 * nice
 			 */
-			mlog(0, "test inode bit failed %d\n", status);
 			status = -ESTALE;
-		} else {
+		} else
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
-		}
 		goto unlock_nfs_sync;
 	}
 
 	/* If the inode allocator bit is clear, this inode must be stale */
 	if (!set) {
-		mlog(0, "inode %llu suballoc bit is clear\n",
-		     (unsigned long long)blkno);
 		status = -ESTALE;
 		goto unlock_nfs_sync;
 	}
@@ -114,8 +110,8 @@ unlock_nfs_sync:
 check_err:
 	if (status < 0) {
 		if (status == -ESTALE) {
-			mlog(0, "stale inode ino: %llu generation: %u\n",
-			     (unsigned long long)blkno, handle->ih_generation);
+			trace_ocfs2_get_dentry_stale((unsigned long long)blkno,
+						     handle->ih_generation);
 		}
 		result = ERR_PTR(status);
 		goto bail;
@@ -130,8 +126,9 @@ check_err:
 check_gen:
 	if (handle->ih_generation != inode->i_generation) {
 		iput(inode);
-		mlog(0, "stale inode ino: %llu generation: %u\n",
-		     (unsigned long long)blkno, handle->ih_generation);
+		trace_ocfs2_get_dentry_generation((unsigned long long)blkno,
+						  handle->ih_generation,
+						  inode->i_generation);
 		result = ERR_PTR(-ESTALE);
 		goto bail;
 	}
@@ -143,7 +140,7 @@ check_gen:
 		mlog_errno(PTR_ERR(result));
 
 bail:
-	mlog(0, "result = %p\n", result);
+	trace_ocfs2_get_dentry_end(result);
 	return result;
 }
 
@@ -154,11 +151,8 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	struct dentry *parent;
 	struct inode *dir = child->d_inode;
 
-	mlog(0, "(0x%p, '%.*s')\n", child,
-	     child->d_name.len, child->d_name.name);
-
-	mlog(0, "find parent of directory %llu\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno);
+	trace_ocfs2_get_parent(child, child->d_name.len, child->d_name.name,
+			       (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
 	status = ocfs2_inode_lock(dir, NULL, 0);
 	if (status < 0) {
@@ -182,7 +176,7 @@ bail_unlock:
 	ocfs2_inode_unlock(dir, 0);
 
 bail:
-	mlog(0, "parent %p\n", parent);
+	trace_ocfs2_get_parent_end(parent);
 
 	return parent;
 }
@@ -197,9 +191,9 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 	u32 generation;
 	__le32 *fh = (__force __le32 *) fh_in;
 
-	mlog(0, "(0x%p, '%.*s', 0x%p, %d, %d)\n", dentry,
-	     dentry->d_name.len, dentry->d_name.name,
-	     fh, len, connectable);
+	trace_ocfs2_encode_fh_begin(dentry, dentry->d_name.len,
+				    dentry->d_name.name,
+				    fh, len, connectable);
 
 	if (len < 3 || (connectable && len < 6)) {
 		mlog(ML_ERROR, "fh buffer is too small for encoding\n");
@@ -210,8 +204,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 	blkno = OCFS2_I(inode)->ip_blkno;
 	generation = inode->i_generation;
 
-	mlog(0, "Encoding fh: blkno: %llu, generation: %u\n",
-	     (unsigned long long)blkno, generation);
+	trace_ocfs2_encode_fh_self((unsigned long long)blkno, generation);
 
 	len = 3;
 	fh[0] = cpu_to_le32((u32)(blkno >> 32));
@@ -236,14 +229,14 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 		len = 6;
 		type = 2;
 
-		mlog(0, "Encoding parent: blkno: %llu, generation: %u\n",
-		     (unsigned long long)blkno, generation);
+		trace_ocfs2_encode_fh_parent((unsigned long long)blkno,
+					     generation);
 	}
 
 	*max_len = len;
 
 bail:
-	mlog(0, "type = %d\n", type);
+	trace_ocfs2_encode_fh_type(type);
 	return type;
 }
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 61197a4..a58008f 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -3800,6 +3800,141 @@ TRACE_EVENT(ocfs2_dentry_attach_lock_found,
 	TP_printk("%s %llu %llu", __entry->name, __entry->parent, __entry->ino)
 );
 
+TRACE_EVENT(ocfs2_get_dentry_begin,
+
+	TP_PROTO(void *sb, void *handle, unsigned long long blkno),
+
+	TP_ARGS(sb, handle, blkno),
+
+	TP_STRUCT__entry(
+		__field(	void *,			sb		)
+		__field(	void *,			handle		)
+		__field(	unsigned long long,	blkno		)
+	),
+
+	TP_fast_assign(
+		__entry->sb		= 	sb;
+		__entry->handle		= 	handle;
+		__entry->blkno		= 	blkno;
+	),
+
+	TP_printk("%p %p %llu", __entry->sb, __entry->handle, __entry->blkno)
+);
+
+DEFINE_EVENT(ocfs2__int_int, ocfs2_get_dentry_test_bit,
+
+	TP_PROTO(int status, int set),
+
+	TP_ARGS(status, set)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_get_dentry_stale,
+
+	TP_PROTO(unsigned long long blkno, unsigned int generation),
+
+	TP_ARGS(blkno, generation)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint_uint, ocfs2_get_dentry_generation,
+
+	TP_PROTO(unsigned long long blkno, unsigned int h_generation,
+		 unsigned int i_generation),
+
+	TP_ARGS(blkno, h_generation, i_generation)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_get_dentry_end,
+
+
+	TP_PROTO(void *result),
+
+	TP_ARGS(result)
+);
+
+TRACE_EVENT(ocfs2_get_parent,
+
+	TP_PROTO(void *child, int len, const char *name,
+		 unsigned long long ino),
+
+	TP_ARGS(child, len, name, ino),
+
+	TP_STRUCT__entry(
+		__field(	void *,			child		)
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+		__field(	unsigned long long,	ino		)
+	),
+
+	TP_fast_assign(
+		__entry->child		= 	child;
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+		__entry->ino		= 	ino;
+	),
+
+	TP_printk("%p %.*s %llu", __entry->child, __entry->len,
+		  __entry->name, __entry->ino)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_get_parent_end,
+
+
+	TP_PROTO(void *parent),
+
+	TP_ARGS(parent)
+);
+
+TRACE_EVENT(ocfs2_encode_fh_begin,
+
+	TP_PROTO(void *dentry, int name_len, const char *name,
+		 void *fh, int len, int connectable),
+
+	TP_ARGS(dentry, name_len, name, fh, len, connectable),
+
+	TP_STRUCT__entry(
+		__field(	void *,			dentry		)
+		__field(	int,			name_len	)
+		__field(	const char *,		name		)
+		__field(	void *,			fh		)
+		__field(	int,			len		)
+		__field(	int,			connectable	)
+	),
+
+	TP_fast_assign(
+		__entry->dentry		= 	dentry;
+		__entry->name_len	= 	name_len;
+		__entry->name		= 	name;
+		__entry->fh		= 	fh;
+		__entry->len		= 	len;
+		__entry->connectable	= 	connectable;
+	),
+
+	TP_printk("%p %.*s %p %d %d", __entry->dentry, __entry->name_len,
+		  __entry->name, __entry->fh, __entry->len,
+		  __entry->connectable)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_encode_fh_self,
+
+	TP_PROTO(unsigned long long blkno, unsigned int generation),
+
+	TP_ARGS(blkno, generation)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_encode_fh_parent,
+
+	TP_PROTO(unsigned long long blkno, unsigned int generation),
+
+	TP_ARGS(blkno, generation)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_encode_fh_type,
+
+	TP_PROTO(int type),
+
+	TP_ARGS(type)
+);
+
 /* End of trace events for fs/ocfs2/dcache.c. */
 #endif /* _TRACE_OCFS2_H */
 
-- 
1.7.0.4
