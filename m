From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:49 -0800
Subject: [Ocfs2-devel] [PATCH 02/40] ocfs2: Change metadata caching locks to
	an operations structure.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We don't really want to cart around too many new fields on the
ocfs2_caching_info structure.  So let's wrap all our access of the
parent object in a set of operations.  One pointer on caching_info, and
more flexibility to boot.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/inode.c    |   49 +++++++++++++++++++
 fs/ocfs2/inode.h    |    1 +
 fs/ocfs2/ocfs2.h    |    8 ++--
 fs/ocfs2/super.c    |    4 +-
 fs/ocfs2/uptodate.c |  129 +++++++++++++++++++++++++++++++++-----------------
 fs/ocfs2/uptodate.h |   30 +++++++++++-
 6 files changed, 169 insertions(+), 52 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 5a89c3d..8e764b2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1346,3 +1346,52 @@ int ocfs2_read_inode_block(struct inode *inode, struct buffer_head **bh)
 {
 	return ocfs2_read_inode_block_full(inode, bh, 0);
 }
+
+static struct ocfs2_inode_info *cache_info_to_inode(struct ocfs2_caching_info *ci)
+{
+	return container_of(ci, struct ocfs2_inode_info, ip_metadata_cache);
+}
+
+static u64 ocfs2_inode_cache_owner(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	return oi->ip_blkno;
+}
+
+static void ocfs2_inode_cache_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	spin_lock(&oi->ip_lock);
+}
+
+static void ocfs2_inode_cache_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	spin_unlock(&oi->ip_lock);
+}
+
+static void ocfs2_inode_cache_io_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	mutex_lock(&oi->ip_io_mutex);
+}
+
+static void ocfs2_inode_cache_io_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_inode_info *oi = cache_info_to_inode(ci);
+
+	mutex_unlock(&oi->ip_io_mutex);
+}
+
+const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
+	.co_owner		= ocfs2_inode_cache_owner,
+	.co_cache_lock		= ocfs2_inode_cache_lock,
+	.co_cache_unlock	= ocfs2_inode_cache_unlock,
+	.co_io_lock		= ocfs2_inode_cache_io_lock,
+	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
+};
+
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 84191b1..6255a6c 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -114,6 +114,7 @@ static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 extern struct kmem_cache *ocfs2_inode_cache;
 
 extern const struct address_space_operations ocfs2_aops;
+extern const struct ocfs2_caching_operations ocfs2_inode_caching_ops;
 
 void ocfs2_clear_inode(struct inode *inode);
 void ocfs2_delete_inode(struct inode *inode);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b36d961..166b8be 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -64,14 +64,14 @@ enum ocfs2_caching_info_flags {
 	OCFS2_CACHE_FL_INLINE	= 1<<1,
 };
 
+struct ocfs2_caching_operations;
 struct ocfs2_caching_info {
 	/*
 	 * The parent structure provides the locks, but because the
-	 * parent structure can differ, struct ocfs2_caching_info needs
-	 * its own pointers to them.
+	 * parent structure can differ, it provides locking operations
+	 * to struct ocfs2_caching_info.
 	 */
-	spinlock_t		*ci_lock;
-	struct mutex		*ci_io_mutex;
+	const struct ocfs2_caching_operations *ci_ops;
 
 	unsigned int		ci_flags;
 	unsigned int		ci_num_cached;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b10e3ca..536994d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1463,8 +1463,8 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-	ocfs2_metadata_cache_init(&oi->ip_metadata_cache, &oi->ip_lock,
-				  &oi->ip_io_mutex);
+	ocfs2_metadata_cache_init(&oi->ip_metadata_cache,
+				  &ocfs2_inode_caching_ops);
 
 	inode_init_once(&oi->vfs_inode);
 }
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 8dbc457..226d042 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -75,12 +75,48 @@ struct ocfs2_meta_cache_item {
 
 static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
 
+static u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	return ci->ci_ops->co_owner(ci);
+}
+
+static void ocfs2_metadata_cache_lock(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	ci->ci_ops->co_cache_lock(ci);
+}
+
+static void ocfs2_metadata_cache_unlock(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	ci->ci_ops->co_cache_unlock(ci);
+}
+
+static void ocfs2_metadata_cache_io_lock(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	ci->ci_ops->co_io_lock(ci);
+}
+
+static void ocfs2_metadata_cache_io_unlock(struct ocfs2_caching_info *ci)
+{
+	BUG_ON(!ci || !ci->ci_ops);
+
+	ci->ci_ops->co_io_unlock(ci);
+}
+
+
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
-			       spinlock_t *cache_lock,
-			       struct mutex *io_mutex)
+			       const struct ocfs2_caching_operations *ops)
 {
-	ci->ci_lock = cache_lock;
-	ci->ci_io_mutex = io_mutex;
+	BUG_ON(!ops);
+
+	ci->ci_ops = ops;
 	ci->ci_flags |= OCFS2_CACHE_FL_INLINE;
 	ci->ci_num_cached = 0;
 }
