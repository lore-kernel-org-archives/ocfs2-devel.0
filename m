From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 1 Dec 2008 14:54:49 -0800
Subject: [Ocfs2-devel] [git patches] Ocfs2 fixes
Message-ID: <20081201225449.GD8791@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 Documentation/filesystems/ocfs2.txt |    3 ---
 fs/ocfs2/buffer_head_io.c           |   15 ++++-----------
 fs/ocfs2/dlm/dlmfs.c                |    4 +++-
 fs/ocfs2/dlm/userdlm.h              |    2 +-
 fs/ocfs2/dlmglue.c                  |    3 +--
 fs/ocfs2/ocfs2.h                    |    2 +-
 fs/ocfs2/stack_user.c               |    3 +++
 7 files changed, 13 insertions(+), 19 deletions(-)

Coly Li (2):
      ocfs2: comments typo fix
      ocfs2: fix return value set in init_dlmfs_fs()

David Teigland (2):
      ocfs2: initialize stack_user lvbptr
      ocfs2: fix wake_up in unlock_ast

Mark Fasheh (2):
      ocfs2: Small documentation update
      ocfs2: fix regression in ocfs2_read_blocks_sync()

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 4340cc8..67310fb 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -28,10 +28,7 @@ Manish Singh  <manish.singh@oracle.com>
 Caveats
 =======
 Features which OCFS2 does not support yet:
-	- extended attributes
 	- quotas
-	- cluster aware flock
-	- cluster aware lockf
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 	- POSIX ACLs
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7e947c6..3a178ec 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -112,7 +112,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		bh = bhs[i];
 
 		if (buffer_jbd(bh)) {
-			mlog(ML_ERROR,
+			mlog(ML_BH_IO,
 			     "trying to sync read a jbd "
 			     "managed bh (blocknr = %llu), skipping\n",
 			     (unsigned long long)bh->b_blocknr);
@@ -147,15 +147,10 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 	for (i = nr; i > 0; i--) {
 		bh = bhs[i - 1];
 
-		if (buffer_jbd(bh)) {
-			mlog(ML_ERROR,
-			     "the journal got the buffer while it was "
-			     "locked for io! (blocknr = %llu)\n",
-			     (unsigned long long)bh->b_blocknr);
-			BUG();
-		}
+		/* No need to wait on the buffer if it's managed by JBD. */
+		if (!buffer_jbd(bh))
+			wait_on_buffer(bh);
 
-		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			/* Status won't be cleared from here on out,
 			 * so we can safely record this and loop back
@@ -251,8 +246,6 @@ int ocfs2_read_blocks(struct inode *inode, u64 block, int nr,
 			ignore_cache = 1;
 		}
 
-		/* XXX: Can we ever get this and *not* have the cached
-		 * flag set? */
 		if (buffer_jbd(bh)) {
 			if (ignore_cache)
 				mlog(ML_BH_IO, "trying to sync read a jbd "
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 533a789..ba962d7 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -608,8 +608,10 @@ static int __init init_dlmfs_fs(void)
 				0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
 					SLAB_MEM_SPREAD),
 				dlmfs_init_once);
-	if (!dlmfs_inode_cache)
+	if (!dlmfs_inode_cache) {
+		status = -ENOMEM;
 		goto bail;
+	}
 	cleanup_inode = 1;
 
 	user_dlm_worker = create_singlethread_workqueue("user_dlm");
diff --git a/fs/ocfs2/dlm/userdlm.h b/fs/ocfs2/dlm/userdlm.h
index 39ec277..0c3cc03 100644
--- a/fs/ocfs2/dlm/userdlm.h
+++ b/fs/ocfs2/dlm/userdlm.h
@@ -33,7 +33,7 @@
 #include <linux/workqueue.h>
 
 /* user_lock_res->l_flags flags. */
-#define USER_LOCK_ATTACHED      (0x00000001) /* have we initialized
+#define USER_LOCK_ATTACHED      (0x00000001) /* we have initialized
 					       * the lvb */
 #define USER_LOCK_BUSY          (0x00000002) /* we are currently in
 					       * dlm_lock */
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index ec68442..6e6cc0a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2841,9 +2841,8 @@ static void ocfs2_unlock_ast(void *opaque, int error)
 
 	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
 	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
-	spin_unlock_irqrestore(&lockres->l_lock, flags);
-
 	wake_up(&lockres->l_event);
+	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	mlog_exit_void();
 }
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index fef7ece..3fed9e3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -85,7 +85,7 @@ enum ocfs2_unlock_action {
 };
 
 /* ocfs2_lock_res->l_flags flags. */
-#define OCFS2_LOCK_ATTACHED      (0x00000001) /* have we initialized
+#define OCFS2_LOCK_ATTACHED      (0x00000001) /* we have initialized
 					       * the lvb */
 #define OCFS2_LOCK_BUSY          (0x00000002) /* we are currently in
 					       * dlm_lock */
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index faec2d8..9b76d41 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -740,6 +740,9 @@ static int user_dlm_lock_status(union ocfs2_dlm_lksb *lksb)
 
 static void *user_dlm_lvb(union ocfs2_dlm_lksb *lksb)
 {
+	if (!lksb->lksb_fsdlm.sb_lvbptr)
+		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
+					     sizeof(struct dlm_lksb);
 	return (void *)(lksb->lksb_fsdlm.sb_lvbptr);
 }
 
