From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  1 Feb 2010 16:55:50 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Remove overzealous BUG_ON during
	blocked lock processing
Message-ID: <1265072150-29894-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During blocked lock processing, we should consider the possibility that the
lock is no longer blocking.

Joel Becker <joel.becker@oracle.com> assisted in fixing this issue.

Reported-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 2918c2c..1c4d704 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3392,9 +3392,17 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 
-	BUG_ON(!(lockres->l_flags & OCFS2_LOCK_BLOCKED));
-
 recheck:
+	/*
+	 * Is it still blocking? If not, we have no more work to do.
+	 */
+	if (!(lockres->l_flags & OCFS2_LOCK_BLOCKED)) {
+		BUG_ON(lockres->l_blocking != DLM_LOCK_NL);
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		ret = 0;
+		goto leave;
+	}
+
 	if (lockres->l_flags & OCFS2_LOCK_BUSY) {
 		/* XXX
 		 * This is a *big* race.  The OCFS2_LOCK_PENDING flag
-- 
1.6.3.3
