From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 2 Sep 2014 15:38:08 +0800
Subject: [Ocfs2-devel] [PATCH V2]ocfs2: Avoid access invalid address when
 read o2dlm debug messages.
Message-ID: <540573E0.90708@huawei.com>
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

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
---
 fs/ocfs2/dlm/dlmmaster.c | 10 ----------
 fs/ocfs2/dlm/dlmthread.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 3ec906e..204f70d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
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
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 69aac6f..2e5e6d5 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
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
1.8.4.3
