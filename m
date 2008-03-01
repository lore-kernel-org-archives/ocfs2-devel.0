From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sat Mar  1 14:04:50 2008
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2/dlm: dlm_thread should not sleep
	while holding the dlm_spinlock
In-Reply-To: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
References: <1204409065-10953-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1204409065-10953-7-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch addresses the bug in which the dlm_thread could go to sleep
while holding the dlm_spinlock.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmthread.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index cebd089..4060bb3 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -176,12 +176,14 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 	     res->lockname.name, master);
 
 	if (!master) {
+		/* drop spinlock...  retake below */
+		spin_unlock(&dlm->spinlock);
+
 		spin_lock(&res->spinlock);
 		/* This ensures that clear refmap is sent after the set */
 		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
 		spin_unlock(&res->spinlock);
-		/* drop spinlock to do messaging, retake below */
-		spin_unlock(&dlm->spinlock);
+
 		/* clear our bit from the master's refmap, ignore errors */
 		ret = dlm_drop_lockres_ref(dlm, res);
 		if (ret < 0) {
-- 
1.5.3.6
