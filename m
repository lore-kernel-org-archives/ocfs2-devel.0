From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 19 Nov 2018 16:07:25 +0800
Subject: [Ocfs2-devel] [PATCH V2 2/2] ocfs2: clear journal dirty flag after
	shutdown journal
In-Reply-To: <20181119080725.13059-1-junxiao.bi@oracle.com>
References: <20181119080725.13059-1-junxiao.bi@oracle.com>
Message-ID: <20181119080725.13059-2-junxiao.bi@oracle.com>
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
Cc: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/journal.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

 V1 -> V2:
 pointed by Yiwen, need check return value of jbd2_journal_destroy

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 13f8e097babf..b51bb873441f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -986,7 +986,8 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 			mlog_errno(status);
 	}
 
-	if (status == 0) {
+	/* Shutdown the kernel journal system */
+	if (!jbd2_journal_destroy(journal->j_journal) && !status) {
 		/*
 		 * Do not toggle if flush was unsuccessful otherwise
 		 * will leave dirty metadata in a "clean" journal
@@ -995,9 +996,6 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		if (status < 0)
 			mlog_errno(status);
 	}
-
-	/* Shutdown the kernel journal system */
-	jbd2_journal_destroy(journal->j_journal);
 	journal->j_journal = NULL;
 
 	OCFS2_I(inode)->ip_open_count--;
-- 
2.17.1
