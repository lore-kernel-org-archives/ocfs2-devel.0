Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECAC1FBE8C
	for <ocfs2-devel@lists.linux.dev>; Fri, 17 Jan 2025 09:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737105327; cv=none; b=IRUttpsVSLOW6emmIaX6MehENrtyL4Vz3BkFHkm7fZJiHDk9p0gfRLY/uC5erVZnhEBFiwW/P5pLMRByvP2O9jyCoBXp1f7r1HJGSIUApM2UovsQzjQd6BQViXrd2Zhd3B1xhSDs71Z5QSU31SwCenferntcQQonC753cedykVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737105327; c=relaxed/simple;
	bh=UL1kpnlJRe2FgSJIxN1ALQxE11N5PZHZiLtw1uBLpvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gv2t7DMVqODvaAjoLYgRXqCyiw74QQAITdyKSVfRdfkD98SzN6Rusimm4RH+sVDOafZVDzmU95JYZzCTzqw8zqXllb3KKjbttCsiBcsBKI+bsGLWPN536idv+k9I8gMep0o2vSNJhA0eGXRhU78aPk1GRxOssR80QwD/DOF+rLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JuERleFQ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JuERleFQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737105307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j4joo8wSmYF825mfUffHK2AkzP0a4DjGhE5PHP7VknU=;
	b=JuERleFQSlylWcBNegVaBkhmfJs4rS+uUuKrFJORNwYjQoGLbordnjCX/aIPZVvKoaG+nq
	SldUgYNnnfly5SJDy+VH7sxKWrm4nJTopAizITRn3/1hxr6FUmA0+RbI/z/I2h0kFTAV5I
	fVGwfntci6qj6V6DJipk5t5eaz7b3Jc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Use str_yes_no() and str_no_yes() helper functions
Date: Fri, 17 Jan 2025 10:13:29 +0100
Message-ID: <20250117091335.1189-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_yes_no() and str_no_yes()
helper functions.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/dlm/dlmdebug.c    |  9 +++++----
 fs/ocfs2/dlm/dlmmaster.c   | 12 ++++++------
 fs/ocfs2/dlm/dlmrecovery.c |  7 +++----
 fs/ocfs2/dlmglue.c         |  3 ++-
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e9ef4e2b0e75..fe4fdd09bae3 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
 #include <linux/export.h>
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -90,12 +91,12 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 	       buf, res->owner, res->state);
 	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
 	       res->last_used, kref_read(&res->refs),
-	       list_empty(&res->purge) ? "no" : "yes");
+	       str_no_yes(list_empty(&res->purge)));
 	printk("  on dirty list: %s, on reco list: %s, "
 	       "migrating pending: %s\n",
-	       list_empty(&res->dirty) ? "no" : "yes",
-	       list_empty(&res->recovering) ? "no" : "yes",
-	       res->migration_pending ? "yes" : "no");
+	       str_no_yes(list_empty(&res->dirty)),
+	       str_no_yes(list_empty(&res->recovering)),
+	       str_yes_no(res->migration_pending));
 	printk("  inflight locks: %d, asts reserved: %d\n",
 	       res->inflight_locks, atomic_read(&res->asts_reserved));
 	dlm_print_lockres_refmap(res);
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index d610da8e2f24..86bb1a03bcc1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -21,7 +21,7 @@
 #include <linux/inet.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
-
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -2859,7 +2859,7 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
 	dlm_lockres_release_ast(dlm, res);
 
 	mlog(0, "about to wait on migration_wq, dirty=%s\n",
-	       res->state & DLM_LOCK_RES_DIRTY ? "yes" : "no");
+	       str_yes_no(res->state & DLM_LOCK_RES_DIRTY));
 	/* if the extra ref we just put was the final one, this
 	 * will pass thru immediately.  otherwise, we need to wait
 	 * for the last ast to finish. */
@@ -2869,12 +2869,12 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
 		   msecs_to_jiffies(1000));
 	if (ret < 0) {
 		mlog(0, "woken again: migrating? %s, dead? %s\n",
-		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
-		       test_bit(target, dlm->domain_map) ? "no":"yes");
+		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
+		       str_no_yes(test_bit(target, dlm->domain_map)));
 	} else {
 		mlog(0, "all is well: migrating? %s, dead? %s\n",
-		       res->state & DLM_LOCK_RES_MIGRATING ? "yes":"no",
-		       test_bit(target, dlm->domain_map) ? "no":"yes");
+		       str_yes_no(res->state & DLM_LOCK_RES_MIGRATING),
+		       str_no_yes(test_bit(target, dlm->domain_map)));
 	}
 	if (!dlm_migration_can_proceed(dlm, res, target)) {
 		mlog(0, "trying again...\n");
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 50da8af988c1..380f9b777ad5 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -22,7 +22,7 @@
 #include <linux/timer.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
-
+#include <linux/string_choices.h>
 
 #include "../cluster/heartbeat.h"
 #include "../cluster/nodemanager.h"
@@ -581,8 +581,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 							   msecs_to_jiffies(1000));
 					mlog(0, "waited 1 sec for %u, "
 					     "dead? %s\n", ndata->node_num,
-					     dlm_is_node_dead(dlm, ndata->node_num) ?
-					     "yes" : "no");
+					     str_yes_no(dlm_is_node_dead(dlm, ndata->node_num)));
 				} else {
 					/* -ENOMEM on the other node */
 					mlog(0, "%s: node %u returned "
@@ -677,7 +676,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 		spin_unlock(&dlm_reco_state_lock);
 
 		mlog(0, "pass #%d, all_nodes_done?: %s\n", ++pass,
-		     all_nodes_done?"yes":"no");
+		     str_yes_no(all_nodes_done));
 		if (all_nodes_done) {
 			int ret;
 
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 764ecbd5ad41..30e4fedb3f02 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/quotaops.h>
 #include <linux/sched/signal.h>
+#include <linux/string_choices.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
 #include <cluster/masklog.h>
@@ -4339,7 +4340,7 @@ static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
 		ocfs2_schedule_blocked_lock(osb, lockres);
 
 	mlog(ML_BASTS, "lockres %s, requeue = %s.\n", lockres->l_name,
-	     ctl.requeue ? "yes" : "no");
+	     str_yes_no(ctl.requeue));
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	if (ctl.unblock_action != UNBLOCK_CONTINUE
-- 
2.48.0

