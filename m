From: wangyan <wangyan122@huawei.com>
Date: Mon, 4 Jun 2018 14:42:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up some unnecessary code
Message-ID: <5B14DF72.5020800@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Several functions have some unnecessary code, clean up these code.

Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/alloc.c       | 17 ++++-------------
 fs/ocfs2/cluster/tcp.c |  2 --
 fs/ocfs2/inode.c       |  5 +----
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0f157bb..6cb8db7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -932,13 +932,11 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation)
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has an invalid h_fs_generation of #%u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le32_to_cpu(eb->h_fs_generation));
-		goto bail;
-	}
 bail:
 	return rc;
 }
@@ -1598,10 +1596,8 @@ static int ocfs2_grow_tree(handle_t *handle, struct ocfs2_extent_tree *et,
 	 * the new data. */
 	ret = ocfs2_add_branch(handle, et, bh, last_eb_bh,
 			       meta_ac);
-	if (ret < 0) {
+	if (ret < 0)
 		mlog_errno(ret);
-		goto out;
-	}
 
 out:
 	if (final_depth)
@@ -5523,10 +5519,8 @@ static int ocfs2_truncate_rec(handle_t *handle,
 	ocfs2_journal_dirty(handle, path_leaf_bh(path));
 
 	ret = ocfs2_rotate_tree_left(handle, et, path, dealloc);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto out;
-	}
 
 out:
 	ocfs2_free_path(left_path);
@@ -5659,10 +5653,8 @@ int ocfs2_remove_extent(handle_t *handle,
 
 		ret = ocfs2_truncate_rec(handle, et, path, index, dealloc,
 					 cpos, len);
-		if (ret) {
+		if (ret)
 			mlog_errno(ret);
-			goto out;
-		}
 	}
 
 out:
@@ -5707,7 +5699,6 @@ static int ocfs2_reserve_blocks_for_rec_trunc(struct inode *inode,
 		if (ret < 0) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
-			goto out;
 		}
 	}
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index e507618..b6ec4ae 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -872,8 +872,6 @@ int o2net_register_handler(u32 msg_type, u32 key, u32 max_len,
 				"for type %u key %08x\n", msg_type, key);
 	}
 	write_unlock(&o2net_handler_lock);
-	if (ret)
-		goto out;
 
 out:
 	if (ret)
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ddc3e94..7927924 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -637,10 +637,8 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
 		handle = NULL;
 
 		status = ocfs2_commit_truncate(osb, inode, fe_bh);
-		if (status < 0) {
+		if (status < 0)
 			mlog_errno(status);
-			goto out;
-		}
 	}
 
 out:
@@ -1499,7 +1497,6 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr,
 		     le32_to_cpu(di->i_fs_generation));
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
-		goto bail;
 	}
 
 bail:
-- 
1.8.3.1
