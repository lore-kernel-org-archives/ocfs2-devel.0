From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 29 Jan 2010 09:44:11 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not downconvert if the lock level
	is already compatible
Message-ID: <1264787051-7491-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During upconvert, if the master were to send a BAST, dlmglue will detect the
upconversion in process and send a cancel convert to the master. Upon receiving
the AST for the cancel convert, it will re-process the lock resource to determine
whether it needs downconverting. Say, the up was from PR to EX and the BAST was
for EX. After the cancel convert, it will need to downconvert to NL.

However, if the node was originally upconverting from NL to EX, then there would
be no reason to downconvert (assuming the same message sequence).

This patch makes dlmglue consider the possibility that the current lock level
is already compatible and that downconverting is not required.

Joel Becker <joel.becker@oracle.com> assisted in fixing this issue.

Fixes ossbz#1178
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1178

Reported-by: Coly Li <coly.li@suse.de>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f7b9f8f..2918c2c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3445,6 +3445,19 @@ recheck:
 	if (lockres->l_flags & OCFS2_LOCK_UPCONVERT_FINISHING)
 		goto leave_requeue;
 
+	/*
+	 * How can we block and yet be at NL?  We were trying to upconvert
+	 * from NL and got canceled.  The code comes back here, and now
+	 * we notice and clear BLOCKING.
+	 */
+	if (lockres->l_level == DLM_LOCK_NL) {
+		BUG_ON(lockres->l_ex_holders || lockres->l_ro_holders);
+		lockres->l_blocking = DLM_LOCK_NL;
+		lockres_clear_flags(lockres, OCFS2_LOCK_BLOCKED);
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		goto leave;
+	}
+
 	/* if we're blocking an exclusive and we have *any* holders,
 	 * then requeue. */
 	if ((lockres->l_blocking == DLM_LOCK_EX)
-- 
1.6.3.3
