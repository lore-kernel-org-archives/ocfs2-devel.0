From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:03 +0800
Subject: [Ocfs2-devel] [PATCH 20/34] ocfs2: Remove masklog ML_SUPER.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-20-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/super.c and the masklog SUPER.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  141 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c           |   29 +++------
 4 files changed, 151 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index de807d2..b1e1799 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -93,7 +93,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_RECOVERY),
 	define_mask(AIO),
 	define_mask(JOURNAL),
-	define_mask(SUPER),
 	define_mask(DLM_GLUE),
 	define_mask(BH_IO),
 	define_mask(UPTODATE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index fca684c..c6fc51f 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -95,7 +95,6 @@
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_JOURNAL	0x0000000000004000ULL /* ocfs2 journalling functions */
-#define ML_SUPER	0x0000000000010000ULL /* ocfs2 mount / umount */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_BH_IO	0x0000000000100000ULL /* ocfs2 buffer I/O */
 #define ML_UPTODATE	0x0000000000200000ULL /* ocfs2 caching sequence #'s */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 576af58..28c4a05 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -57,6 +57,23 @@ DECLARE_EVENT_CLASS(ocfs2__ull,
 	TP_printk("%llu", __entry->blkno)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__pointer,
+
+	TP_PROTO(void *pointer),
+
+	TP_ARGS(pointer),
+
+	TP_STRUCT__entry(
+		__field(	void *,		pointer		)
+	),
+
+	TP_fast_assign(
+		__entry->pointer	= 	pointer;
+	),
+
+	TP_printk("%p", __entry->pointer)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__int_int,
 
 	TP_PROTO(int value1, int value2),
@@ -2323,6 +2340,130 @@ DEFINE_EVENT(ocfs2__int, ocfs2_find_slot,
 );
 
 /* End of trace events for fs/ocfs2/slot_map.c. */
+
+/* Trace events for fs/ocfs2/super.c. */
+TRACE_EVENT(ocfs2_remount,
+
+	TP_PROTO(unsigned long s_flags, unsigned long osb_flags, int flags),
+
+	TP_ARGS(s_flags, osb_flags, flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,		s_flags		)
+		__field(	unsigned long,		osb_flags	)
+		__field(	int,			flags		)
+	),
+
+	TP_fast_assign(
+		__entry->s_flags	= s_flags;
+		__entry->osb_flags	= osb_flags;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("%lu %lu %d", __entry->s_flags,
+		  __entry->osb_flags, __entry->flags)
+);
+
+TRACE_EVENT(ocfs2_fill_super,
+
+	TP_PROTO(void *sb, void *data, int silent),
+
+	TP_ARGS(sb, data, silent),
+
+	TP_STRUCT__entry(
+		__field(	void *,			sb		)
+		__field(	void *,			data		)
+		__field(	int,			silent		)
+	),
+
+	TP_fast_assign(
+		__entry->sb		= sb;
+		__entry->data		= data;
+		__entry->silent		= silent;
+	),
+
+	TP_printk("%p %p %d", __entry->sb, __entry->data, __entry->silent)
+);
+
+TRACE_EVENT(ocfs2_parse_options,
+
+	TP_PROTO(int is_remount, char *options),
+
+	TP_ARGS(is_remount, options),
+
+	TP_STRUCT__entry(
+		__field(	int,			is_remount	)
+		__field(	char *,			options		)
+	),
+
+	TP_fast_assign(
+		__entry->is_remount	= is_remount;
+		__entry->options	= options;
+	),
+
+	TP_printk("%d %s", __entry->is_remount, __entry->options)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_put_super,
+
+	TP_PROTO(void *sb),
+
+	TP_ARGS(sb)
+);
+
+TRACE_EVENT(ocfs2_statfs,
+
+	TP_PROTO(void *sb, void *buf),
+
+	TP_ARGS(sb, buf),
+
+	TP_STRUCT__entry(
+		__field(	void *,			sb		)
+		__field(	void *,			buf		)
+	),
+
+	TP_fast_assign(
+		__entry->sb		= sb;
+		__entry->buf		= buf;
+	),
+
+	TP_printk("%p %p", __entry->sb, __entry->buf)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_dismount_volume,
+
+	TP_PROTO(void *sb),
+
+	TP_ARGS(sb)
+);
+
+TRACE_EVENT(ocfs2_initialize_super,
+
+	TP_PROTO(char *label, char *uuid_str, unsigned long long root_dir,
+		 unsigned long long system_dir, int cluster_bits),
+
+	TP_ARGS(label, uuid_str, root_dir, system_dir, cluster_bits),
+
+	TP_STRUCT__entry(
+		__field(	char *,			label		)
+		__field(	char *,			uuid_str	)
+		__field(	unsigned long long,	root_dir	)
+		__field(	unsigned long long,	system_dir	)
+		__field(	int,			cluster_bits	)
+	),
+
+	TP_fast_assign(
+		__entry->label		= label;
+		__entry->uuid_str	= uuid_str;
+		__entry->root_dir	= root_dir;
+		__entry->system_dir	= system_dir;
+		__entry->cluster_bits	= cluster_bits;
+	),
+
+	TP_printk("%s %s %llu %llu %d", __entry->label, __entry->uuid_str,
+		  __entry->root_dir, __entry->system_dir, __entry->cluster_bits)
+);
+/* End of trace events for fs/ocfs2/super.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index e88013c..b8b0553 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -45,7 +45,6 @@
 #define CREATE_TRACE_POINTS
 #include "ocfs2_trace.h"
 
-#define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -673,12 +672,9 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (*flags & MS_RDONLY) {
-			mlog(0, "Going to ro mode.\n");
 			sb->s_flags |= MS_RDONLY;
 			osb->osb_flags |= OCFS2_OSB_SOFT_RO;
 		} else {
-			mlog(0, "Making ro filesystem writeable.\n");
-
 			if (osb->osb_flags & OCFS2_OSB_ERROR_FS) {
 				mlog(ML_ERROR, "Cannot remount RDWR "
 				     "filesystem due to previous errors.\n");
@@ -696,6 +692,7 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 			sb->s_flags &= ~MS_RDONLY;
 			osb->osb_flags &= ~OCFS2_OSB_SOFT_RO;
 		}
+		trace_ocfs2_remount(sb->s_flags, osb->osb_flags, *flags);
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
 		/* Enable quota accounting after remounting RW */
@@ -1022,7 +1019,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	char nodestr[8];
 	struct ocfs2_blockcheck_stats stats;
 
-	mlog(0, "%p, %p, %i", sb, data, silent);
+	trace_ocfs2_fill_super(sb, data, silent);
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
@@ -1309,8 +1306,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	char *p;
 	u32 tmp;
 
-	mlog(0, "remount: %d, options: \"%s\"\n", is_remount,
-	     options ? options : "(none)");
+	trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
 
 	mopt->commit_interval = 0;
 	mopt->mount_opt = OCFS2_MOUNT_NOINTR;
@@ -1674,7 +1670,7 @@ static void __exit ocfs2_exit(void)
 
 static void ocfs2_put_super(struct super_block *sb)
 {
-	mlog(0, "(0x%p)\n", sb);
+	trace_ocfs2_put_super(sb);
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
@@ -1689,7 +1685,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct buffer_head *bh = NULL;
 	struct inode *inode = NULL;
 
-	mlog(0, "(%p, %p)\n", dentry->d_sb, buf);
+	trace_ocfs2_statfs(dentry->d_sb, buf);
 
 	osb = OCFS2_SB(dentry->d_sb);
 
@@ -1910,7 +1906,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	struct ocfs2_super *osb = NULL;
 	char nodestr[8];
 
-	mlog(0, "(0x%p)\n", sb);
+	trace_ocfs2_dismount_volume(sb);
 
 	BUG_ON(!sb);
 	osb = OCFS2_SB(sb);
@@ -2124,7 +2120,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		status = -EINVAL;
 		goto bail;
 	}
-	mlog(0, "max_slots for this device: %u\n", osb->max_slots);
 
 	ocfs2_orphan_scan_init(osb);
 
@@ -2263,7 +2258,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
 	osb->s_clustersize = 1 << osb->s_clustersize_bits;
-	mlog(0, "clusterbits=%d\n", osb->s_clustersize_bits);
 
 	if (osb->s_clustersize < OCFS2_MIN_CLUSTERSIZE ||
 	    osb->s_clustersize > OCFS2_MAX_CLUSTERSIZE) {
@@ -2302,11 +2296,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		le64_to_cpu(di->id2.i_super.s_first_cluster_group);
 	osb->fs_generation = le32_to_cpu(di->i_fs_generation);
 	osb->uuid_hash = le32_to_cpu(di->id2.i_super.s_uuid_hash);
-	mlog(0, "vol_label: %s\n", osb->vol_label);
-	mlog(0, "uuid: %s\n", osb->uuid_str);
-	mlog(0, "root_blkno=%llu, system_dir_blkno=%llu\n",
-	     (unsigned long long)osb->root_blkno,
-	     (unsigned long long)osb->system_dir_blkno);
+	trace_ocfs2_initialize_super(osb->vol_label, osb->uuid_str,
+				     (unsigned long long)osb->root_blkno,
+				     (unsigned long long)osb->system_dir_blkno,
+				     osb->s_clustersize_bits);
 
 	osb->osb_dlm_debug = ocfs2_new_dlm_debug();
 	if (!osb->osb_dlm_debug) {
@@ -2481,8 +2474,6 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		 * ourselves as mounted. */
 	}
 
-	mlog(0, "Journal loaded.\n");
-
 	status = ocfs2_load_local_alloc(osb);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.7.0.4
