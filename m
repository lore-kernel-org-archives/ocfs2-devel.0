From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 20 Jul 2009 17:08:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync ocfs2
	volume.
Message-ID: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In commit ea455f8ab68338ba69f5d3362b342c115bea8e13, we move the
dentry lock put process into ocfs2_wq. This is OK for most case,
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

So the only chance that we can solve this problem is flush dentry put
in step 2 of generic_shutdown_super, that is sync_filesystem. And
this patch is just adding dentry put flush process in ocfs2_sync_fs.

Jan,
	Will dentry put in sync_fs have potential dead lock with quota
lock? If yes, maybe we have to revert that commit which cause this umount
problem and find other ways instead.

Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dcache.c |   16 ++++++++++++++++
 fs/ocfs2/dcache.h |    1 +
 fs/ocfs2/super.c  |    7 +++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b574431..610288a 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -316,6 +316,22 @@ static DEFINE_SPINLOCK(dentry_list_lock);
  * this limit so that we don't starve other users of ocfs2_wq. */
 #define DL_INODE_DROP_COUNT 64
 
+void ocfs2_flush_dl_inode_drop(struct ocfs2_super *osb)
+{
+	struct ocfs2_dentry_lock *dl;
+
+	spin_lock(&dentry_list_lock);
+	while (osb->dentry_lock_list) {
+		dl = osb->dentry_lock_list;
+		osb->dentry_lock_list = dl->dl_next;
+		spin_unlock(&dentry_list_lock);
+		iput(dl->dl_inode);
+		kfree(dl);
+		spin_lock(&dentry_list_lock);
+	}
+	spin_unlock(&dentry_list_lock);
+}
+
 /* Drop inode references from dentry locks */
 void ocfs2_drop_dl_inodes(struct work_struct *work)
 {
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index faa12e7..6dcf7cd 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -62,4 +62,5 @@ void ocfs2_dentry_move(struct dentry *dentry, struct dentry *target,
 
 extern spinlock_t dentry_attach_lock;
 
+void ocfs2_flush_dl_inode_drop(struct ocfs2_super *osb);
 #endif /* OCFS2_DCACHE_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2b4fd69..7e80fda 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -384,6 +384,13 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	if (osb->dentry_lock_list) {
+		if (wait)
+			ocfs2_flush_dl_inode_drop(osb);
+		else
+			queue_work(ocfs2_wq, &osb->dentry_lock_work);
+	}
+
 	if (wait) {
 		status = ocfs2_flush_truncate_log(osb);
 		if (status < 0)
-- 
1.6.2.rc2.16.gf474c
