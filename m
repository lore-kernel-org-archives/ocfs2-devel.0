From: ge.changwei at h3c.com <ge.changwei@h3c.com>
Date: Fri, 23 Feb 2018 15:30:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean unrelated comment
Message-ID: <1519371054-4648-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Changwei Ge <ge.changwei@h3c.com>

Obviously, the comment before dlm_do_local_recovery_cleanup() has
nothing to do with it. So remove it.

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ec8f758..65f0c54 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2331,13 +2331,6 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 	__dlm_dirty_lockres(dlm, res);
 }
 
-/* if this node is the recovery master, and there are no
- * locks for a given lockres owned by this node that are in
- * either PR or EX mode, zero out the lvb before requesting.
- *
- */
-
-
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node)
 {
 	struct dlm_lock_resource *res;
-- 
2.7.4
