From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Mon Apr 26 15:46:21 2004
Subject: [Ocfs2-devel] Patch for hash.c
Message-ID: <408D75BA.3070907@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Going through hash.c to figure things out.  Here is a patch with comments.  Where you see FIXME: are places where I think the code needs fixing.

One thing I noticed is that it seems like in ocfs_bh_sem_hash_prune() that the logic to have it do a mandatory prune every 10 times through is broken.  I put a comment in that function where to me it seems like it is not working as intended.

I also changed a goto statement into a do/while loop in ocfs_bh_sem_hash_prune_all()

John


Index: hash.c
===================================================================
--- hash.c	(revision 867)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
   * hash.c
   *
   * lockid hash, bh sem hash, inode hash
@@ -9,12 +11,12 @@
   * modify it under the terms of the GNU General Public
   * License as published by the Free Software Foundation; either
   * version 2 of the License, or (at your option) any later version.
- *
+ *
   * This program is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   * General Public License for more details.
- *
+ *
   * You should have received a copy of the GNU General Public
   * License along with this program; if not, write to the
   * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
@@ -687,19 +689,36 @@
  #define ocfs_bh_sem_hash_fn(_b)   \
  	(_hashfn((unsigned int)BH_GET_DEVICE((_b)), (_b)->b_blocknr) & ocfs_bh_hash_shift)

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
+	/* Get 4 ( = pow(2, 2) ) pages of memory. */
  	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, 2);
  	if (!OcfsGlobalCtxt.bh_sem_hash) {
  		LOG_ERROR_STR("ENOMEM allocating ocfs_bh_sem_hash");
  		ret = -ENOMEM;
  		goto bail;
  	}
+	/* Keep track of how many buckets we have spots for in our hash table
+	 * */
  	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * 4) / sizeof(struct list_head);
-
+	/* Setup all our buckets, so that they have properly initialized lists
+	 * */
  	for (i=OcfsGlobalCtxt.bh_sem_hash_sz-1; i>=0; i--)
  		INIT_LIST_HEAD(&OcfsGlobalCtxt.bh_sem_hash[i]);

@@ -728,15 +747,25 @@
  	return 0;
  }