@@ -120,12 +156,15 @@ void ocfs2_metadata_cache_purge(struct inode *inode)
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 	struct rb_root root = RB_ROOT;
 
-	spin_lock(ci->ci_lock);
+	BUG_ON(!ci || !ci->ci_ops);
+
+	ocfs2_metadata_cache_lock(ci);
 	tree = !(ci->ci_flags & OCFS2_CACHE_FL_INLINE);
 	to_purge = ci->ci_num_cached;
 
-	mlog(0, "Purge %u %s items from Inode %llu\n", to_purge,
-	     tree ? "array" : "tree", (unsigned long long)oi->ip_blkno);
+	mlog(0, "Purge %u %s items from Owner %llu\n", to_purge,
+	     tree ? "array" : "tree",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci));
 
 	/* If we're a tree, save off the root so that we can safely
 	 * initialize the cache. We do the work to free tree members
@@ -133,16 +172,17 @@ void ocfs2_metadata_cache_purge(struct inode *inode)
 	if (tree)
 		root = ci->ci_cache.ci_tree;
 
-	ocfs2_metadata_cache_init(ci, ci->ci_lock, ci->ci_io_mutex);
-	spin_unlock(ci->ci_lock);
+	ocfs2_metadata_cache_init(ci, ci->ci_ops);
+	ocfs2_metadata_cache_unlock(ci);
 
 	purged = ocfs2_purge_copied_metadata_tree(&root);
 	/* If possible, track the number wiped so that we can more
 	 * easily detect counting errors. Unfortunately, this is only
 	 * meaningful for trees. */
 	if (tree && purged != to_purge)
-		mlog(ML_ERROR, "Inode %llu, count = %u, purged = %u\n",
-		     (unsigned long long)oi->ip_blkno, to_purge, purged);
+		mlog(ML_ERROR, "Owner %llu, count = %u, purged = %u\n",
+		     (unsigned long long)ocfs2_metadata_cache_owner(ci),
+		     to_purge, purged);
 }
 
 /* Returns the index in the cache array, -1 if not found.
@@ -190,10 +230,10 @@ static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
 	struct ocfs2_meta_cache_item *item = NULL;
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
-	spin_lock(ci->ci_lock);
+	ocfs2_metadata_cache_lock(ci);
 
-	mlog(0, "Inode %llu, query block %llu (inline = %u)\n",
-	     (unsigned long long)oi->ip_blkno,
+	mlog(0, "Owner %llu, query block %llu (inline = %u)\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
 	     (unsigned long long) bh->b_blocknr,
 	     !!(ci->ci_flags & OCFS2_CACHE_FL_INLINE));
 
@@ -204,7 +244,7 @@ static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
 		item = ocfs2_search_cache_tree(&oi->ip_metadata_cache,
 					       bh->b_blocknr);
 
-	spin_unlock(ci->ci_lock);
+	ocfs2_metadata_cache_unlock(ci);
 
 	mlog(0, "index = %d, item = %p\n", index, item);
 
@@ -294,18 +334,19 @@ static void __ocfs2_insert_cache_tree(struct ocfs2_caching_info *ci,
 	ci->ci_num_cached++;
 }
 
+/* co_cache_lock() must be held */
 static inline int ocfs2_insert_can_use_array(struct ocfs2_inode_info *oi,
 					     struct ocfs2_caching_info *ci)
 {
-	assert_spin_locked(ci->ci_lock);
-
 	return (ci->ci_flags & OCFS2_CACHE_FL_INLINE) &&
 		(ci->ci_num_cached < OCFS2_CACHE_INFO_MAX_ARRAY);
 }
 
 /* tree should be exactly OCFS2_CACHE_INFO_MAX_ARRAY wide. NULL the
  * pointers in tree after we use them - this allows caller to detect
- * when to free in case of error. */
+ * when to free in case of error.
+ *
+ * The co_cache_lock() must be held. */
 static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
 			       struct ocfs2_meta_cache_item **tree)
 {
@@ -313,13 +354,12 @@ static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	mlog_bug_on_msg(ci->ci_num_cached != OCFS2_CACHE_INFO_MAX_ARRAY,
-			"Inode %llu, num cached = %u, should be %u\n",
-			(unsigned long long)oi->ip_blkno, ci->ci_num_cached,
-			OCFS2_CACHE_INFO_MAX_ARRAY);
+			"Owner %llu, num cached = %u, should be %u\n",
+			(unsigned long long)ocfs2_metadata_cache_owner(ci),
+			ci->ci_num_cached, OCFS2_CACHE_INFO_MAX_ARRAY);
 	mlog_bug_on_msg(!(ci->ci_flags & OCFS2_CACHE_FL_INLINE),
-			"Inode %llu not marked as inline anymore!\n",
-			(unsigned long long)oi->ip_blkno);
-	assert_spin_locked(ci->ci_lock);
+			"Owner %llu not marked as inline anymore!\n",
+			(unsigned long long)ocfs2_metadata_cache_owner(ci));
 
 	/* Be careful to initialize the tree members *first* because
 	 * once the ci_tree is used, the array is junk... */
