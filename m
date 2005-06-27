From: James Morris <jmorris@redhat.com>
Date: Mon Jun 27 01:21:16 2005
Subject: [Ocfs2-devel] [PATCH 3/3] brelse() cleanups
In-Reply-To: <Xine.LNX.4.44.0506270218200.31257-100000@thoron.boston.redhat.com>
Message-ID: <Xine.LNX.4.44.0506270219450.31257-100000@thoron.boston.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This one is for brelse().

Signed-off-by: James Morris <jmorris@redhat.com>

---

 fs/ocfs2/alloc.c      |   49 ++++++++------------------
 fs/ocfs2/aops.c       |    3 -
 fs/ocfs2/dir.c        |   12 ++----
 fs/ocfs2/dlmglue.c    |    3 -
 fs/ocfs2/extent_map.c |    9 +---
 fs/ocfs2/file.c       |    6 +--
 fs/ocfs2/inode.c      |    9 +---
 fs/ocfs2/journal.c    |   10 +----
 fs/ocfs2/localalloc.c |   18 ++-------
 fs/ocfs2/namei.c      |   91 +++++++++++++++-----------------------------------
 fs/ocfs2/slot_map.c   |    3 -
 fs/ocfs2/suballoc.c   |   18 +++------
 fs/ocfs2/symlink.c    |    3 -
 fs/ocfs2/sysfile.c    |    3 -
 14 files changed, 74 insertions(+), 163 deletions(-)

diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/alloc.c linux-2.6.12-mm2.w/fs/ocfs2/alloc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/alloc.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/alloc.c	2005-06-27 01:29:05.000000000 -0400
@@ -131,8 +131,7 @@ int ocfs2_num_free_extents(ocfs2_super *
 
 	retval = el->l_count - el->l_next_free_rec;
 bail:
-	if (eb_bh)
-		brelse(eb_bh);
+	brelse(eb_bh);
 
 	mlog_exit(retval);
 	return retval;
@@ -224,8 +223,7 @@ static int ocfs2_create_new_meta_bhs(ocf
 bail:
 	if (status < 0) {
 		for(i = 0; i < wanted; i++) {
-			if (bhs[i])
-				brelse(bhs[i]);
+			brelse(bhs[i]);
 			bhs[i] = NULL;
 		}
 	}
@@ -391,8 +389,7 @@ static int ocfs2_add_branch(ocfs2_super 
 bail:
 	if (new_eb_bhs) {
 		for (i = 0; i < new_blocks; i++)
-			if (new_eb_bhs[i])
-				brelse(new_eb_bhs[i]);
+			brelse(new_eb_bhs[i]);
 		kfree(new_eb_bhs);
 	}
 
@@ -490,8 +487,7 @@ static int ocfs2_shift_tree_depth(ocfs2_
 	new_eb_bh = NULL;
 	status = 0;
 bail:
-	if (new_eb_bh)
-		brelse(new_eb_bh);
+	brelse(new_eb_bh);
 
 	mlog_exit(status);
 	return status;
@@ -649,8 +645,7 @@ static int ocfs2_do_insert_extent(ocfs2_
 bail:
 	if (eb_bhs) {
 		for (i = 0; i < num_bhs; i++)
-			if (eb_bhs[i])
-				brelse(eb_bhs[i]);
+			brelse(eb_bhs[i]);
 		kfree(eb_bhs);
 	}
 
@@ -718,8 +713,7 @@ static int ocfs2_find_branch_target(ocfs
 		el = &eb->h_list;
 
 		if (el->l_next_free_rec < el->l_count) {
-			if (lowest_bh)
-				brelse(lowest_bh);
+			brelse(lowest_bh);
 			lowest_bh = bh;
 			get_bh(lowest_bh);
 		}
@@ -733,8 +727,7 @@ static int ocfs2_find_branch_target(ocfs
 
 	*target_bh = lowest_bh;
 bail:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(status);
 	return status;
@@ -838,11 +831,8 @@ out_add:
 		mlog_errno(status);
 
 bail:
-	if (bh)
-		brelse(bh);
-
-	if (last_eb_bh)
-		brelse(last_eb_bh);
+	brelse(bh);
+	brelse(last_eb_bh);
 
 	mlog_exit(status);
 	return status;
@@ -1098,9 +1088,7 @@ bail:
 		ocfs2_commit_trans(handle);
 
 	iput(data_alloc_inode);
-
-	if (data_alloc_bh)
-		brelse(data_alloc_bh);
+	brelse(data_alloc_bh);
 
 	mlog_exit(status);
 	return status;
@@ -1236,8 +1224,7 @@ int ocfs2_begin_truncate_log_recovery(oc
 
 bail:
 	iput(tl_inode);
-	if (tl_bh)
-		brelse(tl_bh);
+	brelse(tl_bh);
 
 	if (status < 0 && (*tl_copy)) {
 		kfree(*tl_copy);
@@ -1430,8 +1417,7 @@ static int ocfs2_find_new_last_ext_blk(o
 	get_bh(*new_last_eb);
 	mlog(0, "returning block %"MLFu64"\n", le64_to_cpu(eb->h_blkno));
 bail:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	return status;
 }
@@ -1785,8 +1771,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (last_eb_bh)
-		brelse(last_eb_bh);
+	brelse(last_eb_bh);
 
 	/* This will drop the ext_alloc cluster lock for us */
 	ocfs2_free_truncate_context(tc);
@@ -1901,11 +1886,7 @@ void ocfs2_free_truncate_context(ocfs2_t
 		iput(tc->tc_ext_alloc_inode);
 	}
 
-	if (tc->tc_ext_alloc_bh)
-		brelse(tc->tc_ext_alloc_bh);
-
-	if (tc->tc_last_eb_bh)
-		brelse(tc->tc_last_eb_bh);
-
+	brelse(tc->tc_ext_alloc_bh);
+	brelse(tc->tc_last_eb_bh);
 	kfree(tc);
 }
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/aops.c linux-2.6.12-mm2.w/fs/ocfs2/aops.c
--- linux-2.6.12-mm2.s/fs/ocfs2/aops.c	2005-06-27 00:23:11.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/aops.c	2005-06-27 01:29:36.000000000 -0400
@@ -120,8 +120,7 @@ static int ocfs2_symlink_get_block(struc
 	err = 0;
 
 bail:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(err);
 	return err;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/dir.c linux-2.6.12-mm2.w/fs/ocfs2/dir.c
--- linux-2.6.12-mm2.s/fs/ocfs2/dir.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/dir.c	2005-06-27 01:40:39.000000000 -0400
@@ -118,8 +118,7 @@ int ocfs2_readdir(struct file * filp, vo
 			for (i = 16 >> (sb->s_blocksize_bits - 9), num = 0;
 			     i > 0; i--) {
 				tmp = ocfs2_bread(inode, ++blk, &err, 1);
-				if (tmp)
-					brelse(tmp);
+				brelse(tmp);
 			}
 		}
 
@@ -264,8 +263,7 @@ int ocfs2_check_dir_for_entry(struct ino
 
 	ret = 0;
 bail:
-	if (dirent_bh)
-		brelse(dirent_bh);
+	brelse(dirent_bh);
 
 	mlog_exit(ret);
 	return ret;
@@ -501,8 +499,7 @@ bail:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);
 
-	if (new_bh)
-		brelse(new_bh);
+	brelse(new_bh);
 
 	mlog_exit(status);
 	return status;
@@ -608,8 +605,7 @@ int ocfs2_prepare_dir_for_insert(ocfs2_s
 
 	status = 0;
 bail:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/dlmglue.c linux-2.6.12-mm2.w/fs/ocfs2/dlmglue.c
--- linux-2.6.12-mm2.s/fs/ocfs2/dlmglue.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/dlmglue.c	2005-06-27 01:31:27.000000000 -0400
@@ -1777,8 +1777,7 @@ bail:
 			ocfs2_meta_unlock(inode, ex);
 	}
 
-	if (local_bh)
-		brelse(local_bh);
+	brelse(local_bh);
 
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/extent_map.c linux-2.6.12-mm2.w/fs/ocfs2/extent_map.c
--- linux-2.6.12-mm2.s/fs/ocfs2/extent_map.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/extent_map.c	2005-06-27 01:32:38.000000000 -0400
@@ -240,8 +240,7 @@ static int ocfs2_extent_map_find_leaf(st
 	ret = 0;
 
 out_free:
-	if (eb_bh)
-		brelse(eb_bh);
+	brelse(eb_bh);
 
 	return ret;
 }
@@ -279,8 +278,7 @@ static int ocfs2_extent_map_lookup_read(
 		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno, &bh,
 				       OCFS2_BH_CACHED, inode);
 		if (ret) {
-			if (bh)
-				brelse(bh);
+			brelse(bh);
 			return ret;
 		}
 		eb = (ocfs2_extent_block *)bh->b_data;
@@ -293,8 +291,7 @@ static int ocfs2_extent_map_lookup_read(
 				       OCFS2_I(inode)->ip_blkno, &bh,
 				       OCFS2_BH_CACHED, inode);
 		if (ret) {
-			if (bh)
-				brelse(bh);
+			brelse(bh);
 			return ret;
 		}
 		di = (ocfs2_dinode *)bh->b_data;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/file.c linux-2.6.12-mm2.w/fs/ocfs2/file.c
--- linux-2.6.12-mm2.s/fs/ocfs2/file.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/file.c	2005-06-27 01:33:09.000000000 -0400
@@ -519,8 +519,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (fe_bh)
-		brelse(fe_bh);
+	brelse(fe_bh);
 
 	mlog_exit(status);
 	return status;
@@ -1040,8 +1039,7 @@ bail:
 		ocfs2_commit_trans(handle);
 	if (unlock)
 		ocfs2_meta_unlock(inode, 1);
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/inode.c linux-2.6.12-mm2.w/fs/ocfs2/inode.c
--- linux-2.6.12-mm2.s/fs/ocfs2/inode.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/inode.c	2005-06-27 01:33:48.000000000 -0400
@@ -681,12 +681,9 @@ bail:
 		ocfs2_commit_trans(handle);
 	if (unlock)
 		ocfs2_meta_unlock(inode, 1);
-	if (orphan_dir_bh)
-		brelse(orphan_dir_bh);
-	if (inode_alloc_bh)
-		brelse(inode_alloc_bh);
-	if (fe_bh)
-		brelse(fe_bh);
+	brelse(orphan_dir_bh);
+	brelse(inode_alloc_bh);
+	brelse(fe_bh);
 	iput(orphan_dir_inode);
 	iput(inode_alloc_inode);
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/journal.c linux-2.6.12-mm2.w/fs/ocfs2/journal.c
--- linux-2.6.12-mm2.s/fs/ocfs2/journal.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/journal.c	2005-06-27 01:34:37.000000000 -0400
@@ -833,8 +833,7 @@ static int ocfs2_force_read_journal(stru
 
 bail:
 	for(i = 0; i < CONCURRENT_JOURNAL_FILL; i++)
-		if (bhs[i])
-			brelse(bhs[i]);
+		brelse(bhs[i]);
 	mlog_exit(status);
 	return status;
 }
@@ -1175,9 +1174,7 @@ done:
 		ocfs2_meta_unlock(inode, 1);
 
 	iput(inode);
-
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(status);
 	return status;
@@ -1392,8 +1389,7 @@ static int ocfs2_recover_orphans(ocfs2_s
 			status = -EINVAL;
 		if (status < 0) {
 			up(&orphan_dir_inode->i_sem);
-			if (bh)
-				brelse(bh);
+			brelse(bh);
 			mlog_errno(status);
 			goto bail;
 		}
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/localalloc.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/localalloc.c	2005-06-27 01:35:37.000000000 -0400
@@ -171,8 +171,7 @@ int ocfs2_load_local_alloc(ocfs2_super *
 
 bail:
 	if (status < 0)
-		if (alloc_bh)
-			brelse(alloc_bh);
+		brelse(alloc_bh);
 	iput(inode);
 
 	mlog_exit(status);
@@ -282,9 +281,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (main_bm_bh)
-		brelse(main_bm_bh);
-
+	brelse(main_bm_bh);
 	iput(main_bm_inode);
 	iput(local_alloc_inode);
 	kfree(alloc_copy);
@@ -350,8 +347,7 @@ bail:
 		*alloc_copy = NULL;
 	}
 
-	if (alloc_bh)
-		brelse(alloc_bh);
+	brelse(alloc_bh);
 
 	if (inode) {
 		up(&inode->i_sem);
@@ -420,9 +416,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (main_bm_bh)
-		brelse(main_bm_bh);
-
+	brelse(main_bm_bh);
 	iput(main_bm_inode);
 
 	mlog_exit(status);
@@ -933,9 +927,7 @@ bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (main_bm_bh)
-		brelse(main_bm_bh);
-
+	brelse(main_bm_bh);
 	iput(main_bm_inode);
 	kfree(alloc_copy);
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/namei.c linux-2.6.12-mm2.w/fs/ocfs2/namei.c
--- linux-2.6.12-mm2.s/fs/ocfs2/namei.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/namei.c	2005-06-27 01:38:07.000000000 -0400
@@ -195,8 +195,7 @@ bail_unlock:
 	ocfs2_meta_unlock(dir, 0);
 
 bail:
-	if (dirent_bh)
-		brelse(dirent_bh);
+	brelse(dirent_bh);
 
 	mlog_exit_ptr(ret);
 
@@ -250,8 +249,7 @@ struct dentry *ocfs2_get_parent(struct d
 bail_unlock:
 	ocfs2_meta_unlock(dir, 0);
 
-	if (dirent_bh)
-		brelse(dirent_bh);
+	brelse(dirent_bh);
 
 bail:
 	mlog_exit_ptr(parent);
@@ -321,8 +319,7 @@ static int ocfs2_fill_new_dir(ocfs2_supe
 
 	status = 0;
 bail:
-	if (new_bh)
-		brelse(new_bh);
+	brelse(new_bh);
 
 	mlog_exit(status);
 	return status;
@@ -493,14 +490,9 @@ leave:
 	if (status == -ENOSPC)
 		mlog(0, "Disk is full\n");
 
-	if (new_fe_bh)
-		brelse(new_fe_bh);
-
-	if (de_bh) 
-		brelse(de_bh);
-
-	if (parent_fe_bh) 
-		brelse(parent_fe_bh);
+	brelse(new_fe_bh);
+	brelse(de_bh);
+	brelse(parent_fe_bh);
 
 	if ((status < 0) && inode)
 		iput(inode);
@@ -764,12 +756,9 @@ static int ocfs2_link(struct dentry *old
 bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
-	if (de_bh) 
-		brelse(de_bh);
-	if (fe_bh)
-		brelse(fe_bh);
-	if (parent_fe_bh)
-		brelse(parent_fe_bh);
+	brelse(de_bh);
+	brelse(fe_bh);
+	brelse(parent_fe_bh);
 
 	mlog_exit(err);
 
@@ -944,17 +933,10 @@ leave:
 	if (handle)
 		ocfs2_commit_trans(handle);
 
-	if (fe_bh)
-		brelse(fe_bh);
-
-	if (dirent_bh)
-		brelse(dirent_bh);
-
-	if (parent_node_bh)
-		brelse(parent_node_bh);
-
-	if (orphan_entry_bh)
-		brelse(orphan_entry_bh);
+	brelse(fe_bh);
+	brelse(dirent_bh);
+	brelse(parent_node_bh);
+	brelse(orphan_entry_bh);
 
 	mlog_exit(status);
 
@@ -1429,22 +1411,14 @@ bail:
 		sync_mapping_buffers(old_inode->i_mapping);
 
 	iput(new_inode);
-	if (newfe_bh)
-		brelse(newfe_bh);
-	if (old_dir_bh)
-		brelse(old_dir_bh);
-	if (new_dir_bh)
-		brelse(new_dir_bh);
-	if (new_de_bh)
-		brelse(new_de_bh);
-	if (old_de_bh)
-		brelse(old_de_bh);
-	if (old_inode_de_bh)
-		brelse(old_inode_de_bh);
-	if (orphan_entry_bh)
-		brelse(orphan_entry_bh);
-	if (insert_entry_bh)
-		brelse(insert_entry_bh);
+	brelse(newfe_bh);
+	brelse(old_dir_bh);
+	brelse(new_dir_bh);
+	brelse(new_de_bh);
+	brelse(old_de_bh);
+	brelse(old_inode_de_bh);
+	brelse(orphan_entry_bh);
+	brelse(insert_entry_bh);
 
 	mlog_exit(status);
 
@@ -1548,8 +1522,7 @@ bail:
 
 	if (bhs) {
 		for(i = 0; i < blocks; i++)
-			if (bhs[i])
-				brelse(bhs[i]);
+			brelse(bhs[i]);
 		kfree(bhs);
 	}
 
@@ -1730,12 +1703,9 @@ static int ocfs2_symlink(struct inode *d
 bail:
 	if (handle)
 		ocfs2_commit_trans(handle);
-	if (new_fe_bh)
-		brelse(new_fe_bh);
-	if (parent_fe_bh)
-		brelse(parent_fe_bh);
-	if (de_bh)
-		brelse(de_bh);
+	brelse(new_fe_bh);
+	brelse(parent_fe_bh);
+	brelse(de_bh);
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
 	if (data_ac)
@@ -2136,9 +2106,7 @@ static int ocfs2_prepare_orphan_dir(ocfs
 
 leave:
 	iput(orphan_dir_inode);
-
-	if (orphan_dir_bh)
-		brelse(orphan_dir_bh);
+	brelse(orphan_dir_bh);
 
 	mlog_exit(status);
 	return status;
@@ -2219,9 +2187,7 @@ static int ocfs2_orphan_add(ocfs2_super 
 
 leave:
 	iput(orphan_dir_inode);
-
-	if (orphan_dir_bh)
-		brelse(orphan_dir_bh);
+	brelse(orphan_dir_bh);
 
 	mlog_exit(status);
 	return status;
@@ -2288,8 +2254,7 @@ int ocfs2_orphan_del(ocfs2_super *osb,
 	}
 
 leave:
-	if (target_de_bh)
-		brelse(target_de_bh);
+	brelse(target_de_bh);
 		
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/slot_map.c linux-2.6.12-mm2.w/fs/ocfs2/slot_map.c
--- linux-2.6.12-mm2.s/fs/ocfs2/slot_map.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/slot_map.c	2005-06-27 01:38:30.000000000 -0400
@@ -220,8 +220,7 @@ bail:
 void ocfs2_free_slot_info(ocfs2_slot_info *si)
 {
 	iput(si->si_inode);
-	if (si->si_bh)
-		brelse(si->si_bh);
+	brelse(si->si_bh);
 	kfree(si);
 }
 
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/suballoc.c linux-2.6.12-mm2.w/fs/ocfs2/suballoc.c
--- linux-2.6.12-mm2.s/fs/ocfs2/suballoc.c	2005-06-27 01:24:06.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/suballoc.c	2005-06-27 01:39:12.000000000 -0400
@@ -130,8 +130,7 @@ static inline void ocfs2_block_to_cluste
 void ocfs2_free_alloc_context(ocfs2_alloc_context *ac)
 {
 	iput(ac->ac_inode);
-	if (ac->ac_bh)
-		brelse(ac->ac_bh);
+	brelse(ac->ac_bh);
 	kfree(ac);
 }
 
@@ -334,8 +333,7 @@ bail:
 	if (ac)
 		ocfs2_free_alloc_context(ac);
 
-	if (bg_bh)
-		brelse(bg_bh);
+	brelse(bg_bh);
 
 	mlog_exit(status);
 	return status;
@@ -396,8 +394,7 @@ static int ocfs2_reserve_suballoc_bits(o
 	get_bh(bh);
 	ac->ac_bh = bh;
 bail:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	mlog_exit(status);
 	return status;
@@ -1041,10 +1038,8 @@ static int ocfs2_search_chain(ocfs2_allo
 
 	*bg_blkno = bg->bg_blkno;
 bail:
-	if (group_bh)
-		brelse(group_bh);
-	if (prev_group_bh)
-		brelse(prev_group_bh);
+	brelse(group_bh);
+	brelse(prev_group_bh);
 
 	mlog_exit(status);
 	return status;
@@ -1446,8 +1441,7 @@ static int ocfs2_free_suballoc_bits(ocfs
 	}
 
 bail:
-	if (group_bh)
-		brelse(group_bh);
+	brelse(group_bh);
 
 	mlog_exit(status);
 	return status;
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/symlink.c linux-2.6.12-mm2.w/fs/ocfs2/symlink.c
--- linux-2.6.12-mm2.s/fs/ocfs2/symlink.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/symlink.c	2005-06-27 01:39:43.000000000 -0400
@@ -305,8 +305,7 @@ static int ocfs2_follow_link(struct dent
 		kunmap(page);
 		page_cache_release(page);
 	}
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 
 	return res;
 }
diff -purN -X dontdiff linux-2.6.12-mm2.s/fs/ocfs2/sysfile.c linux-2.6.12-mm2.w/fs/ocfs2/sysfile.c
--- linux-2.6.12-mm2.s/fs/ocfs2/sysfile.c	2005-06-27 00:23:12.000000000 -0400
+++ linux-2.6.12-mm2.w/fs/ocfs2/sysfile.c	2005-06-27 01:40:03.000000000 -0400
@@ -123,8 +123,7 @@ static struct inode * _ocfs2_get_system_
 		goto bail;
 	}
 bail:
-	if (dirent_bh)
-		brelse(dirent_bh);
+	brelse(dirent_bh);
 	return inode;
 }
 
