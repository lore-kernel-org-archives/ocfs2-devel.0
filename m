From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:07 +0800
Subject: [Ocfs2-devel] [PATCH 24/34] ocfs2: Remove masklog ML_QUOTA.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-24-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Remove mlog(0) from fs/ocfs2/quota_global.c and
the masklog QUOTA.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/ocfs2_trace.h     |  110 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_global.c    |   24 +++++-----
 4 files changed, 122 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 64bf0b2..44d22cd 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -102,7 +102,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(CONN),
 	define_mask(QUORUM),
 	define_mask(EXPORT),
-	define_mask(QUOTA),
 	define_mask(BASTS),
 	define_mask(ERROR),
 	define_mask(NOTICE),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 57e12a8..789e735 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -104,7 +104,6 @@
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
 #define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
 #define ML_EXPORT	0x0000000010000000ULL /* ocfs2 export operations */
-#define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
 #define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index fef6478..f87a203 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -110,6 +110,25 @@ DECLARE_EVENT_CLASS(ocfs2__int_int,
 	TP_printk("%d %d", __entry->value1, __entry->value2)
 );
 
+DECLARE_EVENT_CLASS(ocfs2__uint_int,
+
+	TP_PROTO(unsigned int value1, int value2),
+
+	TP_ARGS(value1, value2),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	value1			)
+		__field(	int,		value2			)
+	),
+
+	TP_fast_assign(
+		__entry->value1	= 	value1;
+		__entry->value2	= 	value2;
+	),
+
+	TP_printk("%u %d", __entry->value1, __entry->value2)
+);
+
 DECLARE_EVENT_CLASS(ocfs2__uint_uint,
 
 	TP_PROTO(unsigned int value1, unsigned int value2),
@@ -3000,6 +3019,97 @@ DEFINE_EVENT(ocfs2__ull_ull_uint, olq_set_dquot,
 	TP_ARGS(space, inode, id)
 );
 /* End of trace events for fs/ocfs2/quota_local.c. */
+
+/* Trace events for fs/ocfs2/quota_global.c. */
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_quota_block,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+TRACE_EVENT(ocfs2_sync_dquot,
+
+	TP_PROTO(unsigned int dq_id, long long dqb_curspace,
+		 long long spacechange, long long curinodes,
+		 long long inodechange),
+
+	TP_ARGS(dq_id, dqb_curspace, spacechange, curinodes, inodechange),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	dq_id		)
+		__field(	long long,	dqb_curspace	)
+		__field(	long long,	spacechange	)
+		__field(	long long,	curinodes	)
+		__field(	long long,	inodechange	)
+	),
+
+	TP_fast_assign(
+		__entry->dq_id		= 	dq_id;
+		__entry->dqb_curspace	= 	dqb_curspace;
+		__entry->spacechange	= 	spacechange;
+		__entry->curinodes	= 	curinodes;
+		__entry->inodechange	= 	inodechange;
+	),
+
+	TP_printk("%u %lld %lld %lld %lld", __entry->dq_id,
+		  __entry->dqb_curspace, __entry->spacechange,
+		  __entry->curinodes, __entry->inodechange)
+);
+
+TRACE_EVENT(ocfs2_sync_dquot_helper,
+
+	TP_PROTO(unsigned int dq_id, unsigned int dq_type, unsigned long type,
+		 const char *s_id),
+
+	TP_ARGS(dq_id, dq_type, type, s_id),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	dq_id		)
+		__field(	unsigned int,	dq_type		)
+		__field(	unsigned long,	type		)
+		__field(	const char *,	s_id		)
+	),
+
+	TP_fast_assign(
+		__entry->dq_id		= 	dq_id;
+		__entry->dq_type	= 	dq_type;
+		__entry->type		= 	type;
+		__entry->s_id		= 	s_id;
+	),
+
+	TP_printk("%u %u %lu %s", __entry->dq_id, __entry->dq_type,
+		  __entry->type, __entry->s_id)
+);
+
+DEFINE_EVENT(ocfs2__uint_int, ocfs2_write_dquot,
+
+	TP_PROTO(unsigned int id, int type),
+
+	TP_ARGS(id, type)
+);
+
+DEFINE_EVENT(ocfs2__uint_int, ocfs2_release_dquot,
+
+	TP_PROTO(unsigned int id, int type),
+
+	TP_ARGS(id, type)
+);
+
+DEFINE_EVENT(ocfs2__uint_int, ocfs2_acquire_dquot,
+
+	TP_PROTO(unsigned int id, int type),
+
+	TP_ARGS(id, type)
+);
+
+DEFINE_EVENT(ocfs2__uint_int, ocfs2_mark_dquot_dirty,
+
+	TP_PROTO(unsigned int id, int type),
+
+	TP_ARGS(id, type)
+);
+/* End of trace events for fs/ocfs2/quota_global.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 10a49e8..64346f8 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -11,7 +11,6 @@
 #include <linux/writeback.h>
 #include <linux/workqueue.h>
 
-#define MLOG_MASK_PREFIX ML_QUOTA
 #include <cluster/masklog.h>
 
 #include "ocfs2_fs.h"
@@ -27,6 +26,7 @@
 #include "super.h"
 #include "buffer_head_io.h"
 #include "quota.h"
+#include "ocfs2_trace.h"
 
 /*
  * Locking of quotas with OCFS2 is rather complex. Here are rules that
@@ -132,8 +132,7 @@ int ocfs2_validate_quota_block(struct super_block *sb, struct buffer_head *bh)
 	struct ocfs2_disk_dqtrailer *dqt =
 		ocfs2_block_dqtrailer(sb->s_blocksize, bh->b_data);
 
-	mlog(0, "Validating quota block %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_quota_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -509,9 +508,10 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
 	olditime = dquot->dq_dqb.dqb_itime;
 	oldbtime = dquot->dq_dqb.dqb_btime;
 	ocfs2_global_disk2memdqb(dquot, &dqblk);
-	mlog(0, "Syncing global dquot %u space %lld+%lld, inodes %lld+%lld\n",
-	     dquot->dq_id, dquot->dq_dqb.dqb_curspace, (long long)spacechange,
-	     dquot->dq_dqb.dqb_curinodes, (long long)inodechange);
+	trace_ocfs2_sync_dquot(dquot->dq_id, dquot->dq_dqb.dqb_curspace,
+			       (long long)spacechange,
+			       dquot->dq_dqb.dqb_curinodes,
+			       (long long)inodechange);
 	if (!test_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags))
 		dquot->dq_dqb.dqb_curspace += spacechange;
 	if (!test_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags))
@@ -595,8 +595,8 @@ static int ocfs2_sync_dquot_helper(struct dquot *dquot, unsigned long type)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	int status = 0;
 
-	mlog(0, "id=%u qtype=%u type=%lu device=%s\n", dquot->dq_id,
-		   dquot->dq_type, type, sb->s_id);
+	trace_ocfs2_sync_dquot_helper(dquot->dq_id, dquot->dq_type,
+				      type, sb->s_id);
 	if (type != dquot->dq_type)
 		goto out;
 	status = ocfs2_lock_global_qf(oinfo, 1);
@@ -647,7 +647,7 @@ static int ocfs2_write_dquot(struct dquot *dquot)
 	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
 	int status = 0;
 
-	mlog(0, "id=%u, type=%d", dquot->dq_id, dquot->dq_type);
+	trace_ocfs2_write_dquot(dquot->dq_id, dquot->dq_type);
 
 	handle = ocfs2_start_trans(osb, OCFS2_QWRITE_CREDITS);
 	if (IS_ERR(handle)) {
@@ -685,7 +685,7 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	struct ocfs2_super *osb = OCFS2_SB(dquot->dq_sb);
 	int status = 0;
 
-	mlog(0, "id=%u, type=%d", dquot->dq_id, dquot->dq_type);
+	trace_ocfs2_release_dquot(dquot->dq_id, dquot->dq_type);
 
 	mutex_lock(&dquot->dq_lock);
 	/* Check whether we are not racing with some other dqget() */
@@ -743,7 +743,7 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	int need_alloc = ocfs2_global_qinit_alloc(sb, type);
 	handle_t *handle;
 
-	mlog(0, "id=%u, type=%d", dquot->dq_id, type);
+	trace_ocfs2_acquire_dquot(dquot->dq_id, type);
 	mutex_lock(&dquot->dq_lock);
 	/*
 	 * We need an exclusive lock, because we're going to update use count
@@ -830,7 +830,7 @@ static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 	handle_t *handle;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	mlog(0, "id=%u, type=%d", dquot->dq_id, type);
+	trace_ocfs2_mark_dquot_dirty(dquot->dq_id, type);
 
 	/* In case user set some limits, sync dquot immediately to global
 	 * quota file so that information propagates quicker */
-- 
1.7.0.4
