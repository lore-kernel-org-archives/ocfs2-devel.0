From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:44 -0800
Subject: [Ocfs2-devel] [PATCH 29/35] ocfs2/dlm: Fix race during lockres
	mastery
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-30-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

dlm_get_lock_resource() is supposed to return a lock resource with a proper
master. If multiple concurrent threads attempt to lookup the lockres for the
same lockid while the lock mastery in underway, one or more threads are likely
to return a lockres without a proper master.

This patch makes the threads wait in dlm_get_lock_resource() while the mastery
is underway, ensuring all threads return the lockres with a proper master.

This issue is known to be limited to users using the flock() syscall. For all
other fs operations, the ocfs2 dlmglue layer serializes the dlm op for each
lockid.

Users encountering this bug will see flock() return EINVAL and dmesg have the
following error:
ERROR: Dlm error "DLM_BADARGS" while calling dlmlock on resource <LOCKID>: bad api args

Reported-by: Coly Li <coyli@suse.de>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index cbf3abe..54e182a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -732,14 +732,21 @@ lookup:
 	if (tmpres) {
 		int dropping_ref = 0;
 
+		spin_unlock(&dlm->spinlock);
+
 		spin_lock(&tmpres->spinlock);
+		/* We wait for the other thread that is mastering the resource */
+		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+			__dlm_wait_on_lockres(tmpres);
+			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
+		}
+
 		if (tmpres->owner == dlm->node_num) {
 			BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
 			dlm_lockres_grab_inflight_ref(dlm, tmpres);
 		} else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
 			dropping_ref = 1;
 		spin_unlock(&tmpres->spinlock);
-		spin_unlock(&dlm->spinlock);
 
 		/* wait until done messaging the master, drop our ref to allow
 		 * the lockres to be purged, start over. */
-- 
1.5.6
