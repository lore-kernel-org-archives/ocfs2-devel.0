From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 07 Apr 2015 14:56:10 -0700
Subject: [Ocfs2-devel] [patch 9/9] ocfs2: avoid access invalid address when
 read o2dlm debug messages
Message-ID: <5524527a.OINXGMtTHUaG5hEv%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: avoid access invalid address when read o2dlm debug messages

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

In such a race case, invalid address access may occurs.  So we should
delete list res->tracking before resA->refs decrease to 0.


Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   23 ++++++++++++-----------
 fs/ocfs2/dlm/dlmthread.c |   10 ++++++++++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -498,16 +498,6 @@ static void dlm_lockres_release(struct k
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
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm
 
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
_
