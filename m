From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 12 Aug 2010 17:03:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
Message-ID: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2, we now only cache the inodes for global system file
and the system inodes for our own slot. But we have some cases
that we may need to access system inodes of other nodes, such
as orphan scan, inode steal etc.
So consider the following cases, we are slot 0, and we are
replaying orphan_dir:0001.
So the general process is that for every file in this dir:
1. we will get orphan_dir:0001, since there is no inode for it.
   we will have to create an inode and read it from the disk.
2. do the normal work, such as delete_inode and remove it from
   the dir.
3. call iput when we have finish working on orphan_dir:0001. In
   this case, since we have no dcache for this inode, icount will
   reach 0, and VFS will have to call clear_inode and in
   ocfs2_clear_inode we will checkpoint the inode which will let
   ocfs2_cmt and journald begin to work.
4. We loop back to 1 for the next inode.

So you see, actually for every deleted file, we have to read the dir
from the disk and checkpoint the journal. It is very time consuming
and cause a lot of journal checkpoint I/O.
A better solution is that we can another refrence for these inodes
in ocfs2_super. So if there is no other race among nodes(which will
let dlmglue to checkpoint the inode), for step 3, clear_inode won't
be called and for step 1, we may only need to read the inode for the
1st time. This is a big win for us.

Currently, we only cached orphan_dir, extent_alloc and inode_alloc
since these 3 nodes in other slots have a chance to be used in our
own slot.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h   |    2 +
 fs/ocfs2/super.c   |    2 +
 fs/ocfs2/sysfile.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/sysfile.h |    1 +
 4 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..ec251ec 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -278,6 +278,8 @@ struct ocfs2_super
 	struct inode *root_inode;
 	struct inode *sys_root_inode;
 	struct inode *system_inodes[NUM_SYSTEM_INODES];
+	/* Some inodes of other nodes we want to store. */
+	struct inode **other_system_inodes;
 
 	struct ocfs2_slot_info *slot_info;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..697af86 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -535,6 +535,8 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 		osb->root_inode = NULL;
 	}
 
+	ocfs2_release_other_system_inodes(osb);
+
 	mlog_exit(0);
 }
 
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index bfe7190..4f5c0e9 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -66,6 +66,90 @@ static inline int is_in_system_inode_array(struct ocfs2_super *osb,
 	return slot == osb->slot_num || is_global_system_inode(type);
 }
 
+/*
+ * System inodes of other nodes we want to store in osb->other_system_inodes.
+ * Current we only support oprhan dir, extent alloc and inode alloc.
+ */
+enum {
+	ORPHAN_DIR,
+	EXTENT_ALLOC,
+	INODE_ALLOC,
+	NUM_OTHER_SYSTEM_INODES,
+};
+
+static inline int is_in_other_system_inode_array(struct ocfs2_super *osb,
+						 int type,
+						 u32 slot)
+{
+	if (slot == osb->slot_num)
+		return 0;
+
+	return type == ORPHAN_DIR_SYSTEM_INODE ||
+	       type == EXTENT_ALLOC_SYSTEM_INODE ||
+	       type == INODE_ALLOC_SYSTEM_INODE;
+}
+
+/*
+ * Currently we only support orphan dir, extent alloc and inode alloc.
+ * They are contiguous, so the mapping of (type, slot) to index is simple.
+ * We can change it later to some other mapping later if we want to
+ * store other system inodes.
+ */
+static inline int get_system_inode_index(struct ocfs2_super *osb,
+					 int type,
+					 u32 slot)
+{
+	int index = type - ORPHAN_DIR_SYSTEM_INODE;
+
+	if (slot < osb->slot_num)
+		return slot * NUM_OTHER_SYSTEM_INODES + index;
+	else
+		return (slot - 1) * NUM_OTHER_SYSTEM_INODES + index;
+}
+
+static struct inode **get_other_system_inode(struct ocfs2_super *osb,
+					     int type,
+					     u32 slot)
+{
+	BUG_ON(slot == osb->slot_num);
+
+	if (unlikely(!osb->other_system_inodes)) {
+		osb->other_system_inodes = kzalloc(sizeof(struct inode *) *
+						   NUM_OTHER_SYSTEM_INODES *
+						   (osb->max_slots - 1),
+						   GFP_NOFS);
+		if (!osb->other_system_inodes) {
+			mlog_errno(-ENOMEM);
+			/*
+			 * return NULL here so that ocfs2_get_sytem_file_inodes
+			 * will try to create an inode and use it. We will try
+			 * to initialize other_system_inodes next time.
+			 */
+			return NULL;
+		}
+	}
+
+	return &osb->other_system_inodes[get_system_inode_index(osb,
+								type, slot)];
+}
+
+void ocfs2_release_other_system_inodes(struct ocfs2_super *osb)
+{
+	int i;
+
+	if (!osb->other_system_inodes)
+		return;
+
+	for (i = 0; i < NUM_OTHER_SYSTEM_INODES * (osb->max_slots - 1); i++) {
+		if (osb->other_system_inodes[i]) {
+			iput(osb->other_system_inodes[i]);
+			osb->other_system_inodes[i] = NULL;
+		}
+	}
+
+	kfree(osb->other_system_inodes);
+}
+
 struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 					  int type,
 					  u32 slot)
@@ -76,6 +160,8 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	/* avoid the lookup if cached in local system file array */
 	if (is_in_system_inode_array(osb, type, slot))
 		arr = &(osb->system_inodes[type]);
+	else if (is_in_other_system_inode_array(osb, type, slot))
+		arr = get_other_system_inode(osb, type, slot);
 
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
diff --git a/fs/ocfs2/sysfile.h b/fs/ocfs2/sysfile.h
index cc9ea66..26cc4bc 100644
--- a/fs/ocfs2/sysfile.h
+++ b/fs/ocfs2/sysfile.h
@@ -29,5 +29,6 @@
 struct inode * ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 					   int type,
 					   u32 slot);
+void ocfs2_release_other_system_inodes(struct ocfs2_super *osb);
 
 #endif /* OCFS2_SYSFILE_H */
-- 
1.7.1.GIT
