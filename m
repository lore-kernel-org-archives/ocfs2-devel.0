From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  9 Feb 2010 16:02:00 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST for a
	drop lock
Message-ID: <1265760120-4416-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlmglue should ignore BASTs fired after an AST for a drop lock.

Reported-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlmglue.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1dab85b..a34b821 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -920,8 +920,10 @@ static int ocfs2_generic_handle_bast(struct ocfs2_lock_res *lockres,
 		 * one that goes low enough to satisfy the level we're
 		 * blocking.  this also catches the case where we get
 		 * duplicate BASTs */
-		if (ocfs2_highest_compat_lock_level(level) <
-		    ocfs2_highest_compat_lock_level(lockres->l_blocking))
+		if ((ocfs2_highest_compat_lock_level(level) <
+		     lockres->l_level) &&
+		    (ocfs2_highest_compat_lock_level(level) <
+		     ocfs2_highest_compat_lock_level(lockres->l_blocking)))
 			needs_downconvert = 1;
 
 		lockres->l_blocking = level;
@@ -3478,9 +3480,10 @@ recheck:
 	/*
 	 * How can we block and yet be at NL?  We were trying to upconvert
 	 * from NL and got canceled.  The code comes back here, and now
-	 * we notice and clear BLOCKING.
+	 * we notice and clear BLOCKING. It could be IV if the unlock ast
+	 * for the drop lock was received before the bast.
 	 */
-	if (lockres->l_level == DLM_LOCK_NL) {
+	if (lockres->l_level <= DLM_LOCK_NL) {
 		BUG_ON(lockres->l_ex_holders || lockres->l_ro_holders);
 		mlog(ML_NOTICE, "lock %s, Aborting dc\n", lockres->l_name);
 		lockres->l_blocking = DLM_LOCK_NL;
-- 
1.6.3.3
