From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Aug 2010 16:58:21 +0800
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: Cache system inodes of other slots.
Message-ID: <1281949101-4801-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Durring orphan scan, if we are slot 0, and we are replaying
orphan_dir:0001, the general process is that for every file
in this dir:
1. we will iget orphan_dir:0001, since there is no inode for it.
   we will have to create an inode and read it from the disk.
2. do the normal work, such as delete_inode and remove it from
   the dir if it is allowed.
3. call iput orphan_dir:0001 when we are done. In this case,
   since we have no dcache for this inode, i_count will
   reach 0, and VFS will have to call clear_inode and in
   ocfs2_clear_inode we will checkpoint the inode which will let
   ocfs2_cmt and journald begin to work.
4. We loop back to 1 for the next file.

So you see, actually for every deleted file, we have to read the
orphan dir from the disk and checkpoint the journal. It is very
time consuming and cause a lot of journal checkpoint I/O.
A better solution is that we can have another reference for these
inodes in ocfs2_super. So if there is no other race among
nodes(which will let dlmglue to checkpoint the inode), for step 3,
clear_inode won't be called and for step 1, we may only need to
read the inode for the 1st time. This is a big win for us.

So this patch will try to cache system inodes of other slots so
that we will have one more reference for these inodes and avoid
the extra inode read and journal checkpoint.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    3 +-
 fs/ocfs2/ocfs2_fs.h |    5 ++++
 fs/ocfs2/super.c    |   20 ++++++++++++++--
 fs/ocfs2/sysfile.c  |   60 +++++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..70354a5 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,8 @@ struct ocfs2_super
 	struct super_block *sb;
 	struct inode *root_inode;
 	struct inode *sys_root_inode;
-	struct inode *system_inodes[NUM_SYSTEM_INODES];
+	struct inode *global_system_inodes[NUM_GLOBAL_SYSTEM_INODES];
+	struct inode **local_system_inodes;
 
 	struct ocfs2_slot_info *slot_info;
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 33f1c9a..723b20d 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -309,6 +309,7 @@ enum {
 	USER_QUOTA_SYSTEM_INODE,
 	GROUP_QUOTA_SYSTEM_INODE,
 #define OCFS2_LAST_GLOBAL_SYSTEM_INODE GROUP_QUOTA_SYSTEM_INODE
+#define OCFS2_FIRST_LOCAL_SYSTEM_INODE ORPHAN_DIR_SYSTEM_INODE
 	ORPHAN_DIR_SYSTEM_INODE,
 	EXTENT_ALLOC_SYSTEM_INODE,
 	INODE_ALLOC_SYSTEM_INODE,
@@ -317,8 +318,12 @@ enum {
 	TRUNCATE_LOG_SYSTEM_INODE,
 	LOCAL_USER_QUOTA_SYSTEM_INODE,
 	LOCAL_GROUP_QUOTA_SYSTEM_INODE,
+#define OCFS2_LAST_LOCAL_SYSTEM_INODE LOCAL_GROUP_QUOTA_SYSTEM_INODE
 	NUM_SYSTEM_INODES
 };
+#define NUM_GLOBAL_SYSTEM_INODES OCFS2_LAST_GLOBAL_SYSTEM_INODE
+#define NUM_LOCAL_SYSTEM_INODES	\
+		(NUM_SYSTEM_INODES - OCFS2_FIRST_LOCAL_SYSTEM_INODE)
 
 static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 	/* Global system inodes (single copy) */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..caa7bef 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -514,11 +514,11 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	for (i = 0; i < NUM_SYSTEM_INODES; i++) {
-		inode = osb->system_inodes[i];
+	for (i = 0; i < NUM_GLOBAL_SYSTEM_INODES; i++) {
+		inode = osb->global_system_inodes[i];
 		if (inode) {
 			iput(inode);
-			osb->system_inodes[i] = NULL;
+			osb->global_system_inodes[i] = NULL;
 		}
 	}
 
@@ -534,6 +534,20 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 		osb->root_inode = NULL;
 	}
 
+	if (!osb->local_system_inodes)
+		goto out;
+
+	for (i = 0; i < NUM_LOCAL_SYSTEM_INODES * osb->max_slots; i++) {
+		if (osb->local_system_inodes[i]) {
+			iput(osb->local_system_inodes[i]);
+			osb->local_system_inodes[i] = NULL;
+		}
+	}
+
+	kfree(osb->local_system_inodes);
+	osb->local_system_inodes = NULL;
+
+out:
 	mlog_exit(0);
 }
 
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index bfe7190..902efb2 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -44,11 +44,6 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 						   int type,
 						   u32 slot);
 
-static inline int is_global_system_inode(int type);
-static inline int is_in_system_inode_array(struct ocfs2_super *osb,
-					   int type,
-					   u32 slot);
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES];
 #endif
@@ -59,11 +54,52 @@ static inline int is_global_system_inode(int type)
 		type <= OCFS2_LAST_GLOBAL_SYSTEM_INODE;
 }
 
-static inline int is_in_system_inode_array(struct ocfs2_super *osb,
-					   int type,
-					   u32 slot)
+static struct inode **get_local_system_inode(struct ocfs2_super *osb,
+					     int type,
+					     u32 slot)
 {
-	return slot == osb->slot_num || is_global_system_inode(type);
+	int index;
+	struct inode **local_system_inodes, **free = NULL;
+
+	BUG_ON(slot == OCFS2_INVALID_SLOT);
+	BUG_ON(type < OCFS2_FIRST_LOCAL_SYSTEM_INODE ||
+	       type > OCFS2_LAST_LOCAL_SYSTEM_INODE);
+
+	spin_lock(&osb->osb_lock);
+	local_system_inodes = osb->local_system_inodes;
+	spin_unlock(&osb->osb_lock);
+
+	if (unlikely(!local_system_inodes)) {
+		local_system_inodes = kzalloc(sizeof(struct inode *) *
+					      NUM_LOCAL_SYSTEM_INODES *
+					      osb->max_slots,
+					      GFP_NOFS);
+		if (!local_system_inodes) {
+			mlog_errno(-ENOMEM);
+			/*
+			 * return NULL here so that ocfs2_get_sytem_file_inodes
+			 * will try to create an inode and use it. We will try
+			 * to initialize local_system_inodes next time.
+			 */
+			return NULL;
+		}
+
+		spin_lock(&osb->osb_lock);
+		if (osb->local_system_inodes) {
+			/* Someone has initialized it for us. */
+			free = local_system_inodes;
+			local_system_inodes = osb->local_system_inodes;
+		} else
+			osb->local_system_inodes = local_system_inodes;
+		spin_unlock(&osb->osb_lock);
+		if (unlikely(free))
+			kfree(free);
+	}
+
+	index = (slot * NUM_LOCAL_SYSTEM_INODES) +
+		(type - OCFS2_FIRST_LOCAL_SYSTEM_INODE);
+
+	return &local_system_inodes[index];
 }
 
 struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
@@ -74,8 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	struct inode **arr = NULL;
 
 	/* avoid the lookup if cached in local system file array */
-	if (is_in_system_inode_array(osb, type, slot))
-		arr = &(osb->system_inodes[type]);
+	if (is_global_system_inode(type)) {
+		arr = &(osb->global_system_inodes[type]);
+	} else
+		arr = get_local_system_inode(osb, type, slot);
 
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
-- 
1.7.1.GIT
