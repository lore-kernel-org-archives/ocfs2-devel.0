From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] fix printk specifier for block numbers
Message-ID: <20040602083315.GA21125@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In 2.6 block numbers can be 64bit even on 32bit platforms, so use %lld
and cast to a 64bit type first.


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 969)
+++ src/inode.c	(working copy)
@@ -825,7 +825,7 @@
 	__u64 entryOffset;
 	struct buffer_head *bh = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%p, %ld, 0x%p, %d)\n", inode, iblock, bh_result,
+	LOG_ENTRY_ARGS ("(0x%p, %lld, 0x%p, %d)\n", inode, (long long)iblock, bh_result,
 			create);
 
 	if (!inode) {
@@ -836,7 +836,8 @@
 	osb = OCFS_SB(inode->i_sb);
 
 	if ((iblock << 9) > PATH_MAX + 1) {
-		LOG_ERROR_ARGS ("file offset > PATH_MAX: %lu", iblock << 9);
+		LOG_ERROR_ARGS ("file offset > PATH_MAX: %llu",
+				(unsigned long long)iblock << 9);
 		goto bail;
 	}
 
@@ -857,8 +858,8 @@
 
 	if ((iblock << 9) >= (__s64)fe->alloc_size) {
 		OCFS_BH_PUT_DATA(bh);
-		LOG_ERROR_ARGS ("file offset is outside the allocated size: %lu",
-		     iblock << 9);
+		LOG_ERROR_ARGS ("file offset is outside the allocated size: %llu",
+		     (unsigned long long)iblock << 9);
 		goto bail;
 	}
 
@@ -967,8 +968,8 @@
 	__u32 len;
 	int oin_locked = 0;
 
-	LOG_ENTRY_ARGS ("(0x%p, %ld, 0x%p, %d)\n", inode, iblock, bh_result,
-			create);
+	LOG_ENTRY_ARGS ("(0x%p, %lld, 0x%p, %d)\n", inode,
+			(unsigned long long)iblock, bh_result, create);
 
 	if (S_ISLNK (inode->i_mode)) {
 		err = ocfs_symlink_get_block (inode, iblock, bh_result, create);
@@ -1044,7 +1045,7 @@
 	int err = 0;
 	struct inode *inode = mapping->host;
 
-	LOG_ENTRY_ARGS("(block = %lu)\n", block);
+	LOG_ENTRY_ARGS("(block = %llu)\n", (unsigned long long)block);
 
 	if (!inode) {
 		LOG_ERROR_STR ("bmap: bad inode");
Index: src/io.c
===================================================================
--- src/io.c	(revision 969)
+++ src/io.c	(working copy)
@@ -68,8 +68,8 @@
 	my_timing_t begin, end; 
 #endif
 	
-	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %lu, nr=%d, flags=%u, inode=%p)\n", 
-		       bhs[0]->b_blocknr, nr, flags, inode);
+	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %llu, nr=%d, flags=%u, inode=%p)\n", 
+		       (unsigned long long)bhs[0]->b_blocknr, nr, flags, inode);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
 #endif
@@ -122,12 +122,14 @@
 		 * buffer. */
 		if (!buffer_modified(bh)) {
 			printk("ocfs2: modified bit is NOT set on buffer "
-			       "(bh->b_blocknr = %lu)!\n", bh->b_blocknr);
+			       "(bh->b_blocknr = %llu)!\n",
+			       (unsigned long long)bh->b_blocknr);
 			BUG();
 		}
 		if (ocfs_bh_sem_lock_modify(bh) == OCFS_BH_SEM_WAIT_ON_MODIFY){
 			printk("ocfs2: someone else owns this buffer"
-			       "(bh->b_blocknr = %lu)!\n", bh->b_blocknr);
+			       "(bh->b_blocknr = %llu)!\n",
+			       (unsigned long long)bh->b_blocknr);
 			BUG();
 		}
 		ocfs_bh_sem_unlock(bh);
@@ -136,8 +138,8 @@
 		if (!(flags & OCFS_BH_IGNORE_JBD) && buffer_jbd(bh)) {
 #ifdef VERBOSE_BH_JBD_TRACE
 			LOG_TRACE_ARGS("trying to write a jbd managed bh "
-				       "(blocknr = %lu), nr=%d\n", 
-				       bh->b_blocknr, nr);
+				       "(blocknr = %llu), nr=%d\n", 
+				       (unsigned long long)bh->b_blocknr, nr);
 #endif
 			continue;
 		}
