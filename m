From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Fri Apr 23 17:48:11 2004
Subject: [Ocfs2-devel] Commenting patch for hash.c
Message-ID: <40899DBB.6080401@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Started going through trying to figure stuff out.

I commented stuff that I didn't quite understand in the beginning.

Index: hash.c
===================================================================
--- hash.c	(revision 865)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
   * hash.c
   *
   * lockid hash, bh sem hash, inode hash
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
@@ -747,8 +776,15 @@
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
@@ -757,6 +793,9 @@
  				get_bh(bh);
  				sem->s_bh = bh;
  			}
+			/* Make sure that the buffer head associated with the
+			 * semaphore is our buffer head.  If it isn't then
+			 * something went wrong somewhere :( */
  			if (sem->s_bh != bh) {
  				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%lu,%lu), new(%p,%lu)\n",
  					       sem->s_bh, sem->s_bh ? sem->s_bh->b_blocknr : 0,
@@ -768,8 +807,13 @@
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
@@ -777,10 +821,14 @@
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
@@ -788,17 +836,25 @@
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
@@ -809,8 +865,12 @@
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
@@ -822,7 +882,7 @@
  		ocfs_bh_sem_free(newsem);
  	}

-bail:	
+bail:
  	return sem;
  }

-------------- next part --------------
Index: super.c
===================================================================
--- super.c	(revision 865)
+++ super.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * super.c
  *
  * load/unload driver, mount/dismount volumes
@@ -375,13 +377,14 @@
 	LOG_ENTRY ();
 
 	ocfs_version_print();
-	
+
 	ocfs_hostname = kmalloc(strlen(system_utsname.nodename) + 1, GFP_KERNEL);
 	if (ocfs_hostname==NULL)
 		return -EINVAL;
 	strcpy(ocfs_hostname, system_utsname.nodename);
 	printk("ocfs2: hostname is %s\n", ocfs_hostname);
-	
+
+	/* Take care of setting up our /proc (and sysctl entries) */
 	ocfs_table_header = register_sysctl_table(ocfs_root_table, 0);
 	if (!ocfs_table_header) {
 		LOG_ERROR_STATUS(status = -ENOMEM);
@@ -395,7 +398,6 @@
         INIT_LIST_HEAD (&(OcfsGlobalCtxt.item_list));
 #endif
 	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));
-	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));
 
 	/* Read remaining insmod params */
 	if ((status = ocfs_read_params ()) < 0)
@@ -415,7 +417,7 @@
 		LOG_ERROR_STATUS (status);
 		goto leave;
 	}
-	
+
 	status = ocfs_bh_sem_hash_init();
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
@@ -962,6 +964,8 @@
 	
 	osb->publ_map |= (1 << osb->node_num);
 	osb->vol_state = VOLUME_INIT;
+	/* Check if first time this partition has been mounted.  If so create
+	   the root Oracle INode. */
 	status = ocfs_create_root_oin (osb, NULL);
 	if (status >= 0)
 		osb->vol_state = VOLUME_ENABLED;
Index: hash.c
===================================================================
--- hash.c	(revision 865)
+++ hash.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * hash.c
  *
  * lockid hash, bh sem hash, inode hash
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
@@ -747,8 +776,15 @@
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
@@ -757,6 +793,9 @@
 				get_bh(bh);
 				sem->s_bh = bh;
 			}
+			/* Make sure that the buffer head associated with the
+			 * semaphore is our buffer head.  If it isn't then
+			 * something went wrong somewhere :( */
 			if (sem->s_bh != bh) {
 				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%lu,%lu), new(%p,%lu)\n",
 					       sem->s_bh, sem->s_bh ? sem->s_bh->b_blocknr : 0, 
@@ -768,8 +807,13 @@
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
@@ -777,10 +821,14 @@
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
@@ -788,17 +836,25 @@
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
@@ -809,8 +865,12 @@
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
@@ -822,7 +882,7 @@
 		ocfs_bh_sem_free(newsem);
 	}
 
-bail:	
+bail:
 	return sem;
 }
 
Index: osb.c
===================================================================
--- osb.c	(revision 865)
+++ osb.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * osb.c
  *
  * Initialize, verify osb
Index: oin.c
===================================================================
--- oin.c	(revision 865)
+++ oin.c	(working copy)
@@ -1,4 +1,6 @@
-/*
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noet sw=8 ts=8 ai tw=80 sts=0:
+ *
  * oin.c
  *
  * Create, verify, release oin
@@ -451,6 +453,11 @@
 
 /* ocfs_create_root_oin()
  *
+ * This function will create the root Oracle INode (OIN) on the file system if
+ * this is the first time that this partition has ever been mounted.
+ *
+ * If this is NOT the first time this partition has been mounted (meaning it
+ * has been mounted before) then this function does nothing.
  */
 int ocfs_create_root_oin (ocfs_super * osb, struct inode *root)
 {
@@ -464,7 +471,15 @@
 
 	LOG_ENTRY ();
 
+	/* Is this the first time this partition has been mounted? */
 	if (osb->vol_layout.root_start_off == 0) {
+		/* This is our first time being mounted.  We need to take care
+		 * of setting up the root Oracle inode.  In order to do this we
+		 * are going to call ocfs_create_root_dir_node.  So we need to
+		 * get the disk offset to the root directory (root_dirnode).
+		 * In order to get that we need to read in the volume header
+		 * from the first sector of the disk.  */
+
 		status = ocfs_wait_for_disk_lock_release (osb, OCFS_VOLUME_LOCK_OFFSET,
 						 10000, OCFS_DLM_NO_LOCK);
 		if (status < 0) {
@@ -476,12 +491,14 @@
 				     OCFS_DLM_EXCLUSIVE_LOCK, FLAG_FILE_CREATE,
 				     &lockres, &bh, NULL);
 		if (status >= 0) {
+			/* Read the volume header from the first sector of the
+			 * partition and put it into our buffer head */
 			status = ocfs_read_bh(osb, 0, &hdr_bh, 0, NULL);
 			if (status < 0)
 				LOG_ERROR_STATUS (status);
 
 			tmpstat = ocfs_release_lock (osb, OCFS_VOLUME_LOCK_OFFSET, OCFS_DLM_EXCLUSIVE_LOCK, 0, lockres, bh, NULL);
-	
+
 			if (bh)
 				brelse(bh);
 
@@ -497,7 +514,13 @@
 				LOG_ERROR_STATUS (status);
 			goto finally;
 		}
-		
+
+		/* Get the volume header data from our buffer head.  We need to
+		 * know the following in order to call
+		 * ocfs_create_root_dir_node():
+		 *      * root_off: disk offset to the ocfs root dirnode
+		 *        (root_directory)
+		 *      * internal_off: disk offset to the data segment */
 		volDiskHdr = (ocfs_vol_disk_hdr *) OCFS_BH_GET_DATA_READ(hdr_bh); /* read */
 		root_off = volDiskHdr->root_off;
 		int_off = volDiskHdr->internal_off;
@@ -507,10 +530,13 @@
 			ocfs_wait_for_disk_lock_release (osb,
 							OCFS_VOLUME_LOCK_OFFSET,
 							30000, OCFS_DLM_NO_LOCK);
+			/* Setup the root_start_off with the correct value so
+			 * that it will not run this function the next time the
+			 * filesystem is mounted.  */
 			osb->vol_layout.root_start_off = root_off;
 			osb->vol_layout.root_int_off = int_off;
 		}
-
+		/* Do all the work in creating our root directory */
 		status = ocfs_create_root_dir_node (osb);
 		if (status < 0) {
 			LOG_ERROR_STATUS (status);
