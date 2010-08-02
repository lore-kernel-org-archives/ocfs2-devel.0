From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  2 Aug 2010 11:02:15 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Add some trace log for orphan scan.
In-Reply-To: <4C56350A.7090309@oracle.com>
References: <4C56350A.7090309@oracle.com>
Message-ID: <1280718135-11036-4-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now orphan scan worker has no trace log, so it is
very hard to tell whether it is finished or blocked.
So add 2 mlog trace log so that we can tell whether
the current orphan scan worker is blocked or not.
It does help when I analyzed an orphan scan bug.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/journal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ac2ea71..9209f19 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1887,6 +1887,8 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
 		goto out;
 
+	mlog(0, "Begin orphan scan\n");
+
 	status = ocfs2_orphan_scan_lock(osb, &seqno);
 	if (status < 0) {
 		if (status != -EAGAIN)
@@ -1915,6 +1917,7 @@ void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 	os->os_scantime = CURRENT_TIME;
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno);
+	mlog(0, "Orphan scan completed\n");
 out:
 	return;
 }
-- 
1.7.1.571.gba4d01
