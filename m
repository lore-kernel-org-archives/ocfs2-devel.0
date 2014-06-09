From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:04:04 -0700
Subject: [Ocfs2-devel] [patch 5/8] ocfs2: refcount: take inode_lock until
	write io issued
Message-ID: <20140609200404.B3C6B5A4A39@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: refcount: take inode_lock until write io issued

This patch tries to fix this crash:

 #5 [ffff88003c1cd690] do_invalid_op at ffffffff810166d5
 #6 [ffff88003c1cd730] invalid_op at ffffffff8159b2de
    [exception RIP: ocfs2_direct_IO_get_blocks+359]
    RIP: ffffffffa05dfa27  RSP: ffff88003c1cd7e8  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffff88003c1cdaa8  RCX: 0000000000000000
    RDX: 000000000000000c  RSI: ffff880027a95000  RDI: ffff88003c79b540
    RBP: ffff88003c1cd858   R8: 0000000000000000   R9: ffffffff815f6ba0
    R10: 00000000000001c9  R11: 00000000000001c9  R12: ffff88002d271500
    R13: 0000000000000001  R14: 0000000000000000  R15: 0000000000001000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff88003c1cd860] do_direct_IO at ffffffff811cd31b
 #8 [ffff88003c1cd950] direct_IO_iovec at ffffffff811cde9c
 #9 [ffff88003c1cd9b0] do_blockdev_direct_IO at ffffffff811ce764
#10 [ffff88003c1cdb80] __blockdev_direct_IO at ffffffff811ce7cc
#11 [ffff88003c1cdbb0] ocfs2_direct_IO at ffffffffa05df756 [ocfs2]
#12 [ffff88003c1cdbe0] generic_file_direct_write_iter at ffffffff8112f935
#13 [ffff88003c1cdc40] ocfs2_file_write_iter at ffffffffa0600ccc [ocfs2]
#14 [ffff88003c1cdd50] do_aio_write at ffffffff8119126c
#15 [ffff88003c1cddc0] aio_rw_vect_retry at ffffffff811d9bb4
#16 [ffff88003c1cddf0] aio_run_iocb at ffffffff811db880
#17 [ffff88003c1cde30] io_submit_one at ffffffff811dc238
#18 [ffff88003c1cde80] do_io_submit at ffffffff811dc437
#19 [ffff88003c1cdf70] sys_io_submit at ffffffff811dc530
#20 [ffff88003c1cdf80] system_call_fastpath at ffffffff8159a159

It crashes at
	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
in ocfs2_direct_IO_get_blocks.

ocfs2_direct_IO_get_blocks is expecting the OCFS2_EXT_REFCOUNTED be
removed in ocfs2_prepare_inode_for_write() if it was there.  But no
cluster lock is taken during the time before (or inside)
ocfs2_prepare_inode_for_write() and after ocfs2_direct_IO_get_blocks().

It can happen in this case:

Node A(which crashes)				Node B
------------------------                 ---------------------------
ocfs2_file_aio_write
  ocfs2_prepare_inode_for_write
    ocfs2_inode_lock
    ...
    ocfs2_inode_unlock
  #no refcount found
....					ocfs2_reflink
					  ocfs2_inode_lock
					  ...
					  ocfs2_inode_unlock
					  #now, refcount flag set on extent

					...
					flush change to disk

ocfs2_direct_IO_get_blocks
  ocfs2_get_clusters
    #extent map miss
    #buffer_head miss
    read extents from disk
  found refcount flag on extent
  crash..

Fix: We have to take the inode_lock long enough until
ocfs2_direct_IO_get_blocks finished.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c     |   23 ++++++++++++++++++++---
 fs/ocfs2/ocfs2_fs.h |    2 +-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/file.c~refcount-take-inode_lock-until-write-io-issued fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~refcount-take-inode_lock-until-write-io-issued
+++ a/fs/ocfs2/file.c
@@ -2104,13 +2104,16 @@ static int ocfs2_prepare_inode_for_write
 					 size_t count,
 					 int appending,
 					 int *direct_io,
-					 int *has_refcount)
+					 int *has_refcount,
+					 int *meta_level_out)
 {
 	int ret = 0, meta_level = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	loff_t saved_pos = 0, end;
 
+	if (meta_level_out)
+		*meta_level_out = -1;
 	/*
 	 * We start with a read level meta lock and only jump to an ex
 	 * if we need to make modifications here.
@@ -2226,6 +2229,15 @@ out_unlock:
 					    saved_pos, appending, count,
 					    direct_io, has_refcount);
 
+	/*
+	 * If direct IO would be done later, we have to keep inode_lock locked.
+	 * Buffer'd IO is fine since the COW work will be done again in
+	 * ocfs2_write_begin.
+	 */
+	if (direct_io && *direct_io && meta_level_out && !ret) {
+		*meta_level_out = meta_level;
+		meta_level = -1;
+	}
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
 
@@ -2251,6 +2263,7 @@ static ssize_t ocfs2_file_aio_write(stru
 	int full_coherency = !(osb->s_mount_opt &
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
+	int meta_level = -1;
 
 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2310,7 +2323,8 @@ relock:
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file, ppos,
 					    iocb->ki_nbytes, appending,
-					    &can_do_direct, &has_refcount);
+					    &can_do_direct, &has_refcount,
+					    &meta_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
@@ -2434,6 +2448,8 @@ out_sems:
 	if (have_alloc_sem)
 		ocfs2_iocb_clear_sem_locked(iocb);
 
+	if (meta_level >= 0)
+		ocfs2_inode_unlock(inode, meta_level);
 	mutex_unlock(&inode->i_mutex);
 
 	if (written)
@@ -2448,7 +2464,8 @@ static int ocfs2_splice_to_file(struct p
 	int ret;
 
 	ret = ocfs2_prepare_inode_for_write(out, &sd->pos,
-					    sd->total_len, 0, NULL, NULL);
+					    sd->total_len, 0, NULL, NULL,
+					    NULL);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
diff -puN fs/ocfs2/ocfs2_fs.h~refcount-take-inode_lock-until-write-io-issued fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~refcount-take-inode_lock-until-write-io-issued
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -724,7 +724,7 @@ struct ocfs2_dinode {
 	__le64 i_xattr_loc;
 /*80*/	struct ocfs2_block_check i_check;	/* Error checking */
 /*88*/	__le64 i_dx_root;		/* Pointer to dir index root block */
-/*90*/	__le64 i_refcount_loc;
+/*90*/	__le64 i_refcount_loc;		/* Root block of the refcount tree */
 	__le64 i_suballoc_loc;		/* Suballocator block group this
 					   inode belongs to.  Only valid
 					   if allocated from a
_
