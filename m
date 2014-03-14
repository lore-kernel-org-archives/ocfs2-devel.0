From: jiangyiwen <jiangyiwen@huawei.com>
Date: Fri, 14 Mar 2014 09:55:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid system inode ref in confusion by
	add mutex lock
Message-ID: <53226198.2000902@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following case may lead to the same system inode ref in confusion.

A thread                            B thread
ocfs2_get_system_file_inode
->get_local_system_inode
->_ocfs2_get_system_file_inode
                                    because of *arr == NULL,
                                    ocfs2_get_system_file_inode
                                    ->get_local_system_inode
                                    ->_ocfs2_get_system_file_inode
gets first ref thru
_ocfs2_get_system_file_inode,
gets second ref thru igrab and
set *arr = inode
                                    at the moment, B thread also gets
                                    two refs, so lead to one more
                                    inode ref.

So add mutex lock to avoid multi thread set two inode ref once at
the same time.

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
---
 fs/ocfs2/ocfs2.h   | 2 ++
 fs/ocfs2/super.c   | 2 ++
 fs/ocfs2/sysfile.c | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 553f53c..975a70c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -449,6 +449,8 @@ struct ocfs2_super
 	/* rb tree root for refcount lock. */
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
+
+	struct mutex system_file_mutex;
 };

 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 49d84f8..eb855a7 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2123,6 +2123,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);

+	mutex_init(&osb->system_file_mutex);
+
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index f053688..af155c1 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -113,9 +113,11 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	} else
 		arr = get_local_system_inode(osb, type, slot);

+	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
+		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);

 		return inode;
@@ -129,6 +131,7 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 		*arr = igrab(inode);
 		BUG_ON(!*arr);
 	}
+	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }

-- 
1.8.4.3