@@ -337,7 +377,8 @@ static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
 	}
 
 	mlog(0, "Expanded %llu to a tree cache: flags 0x%x, num = %u\n",
-	     (unsigned long long)oi->ip_blkno, ci->ci_flags, ci->ci_num_cached);
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
+	     ci->ci_flags, ci->ci_num_cached);
 }
 
 /* Slow path function - memory allocation is necessary. See the
@@ -352,8 +393,8 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 	struct ocfs2_meta_cache_item *tree[OCFS2_CACHE_INFO_MAX_ARRAY] =
 		{ NULL, };
 
-	mlog(0, "Inode %llu, block %llu, expand = %d\n",
-	     (unsigned long long)oi->ip_blkno,
+	mlog(0, "Owner %llu, block %llu, expand = %d\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
 	     (unsigned long long)block, expand_tree);
 
 	new = kmem_cache_alloc(ocfs2_uptodate_cachep, GFP_NOFS);
@@ -378,13 +419,13 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 		}
 	}
 
-	spin_lock(ci->ci_lock);
+	ocfs2_metadata_cache_lock(ci);
 	if (ocfs2_insert_can_use_array(oi, ci)) {
 		mlog(0, "Someone cleared the tree underneath us\n");
 		/* Ok, items were removed from the cache in between
 		 * locks. Detect this and revert back to the fast path */
 		ocfs2_append_cache_array(ci, block);
-		spin_unlock(ci->ci_lock);
+		ocfs2_metadata_cache_unlock(ci);
 		goto out_free;
 	}
 
@@ -392,7 +433,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 		ocfs2_expand_cache(oi, tree);
 
 	__ocfs2_insert_cache_tree(ci, new);
-	spin_unlock(ci->ci_lock);
+	ocfs2_metadata_cache_unlock(ci);
 
 	new = NULL;
 out_free:
@@ -409,7 +450,7 @@ out_free:
 	}
 }
 
-/* Item insertion is guarded by ci_io_mutex, so the insertion path takes
+/* Item insertion is guarded by co_io_lock(), so the insertion path takes
  * advantage of this by not rechecking for a duplicate insert during
  * the slow case. Additionally, if the cache needs to be bumped up to
  * a tree, the code will not recheck after acquiring the lock --
@@ -439,18 +480,18 @@ void ocfs2_set_buffer_uptodate(struct inode *inode,
 	if (ocfs2_buffer_cached(oi, bh))
 		return;
 
-	mlog(0, "Inode %llu, inserting block %llu\n",
-	     (unsigned long long)oi->ip_blkno,
+	mlog(0, "Owner %llu, inserting block %llu\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
 	     (unsigned long long)bh->b_blocknr);
 
 	/* No need to recheck under spinlock - insertion is guarded by
-	 * ci_io_mutex */
-	spin_lock(ci->ci_lock);
+	 * co_io_lock() */
+	ocfs2_metadata_cache_lock(ci);
 	if (ocfs2_insert_can_use_array(oi, ci)) {
 		/* Fast case - it's an array and there's a free
 		 * spot. */
 		ocfs2_append_cache_array(ci, bh->b_blocknr);
-		spin_unlock(ci->ci_lock);
+		ocfs2_metadata_cache_unlock(ci);
 		return;
 	}
 
