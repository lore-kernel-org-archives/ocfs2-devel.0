From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Wed May  5 18:39:22 2004
Subject: [Ocfs2-devel] Patch to hash.c
Message-ID: <40997BE7.1080901@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Here is a small patch to hash.c

I didn't like the fact that we had a magic number sprinkled through the code so I replaced it with a #define.

I also added some comments.

John


Index: hash.c
===================================================================
--- hash.c	(revision 900)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
   * hash.c
   *
   * lockid hash, bh sem hash, inode hash
@@ -95,22 +97,44 @@
  #define ocfs_bh_sem_hash_fn(_b)   \
  	(_hashfn((unsigned int)BH_GET_DEVICE((_b)), (_b)->b_blocknr) & ocfs_bh_hash_shift)

+/* How many pages we are allocating for our semaphore hash table */
+#define SEM_HASH_FREE_PAGES 2
+#define SEM_HASH_PAGE_COUNT ( 1 << SEM_HASH_FREE_PAGES )
+
+/*
+ * ocfs_bh_sem_hash_init()
+ *
+ * Setup our buffer head semaphore hash table.
+ *
+ * The purpose of the buffer head semaphore hash table is to store semaphores
+ * for our buffer heads.  In order to help speed up the performance of finding
+ * the correct semaphore for our buffer heads we use a hash.  The way this is
+ * done is we create a table that has "buckets" of semaphores.  Each bucket
+ * contains a list of semaphores for our buffer heads which all have the same
+ * hash value.  When we need to find the correct semaphore for a buffer head we
+ * call the ocfs_bh_sem_lookup() function.
+ */
  int ocfs_bh_sem_hash_init()
  {
  	int i, ret;

  	spin_lock_init (&OcfsGlobalCtxt.bh_sem_hash_lock);
-	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, 2);
+	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, SEM_HASH_FREE_PAGES);
  	if (!OcfsGlobalCtxt.bh_sem_hash) {
  		LOG_ERROR_STR("ENOMEM allocating ocfs_bh_sem_hash");
  		ret = -ENOMEM;
  		goto bail;
  	}
-	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * 4) / sizeof(struct list_head);
-
+	/* Keep track of how many buckets we have spots for in our hash table
+	 * */
+	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * SEM_HASH_PAGE_COUNT) / sizeof(struct list_head);
+	/* Setup all our buckets, so that they have properly initialized lists
+	 * */
  	for (i=OcfsGlobalCtxt.bh_sem_hash_sz-1; i>=0; i--)
  		INIT_LIST_HEAD(&OcfsGlobalCtxt.bh_sem_hash[i]);

+	/* Initially we have no target for pruning and we haven't yet gone
+	 * through our pruning function (ocfs_bh_sem_hash_prune) */
  	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, -1);
  	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_num_iters, 0);
  	ret = 0;
@@ -130,7 +154,7 @@
  	}

  	spin_lock (&OcfsGlobalCtxt.bh_sem_hash_lock);
-	free_pages((unsigned long)OcfsGlobalCtxt.bh_sem_hash, 2);
+	free_pages((unsigned long)OcfsGlobalCtxt.bh_sem_hash, SEM_HASH_FREE_PAGES);
  	OcfsGlobalCtxt.bh_sem_hash = NULL;
  	
  	return 0;

-------------- next part --------------
Index: hash.c
===================================================================
--- hash.c	(revision 900)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * hash.c
  *
  * lockid hash, bh sem hash, inode hash
@@ -95,22 +97,44 @@
 #define ocfs_bh_sem_hash_fn(_b)   \
 	(_hashfn((unsigned int)BH_GET_DEVICE((_b)), (_b)->b_blocknr) & ocfs_bh_hash_shift)
 
+/* How many pages we are allocating for our semaphore hash table */
+#define SEM_HASH_FREE_PAGES 2
+#define SEM_HASH_PAGE_COUNT ( 1 << SEM_HASH_FREE_PAGES )
+
+/*
+ * ocfs_bh_sem_hash_init()
+ *
+ * Setup our buffer head semaphore hash table.
+ *
+ * The purpose of the buffer head semaphore hash table is to store semaphores
+ * for our buffer heads.  In order to help speed up the performance of finding
+ * the correct semaphore for our buffer heads we use a hash.  The way this is
+ * done is we create a table that has "buckets" of semaphores.  Each bucket
+ * contains a list of semaphores for our buffer heads which all have the same
+ * hash value.  When we need to find the correct semaphore for a buffer head we
+ * call the ocfs_bh_sem_lookup() function.
+ */
 int ocfs_bh_sem_hash_init()
 {
 	int i, ret;
 
 	spin_lock_init (&OcfsGlobalCtxt.bh_sem_hash_lock);
-	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, 2);
+	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, SEM_HASH_FREE_PAGES);
 	if (!OcfsGlobalCtxt.bh_sem_hash) {
 		LOG_ERROR_STR("ENOMEM allocating ocfs_bh_sem_hash");
 		ret = -ENOMEM;
 		goto bail;
 	}
-	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * 4) / sizeof(struct list_head);
-
+	/* Keep track of how many buckets we have spots for in our hash table
+	 * */
+	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * SEM_HASH_PAGE_COUNT) / sizeof(struct list_head);
+	/* Setup all our buckets, so that they have properly initialized lists
+	 * */
 	for (i=OcfsGlobalCtxt.bh_sem_hash_sz-1; i>=0; i--)
 		INIT_LIST_HEAD(&OcfsGlobalCtxt.bh_sem_hash[i]);
 
+	/* Initially we have no target for pruning and we haven't yet gone
+	 * through our pruning function (ocfs_bh_sem_hash_prune) */
 	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, -1);
 	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_num_iters, 0);
 	ret = 0;
@@ -130,7 +154,7 @@
 	}
 
 	spin_lock (&OcfsGlobalCtxt.bh_sem_hash_lock);
-	free_pages((unsigned long)OcfsGlobalCtxt.bh_sem_hash, 2);
+	free_pages((unsigned long)OcfsGlobalCtxt.bh_sem_hash, SEM_HASH_FREE_PAGES);
 	OcfsGlobalCtxt.bh_sem_hash = NULL;
 	
 	return 0;
