From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 22 May 2015 15:12:26 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: do not BUG if
	jbd2_journal_dirty_metadata fails
Message-ID: <555ED6DA.8000607@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

jbd2_journal_dirty_metadata may fail. Currently it cannot take care of
non zero return value and just BUG in ocfs2_journal_dirty.
Instead of BUG, this patch is aborting the handle and journal, and then
set filesystem to read-only.

Changes since v2:
As Junxiao suggested, we also set filesystem read-only here.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/journal.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ff53192..4b28538 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -775,7 +775,20 @@ void ocfs2_journal_dirty(handle_t *handle, struct buffer_head *bh)
 	trace_ocfs2_journal_dirty((unsigned long long)bh->b_blocknr);

 	status = jbd2_journal_dirty_metadata(handle, bh);
-	BUG_ON(status);
+	if (status) {
+		mlog_errno(status);
+		if (!is_handle_aborted(handle)) {
+			journal_t *journal = handle->h_transaction->t_journal;
+			struct super_block *sb = bh->b_bdev->bd_super;
+
+			mlog(ML_ERROR, "jbd2_journal_dirty_metadata failed. "
+					"Aborting transaction and journal.\n");
+			handle->h_err = status;
+			jbd2_journal_abort_handle(handle);
+			jbd2_journal_abort(journal, status);
+			ocfs2_abort(sb, "Journal already aborted.\n");
+		}
+	}
 }

 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
-- 
1.8.4.3