@@ -270,8 +272,9 @@
 		if (flags & OCFS_BH_CACHED && inode && 
 		    !TEST_BH_SEQNUM(inode, bh)) {
 #ifdef VERBOSE_BH_SEQNUM_TRACE
-			LOG_TRACE_ARGS("(read) bh (%lu) seqnum (%lu) does not "
-				       "match inode (%u)\n", bh->b_blocknr, 
+			LOG_TRACE_ARGS("(read) bh (%llu) seqnum (%lu) does not "
+				       "match inode (%u)\n",
+				       (unsigned long long)bh->b_blocknr, 
 				       (bh->b_state & STATE_BIT_MASK) >> 19,
 				       atomic_read(GET_INODE_CLEAN_SEQ(inode)));
 #endif
@@ -285,8 +288,8 @@
 #ifdef VERBOSE_BH_JBD_TRACE
 			if (!(flags & OCFS_BH_CACHED) || ignore_cache)
 				LOG_TRACE_ARGS("trying to sync read a jbd "
-					       "managed bh (blocknr = %lu)\n",
-					       bh->b_blocknr);
+					       "managed bh (blocknr = %llu)\n",
+					       (unsigned long long)bh->b_blocknr);
 #endif
 			continue;
 		}
@@ -296,8 +299,8 @@
 				/* This should probably be a BUG, or
 				 * at least return an error. */
 				LOG_TRACE_ARGS("asking me to sync read a "
-					      "dirty buffer! (blocknr = %lu)\n",
-					      bh->b_blocknr);
+					      "dirty buffer! (blocknr = %llu)\n",
+					      (unsigned long long)bh->b_blocknr);
 				continue;
 			}
 
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 969)
+++ src/journal.c	(working copy)
@@ -603,9 +603,9 @@
 			CLEAR_BH_SEQNUM(bh);
 
 			if (buffer_jbd(bh))
-				LOG_ERROR_ARGS("Buffer %lu has JBD bit set "
+				LOG_ERROR_ARGS("Buffer %llu has JBD bit set "
 					       "after a journal_forget!\n",
-					       bh->b_blocknr);
+					       (unsigned long long)bh->b_blocknr);
 
 			lock_buffer(bh);
 			clear_buffer_uptodate(bh);
@@ -698,9 +698,9 @@
 	int i;
 	int found = 0;
 
