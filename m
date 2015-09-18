From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 18 Sep 2015 19:44:57 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix deadlock when dispatch assert
	master
Message-ID: <55FBF939.1000401@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The order of the following three spinlock should be:
dlm_domain_lock < dlm_ctxt->spinlock < dlm_lock_resource->spinlock

But dlm_dispatch_assert_master is called with holding dlm_ctxt->spinlock
and dlm_lock_resource->spinlock, and then it calls dlm_grab which will
take dlm_domain_lock.
Once another thread (for example, dlm_query_join_handler) has already
taken dlm_domain_lock, and tries to take dlm_ctxt->spinlock deadlock
happens.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ocfs2/dlm/dlmmaster.c   | 9 ++++++---
 fs/ocfs2/dlm/dlmrecovery.c | 8 ++++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index fdf4b41..482cfd3 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1439,6 +1439,7 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	int found, ret;
 	int set_maybe;
 	int dispatch_assert = 0;
+	int dispatched = 0;

 	if (!dlm_grab(dlm))
 		return DLM_MASTER_RESP_NO;
@@ -1658,15 +1659,18 @@ send_response:
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
-		} else
+		} else {
+			dispatched = 1;
 			__dlm_lockres_grab_inflight_worker(dlm, res);
+		}
 		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
 	}

-	dlm_put(dlm);
+	if (!dispatched)
+		dlm_put(dlm);
 	return response;
 }

@@ -2090,7 +2094,6 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,


 	/* queue up work for dlm_assert_master_worker */
-	dlm_grab(dlm);  /* get an extra ref for the work item */
 	dlm_init_work_item(dlm, item, dlm_assert_master_worker, NULL);
 	item->u.am.lockres = res; /* already have a ref */
 	/* can optionally ignore node numbers higher than this node */
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ce12e0b..3d90ad7 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1694,6 +1694,7 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 	unsigned int hash;
 	int master = DLM_LOCK_RES_OWNER_UNKNOWN;
 	u32 flags = DLM_ASSERT_MASTER_REQUERY;
+	int dispatched = 0;

 	if (!dlm_grab(dlm)) {
 		/* since the domain has gone away on this
@@ -1719,8 +1720,10 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 				dlm_put(dlm);
 				/* sender will take care of this and retry */
 				return ret;
-			} else
+			} else {
+				dispatched = 1;
 				__dlm_lockres_grab_inflight_worker(dlm, res);
+			}
 			spin_unlock(&res->spinlock);
 		} else {
 			/* put.. incase we are not the master */
@@ -1730,7 +1733,8 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 	spin_unlock(&dlm->spinlock);

-	dlm_put(dlm);
+	if (!dispatched)
+		dlm_put(dlm);
 	return master;
 }

-- 
1.8.4.3
