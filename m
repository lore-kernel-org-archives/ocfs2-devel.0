From: alex chen <alex.chen@huawei.com>
Date: Fri, 27 Oct 2017 15:57:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: should wait dio before inode lock in
	ocfs2_setattr()
Message-ID: <59F2E6F2.7090803@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we should wait dio requests to finish before inode lock in
ocfs2_setattr(), otherwise the following deadlock will be happened:
process 1                  process 2                    process 3
truncate file 'A'          end_io of writing file 'A'   receiving the bast messages
ocfs2_setattr
 ocfs2_inode_lock_tracker
  ocfs2_inode_lock_full
 inode_dio_wait
  __inode_dio_wait
  -->waiting for all dio
  requests finish
                                                        dlm_proxy_ast_handler
                                                         dlm_do_local_bast
                                                          ocfs2_blocking_ast
                                                           ocfs2_generic_handle_bast
                                                            set OCFS2_LOCK_BLOCKED flag
                        dio_end_io
                         dio_bio_end_aio
                          dio_complete
                           ocfs2_dio_end_io
                            ocfs2_dio_end_io_write
                             ocfs2_inode_lock
                              __ocfs2_cluster_lock
                               ocfs2_wait_for_mask
                               -->waiting for OCFS2_LOCK_BLOCKED
                               flag to be cleared, that is waiting
                               for 'process 1' unlocking the inode lock
                           inode_dio_end
                           -->here dec the i_dio_count, but will never
                           be called, so a deadlock happened.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>

---
 fs/ocfs2/file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6e41fc8..50e09a6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1161,6 +1161,13 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
 	if (size_change) {
+
+		/* here we should wait dio to finish before inode lock
+		 * to avoid a deadlock between ocfs2_setattr() and
+		 * ocfs2_dio_end_io_write()
+		 */
+		inode_dio_wait(inode);
+
 		status = ocfs2_rw_lock(inode, 1);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1200,8 +1207,6 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (status)
 			goto bail_unlock;

-		inode_dio_wait(inode);
-
 		if (i_size_read(inode) >= attr->ia_size) {
 			if (ocfs2_should_order_data(inode)) {
 				status = ocfs2_begin_ordered_truncate(inode,
-- 
1.9.5.msysgit.1