-	LOG_ENTRY_ARGS("(bh->b_blocknr=%lu, type=%d (\"%s\"), "
+	LOG_ENTRY_ARGS("(bh->b_blocknr=%llu, type=%d (\"%s\"), "
 		       "bh->b_size = %hu)\n", 
-		       bh->b_blocknr, type, 
+		       (unsigned long long)bh->b_blocknr, type, 
 		       (type == OCFS_JOURNAL_ACCESS_CREATE) ? 
 		       "OCFS_JOURNAL_ACCESS_CREATE" : 
 		       "OCFS_JOURNAL_ACCESS_WRITE", bh->b_size);
@@ -708,7 +708,8 @@
 	/* we can safely remove this assertion after testing. */
 	if (!buffer_uptodate(bh)) {
 		printk("ocfs2: giving me a buffer that's not uptodate!\n");
-		printk("ocfs2: b_blocknr=%lu\n", bh->b_blocknr);
+		printk("ocfs2: b_blocknr=%llu\n",
+				(unsigned long long)bh->b_blocknr);
 		BUG();
 	}
 	/* by taking a "read" lock, we prevent anyone from doing any
@@ -743,8 +744,9 @@
 		 *
 		 * Otherwise, we make a copy of the data in the buffer. */
 		if (!buffer_jbd(bh) && type == OCFS_JOURNAL_ACCESS_CREATE) {
-			LOG_TRACE_ARGS("Making block (%lu) a forget block at "
-				       "position %d\n", bh->b_blocknr, i);
+			LOG_TRACE_ARGS("Making block (%llu) a forget block at "
+				       "position %d\n",
+				       (unsigned long long)bh->b_blocknr, i);
 			handle->co_buffs[i].data = NULL;
 			handle->co_buffs[i].forget = 1;
 		} else {
@@ -811,7 +813,8 @@
 	int status = -1;
 	int i;
 
-	LOG_ENTRY_ARGS("(bh->b_blocknr=%lu)\n", bh->b_blocknr);
+	LOG_ENTRY_ARGS("(bh->b_blocknr=%llu)\n",
+			(unsigned long long)bh->b_blocknr);
 
 	if (handle->num_buffs >= handle->max_buffs) {
 		LOG_ERROR_STR("Cannot add buffer to full transaction!");
@@ -824,8 +827,9 @@
 	 */
 	for(i = 0; i < handle->num_buffs; i++) {
 		if (handle->buffs[i] == bh) {
-			LOG_TRACE_ARGS("block (%lu) already added to dirty "  \
-				       "list!\n", bh->b_blocknr);
+			LOG_TRACE_ARGS("block (%llu) already added to dirty "  \
+				       "list!\n",
+				       (unsigned long long)bh->b_blocknr);
 			goto call_jbd;
 		}
 	}
@@ -844,7 +848,8 @@
 	status = journal_dirty_metadata(handle->k_handle, bh);
 	if (status < 0) {
 		LOG_ERROR_ARGS("Could not dirty metadata buffer. "
-			       "(bh->b_blocknr=%lu)\n", bh->b_blocknr);
+			       "(bh->b_blocknr=%llu)\n",
+			       (unsigned long long)bh->b_blocknr);
 		LOG_TRACE_ARGS("Setting handle->buffs[%d] = NULL\n", i);
 		brelse(bh);
 		handle->buffs[i] = NULL;
@@ -867,7 +872,8 @@
 {
 	ocfs_journal_lock *lock;
 
-	LOG_ENTRY_ARGS("(id=%lu, type=%u, flags=%u, bh=%p)\n", bh->b_blocknr, type, flags, bh);
+	LOG_ENTRY_ARGS("(id=%llu, type=%u, flags=%u, bh=%p)\n",
+			(unsigned long long)bh->b_blocknr, type, flags, bh);
 
 	lock = ocfs_malloc(sizeof(ocfs_journal_lock));
 	if (lock == NULL) {
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 969)
+++ src/dlm.c	(working copy)
@@ -1223,8 +1223,8 @@
 		if (OCFS_BH_GET_DATA_WRITE_TRYLOCK(bh) == NULL) {
 			tries++;
 			ocfs_release_lockres(lockres); // ocfs_release_lock
-			LOG_ERROR_ARGS("failed to get bh sem (%lu), attempt %d, trying again\n",
-				       bh->b_blocknr, tries);
+			LOG_ERROR_ARGS("failed to get bh sem (%llu), attempt %d, trying again\n",
+				       (unsigned long long)bh->b_blocknr, tries);
 			ocfs_sleep(100);
 			goto again;
 		}
Index: src/dir.c
===================================================================
--- src/dir.c	(revision 969)
+++ src/dir.c	(working copy)
@@ -83,7 +83,8 @@
 
 		if (buf) {
 #warning take this out later
-			LOG_ERROR_ARGS("uhoh!  buf not null... block=%lu\n", bh->b_blocknr);
+			LOG_ERROR_ARGS("uhoh!  buf not null... block=%llu\n",
+					(unsigned long long)bh->b_blocknr);
 			BUG();
 		}
 		buf = OCFS_BH_GET_DATA_READ(bh); /* read */
Index: src/hash.c
===================================================================
--- src/hash.c	(revision 969)
+++ src/hash.c	(working copy)
@@ -68,8 +68,8 @@
 {
 	if (atomic_dec_and_lock(&sem->s_refcnt, &OcfsGlobalCtxt.bh_sem_hash_lock)) {
 		if (buffer_modified(sem->s_bh)) {
-			LOG_ERROR_ARGS("putting last refcount of a modified buffer!  block %lu\n",
-				       sem->s_bh->b_blocknr);
+			LOG_ERROR_ARGS("putting last refcount of a modified buffer!  block %llu\n",
+				       (unsigned long long)sem->s_bh->b_blocknr);
 		}
 		put_bh(sem->s_bh);
 		sem->s_bh = NULL;
@@ -167,9 +167,11 @@
 				sem->s_bh = bh;
 			}
 			if (sem->s_bh != bh) {
-				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%lu,%lu), new(%p,%lu)\n",
-					       sem->s_bh, sem->s_bh ? sem->s_bh->b_blocknr : 0, 
-					       sem->s_blocknr, bh, bh->b_blocknr);
+				LOG_ERROR_ARGS("bad bh_sem->bh: sem(%p,%llu,%lu), new(%p,%llu)\n",
+					       sem->s_bh, sem->s_bh ?
+					       (unsigned long long)sem->s_bh->b_blocknr : 0ULL, 
+					       sem->s_blocknr, bh,
+					       (unsigned long long)bh->b_blocknr);
 				BUG();
 			}
 			break;
@@ -199,9 +201,9 @@
 		//	      sem->s_pid);
 			      
 		if (buffer_modified(sem->s_bh) && sem->s_pid == 0) {
-			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%lu)\n", 
+			LOG_ERROR_ARGS("found a%s sem with a modified bh but no pid!!! (block=%llu)\n", 
 				       newsem != sem ? "n old" : " new",
-				       sem->s_bh->b_blocknr);
+				       (unsigned long long)sem->s_bh->b_blocknr);
 		}
 	} else {
 		/* first pass. not found. do alloc */
@@ -424,8 +426,9 @@
 			/* only do one buffer at a time. */
 			spin_unlock(&OcfsGlobalCtxt.bh_sem_hash_lock);
 
-			LOG_ERROR_ARGS("blocknr = %lu, pid = %d\n", 
-				       sem->s_bh->b_blocknr, pid);
+			LOG_ERROR_ARGS("blocknr = %llu, pid = %d\n", 
+				       (unsigned long long)sem->s_bh->b_blocknr,
+				       pid);
 			ocfs_clear_buffer_modified(sem->s_bh);
 			ocfs_bh_sem_put(sem);
 			goto again;
@@ -466,8 +469,9 @@
 		sem = list_entry (iter, ocfs_bh_sem, s_list);
 		if (atomic_read(&sem->s_refcnt) < 1) {
 			if (sem->s_bh) {
-				LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%lu, count=%d\n",
-					       sem->s_bh->b_blocknr, atomic_read(&sem->s_bh->b_count));
+				LOG_ERROR_ARGS("killing off bh_sem with bh still attached! block=%llu, count=%d\n",
+					       (unsigned long long)sem->s_bh->b_blocknr,
+					       atomic_read(&sem->s_bh->b_count));
 			}
 			list_del(&sem->s_list);
 			list_add(&sem->s_list, &tmp);
@@ -510,8 +514,8 @@
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
 
-	LOG_ENTRY_ARGS("(block=%lu, sem->s_pid=%d)\n", bh->b_blocknr, 
-		       sem->s_pid );
+	LOG_ENTRY_ARGS("(block=%llu, sem->s_pid=%d)\n",
+		       (unsigned long long)bh->b_blocknr, sem->s_pid);
 
 	add_wait_queue(&sem->s_wait, &wait);
 	do {
@@ -546,8 +550,8 @@
 				LOG_ERROR_ARGS("possible deadlock: block=%lu, owner=%d, this=%d, modifier='%s'\n",
 				       bh->b_blocknr, sem->s_pid, current->pid, sem->s_modifier);
 #else
-				LOG_ERROR_ARGS("possible deadlock: block=%lu, owner=%d, this=%d\n",
-				       bh->b_blocknr, sem->s_pid, current->pid);
+				LOG_ERROR_ARGS("possible deadlock: block=%llu, owner=%d, this=%d\n",
+				       (unsigned long long)bh->b_blocknr, sem->s_pid, current->pid);
 #endif
 			}
 		}
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 969)
+++ src/namei.c	(working copy)
@@ -1058,8 +1058,9 @@
 			goto finally;
 		}
 		got_newlock = 1;
-		LOG_ERROR_ARGS("aha rename over existing... new_de=%p newlockid=%llu newfebh=%p bhblocknr=%lu\n",
-			       new_de, newfe_lockid, newfe_bh, newfe_bh ? newfe_bh->b_blocknr : 0);
+		LOG_ERROR_ARGS("aha rename over existing... new_de=%p newlockid=%llu newfebh=%p bhblocknr=%llu\n",
+			       new_de, newfe_lockid, newfe_bh, newfe_bh ?
+			       (unsigned long long)newfe_bh->b_blocknr : 0ULL);
 
 		status = ocfs_journal_access(handle, newfe_bh, OCFS_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
