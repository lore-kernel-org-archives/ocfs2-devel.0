From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:51 -0800
Subject: [Ocfs2-devel] [PATCH 04/40] ocfs2: move ip_last_trans to struct
	ocfs2_caching_info
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have the read side of metadata caching isolated to struct
ocfs2_caching_info, now we need the write side.  This means the journal
functions.  The journal only does a couple of things with struct inode.

This change moves the ip_last_trans field onto struct
ocfs2_caching_info as ci_last_trans.  This field tells the journal
whether a pending journal flush is required.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/inode.c    |   10 +++++-----
 fs/ocfs2/inode.h    |    2 --
 fs/ocfs2/journal.h  |    5 +++--
 fs/ocfs2/ocfs2.h    |    4 ++++
 fs/ocfs2/super.c    |    1 -
 fs/ocfs2/uptodate.c |   22 +++++++++++++++++++---
 fs/ocfs2/uptodate.h |    1 +
 7 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fc55fcf..9cefa54 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1063,13 +1063,14 @@ void ocfs2_clear_inode(struct inode *inode)
 	ocfs2_lock_res_free(&oi->ip_inode_lockres);
 	ocfs2_lock_res_free(&oi->ip_open_lockres);
 
-	ocfs2_metadata_cache_purge(INODE_CACHE(inode));
+	ocfs2_metadata_cache_exit(INODE_CACHE(inode));
 
-	mlog_bug_on_msg(oi->ip_metadata_cache.ci_num_cached,
+	mlog_bug_on_msg(INODE_CACHE(inode)->ci_num_cached,
 			"Clear inode of %llu, inode has %u cache items\n",
-			(unsigned long long)oi->ip_blkno, oi->ip_metadata_cache.ci_num_cached);
+			(unsigned long long)oi->ip_blkno,
+			INODE_CACHE(inode)->ci_num_cached);
 
-	mlog_bug_on_msg(!(oi->ip_metadata_cache.ci_flags &
+	mlog_bug_on_msg(!(INODE_CACHE(inode)->ci_flags &
 			  OCFS2_CACHE_FL_INLINE),
 			"Clear inode of %llu, inode has a bad flag\n",
 			(unsigned long long)oi->ip_blkno);
@@ -1099,7 +1100,6 @@ void ocfs2_clear_inode(struct inode *inode)
 	/* Clear all other flags. */
 	oi->ip_flags = 0;
 	oi->ip_created_trans = 0;
-	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 	oi->ip_blkno = 0ULL;
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 5731e42..7467f1d 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -63,8 +63,6 @@ struct ocfs2_inode_info
 	/* next two are protected by trans_inc_lock */
 	/* which transaction were we created on? Zero if none. */
 	unsigned long			ip_created_trans;
-	/* last transaction we were a part of. */
-	unsigned long			ip_last_trans;
 
 	struct ocfs2_caching_info	ip_metadata_cache;
 
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 3c3532e..ef75dbb 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -83,7 +83,7 @@ static inline void ocfs2_set_inode_lock_trans(struct ocfs2_journal *journal,
 					      struct inode *inode)
 {
 	spin_lock(&trans_inc_lock);
-	OCFS2_I(inode)->ip_last_trans = journal->j_trans_id;
+	INODE_CACHE(inode)->ci_last_trans = journal->j_trans_id;
 	spin_unlock(&trans_inc_lock);
 }
 
@@ -98,7 +98,8 @@ static inline int ocfs2_inode_fully_checkpointed(struct inode *inode)
 	struct ocfs2_journal *journal = OCFS2_SB(inode->i_sb)->journal;
 
 	spin_lock(&trans_inc_lock);
-	ret = time_after(journal->j_trans_id, OCFS2_I(inode)->ip_last_trans);
+	ret = time_after(journal->j_trans_id,
+			 INODE_CACHE(inode)->ci_last_trans);
 	spin_unlock(&trans_inc_lock);
 	return ret;
 }
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 166b8be..04cd9ef 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -73,6 +73,10 @@ struct ocfs2_caching_info {
 	 */
 	const struct ocfs2_caching_operations *ci_ops;
 
+	/* last transaction we were a part of. */
+	unsigned long		ci_last_trans;
+
+	/* Cache structures */
 	unsigned int		ci_flags;
 	unsigned int		ci_num_cached;
 	union {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4c6f511..b0532d2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1449,7 +1449,6 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_extent_map_init(&oi->vfs_inode);
 	INIT_LIST_HEAD(&oi->ip_io_markers);
 	oi->ip_created_trans = 0;
-	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 
 	init_rwsem(&oi->ip_alloc_sem);
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 1c829e4..81c8220 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -118,16 +118,32 @@ void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci)
 }
 
 
+static void ocfs2_metadata_cache_reset(struct ocfs2_caching_info *ci,
+				       int clear)
+{
+	ci->ci_flags |= OCFS2_CACHE_FL_INLINE;
+	ci->ci_num_cached = 0;
+
+	if (clear)
+		ci->ci_last_trans = 0;
+}
+
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
 			       const struct ocfs2_caching_operations *ops)
 {
 	BUG_ON(!ops);
 
 	ci->ci_ops = ops;
-	ci->ci_flags |= OCFS2_CACHE_FL_INLINE;
-	ci->ci_num_cached = 0;
+	ocfs2_metadata_cache_reset(ci, 1);
+}
+
+void ocfs2_metadata_cache_exit(struct ocfs2_caching_info *ci)
+{
+	ocfs2_metadata_cache_purge(ci);
+	ocfs2_metadata_cache_reset(ci, 1);
 }
 
+
 /* No lock taken here as 'root' is not expected to be visible to other
  * processes. */
 static unsigned int ocfs2_purge_copied_metadata_tree(struct rb_root *root)
@@ -177,7 +193,7 @@ void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci)
 	if (tree)
 		root = ci->ci_cache.ci_tree;
 
-	ocfs2_metadata_cache_init(ci, ci->ci_ops);
+	ocfs2_metadata_cache_reset(ci, 0);
 	ocfs2_metadata_cache_unlock(ci);
 
 	purged = ocfs2_purge_copied_metadata_tree(&root);
diff --git a/fs/ocfs2/uptodate.h b/fs/ocfs2/uptodate.h
index f268273..80dbb1d 100644
--- a/fs/ocfs2/uptodate.h
+++ b/fs/ocfs2/uptodate.h
@@ -61,6 +61,7 @@ void exit_ocfs2_uptodate_cache(void);
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
 			       const struct ocfs2_caching_operations *ops);
 void ocfs2_metadata_cache_purge(struct ocfs2_caching_info *ci);
+void ocfs2_metadata_cache_exit(struct ocfs2_caching_info *ci);
 
 u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci);
 struct super_block *ocfs2_metadata_cache_get_super(struct ocfs2_caching_info *ci);
-- 
1.5.6.5
