From: Younger Liu <younger.liu@huawei.com>
Date: Sat, 29 Jun 2013 13:42:52 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix issue that ocfs2_setattr() does
 not deal with new_i_size==i_size
Message-ID: <51CE73DC.60406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The issue scenario is as following:
Create a small file and fallocate a large disk space for a file 
with FALLOC_FL_KEEP_SIZE option. 
Then, ftruncate the file back to the original size again.
but the disk free space is not changed back.
This is a real bug that be fixed in this patch.

In order to Solving the issue above, we modified ocfs2_setattr(), 
if attr->ia_size != i_size_read(inode), It calls 
ocfs2_truncate_file(), and truncate disk space to attr->ia_size.

Compared with PATCH V1, bug description is updated, 
and pointless comments are removed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/file.c  |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b8a9d87..19837d4 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7126,7 +7126,7 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
-	BUG_ON(start >= end);
+	BUG_ON(start > end);
 
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 793c010..05c0bb1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -474,11 +474,6 @@ static int ocfs2_truncate_file(struct inode *inode,
 		goto bail;
 	}
 
-	/* lets handle the simple truncate cases before doing any more
-	 * cluster locking. */
-	if (new_i_size == le64_to_cpu(fe->i_size))
-		goto bail;
-
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
@@ -1150,14 +1145,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		goto bail_unlock_rw;
 	}
 
-	if (size_change && attr->ia_size != i_size_read(inode)) {
+	if (size_change) {
 		status = inode_newsize_ok(inode, attr->ia_size);
 		if (status)
 			goto bail_unlock;
 
 		inode_dio_wait(inode);
 
-		if (i_size_read(inode) > attr->ia_size) {
+		if (i_size_read(inode) >= attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
 								      attr->ia_size);
-- 
1.7.9.7
