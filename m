From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 16 Nov 2018 16:58:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clear journal dirty flag after
	shutdown journal
Message-ID: <20181116085847.10066-1-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dirty flag of the journal should be cleared at the last stage of umount,
if do it before jbd2_journal_destroy(), then some metadata in uncommitted
transaction could be lost due to io error, but as dirty flag of journal
was already cleared, we can't find that until run a full fsck. This may
cause system panic or other corruption.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/journal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index b63c97f4318e..25d678c92fbb 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1017,6 +1017,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 			mlog_errno(status);
 	}
 
+	/* Shutdown the kernel journal system */
+	jbd2_journal_destroy(journal->j_journal);
+	journal->j_journal = NULL;
+
 	if (status == 0) {
 		/*
 		 * Do not toggle if flush was unsuccessful otherwise
@@ -1027,10 +1031,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 			mlog_errno(status);
 	}
 
-	/* Shutdown the kernel journal system */
-	jbd2_journal_destroy(journal->j_journal);
-	journal->j_journal = NULL;
-
 	OCFS2_I(inode)->ip_open_count--;
 
 	/* unlock our journal */
-- 
2.17.1
