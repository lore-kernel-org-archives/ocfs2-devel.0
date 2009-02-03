From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:37:13 -0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2/dlm: Retract fix for race between
	purge and migrate
Message-ID: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit d4f7e650e55af6b235871126f747da88600e8040 attempts to delay
the dlm_thread from sending the drop ref message if the lockres is being
migrated. The problem is that we make the dlm_thread wait for the migration
to complete. This causes a deadlock as dlm_thread also participates in the
lockres migration process.

A better fix for the original oss bugzilla#1012 is in testing.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmthread.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index d129520..4060bb3 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -181,8 +181,7 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 
 		spin_lock(&res->spinlock);
 		/* This ensures that clear refmap is sent after the set */
-		__dlm_wait_on_lockres_flags(res, (DLM_LOCK_RES_SETREF_INPROG |
-						  DLM_LOCK_RES_MIGRATING));
+		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
 		spin_unlock(&res->spinlock);
 
 		/* clear our bit from the master's refmap, ignore errors */
-- 
1.5.6.3
