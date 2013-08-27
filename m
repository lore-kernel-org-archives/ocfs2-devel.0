From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:04:54 -0700
Subject: [Ocfs2-devel] [patch 03/22] ocfs2: fix issue that ocfs2_setattr()
	does not deal with new_i_size==i_size
Message-ID: <20130827210455.2EF6B5A4276@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_size==i_size

The issue scenario is as following:

- Create a small file and fallocate a large disk space for a file with
  FALLOC_FL_KEEP_SIZE option.

- ftruncate the file back to the original size again.  but the disk free
  space is not changed back.  This is a real bug that be fixed in this
  patch.

In order to solve the issue above, we modified ocfs2_setattr(), if
attr->ia_size != i_size_read(inode), It calls ocfs2_truncate_file(), and
truncate disk space to attr->ia_size.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Reviewed-by: Jensen <shencanquan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 fs/ocfs2/file.c  |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/alloc.c
@@ -7126,7 +7126,7 @@ int ocfs2_truncate_inline(struct inode *
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
-	BUG_ON(start >= end);
+	BUG_ON(start > end);
 
 	if (!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
 	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) ||
diff -puN fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size
+++ a/fs/ocfs2/file.c
@@ -474,11 +474,6 @@ static int ocfs2_truncate_file(struct in
 		goto bail;
 	}
 
-	/* lets handle the simple truncate cases before doing any more
-	 * cluster locking. */
-	if (new_i_size == le64_to_cpu(fe->i_size))
-		goto bail;
-
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
@@ -1150,14 +1145,14 @@ int ocfs2_setattr(struct dentry *dentry,
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
_
