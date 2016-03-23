From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:28 -0700
Subject: [Ocfs2-devel] [patch 16/25] ocfs2: extend enough credits for
 freeing one truncate record while replaying truncate records
Message-ID: <56f2f8ac.N+n2D5Y7sAdYO5d2%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: extend enough credits for freeing one truncate record while replaying truncate records

Now function ocfs2_replay_truncate_records() first modifies tl_used, then
calls ocfs2_extend_trans() to extend transactions for gd and alloc inode
used for freeing clusters.  jbd2_journal_restart() may be called and it
may happen that tl_used in truncate log is decreased but the clusters are
not freed, which means these clusters are lost.  So we should avoid
extending transactions in these two operations.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records
+++ a/fs/ocfs2/alloc.c
@@ -5954,16 +5954,6 @@ static int ocfs2_replay_truncate_records
 
 		ocfs2_journal_dirty(handle, tl_bh);
 
-		/* TODO: Perhaps we can calculate the bulk of the
-		 * credits up front rather than extending like
-		 * this. */
-		status = ocfs2_extend_trans(handle,
-					    OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-
 		rec = tl->tl_recs[i];
 		start_blk = ocfs2_clusters_to_blocks(data_alloc_inode->i_sb,
 						    le32_to_cpu(rec.t_start));
@@ -5984,6 +5974,13 @@ static int ocfs2_replay_truncate_records
 				goto bail;
 			}
 		}
+
+		status = ocfs2_extend_trans(handle,
+				OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 		i--;
 	}
 
@@ -6042,7 +6039,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out_mutex;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
+	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
_
