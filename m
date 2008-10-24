From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:13 +0200
Subject: [Ocfs2-devel] [PATCH 20/29] ocfs2: Support nested transactions
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <1224886104206-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 can easily support nested transactions. We just have to
take care and not spoil statistics acquire semaphore unnecessarily.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 81e4067..f3d7c15 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -256,11 +256,9 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 	BUG_ON(osb->journal->j_state == OCFS2_JOURNAL_FREE);
 	BUG_ON(max_buffs <= 0);
 
-	/* JBD might support this, but our journalling code doesn't yet. */
-	if (journal_current_handle()) {
-		mlog(ML_ERROR, "Recursive transaction attempted!\n");
-		BUG();
-	}
+	/* Nested transaction? Just return the handle... */
+	if (journal_current_handle())
+		return jbd2_journal_start(journal, max_buffs);
 
 	down_read(&osb->journal->j_trans_barrier);
 
@@ -285,16 +283,18 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 int ocfs2_commit_trans(struct ocfs2_super *osb,
 		       handle_t *handle)
 {
-	int ret;
+	int ret, nested;
 	struct ocfs2_journal *journal = osb->journal;
 
 	BUG_ON(!handle);
 
+	nested = handle->h_ref > 1;
 	ret = jbd2_journal_stop(handle);
 	if (ret < 0)
 		mlog_errno(ret);
 
-	up_read(&journal->j_trans_barrier);
+	if (!nested)
+		up_read(&journal->j_trans_barrier);
 
 	return ret;
 }
-- 
1.5.2.4
