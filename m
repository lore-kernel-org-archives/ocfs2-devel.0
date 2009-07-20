From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Jul 2009 14:34:01 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync
	ocfs2 volume.
In-Reply-To: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090720123401.GA15341@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

On Mon 20-07-09 17:08:42, Tao Ma wrote:
> In commit ea455f8ab68338ba69f5d3362b342c115bea8e13, we move the
> dentry lock put process into ocfs2_wq. This is OK for most case,
> but as for umount, it lead to at least 2 bugs. See
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1133 and
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1135. And it happens
> easily if we have opened a lot of inodes.
> 
> For 1135, the reason is that during umount will call
> generic_shutdown_super and it will do:
> 1. shrink_dcache_for_umount
> 2. sync_filesystem.
> 3. invalidate_inodes.
> 
> In shrink_dcache_for_umount, we will drop the dentry, and queue
> ocfs2_wq for dentry lock put. While in invalidate_inodes we will
> call invalidate_list which will iterate all the inodes for the sb.
> The bad thing is that in this function it will call
> cond_resched_lock(&inode_lock). So if in any case, we are scheduled
> out and ocfs2_wq is scheduled and drop some inodes, the "next" in
> invalidate_list will get damaged(have next->next = next). And the
> invalidate_list will enter dead loop and cause very high cpu.
  Aw, well spotted. Sorry for the bug.

> So the only chance that we can solve this problem is flush dentry put
> in step 2 of generic_shutdown_super, that is sync_filesystem. And
> this patch is just adding dentry put flush process in ocfs2_sync_fs.
> 
> Jan,
> 	Will dentry put in sync_fs have potential dead lock with quota
> lock? If yes, maybe we have to revert that commit which cause this umount
> problem and find other ways instead.
  Well, it might be OK but IMHO it's a crude hack. I think the right fix
should be different: OCFS2 should provide it's own .kill_sb function. In
that function we should make sure ocfs2_wq stops putting inode references
and then flush the list from ocfs2_put_super.
  Regarding quota this should be safe as the only lock we hold is
umount_sem.
  Below is a patch doing what I'd imagine (lightly tested only). Could you
verify whether it fixes the issue you can see?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

From f96286432cc05f80e3aabc0c4795c62ffdd37d9a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Jul 2009 12:12:36 +0200
Subject: [PATCH] ocfs2: Fix deadlock on umount

In commit ea455f8ab68338ba69f5d3362b342c115bea8e13, we move the
dentry lock put process into ocfs2_wq. This is OK for most cases,
but as for umount, it lead to at least 2 bugs. See
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1133 and
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1135. And it happens
easily if we have opened a lot of inodes.

For 1135, the reason is that during umount will call
generic_shutdown_super and it will do:
1. shrink_dcache_for_umount
2. sync_filesystem.
3. invalidate_inodes.

In shrink_dcache_for_umount, we will drop the dentry, and queue
ocfs2_wq for dentry lock put. While in invalidate_inodes we will
call invalidate_list which will iterate all the inodes for the sb.
The bad thing is that in this function it will call
cond_resched_lock(&inode_lock). So if in any case, we are scheduled
out and ocfs2_wq is scheduled and drop some inodes, the "next" in
invalidate_list will get damaged(have next->next = next). And the
invalidate_list will enter dead loop and cause very high cpu.

Fix the problem by making sure that ocfs2_wq does no more putting of
inode references when umounting starts and drop all the references
from ocfs2_put_super().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dcache.c |   35 +++++++++++++++++++++++++++--------
 fs/ocfs2/dcache.h |    3 +++
 fs/ocfs2/ocfs2.h  |   13 +++++++++++++
 fs/ocfs2/super.c  |   25 ++++++++++++++++++++++---
 4 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b574431..fd4fa65 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -310,22 +310,19 @@ out_attach:
 	return ret;
 }
 
-static DEFINE_SPINLOCK(dentry_list_lock);
+DEFINE_SPINLOCK(dentry_list_lock);
 
 /* We limit the number of dentry locks to drop in one go. We have
  * this limit so that we don't starve other users of ocfs2_wq. */
 #define DL_INODE_DROP_COUNT 64
 
 /* Drop inode references from dentry locks */
-void ocfs2_drop_dl_inodes(struct work_struct *work)
+static void __ocfs2_drop_dl_inodes(struct ocfs2_super *osb, int drop_count)
 {
-	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
-					       dentry_lock_work);
 	struct ocfs2_dentry_lock *dl;
-	int drop_count = DL_INODE_DROP_COUNT;
 
 	spin_lock(&dentry_list_lock);
