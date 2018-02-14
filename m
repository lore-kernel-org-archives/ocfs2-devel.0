From: Gang He <ghe@suse.com>
Date: Tue, 13 Feb 2018 23:29:06 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: keep the trace point consistent
 with the function name
In-Reply-To: <02609aba-84b2-a22d-3f3b-bc1944b94260@huawei.com>
References: <02609aba-84b2-a22d-3f3b-bc1944b94260@huawei.com>
Message-ID: <5A83D732020000F9001C8D78@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good to me.
Thanks
Gang

>>> Jia Guo <guojia12@huawei.com> 02/14/18 12:53 PM >>>
keep the trace point consistent with the function name

Fixes: 3ef045c3d8ae ("ocfs2: switch to ->write_iter()")

Signed-off-by: Jia Guo <guojia12@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>

---
 fs/ocfs2/aops.h        | 2 +-
 fs/ocfs2/file.c        | 8 ++++----
 fs/ocfs2/ocfs2_trace.h | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 8614ff0..3494a62 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -78,7 +78,7 @@ static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
 /*
  * Using a named enum representing lock types in terms of #N bit stored in
  * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_aio_write/read().
+ * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
  */
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5d1784a..85aef34 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2257,7 +2257,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;

-	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
+	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
 		file->f_path.dentry->d_name.len,
 		file->f_path.dentry->d_name.name,
@@ -2405,7 +2405,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;

-	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
+	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			filp->f_path.dentry->d_name.len,
 			filp->f_path.dentry->d_name.name,
@@ -2448,7 +2448,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	 *
 	 * Take and drop the meta data lock to update inode fields
 	 * like i_size. This allows the checks down below
-	 * generic_file_aio_read() a chance of actually working.
+	 * generic_file_read_iter() a chance of actually working.
 	 */
 	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
 				     !nowait);
@@ -2460,7 +2460,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	ocfs2_inode_unlock(inode, lock_level);

 	ret = generic_file_read_iter(iocb, to);
-	trace_generic_file_aio_read_ret(ret);
+	trace_generic_file_read_iter_ret(ret);

 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index e2a11aa..2ee76a9 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1311,11 +1311,11 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_release);

 DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);

-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_write);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);

 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);

-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_read);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);

 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);

@@ -1467,7 +1467,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_write,
 		  __entry->saved_pos, __entry->count, __entry->wait)
 );

-DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
+DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);

 /* End of trace events for fs/ocfs2/file.c. */

-- 

.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