-
+/*
+ * ocfs_bh_sem_lookup()
+ *
+ * Lookup the semaphore for our buffer head.  If one does NOT exist then we
+ * will create it and add it to the buffer head semaphore hash table.
+ */
  ocfs_bh_sem * ocfs_bh_sem_lookup(struct buffer_head *bh)
  {
  	int depth, bucket;
  	struct list_head *head, *iter = NULL;
  	ocfs_bh_sem *sem = NULL, *newsem = NULL;

+	/* Figure out which bucket our buffer head is in and then get the list
+	 * of semaphores for that bucket */
  	bucket = ocfs_bh_sem_hash_fn(bh);
  	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
+
+/* We will jump to this point after we add a new semaphore for an entry that
+ * was not prexisting in the hash table */
  again:
  	depth = 0;
  	spin_lock (&OcfsGlobalCtxt.bh_sem_hash_lock);
@@ -744,11 +773,20 @@
  	list_for_each(iter, head) {
  		if (++depth > OCFS_BH_SEM_HASH_PRUNE_TRIGGER) {
  			/* Grandma, what a long list you have? */
+			/* Make this list the one that should be pruned next
+			 * time pruning is done. */
  			atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, bucket);
  		}
  		sem = list_entry (iter, ocfs_bh_sem, s_list);
+		/* Is this the correct semaphore for our buffer head? */
  		if (sem->s_blocknr == bh->b_blocknr &&
  		    sem->s_dev == BH_GET_DEVICE(bh)) {
+			/* We have found our semaphore. */
+
+			/* We want to make sure that if nobody is currently
+			 * using the semaphore that there should be no buffer
+			 * head associated with it.  If it isn't being used
+			 * then we can use it for our buffer head */
  			if (atomic_read(&sem->s_refcnt)==0) {
  				if (sem->s_bh) {
  					LOG_ERROR_STR("refcount was zero but s_bh not NULL!");
@@ -757,6 +795,9 @@
  				get_bh(bh);
  				sem->s_bh = bh;
  			}
+			/* Make sure that the buffer head associated with the
+			 * semaphore is our buffer head.  If it isn't then
+			 * something went wrong somewhere :( */
  			if (sem->s_bh != bh) {
  				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%lu,%lu), new(%p,%lu)\n",
  					       sem->s_bh, sem->s_bh ? sem->s_bh->b_blocknr : 0,
@@ -768,8 +809,13 @@
  		sem = NULL;
  	}

+/* TODO: Should "again:" be moved here? Or should the logic of this be moved
+ * down below? */
  	if (newsem && !sem) {
-		/* second pass, we are first to insert */
+		/* We have gone through the list a second time and did not find
+		 * our list item.  Though it seem obvious that we wouldn't find
+		 * it in the second pass since we didn't add it to the list.
+		 * So not sure why we go through the list a second time?? */
  		sem = newsem;
  		list_add(&sem->s_list, head);
  		get_bh(bh);
@@ -777,10 +823,14 @@
  	}

  	if (sem) {
-		/* found something on first or second pass */
+		/* We have found a match, either on the first time through or
+		 * we created a semaphore and added it to the list on the
+		 * second time through.  */
+
  		ocfs_bh_sem_get(sem);
  		if (newsem != sem) {
-			/* if not just added, mru to front */
+			/* if it wasn't just added, the Most Recently Used goes
+			 * to the front of the list */
  			list_del(&sem->s_list);
  			list_add(&sem->s_list, head);
  		}
@@ -788,17 +838,25 @@
  		//	      sem->s_bh->b_blocknr,
  		//	      buffer_modified(sem->s_bh) ? "true" : "false",
  		//	      sem->s_pid);
-			
+
  		if (buffer_modified(sem->s_bh) && sem->s_pid == 0) {
  			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%d)\n",
  				       newsem != sem ? "n old" : " new",
  				       sem->s_bh->b_blocknr);
  		}
  	} else {
-		/* first pass. not found. do alloc */
+		/* We went through the list and did NOT find a match for our
+		 * buffer head.  So now we need to create a new semaphore and
+		 * then go back and go through the list again. */
  		spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
+		/* Create our new semaphore */
  		newsem = ocfs_bh_sem_alloc();
  		if (newsem) {
+			/* Setup the new semaphore.  When a new semaphore is
+			 * created we don't yet assign our buffer head to it.
+			 * We just set the refcnt to 0 and set the block # and
+			 * device.  The buffer head will get put into place
+			 * above. */
  			newsem->s_bh = NULL;
  			atomic_set(&newsem->s_refcnt, 0);
  			newsem->s_blocknr = bh->b_blocknr;
@@ -809,8 +867,12 @@
  #ifdef BH_SEM_DEBUG
  			memset(&newsem->s_modifier[0], 0, 40);
  #endif
+			/* Go back and look up the semaphore again.  It is
+			 * there now since we have just created it */
  			goto again;
  		}
+		/* ERROR.  Shouldn't get here.  If we did then we failed to
+		 * allocate a semaphore. */
  		sem = NULL;
  		goto bail;
  	}
@@ -822,7 +884,7 @@
  		ocfs_bh_sem_free(newsem);
  	}

-bail:	
+bail:
  	return sem;
  }

@@ -919,8 +981,18 @@
  }