-	while (osb->dentry_lock_list && drop_count--) {
+	while (osb->dentry_lock_list && (drop_count < 0 || drop_count--)) {
 		dl = osb->dentry_lock_list;
 		osb->dentry_lock_list = dl->dl_next;
 		spin_unlock(&dentry_list_lock);
@@ -333,11 +330,32 @@ void ocfs2_drop_dl_inodes(struct work_struct *work)
 		kfree(dl);
 		spin_lock(&dentry_list_lock);
 	}
-	if (osb->dentry_lock_list)
+	spin_unlock(&dentry_list_lock);
+}
+
+void ocfs2_drop_dl_inodes(struct work_struct *work)
+{
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       dentry_lock_work);
+
+	__ocfs2_drop_dl_inodes(osb, DL_INODE_DROP_COUNT);
+	/*
+	 * Don't queue dropping if umount is in progress. We flush the
+	 * list in ocfs2_dismount_volume
+	 */
+	spin_lock(&dentry_list_lock);
+	if (osb->dentry_lock_list &&
+	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT))
 		queue_work(ocfs2_wq, &osb->dentry_lock_work);
 	spin_unlock(&dentry_list_lock);
 }
 
+/* Flush the whole work queue */
+void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb)
+{
+	__ocfs2_drop_dl_inodes(osb, -1);
+}
+
 /*
  * ocfs2_dentry_iput() and friends.
  *
@@ -368,7 +386,8 @@ static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 	/* We leave dropping of inode reference to ocfs2_wq as that can
 	 * possibly lead to inode deletion which gets tricky */
 	spin_lock(&dentry_list_lock);
-	if (!osb->dentry_lock_list)
+	if (!osb->dentry_lock_list &&
+	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT))
 		queue_work(ocfs2_wq, &osb->dentry_lock_work);
 	dl->dl_next = osb->dentry_lock_list;
 	osb->dentry_lock_list = dl;
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index faa12e7..f5dd178 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -49,10 +49,13 @@ struct ocfs2_dentry_lock {
 int ocfs2_dentry_attach_lock(struct dentry *dentry, struct inode *inode,
 			     u64 parent_blkno);
 
+extern spinlock_t dentry_list_lock;
+
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl);
 
 void ocfs2_drop_dl_inodes(struct work_struct *work);
+void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb);
 
 struct dentry *ocfs2_find_local_alias(struct inode *inode, u64 parent_blkno,
 				      int skip_unhashed);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c9345eb..cfa7102 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -227,6 +227,7 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_SOFT_RO	0x0001
 #define OCFS2_OSB_HARD_RO	0x0002
 #define OCFS2_OSB_ERROR_FS	0x0004
+#define OCFS2_OSB_UMOUNT	0x0008
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
 struct ocfs2_journal;
@@ -490,6 +491,18 @@ static inline void ocfs2_set_osb_flag(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);
 }
 
+
+static inline unsigned long  ocfs2_test_osb_flag(struct ocfs2_super *osb,
+						 unsigned long flag)
+{
+	unsigned long ret;
+
+	spin_lock(&osb->osb_lock);
+	ret = osb->osb_flags & flag;
+	spin_unlock(&osb->osb_lock);
+	return ret;
+}
+
 static inline void ocfs2_set_ro_flag(struct ocfs2_super *osb,
 				     int hard)
 {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 7efb349..6cf5ab8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1213,14 +1213,27 @@ static int ocfs2_get_sb(struct file_system_type *fs_type,
 			   mnt);
 }
 
+static void ocfs2_kill_sb(struct super_block *sb)
+{
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+
+	/* Prevent further queueing of inode drop events */
+	spin_lock(&dentry_list_lock);
+	ocfs2_set_osb_flag(osb, OCFS2_OSB_UMOUNT);
+	spin_unlock(&dentry_list_lock);
+	/* Wait for work to finish and/or remove it */
+	cancel_work_sync(&osb->dentry_lock_work);
+
+	kill_block_super(sb);
+}
+
 static struct file_system_type ocfs2_fs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ocfs2",
 	.get_sb         = ocfs2_get_sb, /* is this called when we mount
 					* the fs? */
-	.kill_sb        = kill_block_super, /* set to the generic one
-					     * right now, but do we
-					     * need to change that? */
+	.kill_sb        = ocfs2_kill_sb,
+
 	.fs_flags       = FS_REQUIRES_DEV|FS_RENAME_DOES_D_MOVE,
 	.next           = NULL
 };
@@ -1819,6 +1832,12 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	debugfs_remove(osb->osb_ctxt);
 
+	/*
+	 * Flush inode dropping work queue so that deletes are
+	 * performed while the filesystem is still working
+	 */
+	ocfs2_drop_all_dl_inodes(osb);
+
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
-- 
1.6.0.2
