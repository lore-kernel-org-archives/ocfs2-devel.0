From: jiangyiwen <jiangyiwen@huawei.com>
Date: Mon, 9 Feb 2015 11:59:22 +0800
Subject: [Ocfs2-devel] [PATCH V3]ocfs2: Avoid access invalid address when
 read o2dlm debug messages.
Message-ID: <54D8309A.3050405@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following case will lead to a lockres is freed but is still in use.

cat /sys/kernel/debug/o2dlm/locking_state	dlm_thread
lockres_seq_start
    -> lock dlm->track_lock
    -> get resA
                                                resA->refs decrease to 0,
                                                call dlm_lockres_release,
                                                and wait for "cat" unlock.
Although resA->refs is already set to 0,
increase resA->refs, and then unlock
                                                lock dlm->track_lock
                                                    -> list_del_init()
                                                    -> unlock
                                                    -> free resA

In such a race case, invalid address access may occurs.
So we should delete list res->tracking before resA->refs decrease to 0.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

---
 dlm/dlmmaster.c | 23 ++++++++++++-----------
 dlm/dlmthread.c | 10 ++++++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/dlm/dlmmaster.c b/dlm/dlmmaster.c
index a6944b2..52c1a14 100644
--- a/dlm/dlmmaster.c
+++ b/dlm/dlmmaster.c
@@ -498,16 +498,6 @@ static void dlm_lockres_release(struct kref *kref)
 	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
 	     res->lockname.name);

-	spin_lock(&dlm->track_lock);
-	if (!list_empty(&res->tracking))
-		list_del_init(&res->tracking);
-	else {
-		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
-		     res->lockname.len, res->lockname.name);
-		dlm_print_one_lock_resource(res);
-	}
-	spin_unlock(&dlm->track_lock);
-
 	atomic_dec(&dlm->res_cur_count);

 	if (!hlist_unhashed(&res->hash_node) ||
@@ -782,8 +772,19 @@ lookup:
 		dlm_lockres_grab_inflight_ref(dlm, tmpres);

 		spin_unlock(&tmpres->spinlock);
-		if (res)
+		if (res) {
+			spin_lock(&dlm->track_lock);
+			if (!list_empty(&res->tracking))
+				list_del_init(&res->tracking);
+			else {
+				mlog(ML_ERROR, "Resource %.*s not "
+						"on the Tracking list\n",
+						res->lockname.len,
+						res->lockname.name);
+			}
+			spin_unlock(&dlm->track_lock);
 			dlm_lockres_put(res);
+		}
 		res = tmpres;
 		goto leave;
 	}
diff --git a/dlm/dlmthread.c b/dlm/dlmthread.c
index 69aac6f..2e5e6d5 100644
--- a/dlm/dlmthread.c
+++ b/dlm/dlmthread.c
@@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm_ctxt *dlm,

 	__dlm_unhash_lockres(dlm, res);

+	spin_lock(&dlm->track_lock);
+	if (!list_empty(&res->tracking))
+		list_del_init(&res->tracking);
+	else {
+		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
+				res->lockname.len, res->lockname.name);
+		__dlm_print_one_lock_resource(res);
+	}
+	spin_unlock(&dlm->track_lock);
+
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
 	if (!master) {
-- 
1.8.3.4
