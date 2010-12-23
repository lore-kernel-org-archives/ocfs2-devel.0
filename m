From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:10 +0800
Subject: [Ocfs2-devel] [PATCH 27/34] ocfs2: Remove masklog ML_NAMEI.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-27-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/namei.c and the masklog NAMEI finally.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/namei.c           |  126 +++++++---------
 fs/ocfs2/ocfs2_trace.h     |  351 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 408 insertions(+), 71 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 44d22cd..89cdbf8 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -96,7 +96,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_GLUE),
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
-	define_mask(NAMEI),
 	define_mask(VOTE),
 	define_mask(DCACHE),
 	define_mask(CONN),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 789e735..8a8386f 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -98,7 +98,6 @@
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
-#define ML_NAMEI	0x0000000000400000ULL /* ocfs2 directory / namespace */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_DCACHE	0x0000000002000000ULL /* ocfs2 dcache operations */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f52e6bf..3370616 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -42,7 +42,6 @@
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
 
-#define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -63,6 +62,7 @@
 #include "uptodate.h"
 #include "xattr.h"
 #include "acl.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -106,17 +106,15 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *ret;
 	struct ocfs2_inode_info *oi;
 
-	mlog(0, "(0x%p, 0x%p, '%.*s')\n", dir, dentry,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_lookup(dir, dentry, dentry->d_name.len,
+			   dentry->d_name.name,
+			   (unsigned long long)OCFS2_I(dir)->ip_blkno, 0);
 
 	if (dentry->d_name.len > OCFS2_MAX_FILENAME_LEN) {
 		ret = ERR_PTR(-ENAMETOOLONG);
 		goto bail;
 	}
 
-	mlog(0, "find name %.*s in directory %llu\n", dentry->d_name.len,
-	     dentry->d_name.name, (unsigned long long)OCFS2_I(dir)->ip_blkno);
-
 	status = ocfs2_inode_lock_nested(dir, NULL, 0, OI_LS_PARENT);
 	if (status < 0) {
 		if (status != -ENOENT)
@@ -183,7 +181,7 @@ bail_unlock:
 
 bail:
 
-	mlog(0, "%p\n", ret);
+	trace_ocfs2_lookup_ret(ret);
 
 	return ret;
 }
@@ -236,9 +234,9 @@ static int ocfs2_mknod(struct inode *dir,
 	sigset_t oldset;
 	int did_block_signals = 0;
 
-	mlog(0, "(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
-	     (unsigned long)dev, dentry->d_name.len,
-	     dentry->d_name.name);
+	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
+			  (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			  (unsigned long)dev, mode);
 
 	dquot_initialize(dir);
 
@@ -355,10 +353,6 @@ static int ocfs2_mknod(struct inode *dir,
 		goto leave;
 	did_quota_inode = 1;
 
-	mlog(0, "(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry,
-	     inode->i_mode, (unsigned long)dev, dentry->d_name.len,
-	     dentry->d_name.name);
-
 	/* do the real work now. */
 	status = ocfs2_mknod_locked(osb, dir, inode, dev,
 				    &new_fe_bh, parent_fe_bh, handle,
@@ -438,9 +432,6 @@ leave:
 	if (did_block_signals)
 		ocfs2_unblock_signals(&oldset);
 
-	if (status == -ENOSPC)
-		mlog(0, "Disk is full\n");
-
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
 	kfree(si.name);
@@ -619,8 +610,8 @@ static int ocfs2_mkdir(struct inode *dir,
 {
 	int ret;
 
-	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_mkdir(dir, dentry, dentry->d_name.len, dentry->d_name.name,
+			  OCFS2_I(dir)->ip_blkno, mode);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFDIR, 0);
 	if (ret)
 		mlog_errno(ret);
@@ -635,8 +626,8 @@ static int ocfs2_create(struct inode *dir,
 {
 	int ret;
 
-	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry, mode,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_create(dir, dentry, dentry->d_name.len, dentry->d_name.name,
+			   (unsigned long long)OCFS2_I(dir)->ip_blkno, mode);
 	ret = ocfs2_mknod(dir, dentry, mode | S_IFREG, 0);
 	if (ret)
 		mlog_errno(ret);
@@ -658,9 +649,9 @@ static int ocfs2_link(struct dentry *old_dentry,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
 
-	mlog(0, "(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
-	     old_dentry->d_name.len, old_dentry->d_name.name,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_link((unsigned long long)OCFS2_I(inode)->ip_blkno,
+			 old_dentry->d_name.len, old_dentry->d_name.name,
+			 dentry->d_name.len, dentry->d_name.name);
 
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
@@ -817,19 +808,17 @@ static int ocfs2_unlink(struct inode *dir,
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 
-	mlog(0, "(0x%p, 0x%p, '%.*s')\n", dir, dentry,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_unlink(dir, dentry, dentry->d_name.len,
+			   dentry->d_name.name,
+			   (unsigned long long)OCFS2_I(dir)->ip_blkno,
+			   (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	dquot_initialize(dir);
 
 	BUG_ON(dentry->d_parent->d_inode != dir);
 
-	mlog(0, "ino = %llu\n", (unsigned long long)OCFS2_I(inode)->ip_blkno);
-
-	if (inode == osb->root_inode) {
-		mlog(0, "Cannot delete the root directory\n");
+	if (inode == osb->root_inode)
 		return -EPERM;
-	}
 
 	status = ocfs2_inode_lock_nested(dir, &parent_node_bh, 1,
 					 OI_LS_PARENT);
@@ -851,9 +840,10 @@ static int ocfs2_unlink(struct inode *dir,
 	if (OCFS2_I(inode)->ip_blkno != blkno) {
 		status = -ENOENT;
 
-		mlog(0, "ip_blkno %llu != dirent blkno %llu ip_flags = %x\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     (unsigned long long)blkno, OCFS2_I(inode)->ip_flags);
+		trace_ocfs2_unlink_noent(
+				(unsigned long long)OCFS2_I(inode)->ip_blkno,
+				(unsigned long long)blkno,
+				OCFS2_I(inode)->ip_flags);
 		goto leave;
 	}
 
@@ -984,9 +974,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	struct buffer_head **tmpbh;
 	struct inode *tmpinode;
 
-	mlog(0, "(inode1 = %llu, inode2 = %llu)\n",
-	     (unsigned long long)oi1->ip_blkno,
-	     (unsigned long long)oi2->ip_blkno);
+	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
+				(unsigned long long)oi2->ip_blkno);
 
 	if (*bh1)
 		*bh1 = NULL;
@@ -997,7 +986,6 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	if (oi1->ip_blkno != oi2->ip_blkno) {
 		if (oi1->ip_blkno < oi2->ip_blkno) {
 			/* switch id1 and id2 around */
-			mlog(0, "switching them around...\n");
 			tmpbh = bh2;
 			bh2 = bh1;
 			bh1 = tmpbh;
@@ -1030,6 +1018,10 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 			mlog_errno(status);
 	}
 
+	trace_ocfs2_double_lock_end(
+			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
+			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+
 bail:
 	if (status)
 		mlog_errno(status);
@@ -1074,10 +1066,9 @@ static int ocfs2_rename(struct inode *old_dir,
 	/* At some point it might be nice to break this function up a
 	 * bit. */
 
-	mlog(0, "(0x%p, 0x%p, 0x%p, 0x%p, from='%.*s' to='%.*s')\n",
-	     old_dir, old_dentry, new_dir, new_dentry,
-	     old_dentry->d_name.len, old_dentry->d_name.name,
-	     new_dentry->d_name.len, new_dentry->d_name.name);
+	trace_ocfs2_rename(old_dir, old_dentry, new_dir, new_dentry,
+			   old_dentry->d_name.len, old_dentry->d_name.name,
+			   new_dentry->d_name.len, new_dentry->d_name.name);
 
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
@@ -1234,16 +1225,15 @@ static int ocfs2_rename(struct inode *old_dir,
 		if (!new_inode) {
 			status = -EACCES;
 
-			mlog(0, "We found an inode for name %.*s but VFS "
-			     "didn't give us one.\n", new_dentry->d_name.len,
-			     new_dentry->d_name.name);
+			trace_ocfs2_rename_target_exists(new_dentry->d_name.len,
+						new_dentry->d_name.name);
 			goto bail;
 		}
 
 		if (OCFS2_I(new_inode)->ip_blkno != newfe_blkno) {
 			status = -EACCES;
 
-			mlog(0, "Inode %llu and dir %llu disagree. flags = %x\n",
+			trace_ocfs2_rename_disagree(
 			     (unsigned long long)OCFS2_I(new_inode)->ip_blkno,
 			     (unsigned long long)newfe_blkno,
 			     OCFS2_I(new_inode)->ip_flags);
@@ -1266,8 +1256,7 @@ static int ocfs2_rename(struct inode *old_dir,
 
 		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
 
-		mlog(0, "aha rename over existing... new_blkno=%llu "
-		     "newfebh=%p bhblocknr=%llu\n",
+		trace_ocfs2_rename_over_existing(
 		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
 		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
 
@@ -1509,9 +1498,8 @@ static int ocfs2_create_symlink_data(struct ocfs2_super *osb,
 	 * write i_size + 1 bytes. */
 	blocks = (bytes_left + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 
-	mlog(0, "i_blocks = %llu, i_size = %llu, blocks = %d\n",
-	     (unsigned long long)inode->i_blocks,
-	     i_size_read(inode), blocks);
+	trace_ocfs2_create_symlink_data((unsigned long long)inode->i_blocks,
+					i_size_read(inode), blocks);
 
 	/* Sanity check -- make sure we're going to fit. */
 	if (bytes_left >
@@ -1619,8 +1607,8 @@ static int ocfs2_symlink(struct inode *dir,
 	sigset_t oldset;
 	int did_block_signals = 0;
 
-	mlog(0, "(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
-	     dentry, symname, dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_symlink_begin(dir, dentry, symname,
+				  dentry->d_name.len, dentry->d_name.name);
 
 	dquot_initialize(dir);
 
@@ -1722,9 +1710,10 @@ static int ocfs2_symlink(struct inode *dir,
 		goto bail;
 	did_quota_inode = 1;
 
-	mlog(0, "(0x%p, 0x%p, %d, '%.*s')\n", dir, dentry,
-	     inode->i_mode, dentry->d_name.len,
-	     dentry->d_name.name);
+	trace_ocfs2_symlink_create(dir, dentry, dentry->d_name.len,
+				   dentry->d_name.name,
+				   (unsigned long long)OCFS2_I(dir)->ip_blkno,
+				   inode->i_mode);
 
 	status = ocfs2_mknod_locked(osb, dir, inode,
 				    0, &new_fe_bh, parent_fe_bh, handle,
@@ -1871,8 +1860,7 @@ static int ocfs2_blkno_stringify(u64 blkno, char *name)
 		goto bail;
 	}
 
-	mlog(0, "built filename '%s' for orphan dir (len=%d)\n", name,
-	     namelen);
+	trace_ocfs2_blkno_stringify(blkno, name, namelen);
 
 	status = 0;
 bail:
@@ -2008,7 +1996,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	struct ocfs2_dinode *orphan_fe;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
-	mlog(0, "(inode->i_ino = %lu)\n", inode->i_ino);
+	trace_ocfs2_orphan_add_begin(
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	status = ocfs2_read_inode_block(orphan_dir_inode, &orphan_dir_bh);
 	if (status < 0) {
@@ -2067,8 +2056,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 
 	ocfs2_journal_dirty(handle, fe_bh);
 
-	mlog(0, "Inode %llu orphaned in slot %d\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, osb->slot_num);
+	trace_ocfs2_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   osb->slot_num);
 
 leave:
 	brelse(orphan_dir_bh);
@@ -2096,9 +2085,9 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	mlog(0, "removing '%s' from orphan dir %llu (namelen=%d)\n",
-	     name, (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
-	     OCFS2_ORPHAN_NAMELEN);
+	trace_ocfs2_orphan_del(
+	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
+	     name, OCFS2_ORPHAN_NAMELEN);
 
 	/* find it's spot in the orphan directory */
 	status = ocfs2_find_entry(name, OCFS2_ORPHAN_NAMELEN, orphan_dir_inode,
@@ -2332,9 +2321,6 @@ leave:
 		iput(orphan_dir);
 	}
 
-	if (status == -ENOSPC)
-		mlog(0, "Disk is full\n");
-
 	if ((status < 0) && inode) {
 		clear_nlink(inode);
 		iput(inode);
@@ -2369,8 +2355,10 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	mlog(0, "(0x%p, 0x%p, %.*s')\n", dir, dentry,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_mv_orphaned_inode_to_new(dir, dentry,
+				dentry->d_name.len, dentry->d_name.name,
+				(unsigned long long)OCFS2_I(dir)->ip_blkno,
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
 	if (status < 0) {
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 6456975..fa424a6 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -3307,6 +3307,357 @@ DEFINE_EVENT(ocfs2__ull_int, ocfs2_prepare_dir_for_insert,
 	TP_ARGS(dir, namelen)
 );
 /* End of trace events for fs/ocfs2/dir.c. */
+
+/* Trace events for fs/ocfs2/namei.c. */
+DECLARE_EVENT_CLASS(ocfs2__dentry_ops,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long extra),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, extra),
+
+	TP_STRUCT__entry(
+		__field(	void *,			dir		)
+		__field(	void *,			dentry		)
+		__field(	int,			name_len	)
+		__field(	const char *,		name		)
+		__field(	unsigned long long,	dir_blkno	)
+		__field(	unsigned long long,	extra		)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->dentry		= 	dentry;
+		__entry->name_len	= 	name_len;
+		__entry->name		= 	name;
+		__entry->dir_blkno	= 	dir_blkno;
+		__entry->extra		= 	extra;
+	),
+
+	TP_printk("%p %p %.*s %llu %llu", __entry->dir, __entry->dentry,
+		  __entry->name_len, __entry->name,
+		  __entry->dir_blkno, __entry->extra)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_lookup,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long extra),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, extra)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_lookup_ret,
+
+	TP_PROTO(void *ret),
+
+	TP_ARGS(ret)
+);
+
+TRACE_EVENT(ocfs2_mknod,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long dev, int mode),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, dev, mode),
+
+	TP_STRUCT__entry(
+		__field(	void *,			dir		)
+		__field(	void *,			dentry		)
+		__field(	int,			name_len	)
+		__field(	const char *,		name		)
+		__field(	unsigned long long,	dir_blkno	)
+		__field(	unsigned long,		dev		)
+		__field(	int,			mode		)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->dentry		= 	dentry;
+		__entry->name_len	= 	name_len;
+		__entry->name		= 	name;
+		__entry->dir_blkno	= 	dir_blkno;
+		__entry->dev		= 	dev;
+		__entry->mode		= 	mode;
+	),
+
+	TP_printk("%p %p %.*s %llu %lu %d", __entry->dir, __entry->dentry,
+		  __entry->name_len, __entry->name,
+		  __entry->dir_blkno, __entry->dev, __entry->mode)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_mkdir,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long mode),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, mode)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_create,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long mode),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, mode)
+);
+
+TRACE_EVENT(ocfs2_link,
+
+	TP_PROTO(unsigned long long ino, int old_len, const char *old_name,
+		 int name_len, const char *name),
+
+	TP_ARGS(ino, old_len, old_name, name_len, name),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	int,			old_len		)
+		__field(	const char *,		old_name	)
+		__field(	int,			name_len	)
+		__field(	const char *,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= 	ino;
+		__entry->old_len	= 	old_len;
+		__entry->old_name	= 	old_name;
+		__entry->name_len	= 	name_len;
+		__entry->name		= 	name;
+	),
+
+	TP_printk("%llu %.*s %.*s", __entry->ino,
+		  __entry->old_len, __entry->old_name,
+		  __entry->name_len, __entry->name)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_unlink,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long ino),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, ino)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_unlink_noent,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long blkno,
+		 unsigned int ip_flags),
+
+	TP_ARGS(ip_blkno, blkno, ip_flags)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_double_lock,
+
+	TP_PROTO(unsigned long long blkno1, unsigned long long blkno2),
+
+	TP_ARGS(blkno1, blkno2)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_double_lock_end,
+
+	TP_PROTO(unsigned long long blkno1, unsigned long long blkno2),
+
+	TP_ARGS(blkno1, blkno2)
+);
+
+TRACE_EVENT(ocfs2_rename,
+
+	TP_PROTO(void *old_dir, void *old_dentry,
+		 void *new_dir, void *new_dentry,
+		 int old_len, const char *old_name,
+		 int new_len, const char *new_name),
+
+	TP_ARGS(old_dir, old_dentry, new_dir, new_dentry,
+		old_len, old_name, new_len, new_name),
+
+	TP_STRUCT__entry(
+		__field(	void *,			old_dir		)
+		__field(	void *,			old_dentry	)
+		__field(	void *,			new_dir		)
+		__field(	void *,			new_dentry	)
+		__field(	int,			old_len		)
+		__field(	const char *,		old_name	)
+		__field(	int,			new_len		)
+		__field(	const char *,		new_name	)
+	),
+
+	TP_fast_assign(
+		__entry->old_dir		= 	old_dir;
+		__entry->old_dentry		= 	old_dentry;
+		__entry->new_dir		= 	new_dir;
+		__entry->new_dentry		= 	new_dentry;
+		__entry->old_len		= 	old_len;
+		__entry->old_name		= 	old_name;
+		__entry->new_len		= 	new_len;
+		__entry->new_name		= 	new_name;
+	),
+
+	TP_printk("%p %p %p %p %.*s %.*s",
+		  __entry->old_dir, __entry->old_dentry,
+		  __entry->new_dir, __entry->new_dentry,
+		  __entry->old_len, __entry->old_name,
+		  __entry->new_len, __entry->new_name)
+);
+
+TRACE_EVENT(ocfs2_rename_target_exists,
+
+	TP_PROTO(int new_len, const char *new_name),
+
+	TP_ARGS(new_len, new_name),
+
+	TP_STRUCT__entry(
+		__field(	int,			new_len		)
+		__field(	const char *,		new_name	)
+	),
+
+	TP_fast_assign(
+		__entry->new_len		= 	new_len;
+		__entry->new_name		= 	new_name;
+	),
+
+	TP_printk("%.*s", __entry->new_len, __entry->new_name)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_rename_disagree,
+
+	TP_PROTO(unsigned long long ip_blkno, unsigned long long new_blkno,
+		 unsigned int ip_flags),
+
+	TP_ARGS(ip_blkno, new_blkno, ip_flags)
+);
+
+TRACE_EVENT(ocfs2_rename_over_existing,
+
+	TP_PROTO(unsigned long long new_blkno, void *new_bh,
+		 unsigned long long newdi_blkno),
+
+	TP_ARGS(new_blkno, new_bh, newdi_blkno),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	new_blkno	)
+		__field(	void *,			new_bh		)
+		__field(	unsigned long long,	newdi_blkno	)
+	),
+
+	TP_fast_assign(
+		__entry->new_blkno	= 	new_blkno;
+		__entry->new_bh		= 	new_bh;
+		__entry->newdi_blkno	= 	newdi_blkno;
+	),
+
+	TP_printk("%llu %p %llu", __entry->new_blkno, __entry->new_bh,
+		  __entry->newdi_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_create_symlink_data,
+
+	TP_PROTO(unsigned long long iblocks, unsigned long long i_size,
+		 unsigned int blocks),
+
+	TP_ARGS(iblocks, i_size, blocks)
+);
+
+TRACE_EVENT(ocfs2_symlink_begin,
+
+	TP_PROTO(void *dir, void *dentry, const char *symname,
+		 int len, const char *name),
+
+	TP_ARGS(dir, dentry, symname, len, name),
+
+	TP_STRUCT__entry(
+		__field(	void *,			dir		)
+		__field(	void *,			dentry		)
+		__field(	const char *,		symname		)
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->dentry		= 	dentry;
+		__entry->symname	= 	symname;
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+	),
+
+	TP_printk("%p %p %s %.*s", __entry->dir, __entry->dentry,
+		  __entry->symname, __entry->len, __entry->name)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_symlink_create,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long mode),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, mode)
+);
+
+TRACE_EVENT(ocfs2_blkno_stringify,
+
+	TP_PROTO(unsigned long long blkno, const char *name, int namelen),
+
+	TP_ARGS(blkno, name, namelen),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	blkno		)
+		__field(	const char *,		name		)
+		__field(	int,			namelen		)
+	),
+
+	TP_fast_assign(
+		__entry->blkno		= 	blkno;
+		__entry->name		= 	name;
+		__entry->namelen	= 	namelen;
+	),
+
+	TP_printk("%llu %s %d", __entry->blkno, __entry->name,
+		  __entry->namelen)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_orphan_add_begin,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+DEFINE_EVENT(ocfs2__ull_uint, ocfs2_orphan_add_end,
+
+	TP_PROTO(unsigned long long ino, unsigned int slot),
+
+	TP_ARGS(ino, slot)
+);
+
+TRACE_EVENT(ocfs2_orphan_del,
+
+	TP_PROTO(unsigned long long dir, const char *name, int namelen),
+
+	TP_ARGS(dir, name, namelen),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	dir		)
+		__field(	const char *,		name		)
+		__field(	int,			namelen		)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->name		= 	name;
+		__entry->namelen	= 	namelen;
+	),
+
+	TP_printk("%llu %s %d", __entry->dir, __entry->name,
+		  __entry->namelen)
+);
+
+DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_mv_orphaned_inode_to_new,
+
+	TP_PROTO(void *dir, void *dentry, int name_len, const char *name,
+		 unsigned long long dir_blkno, unsigned long long ino),
+
+	TP_ARGS(dir, dentry, name_len, name, dir_blkno, ino)
+);
+/* End of trace events for fs/ocfs2/namei.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
