From: Gang He <ghe@suse.com>
Date: Thu,  7 Dec 2017 21:21:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add trimfs dlm lock
Message-ID: <1512652918-11777-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As you know, ocfs2 has support trim the underlying disk via
fstrim command. But there is a problem, ocfs2 is a shared storage
cluster file system, if the user configures a scheduled fstrim
job on each file system node, this will trigger multiple nodes
trim a shared disk simultaneously, it is very wasteful for CPU
and IO consumption.
Then, we introduce a trimfs dlm lock, which will make only one
fstrim command is running on the shared disk among the cluster,
the other fstrim command should be returned with -EBUSY errno.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/alloc.c        | 18 +++++++++++++++++-
 fs/ocfs2/dlmglue.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/dlmglue.h      |  2 ++
 fs/ocfs2/ocfs2.h        |  1 +
 fs/ocfs2/ocfs2_lockid.h |  5 +++++
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ab5105f..89d16ad 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7401,10 +7401,24 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	inode_lock(main_bm_inode);
 
+	ret = ocfs2_trim_fs_lock(osb);
+	if (ret < 0) {
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
+		else {
+			ret = -EBUSY;
+			mlog(ML_NOTICE,
+			     "Cannot trim disk %s since a trim operation is "
+			     "running on it from another node.\n",
+			     sb->s_id);
+		}
+		goto out_mutex;
+	}
+
 	ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
-		goto out_mutex;
+		goto out_fsunlock;
 	}
 	main_bm = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
@@ -7466,6 +7480,8 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 out_unlock:
 	ocfs2_inode_unlock(main_bm_inode, 0);
 	brelse(main_bm_bh);
+out_fsunlock:
+	ocfs2_trim_fs_unlock(osb);
 out_mutex:
 	inode_unlock(main_bm_inode);
 	iput(main_bm_inode);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4689940..b28fdf4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -259,6 +259,10 @@ struct ocfs2_lock_res_ops {
 	.flags		= 0,
 };
 
+static struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
+	.flags		= 0,
+};
+
 static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
@@ -676,6 +680,15 @@ static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
 				   &ocfs2_nfs_sync_lops, osb);
 }
 
+static void ocfs2_trim_fs_lock_res_init(struct ocfs2_lock_res *res,
+					struct ocfs2_super *osb)
+{
+	ocfs2_lock_res_init_once(res);
+	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_TRIM_FS, 0, 0, res->l_name);
+	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_TRIM_FS,
+				   &ocfs2_trim_fs_lops, osb);
+}
+
 static void ocfs2_orphan_scan_lock_res_init(struct ocfs2_lock_res *res,
 					    struct ocfs2_super *osb)
 {
@@ -2745,6 +2758,41 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
 				     ex ? LKM_EXMODE : LKM_PRMODE);
 }
 
+int ocfs2_trim_fs_lock(struct ocfs2_super *osb)
+{
+	int status;
+	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
+
+	if (ocfs2_is_hard_readonly(osb))
+		return -EROFS;
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	ocfs2_trim_fs_lock_res_init(lockres, osb);
+	status = ocfs2_cluster_lock(osb, lockres, LKM_EXMODE,
+				    DLM_LKF_NOQUEUE, 0);
+	if (status < 0) {
+		if (status != -EAGAIN)
+			mlog_errno(status);
+		ocfs2_simple_drop_lockres(osb, lockres);
+		ocfs2_lock_res_free(lockres);
+	}
+
+	return status;
+}
+
+void ocfs2_trim_fs_unlock(struct ocfs2_super *osb)
+{
+	struct ocfs2_lock_res *lockres = &osb->osb_trim_fs_lockres;
+
+	if (!ocfs2_mount_local(osb)) {
+		ocfs2_cluster_unlock(osb, lockres, LKM_EXMODE);
+		ocfs2_simple_drop_lockres(osb, lockres);
+		ocfs2_lock_res_free(lockres);
+	}
+}
+
 int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 {
 	int ret;
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index a7fc18b..361e8a5 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -153,6 +153,8 @@ void ocfs2_super_unlock(struct ocfs2_super *osb,
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
 int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
 void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex);
+int ocfs2_trim_fs_lock(struct ocfs2_super *osb);
+void ocfs2_trim_fs_unlock(struct ocfs2_super *osb);
 int ocfs2_dentry_lock(struct dentry *dentry, int ex);
 void ocfs2_dentry_unlock(struct dentry *dentry, int ex);
 int ocfs2_file_lock(struct file *file, int ex, int trylock);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 9a50f22..6867eef 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -404,6 +404,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_super_lockres;
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct ocfs2_lock_res osb_nfs_sync_lockres;
+	struct ocfs2_lock_res osb_trim_fs_lockres;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index d277aab..7051b99 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -50,6 +50,7 @@ enum ocfs2_lock_type {
 	OCFS2_LOCK_TYPE_NFS_SYNC,
 	OCFS2_LOCK_TYPE_ORPHAN_SCAN,
 	OCFS2_LOCK_TYPE_REFCOUNT,
+	OCFS2_LOCK_TYPE_TRIM_FS,
 	OCFS2_NUM_LOCK_TYPES
 };
 
@@ -93,6 +94,9 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 		case OCFS2_LOCK_TYPE_REFCOUNT:
 			c = 'T';
 			break;
+		case OCFS2_LOCK_TYPE_TRIM_FS:
+			c = 'I';
+			break;
 		default:
 			c = '\0';
 	}
@@ -115,6 +119,7 @@ static inline char ocfs2_lock_type_char(enum ocfs2_lock_type type)
 	[OCFS2_LOCK_TYPE_NFS_SYNC] = "NFSSync",
 	[OCFS2_LOCK_TYPE_ORPHAN_SCAN] = "OrphanScan",
 	[OCFS2_LOCK_TYPE_REFCOUNT] = "Refcount",
+	[OCFS2_LOCK_TYPE_TRIM_FS] = "TrimFs",
 };
 
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
-- 
1.8.5.6
