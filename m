From: piaojun <piaojun@huawei.com>
Date: Tue, 30 Jan 2018 15:38:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: use 'oi' instead of 'OCFS2_I()'
Message-ID: <5A7020FE.5050906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We could use 'oi' instead of 'OCFS2_I()' to make code more elegant.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/alloc.c        | 2 +-
 fs/ocfs2/aops.c         | 2 +-
 fs/ocfs2/file.c         | 6 +++---
 fs/ocfs2/inode.c        | 2 +-
 fs/ocfs2/namei.c        | 6 +++---
 fs/ocfs2/refcounttree.c | 6 +++---
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ab5105f..8ee4bd8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6940,7 +6940,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 			goto out_commit;
 		did_quota = 1;

-		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+		data_ac->ac_resv = &oi->ip_la_data_resv;

 		ret = ocfs2_claim_clusters(handle, data_ac, 1, &bit_off,
 					   &num);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index d151632..4dae836 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -346,7 +346,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
 	unlock = 0;

 out_alloc:
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+	up_read(&oi->ip_alloc_sem);
 out_inode_unlock:
 	ocfs2_inode_unlock(inode, 0);
 out:
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index dc455d4..2188af4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -101,7 +101,7 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);

 	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
-			      (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			      (unsigned long long)oi->ip_blkno,
 			      file->f_path.dentry->d_name.len,
 			      file->f_path.dentry->d_name.name, mode);

@@ -116,7 +116,7 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	/* Check that the inode hasn't been wiped from disk by another
 	 * node. If it hasn't then we're safe as long as we hold the
 	 * spin lock until our increment of open count. */
-	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED) {
+	if (oi->ip_flags & OCFS2_INODE_DELETED) {
 		spin_unlock(&oi->ip_lock);

 		status = -ENOENT;
@@ -188,7 +188,7 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 	bool needs_barrier = false;

 	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
-			      OCFS2_I(inode)->ip_blkno,
+			      oi->ip_blkno,
 			      file->f_path.dentry->d_name.len,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1a1e007..2c48395 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1159,7 +1159,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 	 * exception here are successfully wiped inodes - their
 	 * metadata can now be considered to be part of the system
 	 * inodes from which it came. */
-	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED))
+	if (!(oi->ip_flags & OCFS2_INODE_DELETED))
 		ocfs2_checkpoint_inode(inode);

 	mlog_bug_on_msg(!list_empty(&oi->ip_io_markers),
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3b0a10d..e1208d1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -524,7 +524,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	 * these are used by the support functions here and in
 	 * callers. */
 	inode->i_ino = ino_from_blkno(osb->sb, fe_blkno);
-	OCFS2_I(inode)->ip_blkno = fe_blkno;
+	oi->ip_blkno = fe_blkno;
 	spin_lock(&osb->osb_lock);
 	inode->i_generation = osb->s_next_generation++;
 	spin_unlock(&osb->osb_lock);
@@ -1185,8 +1185,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	}

 	trace_ocfs2_double_lock_end(
-			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
-			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+			(unsigned long long)oi1->ip_blkno,
+			(unsigned long long)oi2->ip_blkno);

 bail:
 	if (status)
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ab156e3..50e288e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -573,7 +573,7 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 	BUG_ON(ocfs2_is_refcount_inode(inode));

 	trace_ocfs2_create_refcount_tree(
-		(unsigned long long)OCFS2_I(inode)->ip_blkno);
+		(unsigned long long)oi->ip_blkno);

 	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
 	if (ret) {
@@ -4766,8 +4766,8 @@ static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
 		*bh2 = *bh1;

 	trace_ocfs2_double_lock_end(
-			(unsigned long long)OCFS2_I(inode1)->ip_blkno,
-			(unsigned long long)OCFS2_I(inode2)->ip_blkno);
+			(unsigned long long)oi1->ip_blkno,
+			(unsigned long long)oi2->ip_blkno);

 	return 0;

-- 
