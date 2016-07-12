From: piaojun <piaojun@huawei.com>
Date: Tue, 12 Jul 2016 10:08:03 +0800
Subject: [Ocfs2-devel] [PATCH v2 2/3] ocfs2/dlm: solve a BUG when deref
 failed in dlm_drop_lockres_ref
Message-ID: <57845103.3070406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found a BUG situation that lockres is migrated during deref
described below. To solve the BUG, we could purge lockres directly when
other node says I did not have a ref. Additionally, we'd better purge
lockres if master goes down, as no one will response deref done.

Node 1                  Node 2(old master)             Node3(new master)
dlm_purge_lockres
send deref to N2

                        leave domain
                        migrate lockres to N3
                                                       finish migration
                                                       send do assert
                                                       master to N1

receive do assert msg
form N3, but can not
find lockres because
DROPPING_REF is set,
so the owner is still
N2.

                        receive deref from N1
                        and response -EINVAL
                        because lockres is migrated

BUG when receive -EINVAL
in dlm_drop_lockres_ref

Fixes: 842b90b62461d ("ocfs2/dlm: return in progress if master can not clear the refmap bit right now")

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c |  9 ++++++---
 fs/ocfs2/dlm/dlmthread.c | 13 +++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 9456217..311404f 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2276,9 +2276,12 @@ int dlm_drop_lockres_ref(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
 		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
 		     dlm->name, namelen, lockname, res->owner, r);
 		dlm_print_one_lock_resource(res);
-		BUG();
-	}
-	return ret ? ret : r;
+		if (r == -ENOMEM)
+			BUG();
+	} else
+		ret = r;
+
+	return ret;
 }
 
 int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 68d239b..ce39722 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -175,6 +175,15 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
 	     res->lockname.len, res->lockname.name, master);
 
 	if (!master) {
+		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+			mlog(ML_NOTICE, "%s: res %.*s already in "
+				"DLM_LOCK_RES_DROPPING_REF state\n",
+				dlm->name, res->lockname.len,
+				res->lockname.name);
+			spin_unlock(&res->spinlock);
+			return;
+		}
+
 		res->state |= DLM_LOCK_RES_DROPPING_REF;
 		/* drop spinlock...  retake below */
 		spin_unlock(&res->spinlock);
@@ -203,8 +212,8 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,
 		dlm->purge_count--;
 	}
 
-	if (!master && ret != 0) {
-		mlog(0, "%s: deref %.*s in progress or master goes down\n",
+	if (!master && ret == DLM_DEREF_RESPONSE_INPROG) {
+		mlog(0, "%s: deref %.*s in progress\n",
 			dlm->name, res->lockname.len, res->lockname.name);
 		spin_unlock(&res->spinlock);
 		return;
-- 
1.8.4.3
