From: tao.ma at oracle.com <tao.ma@oracle.com>
Date: Wed, 30 Apr 2008 15:34:58 +0800
Subject: [Ocfs2-devel] [patch 1/2] ocfs2-1.2: Remove inode_alloc from handle
	when inode	allocation fails.
References: <20080430065128.592723569@oracle.com>
Message-ID: <20080430073458.GA11325@dhcp-beijing-cdc-10-182-121-54.cn.oracle
	.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we fail to alloc an inode from the inode_alloc:000X, we need to
remove that allocation inode from current transaction. Otherwise
we may encounter dead lock when other nodes want to steal inode
from us.

Index: ocfs2-1.2/fs/ocfs2/journal.c
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/journal.c	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/journal.c	2008-04-30 14:09:54.000000000 +0800
@@ -228,6 +228,53 @@ void ocfs2_handle_add_inode(struct ocfs2
 	list_add_tail(&(OCFS2_I(inode)->ip_handle_list), &(handle->inode_list));
 }
 
+/*
+ * This method is a bit tricky and break up the policy of normal inode
+ * operation in a journal transaction. It will remove the alloc inode
+ * and free its lock from the transaction.
+ * So it should only be used in inode stealing.
+ *
+ * The 1st part is copied from ocfs2_handle_unlock_inodes.
+ * The 2nd part is copied from ocfs2_handle_cleanup_locks.
+ */
+void  ocfs2_handle_remove_alloc_inode(struct ocfs2_journal_handle *handle,
+				      struct inode *inode)
+{
+	struct list_head *p, *n;
+	struct ocfs2_journal_lock *lock;
+
+	BUG_ON(!handle);
+	BUG_ON(!inode);
+	BUG_ON(!OCFS2_I(inode)->ip_handle);
+	BUG_ON(list_empty(&OCFS2_I(inode)->ip_handle_list));
+
+	OCFS2_I(inode)->ip_handle = NULL;
+	list_del_init(&OCFS2_I(inode)->ip_handle_list);
+
+	mutex_unlock(&inode->i_mutex);
+	iput(inode);
+
+	list_for_each_safe(p, n, &(handle->locks)) {
+		lock = list_entry(p, struct ocfs2_journal_lock,
+				  jl_lock_list);
+
+		if (inode == lock->jl_inode) {
+			list_del(&lock->jl_lock_list);
+			handle->num_locks--;
+
+			ocfs2_meta_unlock(inode, 1);
+			if (atomic_read(&inode->i_count) == 1)
+				mlog(ML_ERROR,
+				     "Inode %"MLFu64", "
+				     "I'm doing a last iput for!",
+				     OCFS2_I(inode)->ip_blkno);
+			iput(inode);
+			kmem_cache_free(ocfs2_lock_cache, lock);
+			break;
+		}
+	}
+}
+
 static void ocfs2_handle_unlock_inodes(struct ocfs2_journal_handle *handle)
 {
 	struct list_head *p, *n;
Index: ocfs2-1.2/fs/ocfs2/journal.h
===================================================================
--- ocfs2-1.2.orig/fs/ocfs2/journal.h	2008-04-30 13:59:12.000000000 +0800
+++ ocfs2-1.2/fs/ocfs2/journal.h	2008-04-30 14:05:43.000000000 +0800
@@ -256,6 +256,9 @@ static inline void ocfs2_checkpoint_inod
  *                          to be released at the end of that handle. Locks
  *                          will be released in the order that they are added.
  *  ocfs2_handle_add_inode - Add a locked inode to a transaction.
+ *
+ *  ocfs2_handle_remove_alloc_inode - Remove a locked alloc inode from a
+ *                        transaction. It should only be used in inode stealing.
  */
 
 /* You must always start_trans with a number of buffs > 0, but it's
@@ -318,6 +321,8 @@ int                  ocfs2_handle_add_lo
 void                 ocfs2_handle_add_inode(struct ocfs2_journal_handle *handle,
 					    struct inode *inode);
 
+void ocfs2_handle_remove_alloc_inode(struct ocfs2_journal_handle *handle,
+				     struct inode *inode);
 /*
  *  Credit Macros:
  *  Convenience macros to calculate number of credits needed.

-- 
