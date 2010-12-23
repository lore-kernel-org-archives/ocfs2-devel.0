From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:11 +0800
Subject: [Ocfs2-devel] [PATCH 28/34] ocfs2: Remove masklog ML_DCACHE.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-28-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/dcache.c and the masklog DCACHE.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/dcache.c          |   44 +++++++-------
 fs/ocfs2/ocfs2_trace.h     |  143 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 165 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 89cdbf8..15f6f03 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -97,7 +97,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
 	define_mask(VOTE),
-	define_mask(DCACHE),
 	define_mask(CONN),
 	define_mask(QUORUM),
 	define_mask(EXPORT),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 8a8386f..7e76559 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -99,7 +99,6 @@
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
-#define ML_DCACHE	0x0000000002000000ULL /* ocfs2 dcache operations */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
 #define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 866d767..02e3998 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <linux/namei.h>
 
-#define MLOG_MASK_PREFIX ML_DCACHE
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -39,6 +38,7 @@
 #include "file.h"
 #include "inode.h"
 #include "super.h"
+#include "ocfs2_trace.h"
 
 void ocfs2_dentry_attach_gen(struct dentry *dentry)
 {
@@ -56,8 +56,8 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	int ret = 0;    /* if all else fails, just return false */
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
-	mlog(0, "(0x%p, '%.*s')\n", dentry,
-	     dentry->d_name.len, dentry->d_name.name);
+	trace_ocfs2_dentry_revalidate(dentry, dentry->d_name.len,
+				      dentry->d_name.name);
 
 	/* For a negative dentry -
 	 * check the generation number of the parent and compare with the
@@ -67,9 +67,10 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 		unsigned long gen = (unsigned long) dentry->d_fsdata;
 		unsigned long pgen =
 			OCFS2_I(dentry->d_parent->d_inode)->ip_dir_lock_gen;
-		mlog(0, "negative dentry: %.*s parent gen: %lu "
-			"dentry gen: %lu\n",
-			dentry->d_name.len, dentry->d_name.name, pgen, gen);
+
+		trace_ocfs2_dentry_revalidate_negative(dentry->d_name.len,
+						       dentry->d_name.name,
+						       pgen, gen);
 		if (gen != pgen)
 			goto bail;
 		goto valid;
@@ -84,8 +85,8 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	/* did we or someone else delete this inode? */
 	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED) {
 		spin_unlock(&OCFS2_I(inode)->ip_lock);
-		mlog(0, "inode (%llu) deleted, returning false\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		trace_ocfs2_dentry_revalidate_delete(
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 		goto bail;
 	}
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
@@ -95,10 +96,9 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	 * inode nlink hits zero, it never goes back.
 	 */
 	if (inode->i_nlink == 0) {
-		mlog(0, "Inode %llu orphaned, returning false "
-		     "dir = %d\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     S_ISDIR(inode->i_mode));
+		trace_ocfs2_dentry_revalidate_orphaned(
+			(unsigned long long)OCFS2_I(inode)->ip_blkno,
+			S_ISDIR(inode->i_mode));
 		goto bail;
 	}
 
@@ -107,9 +107,8 @@ static int ocfs2_dentry_revalidate(struct dentry *dentry,
 	 * redo it.
 	 */
 	if (!dentry->d_fsdata) {
-		mlog(0, "Inode %llu doesn't have dentry lock, "
-		     "returning false\n",
-		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		trace_ocfs2_dentry_revalidate_nofsdata(
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 		goto bail;
 	}
 
@@ -117,7 +116,7 @@ valid:
 	ret = 1;
 
 bail:
-	mlog(0, "ret = %d\n", ret);
+	trace_ocfs2_dentry_revalidate_ret(ret);
 	return ret;
 }
 
@@ -174,8 +173,8 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 		dentry = list_entry(p, struct dentry, d_alias);
 
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
-			mlog(0, "dentry found: %.*s\n",
-			     dentry->d_name.len, dentry->d_name.name);
+			trace_ocfs2_find_local_alias(dentry->d_name.len,
+						     dentry->d_name.name);
 
 			dget_locked(dentry);
 			break;
@@ -231,9 +230,8 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
 	struct dentry *alias;
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 
-	mlog(0, "Attach \"%.*s\", parent %llu, fsdata: %p\n",
-	     dentry->d_name.len, dentry->d_name.name,
-	     (unsigned long long)parent_blkno, dl);
+	trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
+				       (unsigned long long)parent_blkno, dl);
 
 	/*
 	 * Negative dentry. We ignore these for now.
@@ -283,7 +281,9 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
 				(unsigned long long)parent_blkno,
 				(unsigned long long)dl->dl_parent_blkno);
 
-		mlog(0, "Found: %s\n", dl->dl_lockres.l_name);
+		trace_ocfs2_dentry_attach_lock_found(dl->dl_lockres.l_name,
+				(unsigned long long)parent_blkno,
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 		goto out_attach;
 	}
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index fa424a6..61197a4 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -3658,6 +3658,149 @@ DEFINE_EVENT(ocfs2__dentry_ops, ocfs2_mv_orphaned_inode_to_new,
 	TP_ARGS(dir, dentry, name_len, name, dir_blkno, ino)
 );
 /* End of trace events for fs/ocfs2/namei.c. */
+
+/* Trace events for fs/ocfs2/dcache.c. */
+TRACE_EVENT(ocfs2_dentry_revalidate,
+
+	TP_PROTO(void *dentry, int len, const char *name),
+
+	TP_ARGS(dentry, len, name),
+
+	TP_STRUCT__entry(
+		__field(	void *,			dentry		)
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->dentry		= 	dentry;
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+	),
+
+	TP_printk("%p %.*s", __entry->dentry, __entry->len, __entry->name)
+);
+
+TRACE_EVENT(ocfs2_dentry_revalidate_negative,
+
+	TP_PROTO(int len, const char *name, unsigned long pgen,
+		 unsigned long gen),
+
+	TP_ARGS(len, name, pgen, gen),
+
+	TP_STRUCT__entry(
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+		__field(	unsigned long,		pgen		)
+		__field(	unsigned long,		gen		)
+	),
+
+	TP_fast_assign(
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+		__entry->pgen		= 	pgen;
+		__entry->gen		= 	gen;
+	),
+
+	TP_printk("%.*s %lu %lu", __entry->len, __entry->name,
+		  __entry->pgen, __entry->gen)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_dentry_revalidate_delete,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_dentry_revalidate_orphaned,
+
+	TP_PROTO(unsigned long long ino, int dir),
+
+	TP_ARGS(ino, dir)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_dentry_revalidate_nofsdata,
+
+	TP_PROTO(unsigned long long ino),
+
+	TP_ARGS(ino)
+);
+
+DEFINE_EVENT(ocfs2__int, ocfs2_dentry_revalidate_ret,
+
+	TP_PROTO(int ret),
+
+	TP_ARGS(ret)
+);
+
+TRACE_EVENT(ocfs2_find_local_alias,
+
+	TP_PROTO(int len, const char *name),
+
+	TP_ARGS(len, name),
+
+	TP_STRUCT__entry(
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+	),
+
+	TP_printk("%.*s", __entry->len, __entry->name)
+);
+
+TRACE_EVENT(ocfs2_dentry_attach_lock,
+
+	TP_PROTO(int len, const char *name,
+		 unsigned long long parent, void *fsdata),
+
+	TP_ARGS(len, name, parent, fsdata),
+
+	TP_STRUCT__entry(
+		__field(	int,			len		)
+		__field(	const char *,		name		)
+		__field(	unsigned long long,	parent		)
+		__field(	void *,			fsdata		)
+	),
+
+	TP_fast_assign(
+		__entry->len		= 	len;
+		__entry->name		= 	name;
+		__entry->parent		= 	parent;
+		__entry->fsdata		= 	fsdata;
+	),
+
+	TP_printk("%.*s %llu %p", __entry->len, __entry->name,
+		  __entry->parent, __entry->fsdata)
+);
+
+TRACE_EVENT(ocfs2_dentry_attach_lock_found,
+
+	TP_PROTO(const char *name, unsigned long long parent,
+		 unsigned long long ino),
+
+	TP_ARGS(name, parent, ino),
+
+	TP_STRUCT__entry(
+		__field(	const char *,		name		)
+		__field(	unsigned long long,	parent		)
+		__field(	unsigned long long,	ino		)
+	),
+
+	TP_fast_assign(
+		__entry->name		= 	name;
+		__entry->parent		= 	parent;
+		__entry->ino		= 	ino;
+	),
+
+	TP_printk("%s %llu %llu", __entry->name, __entry->parent, __entry->ino)
+);
+
+/* End of trace events for fs/ocfs2/dcache.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
