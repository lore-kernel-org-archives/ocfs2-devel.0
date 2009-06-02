From: Jan Kara <jack@suse.cz>
Date: Tue,  2 Jun 2009 14:24:05 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add lockdep annotations
In-Reply-To: <1243945445-25847-1-git-send-email-jack@suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
Message-ID: <1243945445-25847-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add lockdep support to OCFS2. The support also covers all of the cluster
locks except for open locks, journal locks, and local quotafile locks. These
are special because they are acquired for a node, not for a particular process
and lockdep cannot deal with such type of locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c |   99 ++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/dlmglue.h |   12 +++++--
 fs/ocfs2/inode.c   |   11 ++++++
 fs/ocfs2/inode.h   |    8 ++++
 fs/ocfs2/namei.c   |   15 +++++---
 fs/ocfs2/ocfs2.h   |    4 ++
 fs/ocfs2/sysfile.c |   17 +++++++++
 7 files changed, 142 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e15fc7d..5cf731f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -92,6 +92,9 @@ struct ocfs2_unblock_ctl {
 	enum ocfs2_unblock_action unblock_action;
 };
 
+/* Lockdep class keys */
+struct lock_class_key lockdep_keys[OCFS2_NUM_LOCK_TYPES];
+
 static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
 					int new_level);
 static void ocfs2_set_meta_lvb(struct ocfs2_lock_res *lockres);
@@ -313,9 +316,16 @@ static int ocfs2_lock_create(struct ocfs2_super *osb,
 			     u32 dlm_flags);
 static inline int ocfs2_may_continue_on_blocked_lock(struct ocfs2_lock_res *lockres,
 						     int wanted);
-static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
-				 struct ocfs2_lock_res *lockres,
-				 int level);
+static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
+				   struct ocfs2_lock_res *lockres,
+				   int level, unsigned long ip);
+static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
+					struct ocfs2_lock_res *lockres,
+					int level)
+{
+	__ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
+}
+
 static inline void ocfs2_generic_handle_downconvert_action(struct ocfs2_lock_res *lockres);
 static inline void ocfs2_generic_handle_convert_action(struct ocfs2_lock_res *lockres);
 static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *lockres);
@@ -485,6 +495,13 @@ static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 	ocfs2_add_lockres_tracking(res, osb->osb_dlm_debug);
 
 	ocfs2_init_lock_stats(res);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (type != OCFS2_LOCK_TYPE_OPEN)
+		lockdep_init_map(&res->l_lockdep_map, ocfs2_lock_type_strings[type],
+				 &lockdep_keys[type], 0);
+	else
+		res->l_lockdep_map.key = NULL;
+#endif
 }
 
 void ocfs2_lock_res_init_once(struct ocfs2_lock_res *res)
@@ -1239,11 +1256,21 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
 	return ret;
 }
 
-static int ocfs2_cluster_lock(struct ocfs2_super *osb,
-			      struct ocfs2_lock_res *lockres,
-			      int level,
-			      u32 lkm_flags,
-			      int arg_flags)
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres,
+				int level,
+				u32 lkm_flags,
+				int arg_flags,
+				int l_subclass,
+				unsigned long ip)
+#else
+static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres,
+				int level,
+				u32 lkm_flags,
+				int arg_flags)
+#endif
 {
 	struct ocfs2_mask_waiter mw;
 	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
@@ -1386,13 +1413,45 @@ out:
 	}
 	ocfs2_update_lock_stats(lockres, level, &mw, ret);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (!ret && lockres->l_lockdep_map.key != NULL) {
+		if (level == DLM_LOCK_PR)
+			rwsem_acquire_read(&lockres->l_lockdep_map, l_subclass,
+				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
+		else
+			rwsem_acquire(&lockres->l_lockdep_map, l_subclass,
+				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
+	}
+#endif
 	mlog_exit(ret);
 	return ret;
 }
 
-static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
-				 struct ocfs2_lock_res *lockres,
-				 int level)
+static inline int ocfs2_cluster_lock(struct ocfs2_super *osb,
+				     struct ocfs2_lock_res *lockres,
+				     int level,
+				     u32 lkm_flags,
+				     int arg_flags)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags, arg_flags,
+				    0, _RET_IP_);
+#else
+	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags, arg_flags);
+#endif
+}
+
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
+				   struct ocfs2_lock_res *lockres,
+				   int level,
+				   unsigned long ip)
+#else
+static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
+				   struct ocfs2_lock_res *lockres,
+				   int level)
+#endif
 {
 	unsigned long flags;
 
@@ -1401,6 +1460,10 @@ static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
 	ocfs2_dec_holders(lockres, level);
 	ocfs2_downconvert_on_unlock(osb, lockres);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (lockres->l_lockdep_map.key != NULL)
+		rwsem_release(&lockres->l_lockdep_map, 1, ip);
+#endif
 	mlog_exit_void();
 }
 