@@ -459,14 +500,14 @@ void ocfs2_set_buffer_uptodate(struct inode *inode,
 		/* We need to bump things up to a tree. */
 		expand = 1;
 	}
-	spin_unlock(ci->ci_lock);
+	ocfs2_metadata_cache_unlock(ci);
 
 	__ocfs2_set_buffer_uptodate(oi, bh->b_blocknr, expand);
 }
 
 /* Called against a newly allocated buffer. Most likely nobody should
  * be able to read this sort of metadata while it's still being
- * allocated, but this is careful to take ci_io_mutex anyway. */
+ * allocated, but this is careful to take co_io_lock() anyway. */
 void ocfs2_set_new_buffer_uptodate(struct inode *inode,
 				   struct buffer_head *bh)
 {
@@ -478,9 +519,9 @@ void ocfs2_set_new_buffer_uptodate(struct inode *inode,
 
 	set_buffer_uptodate(bh);
 
-	mutex_lock(ci->ci_io_mutex);
+	ocfs2_metadata_cache_io_lock(ci);
 	ocfs2_set_buffer_uptodate(inode, bh);
-	mutex_unlock(ci->ci_io_mutex);
+	ocfs2_metadata_cache_io_unlock(ci);
 }
 
 /* Requires ip_lock. */
@@ -526,9 +567,9 @@ static void ocfs2_remove_block_from_cache(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
-	spin_lock(ci->ci_lock);
-	mlog(0, "Inode %llu, remove %llu, items = %u, array = %u\n",
-	     (unsigned long long)oi->ip_blkno,
+	ocfs2_metadata_cache_lock(ci);
+	mlog(0, "Owner %llu, remove %llu, items = %u, array = %u\n",
+	     (unsigned long long)ocfs2_metadata_cache_owner(ci),
 	     (unsigned long long) block, ci->ci_num_cached,
 	     ci->ci_flags & OCFS2_CACHE_FL_INLINE);
 
@@ -541,7 +582,7 @@ static void ocfs2_remove_block_from_cache(struct inode *inode,
 		if (item)
 			ocfs2_remove_metadata_tree(ci, item);
 	}
-	spin_unlock(ci->ci_lock);
+	ocfs2_metadata_cache_unlock(ci);
 
 	if (item)
 		kmem_cache_free(ocfs2_uptodate_cachep, item);
diff --git a/fs/ocfs2/uptodate.h b/fs/ocfs2/uptodate.h
index bd749e1..3b33eb8 100644
--- a/fs/ocfs2/uptodate.h
+++ b/fs/ocfs2/uptodate.h
@@ -26,12 +26,38 @@
 #ifndef OCFS2_UPTODATE_H
 #define OCFS2_UPTODATE_H
 
+/*
+ * The caching code relies on locking provided by the user of
+ * struct ocfs2_caching_info.  These operations connect that up.
+ */
+struct ocfs2_caching_operations {
+	/*
+	 * A u64 representing the owning structure.  Usually this
+	 * is the block number (i_blkno or whatnot).  This is used so
+	 * that caching log messages can identify the owning structure.
+	 */
+	u64	(*co_owner)(struct ocfs2_caching_info *ci);
+
+	/*
+	 * Lock and unlock the caching data.  These will not sleep, and
+	 * should probably be spinlocks.
+	 */
+	void	(*co_cache_lock)(struct ocfs2_caching_info *ci);
+	void	(*co_cache_unlock)(struct ocfs2_caching_info *ci);
+
+	/*
+	 * Lock and unlock for disk I/O.  These will sleep, and should
+	 * be mutexes.
+	 */
+	void	(*co_io_lock)(struct ocfs2_caching_info *ci);
+	void	(*co_io_unlock)(struct ocfs2_caching_info *ci);
+};
+
 int __init init_ocfs2_uptodate_cache(void);
 void exit_ocfs2_uptodate_cache(void);
 
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
-			       spinlock_t *cache_lock,
-			       struct mutex *io_mutex);
+			       const struct ocfs2_caching_operations *ops);
 void ocfs2_metadata_cache_purge(struct inode *inode);
 
 int ocfs2_buffer_uptodate(struct inode *inode,
-- 
1.5.6.5