-/* returns number of pruned entries */
-int ocfs_bh_sem_hash_prune()
+/*
+ * ocfs_bh_sem_hash_prune()
+ *
+ * This function will prune the semaphore hash list.  If
+ * OcfsGlobalCtxt.bh_sem_hash_target_bucket is a valid bucket then the list
+ * contained in that bucket will be pruned.  Otherwise if we have gone through
+ * this function more than 10 times without doing a mandatory prune then we will
+ * do a prune of a random bucket.
+ *
+ * returns number of pruned entries
+ */
+int ocfs_bh_sem_hash_prune(void)
  {
  	unsigned int bucket;
  	int pruned = 0, mandatory=0;
@@ -928,16 +1000,24 @@
  	ocfs_bh_sem *sem = NULL;
  	LIST_HEAD(tmp);

+	/* Every 10 times through this function we will force a prune to be done
+	 * */
  	atomic_inc(&OcfsGlobalCtxt.bh_sem_hash_num_iters);
         	if (atomic_read(&OcfsGlobalCtxt.bh_sem_hash_num_iters) > 10) {
  		mandatory = 1;
  		atomic_sub(10, &OcfsGlobalCtxt.bh_sem_hash_num_iters);
  	}

-	/* The better to prune you with, my dear! */
+	/* Get the bucket that we are supposed to prune.  If it is -1 then we
+	 * don't have any bucket specified.  In that case, if we have gone
+	 * through 10 or more times time through this function without a
+	 * mandatory prune then we will randomly pick a bucket and do a prune on
+	 * it */
  	bucket = atomic_read(&OcfsGlobalCtxt.bh_sem_hash_target_bucket);
  	if (bucket == -1) {
  		if (mandatory) {
+			/* Pruning is mandatory.  Pick a random bucket and prune
+			 * it. */
  			get_random_bytes(&bucket, sizeof(bucket));
  			bucket %= OcfsGlobalCtxt.bh_sem_hash_sz;
  		} else {
@@ -948,6 +1028,8 @@

  	spin_lock(&OcfsGlobalCtxt.bh_sem_hash_lock);

+	/* FIXME: BUG: This seems to kill the mandatory pruning that is setup
+	 * above */
  	bucket = atomic_read(&OcfsGlobalCtxt.bh_sem_hash_target_bucket);
  	if (bucket == -1) {
  		spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
@@ -958,7 +1040,10 @@
  	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
  	pruned = 0;

-	/* run in lru order */
+	/* We need to get the Least Recently Used (LRU) entries from our list.
+	 * We look for entries that are not being used and then delete them from
+	 * the list and move them into a temporary list that we will use later
+	 * to actually delete the semaphores from memory.  */
  	list_for_each_prev_safe(iter, tmpiter, head) {
  		sem = list_entry (iter, ocfs_bh_sem, s_list);
  		if (atomic_read(&sem->s_refcnt) < 1) {
@@ -973,6 +1058,8 @@

  	spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);

+	/* Go through the list of unused semaphores and free the memory being
+	 * used by each semaphore */
  	list_for_each_safe(iter, tmpiter, &tmp) {
  		sem = list_entry (iter, ocfs_bh_sem, s_list);
  		if (sem->s_bh) {
@@ -1034,7 +1121,18 @@
  	return found;
  } /* ocfs_bh_sem_hash_cleanup_pid() */

-/* returns number of missed entries */
+/* ocfs_bh_sem_hash_prune_all()
+ *
+ * Goes through and removes all semaphores in the semaphore hash table which are
+ * not being used.
+ *
+ * - Returns number of missed entries.  Missed entries are ones that are still
+ * - being referenced and were not able to be pruned.
+ *
+ * This function has an assumption that all the entries should be available to
+ * be removed.  If it finds some which are not available to be removed it will
+ * log that information.
+ */
  int ocfs_bh_sem_hash_prune_all()
  {
  	int bucket, missed;
@@ -1045,39 +1143,46 @@
  	missed = 0;
  	bucket = 0;
  	spin_lock(&OcfsGlobalCtxt.bh_sem_hash_lock);
+	/* Turn off pruning for the ocfs_bh_sem_hash_prune() function */
  	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, -1);
-again:
-	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];

-	/* run in lru order */
-	list_for_each_prev_safe(iter, tmpiter, head) {
-		sem = list_entry (iter, ocfs_bh_sem, s_list);
-		if (atomic_read(&sem->s_refcnt) < 1) {
-			if (sem->s_bh) {
-				LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%lu, count=%d\n",
-					       sem->s_bh->b_blocknr, atomic_read(&sem->s_bh->b_count));
+	/* Go through every bucket and move all the semaphores which are not
+	 * being used to a temporary list.  Keep a count of all the semaphores
+	 * which are still being used and thus can not be moved. */
+	do {
+		head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
+
+		/* run in lru order */
+		list_for_each_prev_safe(iter, tmpiter, head) {
+			sem = list_entry (iter, ocfs_bh_sem, s_list);
+			if (atomic_read(&sem->s_refcnt) < 1) {
+				if (sem->s_bh) {
+					LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%lu, count=%d\n",
+						       sem->s_bh->b_blocknr, atomic_read(&sem->s_bh->b_count));
+				}
+				list_del(&sem->s_list);
+				list_add(&sem->s_list, &tmp);
+			} else {
+				missed++;
+				LOG_TRACE_ARGS("missed block %lu, refcount %u, "
+					       "pid = %u\n",
+					       sem->s_blocknr,
+					       sem->s_refcnt,
+					       sem->s_pid);
  			}
-			list_del(&sem->s_list);
-			list_add(&sem->s_list, &tmp);
-		} else {
-			missed++;
-			LOG_TRACE_ARGS("missed block %lu, refcount %u, "
-				       "pid = %u\n",
-				       sem->s_blocknr,
-				       sem->s_refcnt,
-				       sem->s_pid);
  		}
-	}
+	} while ( ++bucket < OcfsGlobalCtxt.bh_sem_hash_sz );

-	if (++bucket < OcfsGlobalCtxt.bh_sem_hash_sz)
-		goto again;
-
  	LOG_TRACE_ARGS("finished pruning, missed %d entries\n", missed);

  	spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);

+	/* Go through our temporary list of semaphores which are unused and
+	 * release the memory associated with them */
  	list_for_each_safe(iter, tmpiter, &tmp) {
  		sem = list_entry (iter, ocfs_bh_sem, s_list);
+		/* FIXME: REDUNDANT: This seems to duplicate the error message
+		 * printed above for the same condition */
  		if (sem->s_bh) {
  			LOG_ERROR_STR("s_bh is NOT NULL");
  			BUG();
@@ -1868,5 +1973,3 @@

  	return(inode);
  } /* ocfs_get_inode_from_offset */
-
-
-------------- next part --------------
Index: hash.c
===================================================================
--- hash.c	(revision 867)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * hash.c
  *
  * lockid hash, bh sem hash, inode hash
@@ -9,12 +11,12 @@
  * modify it under the terms of the GNU General Public
  * License as published by the Free Software Foundation; either
  * version 2 of the License, or (at your option) any later version.
- * 
+ *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- * 
+ *
  * You should have received a copy of the GNU General Public
  * License along with this program; if not, write to the
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
@@ -687,19 +689,36 @@
 #define ocfs_bh_sem_hash_fn(_b)   \
 	(_hashfn((unsigned int)BH_GET_DEVICE((_b)), (_b)->b_blocknr) & ocfs_bh_hash_shift)
 
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
+	/* Get 4 ( = pow(2, 2) ) pages of memory. */
 	OcfsGlobalCtxt.bh_sem_hash = (struct list_head *)__get_free_pages(GFP_KERNEL, 2);
 	if (!OcfsGlobalCtxt.bh_sem_hash) {
 		LOG_ERROR_STR("ENOMEM allocating ocfs_bh_sem_hash");
 		ret = -ENOMEM;
 		goto bail;
 	}
+	/* Keep track of how many buckets we have spots for in our hash table
+	 * */
 	OcfsGlobalCtxt.bh_sem_hash_sz = (PAGE_SIZE * 4) / sizeof(struct list_head);
-
+	/* Setup all our buckets, so that they have properly initialized lists
+	 * */
 	for (i=OcfsGlobalCtxt.bh_sem_hash_sz-1; i>=0; i--)
 		INIT_LIST_HEAD(&OcfsGlobalCtxt.bh_sem_hash[i]);
 
@@ -728,15 +747,25 @@
 	return 0;
 }
 
-
+/*
+ * ocfs_bh_sem_lookup()
+ *
+ * Lookup the semaphore for our buffer head.  If one does NOT exist then we
+ * will create it and add it to the buffer head semaphore hash table.
+ */
 ocfs_bh_sem * ocfs_bh_sem_lookup(struct buffer_head *bh)
 {
 	int depth, bucket;
 	struct list_head *head, *iter = NULL;
 	ocfs_bh_sem *sem = NULL, *newsem = NULL;
 
+	/* Figure out which bucket our buffer head is in and then get the list
+	 * of semaphores for that bucket */
 	bucket = ocfs_bh_sem_hash_fn(bh);
 	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
+
+/* We will jump to this point after we add a new semaphore for an entry that
+ * was not prexisting in the hash table */
 again:
 	depth = 0;
 	spin_lock (&OcfsGlobalCtxt.bh_sem_hash_lock);
@@ -744,11 +773,20 @@
 	list_for_each(iter, head) {
 		if (++depth > OCFS_BH_SEM_HASH_PRUNE_TRIGGER) {
 			/* Grandma, what a long list you have? */
+			/* Make this list the one that should be pruned next
+			 * time pruning is done. */
 			atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, bucket);
 		}
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
+		/* Is this the correct semaphore for our buffer head? */
 		if (sem->s_blocknr == bh->b_blocknr &&
 		    sem->s_dev == BH_GET_DEVICE(bh)) {
+			/* We have found our semaphore. */
+
+			/* We want to make sure that if nobody is currently
+			 * using the semaphore that there should be no buffer
+			 * head associated with it.  If it isn't being used
+			 * then we can use it for our buffer head */
 			if (atomic_read(&sem->s_refcnt)==0) {
 				if (sem->s_bh) {
 					LOG_ERROR_STR("refcount was zero but s_bh not NULL!");
@@ -757,6 +795,9 @@
 				get_bh(bh);
 				sem->s_bh = bh;
 			}
+			/* Make sure that the buffer head associated with the
+			 * semaphore is our buffer head.  If it isn't then
+			 * something went wrong somewhere :( */
 			if (sem->s_bh != bh) {
 				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%lu,%lu), new(%p,%lu)\n",
 					       sem->s_bh, sem->s_bh ? sem->s_bh->b_blocknr : 0, 
@@ -768,8 +809,13 @@
 		sem = NULL;
 	}
 
+/* TODO: Should "again:" be moved here? Or should the logic of this be moved
+ * down below? */
 	if (newsem && !sem) {
-		/* second pass, we are first to insert */
+		/* We have gone through the list a second time and did not find
+		 * our list item.  Though it seem obvious that we wouldn't find
+		 * it in the second pass since we didn't add it to the list.
+		 * So not sure why we go through the list a second time?? */
 		sem = newsem;
 		list_add(&sem->s_list, head);
 		get_bh(bh);
@@ -777,10 +823,14 @@
 	}
 
 	if (sem) {
-		/* found something on first or second pass */
+		/* We have found a match, either on the first time through or
+		 * we created a semaphore and added it to the list on the
+		 * second time through.  */
+
 		ocfs_bh_sem_get(sem);
 		if (newsem != sem) {
-			/* if not just added, mru to front */
+			/* if it wasn't just added, the Most Recently Used goes
+			 * to the front of the list */
 			list_del(&sem->s_list);
 			list_add(&sem->s_list, head);
 		}
@@ -788,17 +838,25 @@
 		//	      sem->s_bh->b_blocknr,
 		//	      buffer_modified(sem->s_bh) ? "true" : "false",
 		//	      sem->s_pid);
-			      
+
 		if (buffer_modified(sem->s_bh) && sem->s_pid == 0) {
 			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%d)\n", 
 				       newsem != sem ? "n old" : " new",
 				       sem->s_bh->b_blocknr);
 		}
 	} else {
-		/* first pass. not found. do alloc */
+		/* We went through the list and did NOT find a match for our
+		 * buffer head.  So now we need to create a new semaphore and
+		 * then go back and go through the list again. */
 		spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
+		/* Create our new semaphore */
 		newsem = ocfs_bh_sem_alloc();
 		if (newsem) {
+			/* Setup the new semaphore.  When a new semaphore is
+			 * created we don't yet assign our buffer head to it.
+			 * We just set the refcnt to 0 and set the block # and
+			 * device.  The buffer head will get put into place
+			 * above. */
 			newsem->s_bh = NULL;
 			atomic_set(&newsem->s_refcnt, 0);
 			newsem->s_blocknr = bh->b_blocknr;
@@ -809,8 +867,12 @@
 #ifdef BH_SEM_DEBUG
 			memset(&newsem->s_modifier[0], 0, 40);
 #endif
+			/* Go back and look up the semaphore again.  It is
+			 * there now since we have just created it */
 			goto again;
 		}
+		/* ERROR.  Shouldn't get here.  If we did then we failed to
+		 * allocate a semaphore. */
 		sem = NULL;
 		goto bail;
 	}
@@ -822,7 +884,7 @@
 		ocfs_bh_sem_free(newsem);
 	}
 
-bail:	
+bail:
 	return sem;
 }
 
@@ -919,8 +981,18 @@
 }
 
 
-/* returns number of pruned entries */
-int ocfs_bh_sem_hash_prune()
+/*
+ * ocfs_bh_sem_hash_prune()
+ *
+ * This function will prune the semaphore hash list.  If
+ * OcfsGlobalCtxt.bh_sem_hash_target_bucket is a valid bucket then the list
+ * contained in that bucket will be pruned.  Otherwise if we have gone through
+ * this function more than 10 times without doing a mandatory prune then we will
+ * do a prune of a random bucket.
+ *
+ * returns number of pruned entries
+ */
+int ocfs_bh_sem_hash_prune(void)
 {
 	unsigned int bucket;
 	int pruned = 0, mandatory=0;
@@ -928,16 +1000,24 @@
 	ocfs_bh_sem *sem = NULL;
 	LIST_HEAD(tmp);
 
+	/* Every 10 times through this function we will force a prune to be done
+	 * */
 	atomic_inc(&OcfsGlobalCtxt.bh_sem_hash_num_iters);
        	if (atomic_read(&OcfsGlobalCtxt.bh_sem_hash_num_iters) > 10) {
 		mandatory = 1;
 		atomic_sub(10, &OcfsGlobalCtxt.bh_sem_hash_num_iters);
 	}
 
-	/* The better to prune you with, my dear! */
+	/* Get the bucket that we are supposed to prune.  If it is -1 then we
+	 * don't have any bucket specified.  In that case, if we have gone
+	 * through 10 or more times time through this function without a
+	 * mandatory prune then we will randomly pick a bucket and do a prune on
+	 * it */
 	bucket = atomic_read(&OcfsGlobalCtxt.bh_sem_hash_target_bucket);
 	if (bucket == -1) {
 		if (mandatory) {
+			/* Pruning is mandatory.  Pick a random bucket and prune
+			 * it. */
 			get_random_bytes(&bucket, sizeof(bucket));
 			bucket %= OcfsGlobalCtxt.bh_sem_hash_sz;
 		} else {
@@ -948,6 +1028,8 @@
 
 	spin_lock(&OcfsGlobalCtxt.bh_sem_hash_lock);
 
+	/* FIXME: BUG: This seems to kill the mandatory pruning that is setup
+	 * above */
 	bucket = atomic_read(&OcfsGlobalCtxt.bh_sem_hash_target_bucket);
 	if (bucket == -1) {
 		spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
@@ -958,7 +1040,10 @@
 	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
 	pruned = 0;
 
-	/* run in lru order */
+	/* We need to get the Least Recently Used (LRU) entries from our list.
+	 * We look for entries that are not being used and then delete them from
+	 * the list and move them into a temporary list that we will use later
+	 * to actually delete the semaphores from memory.  */
 	list_for_each_prev_safe(iter, tmpiter, head) {
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
 		if (atomic_read(&sem->s_refcnt) < 1) {
@@ -973,6 +1058,8 @@
 
 	spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
 
+	/* Go through the list of unused semaphores and free the memory being
+	 * used by each semaphore */
 	list_for_each_safe(iter, tmpiter, &tmp) {
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
 		if (sem->s_bh) {
@@ -1034,7 +1121,18 @@
 	return found;
 } /* ocfs_bh_sem_hash_cleanup_pid() */
 
-/* returns number of missed entries */
+/* ocfs_bh_sem_hash_prune_all()
+ *
+ * Goes through and removes all semaphores in the semaphore hash table which are
+ * not being used.
+ *
+ * - Returns number of missed entries.  Missed entries are ones that are still
+ * - being referenced and were not able to be pruned.
+ *
+ * This function has an assumption that all the entries should be available to
+ * be removed.  If it finds some which are not available to be removed it will
+ * log that information.
+ */
 int ocfs_bh_sem_hash_prune_all()
 {
 	int bucket, missed;
@@ -1045,39 +1143,46 @@
 	missed = 0;
 	bucket = 0;
 	spin_lock(&OcfsGlobalCtxt.bh_sem_hash_lock);
+	/* Turn off pruning for the ocfs_bh_sem_hash_prune() function */
 	atomic_set(&OcfsGlobalCtxt.bh_sem_hash_target_bucket, -1);
-again:
-	head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
 
-	/* run in lru order */
-	list_for_each_prev_safe(iter, tmpiter, head) {
-		sem = list_entry (iter, ocfs_bh_sem, s_list);
-		if (atomic_read(&sem->s_refcnt) < 1) {
-			if (sem->s_bh) {
-				LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%lu, count=%d\n",
-					       sem->s_bh->b_blocknr, atomic_read(&sem->s_bh->b_count));
+	/* Go through every bucket and move all the semaphores which are not
+	 * being used to a temporary list.  Keep a count of all the semaphores
+	 * which are still being used and thus can not be moved. */
+	do {
+		head = &OcfsGlobalCtxt.bh_sem_hash[bucket];
+
+		/* run in lru order */
+		list_for_each_prev_safe(iter, tmpiter, head) {
+			sem = list_entry (iter, ocfs_bh_sem, s_list);
+			if (atomic_read(&sem->s_refcnt) < 1) {
+				if (sem->s_bh) {
+					LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%lu, count=%d\n",
+						       sem->s_bh->b_blocknr, atomic_read(&sem->s_bh->b_count));
+				}
+				list_del(&sem->s_list);
+				list_add(&sem->s_list, &tmp);
+			} else {
+				missed++;
+				LOG_TRACE_ARGS("missed block %lu, refcount %u, "
+					       "pid = %u\n",
+					       sem->s_blocknr, 
+					       sem->s_refcnt,
+					       sem->s_pid);
 			}
-			list_del(&sem->s_list);
-			list_add(&sem->s_list, &tmp);
-		} else {
-			missed++;
-			LOG_TRACE_ARGS("missed block %lu, refcount %u, "
-				       "pid = %u\n",
-				       sem->s_blocknr, 
-				       sem->s_refcnt,
-				       sem->s_pid);
 		}
-	}
+	} while ( ++bucket < OcfsGlobalCtxt.bh_sem_hash_sz );
 
-	if (++bucket < OcfsGlobalCtxt.bh_sem_hash_sz)
-		goto again;
-
 	LOG_TRACE_ARGS("finished pruning, missed %d entries\n", missed);
 
 	spin_unlock (&OcfsGlobalCtxt.bh_sem_hash_lock);
 
+	/* Go through our temporary list of semaphores which are unused and
+	 * release the memory associated with them */
 	list_for_each_safe(iter, tmpiter, &tmp) {
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
+		/* FIXME: REDUNDANT: This seems to duplicate the error message
+		 * printed above for the same condition */
 		if (sem->s_bh) {
 			LOG_ERROR_STR("s_bh is NOT NULL");
 			BUG();
@@ -1868,5 +1973,3 @@
 
 	return(inode);
 } /* ocfs_get_inode_from_offset */
-
-
