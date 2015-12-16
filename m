From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 16 Dec 2015 13:57:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up redundant NULL check before
	iput
Message-ID: <5670FD43.7080502@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since iput will take care the NULL check itself, NULL check before
calling it is redundant. So clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c      |  3 +--
 fs/ocfs2/ioctl.c      |  4 +---
 fs/ocfs2/journal.c    | 10 +++-------
 fs/ocfs2/localalloc.c | 10 +++-------
 fs/ocfs2/namei.c      |  3 +--
 fs/ocfs2/slot_map.c   |  3 +--
 fs/ocfs2/super.c      |  3 +--
 7 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 86181d6..9a8467f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6174,8 +6174,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 	}

 bail:
-	if (tl_inode)
-		iput(tl_inode);
+	iput(tl_inode);
 	brelse(tl_bh);

 	if (status < 0) {
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 3cb097c..16b0bb4 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -606,9 +606,7 @@ bail:
 	if (gb_inode)
 		mutex_unlock(&gb_inode->i_mutex);

-	if (gb_inode)
-		iput(gb_inode);
-
+	iput(gb_inode);
 	brelse(bh);

 	return status;
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 13534f4..3772a2d 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1042,8 +1042,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)

 //	up_write(&journal->j_trans_barrier);
 done:
-	if (inode)
-		iput(inode);
+	iput(inode);
 }

 static void ocfs2_clear_journal_error(struct super_block *sb,
@@ -1687,9 +1686,7 @@ done:
 	if (got_lock)
 		ocfs2_inode_unlock(inode, 1);

-	if (inode)
-		iput(inode);
-
+	iput(inode);
 	brelse(bh);

 	return status;
@@ -1796,8 +1793,7 @@ static int ocfs2_trylock_journal(struct ocfs2_super *osb,

 	ocfs2_inode_unlock(inode, 1);
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);

 	return status;
 }
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 0a4457f..e9c99e3 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -358,8 +358,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 bail:
 	if (status < 0)
 		brelse(alloc_bh);
-	if (inode)
-		iput(inode);
+	iput(inode);

 	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);

@@ -473,8 +472,7 @@ out_mutex:
 	iput(main_bm_inode);

 out:
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
+	iput(local_alloc_inode);

 	kfree(alloc_copy);
 }
@@ -1327,9 +1325,7 @@ bail:

 	brelse(main_bm_bh);

-	if (main_bm_inode)
-		iput(main_bm_inode);
-
+	iput(main_bm_inode);
 	kfree(alloc_copy);

 	if (ac)
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3123408..922eae9 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1683,8 +1683,7 @@ bail:
 	if (new_inode)
 		sync_mapping_buffers(old_inode->i_mapping);

-	if (new_inode)
-		iput(new_inode);
+	iput(new_inode);

 	ocfs2_free_dir_lookup_result(&target_lookup_res);
 	ocfs2_free_dir_lookup_result(&old_entry_lookup);
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e78a203..47bba1b 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -322,8 +322,7 @@ static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
 	if (si == NULL)
 		return;

-	if (si->si_inode)
-		iput(si->si_inode);
+	iput(si->si_inode);
 	if (si->si_bh) {
 		for (i = 0; i < si->si_blocks; i++) {
 			if (si->si_bh[i]) {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2de4c8a..7805984 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1726,8 +1726,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ocfs2_inode_unlock(inode, 0);
 	status = 0;
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);

 	if (status)
 		mlog_errno(status);
-- 
1.8.4.3
