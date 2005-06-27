From: James Morris <jmorris@redhat.com>
Date: Mon Jun 27 01:19:28 2005
Subject: [Ocfs2-devel] [PATCH 2/3] iput() cleanups
In-Reply-To: <Xine.LNX.4.44.0506270215590.31257-100000@thoron.boston.redhat.com>
Message-ID: <Xine.LNX.4.44.0506270218200.31257-100000@thoron.boston.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Same but for iput().

Signed-off-by: James Morris <jmorris@redhat.com>

---

 fs/ocfs2/alloc.c             |    6 ++----
 fs/ocfs2/cluster/heartbeat.c |    3 +--
 fs/ocfs2/inode.c             |    6 ++----
 fs/ocfs2/journal.c           |   12 ++++--------
 fs/ocfs2/localalloc.c        |   21 ++++++---------------
 fs/ocfs2/namei.c             |    9 +++------
 fs/ocfs2/slot_map.c          |    3 +--
 fs/ocfs2/suballoc.c          |    9 +++------
 fs/ocfs2/super.c             |    6 ++----
 fs/ocfs2/vote.c              |    3 +--
 10 files changed, 25 insertions(+), 53 deletions(-)


diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/alloc.c linux-2.6.12-mm2.w/fs/ocfs2/alloc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/alloc.c	2005-06-27 00:23:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/alloc.c	2005-06-27 01:09:59.000000000 -0400
@@ -1097,8 +1097,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (data_alloc_inode)
-		iput(data_alloc_inode);
+	iput(data_alloc_inode);
 
 	if (data_alloc_bh)
 		brelse(data_alloc_bh);
@@ -1236,8 +1235,7 @@ int ocfs2_begin_truncate_log_recovery(oc
 	}
 
 bail:
