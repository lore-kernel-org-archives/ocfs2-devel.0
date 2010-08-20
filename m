From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 20 Aug 2010 14:40:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't delete orphaned files if we are
	in the process of umount.
Message-ID: <1282286445-16321-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Generally, orphan scan run in ocfs2_wq and is used to replay orphan
dir. So for some low end iscsi device, the delete_inode may take
a long time(In some devices, I have seen that delete 500 files will
take about 15 secs). This will eventually cause umount to
livelock(umount has to flush ocfs2_wq which will wait until orphan
scan to finish).

So this patch just try to finish the orphan scan quickly.
In general when umount starts, we will set a flag(Jan has added one
named OCFS2_OSB_DROP_DENTRY_LOCK_IMMED which is set in kill_sb, I
renamed it to OCFS2_OSB_UMOUNT_START so that we all can use it),
and when ocfs2_evict_inode finds this flag, it will skip the process
of ocfs2_delete_inode if the file is from orphan dir. We are safe to
skip the delete process since it is in orphan dir, so it will be
deleted eventually by other orphan scan, next mount or fsck.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dcache.c |    4 ++--
 fs/ocfs2/inode.c  |   24 ++++++++++++++++++++++--
 fs/ocfs2/ocfs2.h  |    2 +-
 fs/ocfs2/super.c  |    2 +-
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b4957c7..827ccb8 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -356,7 +356,7 @@ void ocfs2_drop_dl_inodes(struct work_struct *work)
 	 */
 	spin_lock(&dentry_list_lock);
 	if (osb->dentry_lock_list &&
-	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED))
+	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT_START))
 		queue_work(ocfs2_wq, &osb->dentry_lock_work);
 	spin_unlock(&dentry_list_lock);
 }
@@ -398,7 +398,7 @@ static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 	 * possibly lead to inode deletion which gets tricky */
 	spin_lock(&dentry_list_lock);
 	if (!osb->dentry_lock_list &&
-	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED))
+	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT_START))
 		queue_work(ocfs2_wq, &osb->dentry_lock_work);
 	dl->dl_next = osb->dentry_lock_list;
 	osb->dentry_lock_list = dl;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0492464..71b47c9 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1182,12 +1182,32 @@ static void ocfs2_clear_inode(struct inode *inode)
 
 void ocfs2_evict_inode(struct inode *inode)
 {
+	int delete = 0;
+
 	if (!inode->i_nlink ||
 	    (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
+		/*
+		 * In case we are in umount and we are now in the
+		 * orphan dir, it is safe for us to just clear the
+		 * inode and let the next mount, fsck or orphan scan
+		 * from other live nodes to clear it for us. So skip
+		 * delete_inode in this case.
+		 */
+		if (ocfs2_test_osb_flag(OCFS2_SB(inode->i_sb),
+					OCFS2_OSB_UMOUNT_START) &&
+		    !(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR))
+			mlog(0, "skip delete inode %llu because "
+			     "umount has begun.\n",
+			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		else
+			delete = 1;
+	}
+
+	if (delete)
 		ocfs2_delete_inode(inode);
-	} else {
+	else
 		truncate_inode_pages(&inode->i_data, 0);
-	}
+
 	ocfs2_clear_inode(inode);
 }
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 70354a5..0544b0c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -261,7 +261,7 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_SOFT_RO			0x0001
 #define OCFS2_OSB_HARD_RO			0x0002
 #define OCFS2_OSB_ERROR_FS			0x0004
-#define OCFS2_OSB_DROP_DENTRY_LOCK_IMMED	0x0008
+#define OCFS2_OSB_UMOUNT_START			0x0008
 
 #define OCFS2_DEFAULT_ATIME_QUANTUM		60
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index caa7bef..327d8c4 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1245,7 +1245,7 @@ static void ocfs2_kill_sb(struct super_block *sb)
 
 	/* Prevent further queueing of inode drop events */
 	spin_lock(&dentry_list_lock);
-	ocfs2_set_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED);
+	ocfs2_set_osb_flag(osb, OCFS2_OSB_UMOUNT_START);
 	spin_unlock(&dentry_list_lock);
 	/* Wait for work to finish and/or remove it */
 	cancel_work_sync(&osb->dentry_lock_work);
-- 
1.5.5
