From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 13 Feb 2013 20:30:07 -0000
Subject: [Ocfs2-devel] [PATCH linux-next v2] ocfs2: remove kfree() redundant
	null checks
Message-ID: <1360787385-75824-1-git-send-email-tim.gardner@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Akinobu Mita <akinobu.mita@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>, ocfs2-devel@oss.oracle.com

smatch analysis indicates a number of redundant NULL checks before
calling kfree(), e.g.,

fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
 redundant null check on *tl_copy calling kfree()

fs/ocfs2/alloc.c:6755 ocfs2_zero_range_for_truncate() info:
 redundant null check on pages calling kfree()

etc....

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

v2 - Decided to fix all the kfree() smatch warnings in one patch. Also
fixed an erroneous change to fs/ocfs2/alloc.c in v1.

 fs/ocfs2/alloc.c             |    5 ++---
 fs/ocfs2/cluster/heartbeat.c |    6 ++----
 fs/ocfs2/cluster/tcp.c       |    6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |    4 +---
 fs/ocfs2/extent_map.c        |    3 +--
 fs/ocfs2/journal.c           |   10 +++-------
 fs/ocfs2/localalloc.c        |    8 +++-----
 fs/ocfs2/stack_o2cb.c        |    2 +-
 fs/ocfs2/super.c             |    6 ++----
 fs/ocfs2/sysfile.c           |    3 +--
 10 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 31b9463..83a1a1d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6134,7 +6134,7 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
-	if (status < 0 && (*tl_copy)) {
+	if (status < 0) {
 		kfree(*tl_copy);
 		*tl_copy = NULL;
 		mlog_errno(status);
@@ -6751,8 +6751,7 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 
 out:
-	if (pages)
-		kfree(pages);
+	kfree(pages);
 
 	return ret;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index ff753bb..8c3318b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1449,8 +1449,7 @@ static void o2hb_region_release(struct config_item *item)
 
 	mlog(ML_HEARTBEAT, "hb region release (%s)\n", reg->hr_dev_name);
 
-	if (reg->hr_tmp_block)
-		kfree(reg->hr_tmp_block);
+	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
@@ -1464,8 +1463,7 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_bdev)
 		blkdev_put(reg->hr_bdev, FMODE_READ|FMODE_WRITE);
 
-	if (reg->hr_slots)
-		kfree(reg->hr_slots);
+	kfree(reg->hr_slots);
 
 	kfree(reg->hr_db_regnum);
 	kfree(reg->hr_db_livenodes);
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 33b8924..aa88bd8 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1159,10 +1159,8 @@ out:
 	o2net_debug_del_nst(&nst); /* must be before dropping sc and node */
 	if (sc)
 		sc_put(sc);
-	if (vec)
-		kfree(vec);
-	if (msg)
-		kfree(msg);
+	kfree(vec);
+	kfree(msg);
 	o2net_complete_nsw(nn, &nsw, 0, 0, 0);
 	return ret;
 }
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 9e89d70..dbb17c0 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -319,9 +319,7 @@ static void dlm_free_ctxt_mem(struct dlm_ctxt *dlm)
 	if (dlm->master_hash)
 		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
 
-	if (dlm->name)
-		kfree(dlm->name);
-
+	kfree(dlm->name);
 	kfree(dlm);
 }
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f487aa3..1c39efb 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -282,8 +282,7 @@ search:
 	spin_unlock(&oi->ip_lock);
 
 out:
-	if (new_emi)
-		kfree(new_emi);
+	kfree(new_emi);
 }
 
 static int ocfs2_last_eb_is_empty(struct inode *inode,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 2dd36af..8eccfab 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1234,11 +1234,8 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 		/* Though we wish to avoid it, we are in fact safe in
 		 * skipping local alloc cleanup as fsck.ocfs2 is more
 		 * than capable of reclaiming unused space. */
-		if (la_dinode)
-			kfree(la_dinode);
-
-		if (tl_dinode)
-			kfree(tl_dinode);
+		kfree(la_dinode);
+		kfree(tl_dinode);
 
 		if (qrec)
 			ocfs2_free_quota_recovery(qrec);
@@ -1408,8 +1405,7 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (rm_quota)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	/* no one is callint kthread_stop() for us so the kthread() api
 	 * requires that we call do_exit().  And it isn't exported, but
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index a9f78c7..aebeacd 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -476,8 +476,7 @@ out:
 	if (local_alloc_inode)
 		iput(local_alloc_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 }
 
 /*
@@ -534,7 +533,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 		mlog_errno(status);
 
 bail:
-	if ((status < 0) && (*alloc_copy)) {
+	if (status < 0) {
 		kfree(*alloc_copy);
 		*alloc_copy = NULL;
 	}
@@ -1290,8 +1289,7 @@ bail:
 	if (main_bm_inode)
 		iput(main_bm_inode);
 
-	if (alloc_copy)
-		kfree(alloc_copy);
+	kfree(alloc_copy);
 
 	if (ac)
 		ocfs2_free_alloc_context(ac);
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 9436801..bf1f893 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -376,7 +376,7 @@ static int o2cb_cluster_connect(struct ocfs2_cluster_connection *conn)
 	dlm_register_eviction_cb(dlm, &priv->op_eviction_cb);
 
 out_free:
-	if (rc && conn->cc_private)
+	if (rc)
 		kfree(conn->cc_private);
 
 out:
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0e91ec2..9b6910d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2525,8 +2525,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		mlog_errno(status);
 
 finally:
-	if (local_alloc)
-		kfree(local_alloc);
+	kfree(local_alloc);
 
 	if (status)
 		mlog_errno(status);
@@ -2553,8 +2552,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	 * we free it here.
 	 */
 	kfree(osb->journal);
-	if (osb->local_alloc_copy)
-		kfree(osb->local_alloc_copy);
+	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 3d635f4..f053688 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -91,8 +91,7 @@ static struct inode **get_local_system_inode(struct ocfs2_super *osb,
 		} else
 			osb->local_system_inodes = local_system_inodes;
 		spin_unlock(&osb->osb_lock);
-		if (unlikely(free))
-			kfree(free);
+		kfree(free);
 	}
 
 	index = (slot * NUM_LOCAL_SYSTEM_INODES) +
-- 
1.7.9.5
