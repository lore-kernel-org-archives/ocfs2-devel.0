From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 5 Mar 2014 22:02:52 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: call ocfs2_update_inode_fsync_trans
 when updating any inode
Message-ID: <20140306060252.GB9876@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ensure that ocfs2_update_inode_fsync_trans() is called any time we
touch an inode in a given transaction.  This is a follow-on to the
previous patch to reduce lock contention and deadlocking during an
fsync operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 555f4cd..7e8282d 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -205,6 +205,7 @@ static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
 	di->i_mode = cpu_to_le16(inode->i_mode);
 	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6b97d68..b4deb5f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5728,6 +5728,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 	}
 
 	ocfs2_et_update_clusters(et, -len);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 	ocfs2_journal_dirty(handle, et->et_root_bh);
 
@@ -7209,6 +7210,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, di_bh);
 
 out_commit:
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8b48e9b..0717662 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3006,6 +3006,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	di->i_size = cpu_to_le64(sb->s_blocksize);
 	di->i_ctime = di->i_mtime = cpu_to_le64(dir->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(dir->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 
 	/*
 	 * This should never fail as our extent list is empty and all
@@ -4405,6 +4406,7 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
 	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
 	spin_unlock(&OCFS2_I(dir)->ip_lock);
 	di->i_dx_root = cpu_to_le64(0ULL);
+	ocfs2_update_inode_fsync_trans(handle, dir, 1);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d390394..db223bd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -286,6 +286,7 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	inode->i_atime = CURRENT_TIME;
 	di->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
 	di->i_atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, bh);
 
 out_commit:
@@ -335,6 +336,7 @@ int ocfs2_simple_size_update(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
@@ -429,6 +431,7 @@ static int ocfs2_orphan_for_truncate(struct ocfs2_super *osb,
 	di->i_size = cpu_to_le64(new_i_size);
 	di->i_ctime = di->i_mtime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = di->i_mtime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, fe_bh);
 
@@ -737,6 +740,7 @@ static handle_t *ocfs2_zero_start_ordered_transaction(struct inode *inode,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret)
 		mlog_errno(ret);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 out:
 	if (ret) {
@@ -834,6 +838,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 		di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
 		di->i_mtime_nsec = di->i_ctime_nsec;
 		ocfs2_journal_dirty(handle, di_bh);
+		ocfs2_update_inode_fsync_trans(handle, inode, 1);
 		ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
 	}
 
@@ -1338,6 +1343,7 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 
 	di = (struct ocfs2_dinode *) bh->b_data;
 	di->i_mode = cpu_to_le16(inode->i_mode);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, bh);
 
@@ -1570,6 +1576,7 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 		if (ret)
 			mlog_errno(ret);
 	}
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 	ocfs2_commit_trans(osb, handle);
 out:
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 64c304d..3ca9395 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -151,6 +151,7 @@ static int __ocfs2_move_extent(handle_t *handle,
 							old_blkno, len);
 	}
 
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 out:
 	ocfs2_free_path(path);
 	return ret;
@@ -957,6 +958,7 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	inode->i_ctime = CURRENT_TIME;
 	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 	ocfs2_journal_dirty(handle, di_bh);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e61e4c9..7e9be0a 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2485,6 +2485,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	di->i_orphaned_slot = 0;
 	set_nlink(inode, 1);
 	ocfs2_set_links_count(di, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 47ae266..482d6c2 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -771,6 +771,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
 	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
+	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
 
 	status = 0;
 
@@ -2091,7 +2092,7 @@ int ocfs2_find_new_inode_loc(struct inode *dir,
 
 	ac->ac_find_loc_priv = res;
 	*fe_blkno = res->sr_blkno;
-
+	ocfs2_update_inode_fsync_trans(handle, dir, 0);
 out:
 	if (handle)
 		ocfs2_commit_trans(OCFS2_SB(dir->i_sb), handle);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 185fa3b7..cf36828 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2602,6 +2602,7 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
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
 
@@ -5476,6 +5478,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	ret = ocfs2_truncate_log_append(osb, handle, blkno, len);
 	if (ret)
 		mlog_errno(ret);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 
 out_commit:
 	ocfs2_commit_trans(osb, handle);
