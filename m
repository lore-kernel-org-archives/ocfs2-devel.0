From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue,  3 Feb 2009 12:37:15 -0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2/dlm: Use ast_lock to protect
	ast_list
In-Reply-To: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
References: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1233693436-29263-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The code was using dlm->spinlock instead of dlm->ast_lock to protect the
ast_list. This patch fixes the issue.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmunlock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmunlock.c b/fs/ocfs2/dlm/dlmunlock.c
index 86ca085..fcf879e 100644
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -117,11 +117,11 @@ static enum dlm_status dlmunlock_common(struct dlm_ctxt *dlm,
 	else
 		BUG_ON(res->owner == dlm->node_num);
 
-	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->ast_lock);
 	/* We want to be sure that we're not freeing a lock
 	 * that still has AST's pending... */
 	in_use = !list_empty(&lock->ast_list);
-	spin_unlock(&dlm->spinlock);
+	spin_unlock(&dlm->ast_lock);
 	if (in_use) {
 	       mlog(ML_ERROR, "lockres %.*s: Someone is calling dlmunlock "
 		    "while waiting for an ast!", res->lockname.len,
-- 
1.5.6.3
