From: Christoph Hellwig <hch@lst.de>
Date: Thu Jun  3 06:01:43 2004
Subject: [Ocfs2-devel] [PATCH] fix #warning in ocfs_inc_icount in f-c branch
Message-ID: <20040603110140.GD13534@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I think you actually want to use igrab here, but..


Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 994)
+++ src/inc/ocfs.h	(working copy)
@@ -1797,30 +1797,14 @@
 
 static inline int ocfs_inc_icount(struct inode *inode)
 {
-	struct dentry *dentry = NULL;
-	struct list_head *iter;
-
 	if (atomic_read(&inode->i_count) >= 1 &&
 	    !(inode->i_state & I_CLEAR)) {
 		atomic_inc(&inode->i_count);
 		return 0;
 	}
 
-	list_for_each (iter, &(inode->i_dentry)) {
-		dentry = list_entry (iter, struct dentry, d_alias);
-#warning This cant be right in the land of hardlinks, can it?
-		// what the heck, take the first one ;-)
-		break;
-	}
-
-	if (dentry)
-		LOG_ERROR_ARGS("eek! i_count=%d, i_state=%lu, i_ino=%lu, name='%*s'\n",
-			       atomic_read(&inode->i_count), inode->i_state, inode->i_ino,
-			       dentry->d_name.len, dentry->d_name.name);
-	else
-		LOG_ERROR_ARGS("eek! i_count=%d, i_state=%lu, i_ino=%lu, no dentry\n",
-			       atomic_read(&inode->i_count), inode->i_state, inode->i_ino);
-
+	LOG_ERROR_ARGS("eek! i_count=%d, i_state=%lu, i_ino=%lu, no dentry\n",
+		       atomic_read(&inode->i_count), inode->i_state, inode->i_ino);
 	LOG_ERROR_ARGS("feoff=%llu, deleted=%u\n", 
 		       GET_INODE_FEOFF(inode),
 		       INODE_DELETED(inode));
