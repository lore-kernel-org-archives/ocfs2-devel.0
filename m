From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:41:20 -0700
Subject: [Ocfs2-devel] [patch 11/24] ocfs2: extend enough credits for
 freeing one truncate record while replaying truncate records
Message-ID: <55d79b00.Fdxqjm8MnWKomDdt%akpm@linux-foundation.org>
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
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records
+++ a/fs/ocfs2/alloc.c
@@ -5975,16 +5975,6 @@ static int ocfs2_replay_truncate_records
 
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
@@ -6005,6 +5995,13 @@ static int ocfs2_replay_truncate_records
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
 
@@ -6063,7 +6060,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out_mutex;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
+	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
_
