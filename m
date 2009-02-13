From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:48 -0800
Subject: [Ocfs2-devel] [PATCH 01/40] ocfs2: Make the ocfs2_caching_info
	structure self-contained.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-2-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We want to use the ocfs2_caching_info structure in places that are not
inodes.  To do that, it can no longer rely on referencing the inode
directly.

This patch moves the flags to ocfs2_caching_info->ci_flags, stores
pointers to the parent's locks on the ocfs2_caching_info, and renames
the constants and flags to reflect its independant state.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/inode.c    |    5 ++-
 fs/ocfs2/inode.h    |    2 -
 fs/ocfs2/ocfs2.h    |   23 +++++++++++-
 fs/ocfs2/super.c    |    3 +-
 fs/ocfs2/uptodate.c |   99 ++++++++++++++++++++++++++------------------------
 fs/ocfs2/uptodate.h |    4 ++-
 6 files changed, 80 insertions(+), 56 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 229e707..5a89c3d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1069,7 +1069,8 @@ void ocfs2_clear_inode(struct inode *inode)
 			"Clear inode of %llu, inode has %u cache items\n",
 			(unsigned long long)oi->ip_blkno, oi->ip_metadata_cache.ci_num_cached);
 
-	mlog_bug_on_msg(!(oi->ip_flags & OCFS2_INODE_CACHE_INLINE),
+	mlog_bug_on_msg(!(oi->ip_metadata_cache.ci_flags &
+			  OCFS2_CACHE_FL_INLINE),
 			"Clear inode of %llu, inode has a bad flag\n",
 			(unsigned long long)oi->ip_blkno);
 
@@ -1096,7 +1097,7 @@ void ocfs2_clear_inode(struct inode *inode)
 			(unsigned long long)oi->ip_blkno, oi->ip_open_count);
 
 	/* Clear all other flags. */
-	oi->ip_flags = OCFS2_INODE_CACHE_INLINE;
+	oi->ip_flags = 0;
 	oi->ip_created_trans = 0;
 	oi->ip_last_trans = 0;
 	oi->ip_dir_start_lookup = 0;
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index eb3c302..84191b1 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -102,8 +102,6 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_MAYBE_ORPHANED	0x00000020
 /* Does someone have the file open O_DIRECT */
 #define OCFS2_INODE_OPEN_DIRECT		0x00000040
-/* Indicates that the metadata cache should be used as an array. */
-#define OCFS2_INODE_CACHE_INLINE	0x00000080
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 0773841..b36d961 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -47,17 +47,36 @@
 #include "ocfs2_fs.h"
 #include "ocfs2_lockid.h"
 
+
+/* Caching of metadata buffers */
+
 /* Most user visible OCFS2 inodes will have very few pieces of
  * metadata, but larger files (including bitmaps, etc) must be taken
  * into account when designing an access scheme. We allow a small
  * amount of inlined blocks to be stored on an array and grow the
  * structure into a rb tree when necessary. */
-#define OCFS2_INODE_MAX_CACHE_ARRAY 2
+#define OCFS2_CACHE_INFO_MAX_ARRAY 2
+
+/* Flags for ocfs2_caching_info */
+
+enum ocfs2_caching_info_flags {
+	/* Indicates that the metadata cache is using the inline array */
+	OCFS2_CACHE_FL_INLINE	= 1<<1,
+};
 
 struct ocfs2_caching_info {
+	/*
+	 * The parent structure provides the locks, but because the
+	 * parent structure can differ, struct ocfs2_caching_info needs
+	 * its own pointers to them.
+	 */
+	spinlock_t		*ci_lock;
+	struct mutex		*ci_io_mutex;
+
+	unsigned int		ci_flags;
 	unsigned int		ci_num_cached;
 	union {
-		sector_t	ci_array[OCFS2_INODE_MAX_CACHE_ARRAY];
+		sector_t	ci_array[OCFS2_CACHE_INFO_MAX_ARRAY];
 		struct rb_root	ci_tree;
 	} ci_cache;
 };
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b1cb38f..b10e3ca 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1463,7 +1463,8 @@ static void ocfs2_inode_init_once(void *data)
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
 
