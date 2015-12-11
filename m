From: Xue jiufei <xuejiufei@huawei.com>
Date: Fri, 11 Dec 2015 11:09:33 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: fix a race between purge and
	migration
Message-ID: <566A3E6D.8050009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a race between purge and migration when doing code review.  Node
A put lockres to purgelist before receiving the migrate message from node
B which is the master. Node A call dlm_mig_lockres_handler to handle
this message.

dlm_mig_lockres_handler
  dlm_lookup_lockres
  >>>>>> race window, dlm_run_purge_list may run and send
         deref message to master, waiting the response
  spin_lock(&res->spinlock);
  res->state |= DLM_LOCK_RES_MIGRATING;
  spin_unlock(&res->spinlock);
  dlm_mig_lockres_handler returns

  >>>>>> dlm_thread receives the response from master for the deref
  message and triggers the BUG because the lockres has the state
  DLM_LOCK_RES_MIGRATING with the following message:

dlm_purge_lockres:209 ERROR: 6633EB681FA7474A9C280A4E1A836F0F:
res M0000000000000000030c0300000000 in use after deref

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 58eaa5c..4055909 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1373,6 +1373,7 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	char *buf = NULL;
 	struct dlm_work_item *item = NULL;
 	struct dlm_lock_resource *res = NULL;
+	unsigned int hash;
 
 	if (!dlm_grab(dlm))
 		return -EINVAL;
@@ -1400,7 +1401,10 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	/* lookup the lock to see if we have a secondary queue for this
 	 * already...  just add the locks in and this will have its owner
 	 * and RECOVERY flag changed when it completes. */
-	res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
+	hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
+	spin_lock(&dlm->spinlock);
+	res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
+			hash);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
@@ -1421,13 +1425,16 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 				     mres->lockname_len, mres->lockname);
 				ret = -EFAULT;
 				spin_unlock(&res->spinlock);
+				spin_unlock(&dlm->spinlock);
 				dlm_lockres_put(res);
 				goto leave;
 			}
 			res->state |= DLM_LOCK_RES_MIGRATING;
 		}
 		spin_unlock(&res->spinlock);
+		spin_unlock(&dlm->spinlock);
 	} else {
+		spin_unlock(&dlm->spinlock);
 		/* need to allocate, just like if it was
 		 * mastered here normally  */
 		res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);
-- 
1.8.4.3
