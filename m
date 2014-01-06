From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sun, 5 Jan 2014 20:11:19 -0600
Subject: [Ocfs2-devel] [RFC] Why unlink performance is low?
Message-ID: <20140106021115.GA5667@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After a delete, the system thread calls evict_inode which calls the
following sequence:
ocfs2_evict_inode() -> ocfs2_delete_inode() ->
ocfs2_query_inode_wipe() -> ocfs2_try_open_lock() on d1, it fails
with -EAGAIN. The open lock fails because on the remote node
a PR->EX convert takes longer than a simple EX grant.

This starts a checkpoint because OCFS2_INODE_DELETED flag is not set.
Now, a checkpoint interferes with the journaling of the inodes deleted 
in the following unlinks. I had earlier concluded that this happens
for directories only, however I was wrong. This happens for files as well.

The patch attached is *not* correct. I am sending this to show that where
the problem lies. I worked this on a "hypothetical" situation where the
files created by other nodes are not open on any other node during the
time of deletion. I agree that open lock should not block during
inode eviction.

The root problem is that open lock fails with -EAGAIN even if the file
is not open on any other node of the cluster. The reason we get -EAGAIN
is because the lock is on the remote end and the whole locking sequence
does not complete with LKF_NOQUEUE set. Here are some numbers:

Without patch (native) times:
-------------------------------------------------
| # files  | create #s | copy  #s  | remove #s |
-------------------------------------------------
|        1 |   0:00.03 |   0:00.25 |   0:00.94 |
|        2 |   0:00.12 |   0:00.20 |   0:01.12 |
|        4 |   0:00.16 |   0:00.31 |   0:03.50 |
|        8 |   0:00.11 |   0:00.38 |   0:08.15 |
|       16 |   0:00.11 |   0:00.60 |   0:14.64 |
|       32 |   0:00.15 |   0:00.89 |   0:28.04 |
|       64 |   0:00.24 |   0:03.49 |   0:59.96 |
|      128 |   0:00.42 |   0:08.73 |   1:52.14 |
|      256 |   0:01.05 |   0:18.03 |   3:54.81 |
|     1024 |   0:02.74 |   0:44.13 |  14:46.36 |

With patch times:
-------------------------------------------------
| # files  | create #s | copy  #s  | remove #s |
-------------------------------------------------
|        1 |   0:00.02 |   0:00.83 |   0:00.33 |
|        2 |   0:00.04 |   0:00.18 |   0:00.27 |
|        4 |   0:00.07 |   0:00.26 |   0:00.27 |
|        8 |   0:00.08 |   0:00.29 |   0:00.44 |
|       16 |   0:00.10 |   0:00.39 |   0:00.69 |
|       32 |   0:00.14 |   0:00.60 |   0:01.26 |
|       64 |   0:00.23 |   0:01.19 |   0:02.33 |
|      128 |   0:00.51 |   0:02.15 |   0:04.60 |
|      256 |   0:00.87 |   0:04.59 |   0:09.74 |
|     1024 |   0:02.78 |   0:17.64 |   0:37.93 |

The numbers show that the improvement is not just with unlinks
but with other operations as well because the journal is
no longer overworked.

I am looking for suggestions where we can overcome this design issue
to make sure that try open locks succeed if the file is not
opened on any node. I think the semantics of DLM_LKF_NOQUEUE
may be interpreted incorrectly, or we are probably not waiting for the
lksb status to be updated, but I am not sure and some insight into this
would be helpful.

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f2d48c8..eb3baac 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1681,9 +1681,9 @@ void ocfs2_rw_unlock(struct inode *inode, int write)
 /*
  * ocfs2_open_lock always get PR mode lock.
  */
-int ocfs2_open_lock(struct inode *inode)
+int ocfs2_open_lock(struct inode *inode, int ex)
 {
-	int status = 0;
+	int status = 0, level;
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
@@ -1696,9 +1696,10 @@ int ocfs2_open_lock(struct inode *inode)
 		goto out;
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
+	level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
 
 	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    DLM_LOCK_PR, 0, 0);
+				    level, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 1d596d8..12766a1 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -110,7 +110,7 @@ int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
-int ocfs2_open_lock(struct inode *inode);
+int ocfs2_open_lock(struct inode *inode, int ex);
 int ocfs2_try_open_lock(struct inode *inode, int write);
 void ocfs2_open_unlock(struct inode *inode);
 int ocfs2_inode_lock_atime(struct inode *inode,
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f87f9bd..792dba7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -454,7 +454,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 				  0, inode);
 
 	if (can_lock) {
-		status = ocfs2_open_lock(inode);
+		status = ocfs2_open_lock(inode, 0);
 		if (status) {
 			make_bad_inode(inode);
 			mlog_errno(status);
@@ -922,7 +922,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	 * Though we call this with the meta data lock held, the
 	 * trylock keeps us from ABBA deadlock.
 	 */
-	status = ocfs2_try_open_lock(inode, 1);
+	status = ocfs2_open_lock(inode, 1);
 	if (status == -EAGAIN) {
 		status = 0;
 		reason = 3;
@@ -997,6 +997,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 		ocfs2_cleanup_delete_inode(inode, 0);
 		goto bail_unblock;
 	}
+
 	/* Lock down the inode. This gives us an up to date view of
 	 * it's metadata (for verification), and allows us to
 	 * serialize delete_inode on multiple nodes.
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index be3f867..ac67f2d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2307,7 +2307,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	}
 
 	/* get open lock so that only nodes can't remove it from orphan dir. */
-	status = ocfs2_open_lock(inode);
+	status = ocfs2_open_lock(inode, 0);
 	if (status < 0)
 		mlog_errno(status);
 

-- 
Goldwyn
