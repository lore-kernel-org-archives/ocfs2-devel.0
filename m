From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2014 14:10:02 -0700
Subject: [Ocfs2-devel] [patch 4/8] ocfs2: call
	ocfs2_update_inode_fsync_trans when updating any inode
Message-ID: <20140319211002.D199A5A4217@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: ocfs2: call ocfs2_update_inode_fsync_trans when updating any inode

Ensure that ocfs2_update_inode_fsync_trans() is called any time we touch
an inode in a given transaction.  This is a follow-on to the previous
patch to reduce lock contention and deadlocking during an fsync operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Wengang <wen.gang.wang@oracle.com>
Cc: Greg Marsden <greg.marsden@oracle.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c          |    1 +
 fs/ocfs2/alloc.c        |    2 ++
 fs/ocfs2/dir.c          |    2 ++
 fs/ocfs2/file.c         |    7 +++++++
 fs/ocfs2/move_extents.c |    2 ++
 fs/ocfs2/namei.c        |    1 +
 fs/ocfs2/suballoc.c     |    3 ++-
 fs/ocfs2/xattr.c        |    3 +++
 8 files changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/acl.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/acl.c
@@ -205,6 +205,7 @@ static int ocfs2_acl_set_mode(struct ino
 	di->i_mode = cpu_to_le16(inode->i_mode);
 	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff -puN fs/ocfs2/alloc.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/alloc.c
@@ -5728,6 +5728,7 @@ int ocfs2_remove_btree_range(struct inod
 	}
 
 	ocfs2_et_update_clusters(et, -len);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 	ocfs2_journal_dirty(handle, et->et_root_bh);
 
@@ -7209,6 +7210,7 @@ int ocfs2_truncate_inline(struct inode *
 	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, di_bh);
 
 out_commit:
diff -puN fs/ocfs2/dir.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/dir.c
@@ -3006,6 +3006,7 @@ static int ocfs2_expand_inline_dir(struc
 	di->i_size = cpu_to_le64(sb->s_blocksize);
 	di->i_ctime = di->i_mtime = cpu_to_le64(dir->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(dir->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 
 	/*
 	 * This should never fail as our extent list is empty and all
@@ -4405,6 +4406,7 @@ static int ocfs2_dx_dir_remove_index(str
 	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
 	spin_unlock(&OCFS2_I(dir)->ip_lock);
 	di->i_dx_root = cpu_to_le64(0ULL);
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff -puN fs/ocfs2/file.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/file.c
@@ -286,6 +286,7 @@ int ocfs2_update_inode_atime(struct inod
 	inode->i_atime = CURRENT_TIME;
 	di->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	di->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, bh);
 
 out_commit:
@@ -335,6 +336,7 @@ int ocfs2_simple_size_update(struct inod
 	if (ret < 0)
 		mlog_errno(ret);
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
@@ -429,6 +431,7 @@ static int ocfs2_orphan_for_truncate(str
 	di->i_size = cpu_to_le64(new_i_size);
 	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, fe_bh);
 
@@ -737,6 +740,7 @@ static handle_t *ocfs2_zero_start_ordere
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret)
 		mlog_errno(ret);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 out:
 	if (ret) {
@@ -834,6 +838,7 @@ static int ocfs2_write_zero_page(struct
 		di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 		di->i_mtime_nsec = di->i_ctime_nsec;
 		ocfs2_journal_dirty(handle, di_bh);
+		ocfs2_update_inode_fsync_trans(handle, inode, 1);
 		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 	}
 
@@ -1338,6 +1343,7 @@ static int __ocfs2_write_remove_suid(str
 
 	di = (struct ocfs2_dinode *) bh->b_data;
 	di->i_mode = cpu_to_le16(inode->i_mode);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, bh);
 
@@ -1570,6 +1576,7 @@ static int ocfs2_zero_partial_clusters(s
 		if (ret)
 			mlog_errno(ret);
 	}
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 	ocfs2_commit_trans(osb, handle);
 out:
diff -puN fs/ocfs2/move_extents.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/move_extents.c
@@ -151,6 +151,7 @@ static int __ocfs2_move_extent(handle_t
 							old_blkno, len);
 	}
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 out:
 	ocfs2_free_path(path);
 	return ret;
@@ -954,6 +955,7 @@ static int ocfs2_move_extents(struct ocf
 	inode->i_ctime = CURRENT_TIME;
 	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff -puN fs/ocfs2/namei.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/namei.c
@@ -2578,6 +2578,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 	di->i_orphaned_slot = 0;
 	set_nlink(inode, 1);
 	ocfs2_set_links_count(di, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
diff -puN fs/ocfs2/suballoc.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/suballoc.c
@@ -771,6 +771,7 @@ static int ocfs2_block_group_alloc(struc
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
 	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
+	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
 
 	status = 0;
 
@@ -2075,7 +2076,7 @@ int ocfs2_find_new_inode_loc(struct inod
 
 	ac->ac_find_loc_priv = res;
 	*fe_blkno = res->sr_blkno;
-
+	ocfs2_update_inode_fsync_trans(handle, dir, 0);
 out:
 	if (handle)
 		ocfs2_commit_trans(OCFS2_SB(dir->i_sb), handle);
diff -puN fs/ocfs2/xattr.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-call-ocfs2_update_inode_fsync_trans-when-updating-any-inode
+++ a/fs/ocfs2/xattr.c
@@ -2602,6 +2602,7 @@ int ocfs2_xattr_remove(struct inode *ino
 	oi->ip_dyn_features &= ~(OCFS2_INLINE_XATTR_FL | OCFS2_HAS_XATTR_FL);
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, di_bh);
 out_commit:
@@ -3614,6 +3615,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	}
 
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
+	ocfs2_update_inode_fsync_trans(ctxt.handle, inode, 0);
 
 	ocfs2_commit_trans(osb, ctxt.handle);
 
@@ -5476,6 +5478,7 @@ static int ocfs2_rm_xattr_cluster(struct
 	ret = ocfs2_truncate_log_append(osb, handle, blkno, len);
 	if (ret)
 		mlog_errno(ret);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
_