-	ocfs2_metadata_cache_init(&oi->vfs_inode);
+	ocfs2_metadata_cache_init(&oi->ip_metadata_cache, &oi->ip_lock,
+				  &oi->ip_io_mutex);
 
 	inode_init_once(&oi->vfs_inode);
 }
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 187b99f..8dbc457 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -75,12 +75,13 @@ struct ocfs2_meta_cache_item {
 
 static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
 
-void ocfs2_metadata_cache_init(struct inode *inode)
+void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
+			       spinlock_t *cache_lock,
+			       struct mutex *io_mutex)
 {
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
-
-	oi->ip_flags |= OCFS2_INODE_CACHE_INLINE;
+	ci->ci_lock = cache_lock;
+	ci->ci_io_mutex = io_mutex;
+	ci->ci_flags |= OCFS2_CACHE_FL_INLINE;
 	ci->ci_num_cached = 0;
 }
 
@@ -119,8 +120,8 @@ void ocfs2_metadata_cache_purge(struct inode *inode)
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 	struct rb_root root = RB_ROOT;
 
-	spin_lock(&oi->ip_lock);
-	tree = !(oi->ip_flags & OCFS2_INODE_CACHE_INLINE);
+	spin_lock(ci->ci_lock);
+	tree = !(ci->ci_flags & OCFS2_CACHE_FL_INLINE);
 	to_purge = ci->ci_num_cached;
 
 	mlog(0, "Purge %u %s items from Inode %llu\n", to_purge,
@@ -132,8 +133,8 @@ void ocfs2_metadata_cache_purge(struct inode *inode)
 	if (tree)
 		root = ci->ci_cache.ci_tree;
 
-	ocfs2_metadata_cache_init(inode);
-	spin_unlock(&oi->ip_lock);
+	ocfs2_metadata_cache_init(ci, ci->ci_lock, ci->ci_io_mutex);
+	spin_unlock(ci->ci_lock);
 
 	purged = ocfs2_purge_copied_metadata_tree(&root);
 	/* If possible, track the number wiped so that we can more
@@ -187,22 +188,23 @@ static int ocfs2_buffer_cached(struct ocfs2_inode_info *oi,
 {
 	int index = -1;
 	struct ocfs2_meta_cache_item *item = NULL;
+	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
-	spin_lock(&oi->ip_lock);
+	spin_lock(ci->ci_lock);
 
 	mlog(0, "Inode %llu, query block %llu (inline = %u)\n",
 	     (unsigned long long)oi->ip_blkno,
 	     (unsigned long long) bh->b_blocknr,
-	     !!(oi->ip_flags & OCFS2_INODE_CACHE_INLINE));
+	     !!(ci->ci_flags & OCFS2_CACHE_FL_INLINE));
 
-	if (oi->ip_flags & OCFS2_INODE_CACHE_INLINE)
+	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE)
 		index = ocfs2_search_cache_array(&oi->ip_metadata_cache,
 						 bh->b_blocknr);
 	else
 		item = ocfs2_search_cache_tree(&oi->ip_metadata_cache,
 					       bh->b_blocknr);
 
-	spin_unlock(&oi->ip_lock);
+	spin_unlock(ci->ci_lock);
 
 	mlog(0, "index = %d, item = %p\n", index, item);
 
@@ -235,7 +237,7 @@ int ocfs2_buffer_uptodate(struct inode *inode,
 
 /* 
  * Determine whether a buffer is currently out on a read-ahead request.
- * ip_io_sem should be held to serialize submitters with the logic here.
+ * ci_io_sem should be held to serialize submitters with the logic here.
  */
 int ocfs2_buffer_read_ahead(struct inode *inode,
 			    struct buffer_head *bh)
@@ -247,7 +249,7 @@ int ocfs2_buffer_read_ahead(struct inode *inode,
 static void ocfs2_append_cache_array(struct ocfs2_caching_info *ci,
 				     sector_t block)
 {
-	BUG_ON(ci->ci_num_cached >= OCFS2_INODE_MAX_CACHE_ARRAY);
+	BUG_ON(ci->ci_num_cached >= OCFS2_CACHE_INFO_MAX_ARRAY);
 
 	mlog(0, "block %llu takes position %u\n", (unsigned long long) block,
 	     ci->ci_num_cached);
@@ -295,13 +297,13 @@ static void __ocfs2_insert_cache_tree(struct ocfs2_caching_info *ci,
 static inline int ocfs2_insert_can_use_array(struct ocfs2_inode_info *oi,
 					     struct ocfs2_caching_info *ci)
 {
-	assert_spin_locked(&oi->ip_lock);
+	assert_spin_locked(ci->ci_lock);
 
-	return (oi->ip_flags & OCFS2_INODE_CACHE_INLINE) &&
-		(ci->ci_num_cached < OCFS2_INODE_MAX_CACHE_ARRAY);
+	return (ci->ci_flags & OCFS2_CACHE_FL_INLINE) &&
+		(ci->ci_num_cached < OCFS2_CACHE_INFO_MAX_ARRAY);
 }
 
-/* tree should be exactly OCFS2_INODE_MAX_CACHE_ARRAY wide. NULL the
+/* tree should be exactly OCFS2_CACHE_INFO_MAX_ARRAY wide. NULL the
  * pointers in tree after we use them - this allows caller to detect
  * when to free in case of error. */
 static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
@@ -310,32 +312,32 @@ static void ocfs2_expand_cache(struct ocfs2_inode_info *oi,
 	int i;
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
-	mlog_bug_on_msg(ci->ci_num_cached != OCFS2_INODE_MAX_CACHE_ARRAY,
+	mlog_bug_on_msg(ci->ci_num_cached != OCFS2_CACHE_INFO_MAX_ARRAY,
 			"Inode %llu, num cached = %u, should be %u\n",
 			(unsigned long long)oi->ip_blkno, ci->ci_num_cached,
-			OCFS2_INODE_MAX_CACHE_ARRAY);
-	mlog_bug_on_msg(!(oi->ip_flags & OCFS2_INODE_CACHE_INLINE),
+			OCFS2_CACHE_INFO_MAX_ARRAY);
+	mlog_bug_on_msg(!(ci->ci_flags & OCFS2_CACHE_FL_INLINE),
 			"Inode %llu not marked as inline anymore!\n",
 			(unsigned long long)oi->ip_blkno);
-	assert_spin_locked(&oi->ip_lock);
+	assert_spin_locked(ci->ci_lock);
 
 	/* Be careful to initialize the tree members *first* because
 	 * once the ci_tree is used, the array is junk... */
-	for(i = 0; i < OCFS2_INODE_MAX_CACHE_ARRAY; i++)
+	for (i = 0; i < OCFS2_CACHE_INFO_MAX_ARRAY; i++)
 		tree[i]->c_block = ci->ci_cache.ci_array[i];
 
-	oi->ip_flags &= ~OCFS2_INODE_CACHE_INLINE;
+	ci->ci_flags &= ~OCFS2_CACHE_FL_INLINE;
 	ci->ci_cache.ci_tree = RB_ROOT;
 	/* this will be set again by __ocfs2_insert_cache_tree */
 	ci->ci_num_cached = 0;
 
-	for(i = 0; i < OCFS2_INODE_MAX_CACHE_ARRAY; i++) {
+	for (i = 0; i < OCFS2_CACHE_INFO_MAX_ARRAY; i++) {
 		__ocfs2_insert_cache_tree(ci, tree[i]);
 		tree[i] = NULL;
 	}
 
 	mlog(0, "Expanded %llu to a tree cache: flags 0x%x, num = %u\n",
-	     (unsigned long long)oi->ip_blkno, oi->ip_flags, ci->ci_num_cached);
+	     (unsigned long long)oi->ip_blkno, ci->ci_flags, ci->ci_num_cached);
 }
 
 /* Slow path function - memory allocation is necessary. See the
@@ -347,7 +349,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 	int i;
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 	struct ocfs2_meta_cache_item *new = NULL;
-	struct ocfs2_meta_cache_item *tree[OCFS2_INODE_MAX_CACHE_ARRAY] =
+	struct ocfs2_meta_cache_item *tree[OCFS2_CACHE_INFO_MAX_ARRAY] =
 		{ NULL, };
 
 	mlog(0, "Inode %llu, block %llu, expand = %d\n",
@@ -364,7 +366,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 	if (expand_tree) {
 		/* Do *not* allocate an array here - the removal code
 		 * has no way of tracking that. */
-		for(i = 0; i < OCFS2_INODE_MAX_CACHE_ARRAY; i++) {
+		for (i = 0; i < OCFS2_CACHE_INFO_MAX_ARRAY; i++) {
 			tree[i] = kmem_cache_alloc(ocfs2_uptodate_cachep,
 						   GFP_NOFS);
 			if (!tree[i]) {
@@ -376,13 +378,13 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 		}
 	}
 
-	spin_lock(&oi->ip_lock);
+	spin_lock(ci->ci_lock);
 	if (ocfs2_insert_can_use_array(oi, ci)) {
 		mlog(0, "Someone cleared the tree underneath us\n");
 		/* Ok, items were removed from the cache in between
 		 * locks. Detect this and revert back to the fast path */
 		ocfs2_append_cache_array(ci, block);
-		spin_unlock(&oi->ip_lock);
+		spin_unlock(ci->ci_lock);
 		goto out_free;
 	}
 
@@ -390,7 +392,7 @@ static void __ocfs2_set_buffer_uptodate(struct ocfs2_inode_info *oi,
 		ocfs2_expand_cache(oi, tree);
 
 	__ocfs2_insert_cache_tree(ci, new);
-	spin_unlock(&oi->ip_lock);
+	spin_unlock(ci->ci_lock);
 
 	new = NULL;
 out_free:
@@ -400,14 +402,14 @@ out_free:
 	/* If these were used, then ocfs2_expand_cache re-set them to
 	 * NULL for us. */
 	if (tree[0]) {
-		for(i = 0; i < OCFS2_INODE_MAX_CACHE_ARRAY; i++)
+		for (i = 0; i < OCFS2_CACHE_INFO_MAX_ARRAY; i++)
 			if (tree[i])
 				kmem_cache_free(ocfs2_uptodate_cachep,
 						tree[i]);
 	}
 }
 
-/* Item insertion is guarded by ip_io_mutex, so the insertion path takes
+/* Item insertion is guarded by ci_io_mutex, so the insertion path takes
  * advantage of this by not rechecking for a duplicate insert during
  * the slow case. Additionally, if the cache needs to be bumped up to
  * a tree, the code will not recheck after acquiring the lock --
@@ -442,42 +444,43 @@ void ocfs2_set_buffer_uptodate(struct inode *inode,
 	     (unsigned long long)bh->b_blocknr);
 
 	/* No need to recheck under spinlock - insertion is guarded by
-	 * ip_io_mutex */
-	spin_lock(&oi->ip_lock);
+	 * ci_io_mutex */
+	spin_lock(ci->ci_lock);
 	if (ocfs2_insert_can_use_array(oi, ci)) {
 		/* Fast case - it's an array and there's a free
 		 * spot. */
 		ocfs2_append_cache_array(ci, bh->b_blocknr);
-		spin_unlock(&oi->ip_lock);
+		spin_unlock(ci->ci_lock);
 		return;
 	}
 
 	expand = 0;
-	if (oi->ip_flags & OCFS2_INODE_CACHE_INLINE) {
+	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE) {
 		/* We need to bump things up to a tree. */
 		expand = 1;
 	}
-	spin_unlock(&oi->ip_lock);
+	spin_unlock(ci->ci_lock);
 
 	__ocfs2_set_buffer_uptodate(oi, bh->b_blocknr, expand);
 }
 
 /* Called against a newly allocated buffer. Most likely nobody should
  * be able to read this sort of metadata while it's still being
- * allocated, but this is careful to take ip_io_mutex anyway. */
+ * allocated, but this is careful to take ci_io_mutex anyway. */
 void ocfs2_set_new_buffer_uptodate(struct inode *inode,
 				   struct buffer_head *bh)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
 	/* This should definitely *not* exist in our cache */
 	BUG_ON(ocfs2_buffer_cached(oi, bh));
 
 	set_buffer_uptodate(bh);
 
-	mutex_lock(&oi->ip_io_mutex);
+	mutex_lock(ci->ci_io_mutex);
 	ocfs2_set_buffer_uptodate(inode, bh);
-	mutex_unlock(&oi->ip_io_mutex);
+	mutex_unlock(ci->ci_io_mutex);
 }
 
 /* Requires ip_lock. */
@@ -487,7 +490,7 @@ static void ocfs2_remove_metadata_array(struct ocfs2_caching_info *ci,
 	sector_t *array = ci->ci_cache.ci_array;
 	int bytes;
 
-	BUG_ON(index < 0 || index >= OCFS2_INODE_MAX_CACHE_ARRAY);
+	BUG_ON(index < 0 || index >= OCFS2_CACHE_INFO_MAX_ARRAY);
 	BUG_ON(index >= ci->ci_num_cached);
 	BUG_ON(!ci->ci_num_cached);
 
@@ -523,13 +526,13 @@ static void ocfs2_remove_block_from_cache(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_caching_info *ci = &oi->ip_metadata_cache;
 
-	spin_lock(&oi->ip_lock);
+	spin_lock(ci->ci_lock);
 	mlog(0, "Inode %llu, remove %llu, items = %u, array = %u\n",
 	     (unsigned long long)oi->ip_blkno,
 	     (unsigned long long) block, ci->ci_num_cached,
-	     oi->ip_flags & OCFS2_INODE_CACHE_INLINE);
+	     ci->ci_flags & OCFS2_CACHE_FL_INLINE);
 
-	if (oi->ip_flags & OCFS2_INODE_CACHE_INLINE) {
+	if (ci->ci_flags & OCFS2_CACHE_FL_INLINE) {
 		index = ocfs2_search_cache_array(ci, block);
 		if (index != -1)
 			ocfs2_remove_metadata_array(ci, index);
@@ -538,7 +541,7 @@ static void ocfs2_remove_block_from_cache(struct inode *inode,
 		if (item)
 			ocfs2_remove_metadata_tree(ci, item);
 	}
-	spin_unlock(&oi->ip_lock);
+	spin_unlock(ci->ci_lock);
 
 	if (item)
 		kmem_cache_free(ocfs2_uptodate_cachep, item);
@@ -577,7 +580,7 @@ int __init init_ocfs2_uptodate_cache(void)
 		return -ENOMEM;
 
 	mlog(0, "%u inlined cache items per inode.\n",
-	     OCFS2_INODE_MAX_CACHE_ARRAY);
+	     OCFS2_CACHE_INFO_MAX_ARRAY);
 
 	return 0;
 }
diff --git a/fs/ocfs2/uptodate.h b/fs/ocfs2/uptodate.h
index 531b4b3..bd749e1 100644
--- a/fs/ocfs2/uptodate.h
+++ b/fs/ocfs2/uptodate.h
@@ -29,7 +29,9 @@
 int __init init_ocfs2_uptodate_cache(void);
 void exit_ocfs2_uptodate_cache(void);
 
-void ocfs2_metadata_cache_init(struct inode *inode);
+void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
+			       spinlock_t *cache_lock,
+			       struct mutex *io_mutex);
 void ocfs2_metadata_cache_purge(struct inode *inode);
 
 int ocfs2_buffer_uptodate(struct inode *inode,
-- 
1.5.6.5
