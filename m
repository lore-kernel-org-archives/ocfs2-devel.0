From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 14 Feb 2019 12:03:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: checkpoint appending truncate log
	transaction before flushing
Message-ID: <1550116993-17084-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Appending truncate log(TA) and and flushing truncate log(TF) are
two separated transactions. They can be both committed but not
checkpointed. If crash occurs then, both two transaction will be
replayed with several already released to global bitmap clusters.
Then truncate log will be replayed resulting in cluster double free.

To reproduce this issue, just crash the host while punching hole to files.

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/alloc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d1cbb27..29bc777 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6007,6 +6007,7 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 	struct buffer_head *data_alloc_bh = NULL;
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
+	struct ocfs2_journal *journal = osb->journal;
 
 	BUG_ON(inode_trylock(tl_inode));
 
@@ -6027,6 +6028,20 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 		goto out;
 	}
 
+	/* Appending truncate log(TA) and and flushing truncate log(TF) are
+	 * two separated transactions. They can be both committed but not
+	 * checkpointed. If crash occurs then, both two transaction will be
+	 * replayed with several already released to global bitmap clusters.
+	 * Then truncate log will be replayed resulting in cluster double free.
+	 */
+	jbd2_journal_lock_updates(journal->j_journal);
+	status = jbd2_journal_flush(journal->j_journal);
+	jbd2_journal_unlock_updates(journal->j_journal);
+	if (status < 0) {
+		mlog_errno(status);
+		goto out;
+	}
+
 	data_alloc_inode = ocfs2_get_system_file_inode(osb,
 						       GLOBAL_BITMAP_SYSTEM_INODE,
 						       OCFS2_INVALID_SLOT);
-- 
2.7.4
