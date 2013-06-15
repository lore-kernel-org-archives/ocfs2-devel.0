From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 14 Jun 2013 21:05:10 -0500
Subject: [Ocfs2-devel] [PATCH] unlink performance: wait for open lock in
	case of dirs
Message-ID: <20130615020510.GA4487@shrek.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch is to improve the unlink performance. Here is the scenario:

On node A, create multiple directories say d1-d8, and each have 3
files under it f1, f2 and f3.
On node B, delete all directories using rm -Rf d*

The FS first unlinks f1, f2 and f3. However, when it performs
ocfs2_evict_inode() -> ocfs2_delete_inode() ->
ocfs2_query_inode_wipe() -> ocfs2_try_open_lock() on d1, it fails
with -EAGAIN. The open lock fails because on the remote node
a PR->EX convert takes longer than a simple EX grant.

This starts a checkpoint because OCFS2_INODE_DELETED flag is not set
on the directory inode. Now, a checkpoint interferes with the journaling
of the inodes deleted in the following unlinks, in our case,
directories d2-d8 and the files contained in it.

With this patch, We wait on a directory EX lock only if we already
have an open_lock in PR mode. This way we will avoid the ABBA locking.

By waiting for the open_lock on the directory, I am getting a unlink
performance improvement of a rm -Rf of 50-60% in the usual case.

Also, folded ocfs2_open_lock and ocfs2_try_open_lock into one.

Let me know if you would like to see the test case.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Index: linux-3.0-SLE11-SP3/fs/ocfs2/dlmglue.c
===================================================================
--- linux-3.0-SLE11-SP3.orig/fs/ocfs2/dlmglue.c	2013-06-14 06:47:29.322506695 -0500
+++ linux-3.0-SLE11-SP3/fs/ocfs2/dlmglue.c	2013-06-14 09:19:48.651924037 -0500
@@ -1681,9 +1681,9 @@ void ocfs2_rw_unlock(struct inode *inode
 /*
  * ocfs2_open_lock always get PR mode lock.
  */
-int ocfs2_open_lock(struct inode *inode)
+int ocfs2_open_lock(struct inode *inode, int write, int wait)
 {
-	int status = 0;
+	int status = 0, level, flags;
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -1696,43 +1696,25 @@ int ocfs2_open_lock(struct inode *inode)
 		goto out;
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
-
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    DLM_LOCK_PR, 0, 0);
-	if (status < 0)
-		mlog_errno(status);
-
-out:
-	return status;
-}
-
-int ocfs2_try_open_lock(struct inode *inode, int write)
-{
-	int status = 0, level;
-	struct ocfs2_lock_res *lockres;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-
-	BUG_ON(!inode);
-
-	mlog(0, "inode %llu try to take %s open lock\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-	     write ? "EXMODE" : "PRMODE");
-
-	if (ocfs2_mount_local(osb))
-		goto out;
-
-	lockres = &OCFS2_I(inode)->ip_open_lockres;
-
 	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
+	if (wait) {
+		flags = 0;
+		/* If we don't already have the lock in PR mode,
+		 * don't wait.
+		 *
+		 * This should avoid ABBA locking.
+		 */
+		if ((lockres->l_level != DLM_LOCK_PR) && write)
+			flags = DLM_LKF_NOQUEUE;
+
+	} else
+		flags = DLM_LKF_NOQUEUE;
 
-	/*
-	 * The file system may already holding a PRMODE/EXMODE open lock.
-	 * Since we pass DLM_LKF_NOQUEUE, the request won't block waiting on
-	 * other nodes and the -EAGAIN will indicate to the caller that
-	 * this inode is still in use.
-	 */
 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    level, DLM_LKF_NOQUEUE, 0);
+				    level, flags, 0);
+
+	if ((status < 0) && (flags && (status != -EAGAIN)))
+		mlog_errno(status);
 
 out:
 	return status;
Index: linux-3.0-SLE11-SP3/fs/ocfs2/inode.c
===================================================================
--- linux-3.0-SLE11-SP3.orig/fs/ocfs2/inode.c	2013-06-13 22:54:32.527606012 -0500
+++ linux-3.0-SLE11-SP3/fs/ocfs2/inode.c	2013-06-14 07:33:53.960196648 -0500
@@ -455,7 +455,7 @@ static int ocfs2_read_locked_inode(struc
 				  0, inode);
 
 	if (can_lock) {
-		status = ocfs2_open_lock(inode);
+		status = ocfs2_open_lock(inode, 0, 1);
 		if (status) {
 			make_bad_inode(inode);
 			mlog_errno(status);
@@ -470,7 +470,7 @@ static int ocfs2_read_locked_inode(struc
 	}
 
 	if (args->fi_flags & OCFS2_FI_FLAG_ORPHAN_RECOVERY) {
-		status = ocfs2_try_open_lock(inode, 0);
+		status = ocfs2_open_lock(inode, 0, 0);
 		if (status) {
 			make_bad_inode(inode);
 			return status;
@@ -923,7 +923,8 @@ static int ocfs2_query_inode_wipe(struct
 	 * Though we call this with the meta data lock held, the
 	 * trylock keeps us from ABBA deadlock.
 	 */
-	status = ocfs2_try_open_lock(inode, 1);
+	status = ocfs2_open_lock(inode, 1, S_ISDIR(inode->i_mode));
+
 	if (status == -EAGAIN) {
 		status = 0;
 		reason = 3;
Index: linux-3.0-SLE11-SP3/fs/ocfs2/dlmglue.h
===================================================================
--- linux-3.0-SLE11-SP3.orig/fs/ocfs2/dlmglue.h	2013-06-10 09:45:20.787386504 -0500
+++ linux-3.0-SLE11-SP3/fs/ocfs2/dlmglue.h	2013-06-14 07:38:49.861576515 -0500
@@ -110,8 +110,7 @@ int ocfs2_create_new_inode_locks(struct
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
-int ocfs2_open_lock(struct inode *inode);
-int ocfs2_try_open_lock(struct inode *inode, int write);
+int ocfs2_open_lock(struct inode *inode, int write, int wait);
 void ocfs2_open_unlock(struct inode *inode);
 int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
Index: linux-3.0-SLE11-SP3/fs/ocfs2/namei.c
===================================================================
--- linux-3.0-SLE11-SP3.orig/fs/ocfs2/namei.c	2013-06-13 22:54:32.527606012 -0500
+++ linux-3.0-SLE11-SP3/fs/ocfs2/namei.c	2013-06-14 07:40:06.623785914 -0500
@@ -2302,7 +2302,7 @@ int ocfs2_create_inode_in_orphan(struct
 	}
 
 	/* get open lock so that only nodes can't remove it from orphan dir. */
-	status = ocfs2_open_lock(inode);
+	status = ocfs2_open_lock(inode, 0, 1);
 	if (status < 0)
 		mlog_errno(status);
 
