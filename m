From: Christoph Hellwig <hch@lst.de>
Date: Mon Jul  5 15:23:17 2004
Subject: [Ocfs2-devel] [PATCH] kill allchild iterators
Message-ID: <20040705202313.GA5562@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

iterating over all childs is really a rather bad idea in a unix fs, so
let's kill the if 0'ed code and all the child iteration code behind it
that's now unused.


Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 1238)
+++ src/dcache.c	(working copy)
@@ -112,37 +112,3 @@
 	.d_revalidate		= ocfs_dentry_revalidate24,
 };
 #endif
-
-/*
- * ocfs_foreach_child()
- *
- */
-int ocfs_foreach_child (struct dentry *dentry, int (*func)(struct dentry *, void *), void *data)
-{
-	struct list_head *list;
-	int ret, done;
-
-	LOG_ENTRY_ARGS ("(0x%p, '%*s')\n", dentry,
-			dentry->d_name.len, dentry->d_name.name);
-
-	spin_lock (&dcache_lock);
-	list = dentry->d_subdirs.next;
-
-	ret = 1;
-	while (list != &dentry->d_subdirs) {
-		struct dentry *de = list_entry (list, struct dentry, d_child);
-
-		if (de->d_inode && !d_unhashed (de)) {
-			done = func(de, data);
-			if (done) {
-				ret = 0;
-				break;
-			}
-		}
-		list = list->next;
-	}
-	spin_unlock (&dcache_lock);
-
-	LOG_EXIT_INT (ret);
-	return ret;
-}
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1238)
+++ src/dlm.c	(working copy)
@@ -62,7 +62,6 @@
 static int ocfs_reset_voting (ocfs_super * osb);
 static int ocfs_get_vote_on_disk (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, ocfs_node_map * got_vote_map, ocfs_node_map * vote_map, __u64 lock_seq_num, ocfs_node_map * oin_open_map);
 int ocfs_disk_release_lock (ocfs_super * osb, __u64 lock_id, __u32 lock_type, __u32 flags, struct buffer_head *bh, struct inode *inode);
-static int ocfs_zap_child_buffers_func(struct dentry *dentry, void *data);
 
 
 void ocfs_set_publish_vote_map(ocfs_super *osb, ocfs_publish *publish, ocfs_node_map *vote_map)
@@ -1268,32 +1267,10 @@
 }				/* ocfs_release_lock */
 
 
-/* inode is definitely non NULL */
-static int ocfs_zap_child_buffers_func(struct dentry *dentry, void *data)
-{
-	struct inode *inode = dentry->d_inode;
-	ocfs_super *osb = data;
-
-	ocfs_inc_inode_seq(osb, inode, 0);
-	return 0;
-}
-
 int ocfs_break_cache_lock_zap_buffers(ocfs_super * osb, struct inode * inode)
 {
-	struct list_head *iter;
-	struct dentry *dentry;
-
-	if (inode==NULL) 
-		return 0;
-
-#warning invalidating child inodes is probably inappropriate now
-#if 0
-	list_for_each(iter, &(inode->i_dentry)) {
-		dentry = list_entry (iter, struct dentry, d_alias);
-		ocfs_foreach_child (dentry, ocfs_zap_child_buffers_func, osb);
-	}
-#endif
-	ocfs_inc_inode_seq(osb, inode, 0);
+	if (inode) 
+		ocfs_inc_inode_seq(osb, inode, 0);
 	return 0;
 }
 
Index: src/dcache.h
===================================================================
--- src/dcache.h	(revision 1238)
+++ src/dcache.h	(working copy)
@@ -31,8 +31,4 @@
 
 extern struct dentry_operations ocfs_dentry_ops;
 
-int ocfs_foreach_child(struct dentry *dentry,
-		       int (*func)(struct dentry *, void *),
-		       void *data);
-
 #endif /* OCFS2_DCACHE_H */
