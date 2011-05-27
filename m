From: Tiger Yang <tiger.yang@oracle.com>
Date: Sat, 28 May 2011 00:34:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Bugfix for hard readonly mount
Message-ID: <1306514059-22927-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes few bugs when do hard readonly mount.
see detail: http://oss.oracle.com/bugzilla/show_bug.cgi?id=1322

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/dlmglue.c |   21 +++++++++++++++------
 fs/ocfs2/super.c   |    3 ++-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..da103f5 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1692,7 +1692,7 @@ int ocfs2_open_lock(struct inode *inode)
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
 		goto out;
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
@@ -1718,6 +1718,12 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
 
+	if (ocfs2_is_hard_readonly(osb)) {
+		if (write)
+			status = -EROFS;
+		goto out;
+	}
+
 	if (ocfs2_mount_local(osb))
 		goto out;
 
@@ -2298,7 +2304,7 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	if (ocfs2_is_hard_readonly(osb)) {
 		if (ex)
 			status = -EROFS;
-		goto bail;
+		goto getbh;
 	}
 
 	if (ocfs2_mount_local(osb))
@@ -2356,7 +2362,7 @@ local:
 			mlog_errno(status);
 		goto bail;
 	}
-
+getbh:
 	if (ret_bh) {
 		status = ocfs2_assign_bh(inode, ret_bh, local_bh);
 		if (status < 0) {
@@ -2628,8 +2634,11 @@ int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 
 	BUG_ON(!dl);
 
-	if (ocfs2_is_hard_readonly(osb))
-		return -EROFS;
+	if (ocfs2_is_hard_readonly(osb)) {
+		if (ex)
+			return -EROFS;
+		return 0;
+	}
 
 	if (ocfs2_mount_local(osb))
 		return 0;
@@ -2647,7 +2656,7 @@ void ocfs2_dentry_unlock(struct dentry *dentry, int ex)
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
-	if (!ocfs2_mount_local(osb))
+	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, &dl->dl_lockres, level);
 }
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5a521c7..395b26f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1973,7 +1973,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	 * If we failed before we got a uuid_str yet, we can't stop
 	 * heartbeat.  Otherwise, do it.
 	 */
-	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str)
+	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str &&
+	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
 	if (osb->cconn)
-- 
1.7.4.4
