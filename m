From: wen.gang.wang at oracle.com <wen.gang.wang@oracle.com>
Date: Tue, 10 Jun 2008 14:24:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Handle error during journal load
Message-ID: <1213079088-9921-1-git-send-email-wen.gang.wang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>

This patch ensures the mount fails if the fs is unable to load the journal.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index df63ba2..ccecfe5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1703,7 +1703,11 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 	local = ocfs2_mount_local(osb);
 
 	/* will play back anything left in the journal. */
-	ocfs2_journal_load(osb->journal, local);
+	status = ocfs2_journal_load(osb->journal, local);
+	if (status < 0) {
+		mlog(ML_ERROR, "ocfs2 journal load failed! %d\n", status);
+		goto finally;
+	}
 
 	if (dirty) {
 		/* recover my local alloc if we didn't unmount cleanly. */
-- 
1.5.3.2