-	if (tl_inode)
-		iput(tl_inode);
+	iput(tl_inode);
 	if (tl_bh)
 		brelse(tl_bh);
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/cluster/heartbeat.c linux-2.6.12-mm2.w/fs/ocfs2/cluster/heartbeat.c
--- linux-2.6.12-mm2.s/fs/ocfs2/cluster/heartbeat.c	2005-06-27 01:08:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/cluster/heartbeat.c	2005-06-27 01:10:45.000000000 -0400
@@ -1133,8 +1133,7 @@ static ssize_t o2hb_region_dev_write(str
 out:
 	if (filp)
 		fput(filp);
-	if (inode)
-		iput(inode);
+	iput(inode);
 	if (ret < 0) {
 		if (reg->hr_bdev) {
 			blkdev_put(reg->hr_bdev);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/inode.c linux-2.6.12-mm2.w/fs/ocfs2/inode.c
--- linux-2.6.12-mm2.s/fs/ocfs2/inode.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/inode.c	2005-06-27 01:11:44.000000000 -0400
@@ -687,10 +687,8 @@ bail:
 		brelse(inode_alloc_bh);
 	if (fe_bh)
 		brelse(fe_bh);
-	if (orphan_dir_inode)
-		iput(orphan_dir_inode);
-	if (inode_alloc_inode)
-		iput(inode_alloc_inode);
+	iput(orphan_dir_inode);
+	iput(inode_alloc_inode);
 
 	/* we must clear inode. */
 	clear_inode(inode);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/journal.c linux-2.6.12-mm2.w/fs/ocfs2/journal.c
--- linux-2.6.12-mm2.s/fs/ocfs2/journal.c	2005-06-27 01:08:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/journal.c	2005-06-27 01:13:15.000000000 -0400
@@ -693,8 +693,7 @@ void ocfs2_journal_shutdown(ocfs2_super 
 
 //	up_write(&journal->j_trans_barrier);
 done:
-	if (inode)
-		iput(inode);
+	iput(inode);
 	mlog_exit_void();
 }
 
@@ -1175,8 +1174,7 @@ done:
 	if (got_lock)
 		ocfs2_meta_unlock(inode, 1);
 
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	if (bh)
 		brelse(bh);
@@ -1299,8 +1297,7 @@ static int ocfs2_trylock_journal(ocfs2_s
 
 	ocfs2_meta_unlock(inode, 1);
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	return status;
 }
@@ -1488,8 +1485,7 @@ bail:
 	if (have_disk_lock)
 		ocfs2_meta_unlock(orphan_dir_inode, 0);
 
-	if (orphan_dir_inode)
-		iput(orphan_dir_inode);
+	iput(orphan_dir_inode);
 
 	return status;
 }
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c	2005-06-27 01:08:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c	2005-06-27 01:21:14.000000000 -0400
@@ -173,8 +173,7 @@ bail:
 	if (status < 0)
 		if (alloc_bh)
 			brelse(alloc_bh);
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	mlog_exit(status);
 	return status;
@@ -286,12 +285,8 @@ bail:
 	if (main_bm_bh)
 		brelse(main_bm_bh);
 
-	if (main_bm_inode)
-		iput(main_bm_inode);
-
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
-
+	iput(main_bm_inode);
+	iput(local_alloc_inode);
 	kfree(alloc_copy);
 
 	mlog_exit_void();
@@ -428,8 +423,7 @@ bail:
 	if (main_bm_bh)
 		brelse(main_bm_bh);
 
-	if (main_bm_inode)
-		iput(main_bm_inode);
+	iput(main_bm_inode);
 
 	mlog_exit(status);
 	return status;
@@ -504,8 +498,7 @@ int ocfs2_reserve_local_alloc_bits(ocfs2
 	ac->ac_which = OCFS2_AC_USE_LOCAL;
 	status = 0;
 bail:
-	if (local_alloc_inode)
-		iput(local_alloc_inode);
+	iput(local_alloc_inode);
 
 	mlog_exit(status);
 	return status;
@@ -943,9 +936,7 @@ bail:
 	if (main_bm_bh)
 		brelse(main_bm_bh);
 
-	if (main_bm_inode)
-		iput(main_bm_inode);
-
+	iput(main_bm_inode);
 	kfree(alloc_copy);
 
 	if (ac)
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/namei.c linux-2.6.12-mm2.w/fs/ocfs2/namei.c
--- linux-2.6.12-mm2.s/fs/ocfs2/namei.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/namei.c	2005-06-27 01:17:21.000000000 -0400
@@ -1428,8 +1428,7 @@ bail:
 	if (new_inode)
 		sync_mapping_buffers(old_inode->i_mapping);
 
-	if (new_inode)
-		iput(new_inode);
+	iput(new_inode);
 	if (newfe_bh)
 		brelse(newfe_bh);
 	if (old_dir_bh)
@@ -2136,8 +2135,7 @@ static int ocfs2_prepare_orphan_dir(ocfs
 	}
 
 leave:
-	if (orphan_dir_inode)
-		iput(orphan_dir_inode);
+	iput(orphan_dir_inode);
 
 	if (orphan_dir_bh)
 		brelse(orphan_dir_bh);
@@ -2220,8 +2218,7 @@ static int ocfs2_orphan_add(ocfs2_super 
 	     OCFS2_I(inode)->ip_blkno, osb->slot_num);
 
 leave:
-	if (orphan_dir_inode)
-		iput(orphan_dir_inode);
+	iput(orphan_dir_inode);
 
 	if (orphan_dir_bh)
 		brelse(orphan_dir_bh);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/slot_map.c linux-2.6.12-mm2.w/fs/ocfs2/slot_map.c
--- linux-2.6.12-mm2.s/fs/ocfs2/slot_map.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/slot_map.c	2005-06-27 01:17:45.000000000 -0400
@@ -219,8 +219,7 @@ bail:
 
 void ocfs2_free_slot_info(ocfs2_slot_info *si)
 {
-	if (si->si_inode)
-		iput(si->si_inode);
+	iput(si->si_inode);
 	if (si->si_bh)
 		brelse(si->si_bh);
 	kfree(si);
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/suballoc.c linux-2.6.12-mm2.w/fs/ocfs2/suballoc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/suballoc.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/suballoc.c	2005-06-27 01:18:32.000000000 -0400
@@ -129,8 +129,7 @@ static inline void ocfs2_block_to_cluste
 
 void ocfs2_free_alloc_context(ocfs2_alloc_context *ac)
 {
-	if (ac->ac_inode)
-		iput(ac->ac_inode);
+	iput(ac->ac_inode);
 	if (ac->ac_bh)
 		brelse(ac->ac_bh);
 	kfree(ac);
@@ -455,8 +454,7 @@ bail:
 		*ac = NULL;
 	}
 
-	if (alloc_inode)
-		iput(alloc_inode);
+	iput(alloc_inode);
 
 	mlog_exit(status);
 	return status;
@@ -506,8 +504,7 @@ bail:
 		*ac = NULL;
 	}
 
-	if (alloc_inode)
-		iput(alloc_inode);
+	iput(alloc_inode);
 
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/super.c linux-2.6.12-mm2.w/fs/ocfs2/super.c
--- linux-2.6.12-mm2.s/fs/ocfs2/super.c	2005-06-27 01:08:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/super.c	2005-06-27 01:20:03.000000000 -0400
@@ -409,8 +409,7 @@ static int ocfs2_fill_super(struct super
 	return status;		
 
 read_super_error:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	if (osb) {
 		atomic_set(&osb->vol_state, VOLUME_DISABLED);
@@ -607,8 +606,7 @@ static int ocfs2_statfs(struct super_blo
 	ocfs2_meta_unlock(inode, 0);
 	status = 0;
 bail:
-	if (inode)
-		iput(inode);
+	iput(inode);
 
 	mlog_exit(status);
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/vote.c linux-2.6.12-mm2.w/fs/ocfs2/vote.c
--- linux-2.6.12-mm2.s/fs/ocfs2/vote.c	2005-06-27 01:08:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/vote.c	2005-06-27 01:20:26.000000000 -0400
@@ -471,8 +471,7 @@ respond:
 		mlog(ML_ERROR, "message to node %u fails with error %d!\n",
 		     node_num, net_status);
 
-	if (inode)
-		iput(inode);
+	iput(inode);
 }
 
 static void ocfs2_vote_thread_do_work(ocfs2_super *osb)
