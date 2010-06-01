From: Tao Ma <tao.ma@oracle.com>
Date: Tue,  1 Jun 2010 13:58:13 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add some trace log for orphan scan.
Message-ID: <1275371893-6452-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now orphan scan worker has no trace log, so it is
very hard to tell whether it is finished or blocked.
So add 2 mlog trace log so that we can tell whether
the current orphan scan worker is blocked or not.
It does help when I analyzed a orphan scan bug.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 47878cf..776ab2f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1888,6 +1888,8 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 
 	os = &osb->osb_orphan_scan;
 
+	mlog(0, "Begin orphan scan\n");
+
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
 		goto out;
 
@@ -1920,6 +1922,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno);
 out:
+	mlog(0, "Orphan scan completed\n");
 	return;
 }
 
-- 
1.5.5