@@ -2145,10 +2208,11 @@ static int ocfs2_assign_bh(struct inode *inode,
  * returns < 0 error if the callback will never be called, otherwise
  * the result of the lock will be communicated via the callback.
  */
-int ocfs2_inode_lock_full(struct inode *inode,
-			 struct buffer_head **ret_bh,
-			 int ex,
-			 int arg_flags)
+int ocfs2_inode_lock_full_nested(struct inode *inode,
+				 struct buffer_head **ret_bh,
+				 int ex,
+				 int arg_flags,
+				 int subclass)
 {
 	int status, level, acquired;
 	u32 dlm_flags;
@@ -2186,7 +2250,12 @@ int ocfs2_inode_lock_full(struct inode *inode,
 	if (arg_flags & OCFS2_META_LOCK_NOQUEUE)
 		dlm_flags |= DLM_LKF_NOQUEUE;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	status = __ocfs2_cluster_lock(osb, lockres, level, dlm_flags,
+				      arg_flags, subclass, _RET_IP_);
+#else
 	status = ocfs2_cluster_lock(osb, lockres, level, dlm_flags, arg_flags);
+#endif
 	if (status < 0) {
 		if (status != -EAGAIN && status != -EIOCBRETRY)
 			mlog_errno(status);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e1fd572..9bb9eb5 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -96,17 +96,23 @@ void ocfs2_open_unlock(struct inode *inode);
 int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
 			  int *level);
-int ocfs2_inode_lock_full(struct inode *inode,
+int ocfs2_inode_lock_full_nested(struct inode *inode,
 			 struct buffer_head **ret_bh,
 			 int ex,
-			 int arg_flags);
+			 int arg_flags,
+			 int subclass);
 int ocfs2_inode_lock_with_page(struct inode *inode,
 			      struct buffer_head **ret_bh,
 			      int ex,
 			      struct page *page);
+/* Variants without special locking class or flags */
+#define ocfs2_inode_lock_full(i, r, e, f)\
+		ocfs2_inode_lock_full_nested(i, r, e, f, 0)
+#define ocfs2_inode_lock_nested(i, b, e, s)\
+		ocfs2_inode_lock_full_nested(i, b, e, 0, s)
 /* 99% of the time we don't want to supply any additional flags --
  * those are for very specific cases only. */
-#define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full(i, b, e, 0)
+#define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0, 0)
 void ocfs2_inode_unlock(struct inode *inode,
 		       int ex);
 int ocfs2_super_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 10e1fa8..4dc8890 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -215,6 +215,8 @@ bail:
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 {
 	struct ocfs2_find_inode_args *args = opaque;
+	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
+				     ocfs2_file_ip_alloc_sem_key;
 
 	mlog_entry("inode = %p, opaque = %p\n", inode, opaque);
 
@@ -223,6 +225,15 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 	if (args->fi_sysfile_type != 0)
 		lockdep_set_class(&inode->i_mutex,
 			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
+	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
+	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
+	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
+	    args->fi_sysfile_type == LOCAL_GROUP_QUOTA_SYSTEM_INODE)
+		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
+				  &ocfs2_quota_ip_alloc_sem_key);
+	else
+		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
+				  &ocfs2_file_ip_alloc_sem_key);
 
 	mlog_exit(0);
 	return 0;
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ea71525..7096516 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -109,6 +109,14 @@ struct ocfs2_inode_info
 /* Indicates that the metadata cache should be used as an array. */
 #define OCFS2_INODE_CACHE_INLINE	0x00000080
 
+/* Locking subclasses of inode cluster lock */
+enum {
+	OI_LS_NORMAL,
+	OI_LS_PARENT,
+	OI_LS_RENAME1,
+	OI_LS_RENAME2,
+};
+
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
 	return container_of(inode, struct ocfs2_inode_info, vfs_inode);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 33464c6..8601f93 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -118,7 +118,7 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	mlog(0, "find name %.*s in directory %llu\n", dentry->d_name.len,
 	     dentry->d_name.name, (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	status = ocfs2_inode_lock(dir, NULL, 0);
+	status = ocfs2_inode_lock_nested(dir, NULL, 0, OI_LS_PARENT);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -636,7 +636,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
-	err = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
+	err = ocfs2_inode_lock_nested(dir, &parent_fe_bh, 1, OI_LS_PARENT);
 	if (err < 0) {
 		if (err != -ENOENT)
 			mlog_errno(err);
@@ -800,7 +800,8 @@ static int ocfs2_unlink(struct inode *dir,
 		return -EPERM;
 	}
 
-	status = ocfs2_inode_lock(dir, &parent_node_bh, 1);
+	status = ocfs2_inode_lock_nested(dir, &parent_node_bh, 1,
+					 OI_LS_PARENT);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -978,7 +979,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 			inode1 = tmpinode;
 		}
 		/* lock id2 */
-		status = ocfs2_inode_lock(inode2, bh2, 1);
+		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
+						 OI_LS_RENAME1);
 		if (status < 0) {
 			if (status != -ENOENT)
 				mlog_errno(status);
@@ -987,7 +989,7 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	}
 
 	/* lock id1 */
-	status = ocfs2_inode_lock(inode1, bh1, 1);
+	status = ocfs2_inode_lock_nested(inode1, bh1, 1, OI_LS_RENAME2);
 	if (status < 0) {
 		/*
 		 * An error return must mean that no cluster locks
@@ -1103,7 +1105,8 @@ static int ocfs2_rename(struct inode *old_dir,
 	 * won't have to concurrently downconvert the inode and the
 	 * dentry locks.
 	 */
-	status = ocfs2_inode_lock(old_inode, &old_inode_bh, 1);
+	status = ocfs2_inode_lock_nested(old_inode, &old_inode_bh, 1,
+					 OI_LS_PARENT);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1386281..99e89ba 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -34,6 +34,7 @@
 #include <linux/workqueue.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
+#include <linux/lockdep.h>
 #ifndef CONFIG_OCFS2_COMPAT_JBD
 # include <linux/jbd2.h>
 #else
@@ -149,6 +150,9 @@ struct ocfs2_lock_res {
 	unsigned int		 l_lock_max_exmode; 	   /* Max wait for EX */
 	unsigned int		 l_lock_refresh;	   /* Disk refreshes */
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	 l_lockdep_map;
+#endif
 };
 
 struct ocfs2_dlm_debug {
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index ab713eb..6f53f5e 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -50,6 +50,8 @@ static inline int is_in_system_inode_array(struct ocfs2_super *osb,
 					   int type,
 					   u32 slot);
 
+static struct lock_class_key ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES];
+
 static inline int is_global_system_inode(int type)
 {
 	return type >= OCFS2_FIRST_ONLINE_SYSTEM_INODE &&
@@ -118,6 +120,21 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 		inode = NULL;
 		goto bail;
 	}
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	if (type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
+	    type == LOCAL_GROUP_QUOTA_SYSTEM_INODE ||
+	    type == JOURNAL_SYSTEM_INODE) {
+		/* Ignore inode lock on these inodes as the lock does not
+		 * really belong to any process and lockdep cannot handle
+		 * that */
+		OCFS2_I(inode)->ip_inode_lockres.l_lockdep_map.key = NULL;
+	} else {
+		lockdep_init_map(&OCFS2_I(inode)->ip_inode_lockres.
+								l_lockdep_map,
+				 ocfs2_system_inodes[type].si_name,
+				 &ocfs2_sysfile_cluster_lock_key[type], 0);
+	}
+#endif
 bail:
 
 	return inode;
-- 
1.6.0.2
