From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 23 Mar 2015 11:49:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix possible uninitialized variable
	access
Message-ID: <550F8D66.2000400@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_local_alloc_find_clear_bits and ocfs2_get_dentry, variable
numfound and set may be uninitialized and then used in tracepoint.
In ocfs2_xattr_block_get and ocfs2_delete_xattr_in_bucket, variable
block_off and xv may be uninitialized and then used in the following
logic due to unchecked return value.
This patch is trying to fix these possible issues.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/export.c     | 2 +-
 fs/ocfs2/localalloc.c | 2 +-
 fs/ocfs2/xattr.c      | 8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 2965116..540dc4b 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -82,7 +82,6 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	}

 	status = ocfs2_test_inode_bit(osb, blkno, &set);
-	trace_ocfs2_get_dentry_test_bit(status, set);
 	if (status < 0) {
 		if (status == -EINVAL) {
 			/*
@@ -96,6 +95,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 		goto unlock_nfs_sync;
 	}

+	trace_ocfs2_get_dentry_test_bit(status, set);
 	/* If the inode allocator bit is clear, this inode must be stale */
 	if (!set) {
 		status = -ESTALE;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 096cff6..857bbbc 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -839,7 +839,7 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 				     u32 *numbits,
 				     struct ocfs2_alloc_reservation *resv)
 {
-	int numfound, bitoff, left, startoff, lastzero;
+	int numfound = 0, bitoff, left, startoff, lastzero;
 	int local_resv = 0;
 	struct ocfs2_alloc_reservation r;
 	void *bitmap = NULL;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 85b190d..4ca7533 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1238,6 +1238,10 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 								i,
 								&block_off,
 								&name_offset);
+			if (ret) {
+				mlog_errno(ret);
+				goto cleanup;
+			}
 			xs->base = bucket_block(xs->bucket, block_off);
 		}
 		if (ocfs2_xattr_is_local(xs->here)) {
@@ -5665,6 +5669,10 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,

 		ret = ocfs2_get_xattr_tree_value_root(inode->i_sb, bucket,
 						      i, &xv, NULL);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}

 		ret = ocfs2_lock_xattr_remove_allocators(inode, xv,
 							 args->ref_ci,
-- 
1.8.4.3
