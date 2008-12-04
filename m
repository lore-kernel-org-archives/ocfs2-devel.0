From: Coly Li <coyli@suse.de>
Date: Thu, 04 Dec 2008 18:38:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix lockres mastery race, v2
Message-ID: <4937B32D.2040600@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dlm_get_lock_resource() is supposed to return a lock resource with a proper master. If multiple
concurrent threads attempt to lookup the lockres for the same lockid, one or more threads are likely
to return a lockres without a proper master, if the lock mastery is underway.

This patch makes the threads wait in dlm_get_lock_resource() while the mastery is underway, ensuring
all threads return the lockres with a proper master.

This issue is known limited to users using the flock() syscall. For all other fs operations, dlmglue
should ensure that only one thread is performing dlm operations for a given lockid at any one time.

Thank Sunil for his review and comments.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 44f87ca..dd1e754 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -742,6 +742,17 @@ lookup:
 			goto lookup;
 		}

+		/* wait for lock resource is being mastered by another thread */
+		spin_lock(&tmpres->spinlock);
+		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+			__dlm_wait_on_lockres_flags(tmpres, DLM_LOCK_RES_IN_PROGRESS);
+			spin_unlock(&tmpres->spinlock);
+			dlm_lockres_put(tmpres);
+			tmpres = NULL;
+			goto lookup;
+		}
+		spin_unlock(&tmpres->spinlock);
+
 		mlog(0, "found in hash!\n");
 		if (res)
 			dlm_lockres_put(res);
-- 
Coly Li
SuSE PRC Labs
