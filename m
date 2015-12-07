From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 7 Dec 2015 11:34:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix a race between purge and
	migratio
Message-ID: <5664FE40.2010105@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a race between purge and migration when doing code review.
Node A put lockres to purgelist before receiving the migrate message
from node B which is the master. dlm_mig_lockres_handler finds the
lockres and releases the dlm spinlock. Then dlm_thread on node A
can purge the lockres. dlm_mig_lockres_handler then gets the lockres
spinlock and sends assert master message to tell other nodes that node
A is the master now even lockres is purged. If node C set the master to
node A, and another node D master the lockres because no node respond
he is the master. That will make node C crash when node D send assert
master to node C. So check if lockres gets unhashed in
dlm_mig_lockres_handler to fix this race.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 58eaa5c..84908a0 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1400,11 +1400,33 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	/* lookup the lock to see if we have a secondary queue for this
 	 * already...  just add the locks in and this will have its owner
 	 * and RECOVERY flag changed when it completes. */
+way_up_top:
 	res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
 		spin_lock(&res->spinlock);
+
+		/*
+		 * Right after dlm spinlock was released, dlm_thread could have
+		 * purged the lockres. Check if lockres got unhashed. If so
+		 * start over.
+		 */
+		if (hlist_unhashed(&res->hash_node)) {
+			spin_unlock(&res->spinlock);
+			dlm_lockres_put(res);
+			goto way_up_top;
+		}
+
+		/* Wait on the resource purge to complete before continuing */
+		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+			__dlm_wait_on_lockres_flags(res,
+					DLM_LOCK_RES_DROPPING_REF);
+			spin_unlock(&res->spinlock);
+			dlm_lockres_put(res);
+			goto way_up_top;
+		}
+
 		if (mres->flags & DLM_MRES_RECOVERY) {
 			res->state |= DLM_LOCK_RES_RECOVERING;
 		} else {
-- 
1.8.4.3
