From: Christoph Hellwig <hch@lst.de>
Date: Sat Sep  4 05:26:18 2004
Subject: [Ocfs2-devel] [PATCH] remove flags parameter to write_bh(s)
Message-ID: <20040904102612.GA18894@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/super.c
===================================================================
--- src/super.c	(revision 1426)
+++ src/super.c	(working copy)
@@ -1273,7 +1271,7 @@
 	publish->mounted = value;
 
 	/* write it back out */
-	status = ocfs_write_bh(osb, publish_bh, 0, NULL);
+	status = ocfs_write_bh(osb, publish_bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto done;
@@ -1678,7 +1676,7 @@
 
 	publish = NULL;
 
-	status = ocfs_write_bh (osb, publish_bh, 0, NULL);
+	status = ocfs_write_bh (osb, publish_bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
Index: src/heartbeat.c
===================================================================
--- src/heartbeat.c	(revision 1426)
+++ src/heartbeat.c	(working copy)
@@ -98,7 +98,7 @@
 		publish->comm_seq_num = OcfsGlobalCtxt.comm_seq_num;
 		spin_unlock (&OcfsGlobalCtxt.comm_seq_lock);
 
-		status = ocfs_write_bh(osb, *pub_bh, 0, NULL);
+		status = ocfs_write_bh(osb, *pub_bh, NULL);
 		if (status < 0) {
 			LOG_ERROR_STATUS (status);
 			goto finally;
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1426)
+++ src/journal.c	(working copy)
@@ -1863,7 +1863,7 @@
 	publish->mounted = 0;
 
 	/* Write the publish sector */
-	status = ocfs_write_bh(osb, publish_bh, 0, NULL);
+	status = ocfs_write_bh(osb, publish_bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1426)
+++ src/dlm.c	(working copy)
@@ -92,7 +92,7 @@
 	}
 
 	if (changed) {
-		status = ocfs_write_bh (osb, bh, 0, inode);
+		status = ocfs_write_bh (osb, bh, inode);
 		if (status < 0) 
 			LOG_ERROR_STATUS (status);
 	}
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 1426)
+++ src/volcfg.c	(working copy)
@@ -84,7 +84,7 @@
 	offset = cfg_task->lock_off;
 
 	/* Write the sector back */
-	status = ocfs_write_bh(osb, bh, 0, NULL);
+	status = ocfs_write_bh(osb, bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		/* deliberate no exit jump here */
@@ -185,7 +185,7 @@
 	memcpy (cfg_bhs[node_num]->b_data, new_disk_node, osb->sb->s_blocksize);
 
 	/* Write the new node details on disk */
-	status = ocfs_write_bh(osb, cfg_bhs[node_num], 0, NULL);
+	status = ocfs_write_bh(osb, cfg_bhs[node_num], NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
@@ -253,7 +253,7 @@
 	/* Write the nodecfg hdr into the second sector of newcfg also. */
 	/* We do so so that we can read the nodecfg hdr easily when we */
 	/* read the publish sector, for e.g. in ocfs_nm_thread() */
-	status = ocfs_write_bhs(osb, node_cfg_bhs, 2, 0, NULL);
+	status = ocfs_write_bhs(osb, node_cfg_bhs, 2, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto bail;
@@ -359,7 +359,7 @@
 			memcpy(cfg_buf, disk_lock, osb->sb->s_blocksize);
 		
 			/* Write into volcfg lock sector... */
-			status = ocfs_write_bh(osb, bh, 0, NULL);
+			status = ocfs_write_bh(osb, bh, NULL);
 			if (status < 0) {
 				LOG_ERROR_STATUS (status);
 				goto finito;
@@ -466,7 +466,7 @@
 	memset (bh->b_data, 0, osb->sb->s_blocksize);
 
 	/* Release the lock */
-	status = ocfs_write_bh(osb, bh, 0, NULL);
+	status = ocfs_write_bh(osb, bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
@@ -483,7 +483,7 @@
 	memset (bh->b_data, 0, osb->sb->s_blocksize);
 
 	/* Release the lock */
-	status = ocfs_write_bh(osb, bh, 0, NULL);
+	status = ocfs_write_bh(osb, bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
@@ -604,7 +604,7 @@
 
 	memcpy(bh->b_data, disk, osb->sb->s_blocksize);
 
-	status = ocfs_write_bh(osb, bh, 0, NULL);
+	status = ocfs_write_bh(osb, bh, NULL);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 1426)
+++ src/nm.c	(working copy)
@@ -928,7 +928,7 @@
 
 		/* need to do the write only if fe lock values
 		 * need to change */
-		status = ocfs_write_bh(osb, fe_bh, 0, inode);
+		status = ocfs_write_bh(osb, fe_bh, inode);
 		if (status < 0) {
 			LOG_ERROR_STATUS (status);
 			brelse(fe_bh);
Index: src/file.c
===================================================================
--- src/file.c	(revision 1426)
+++ src/file.c	(working copy)
@@ -1182,7 +1182,7 @@
 				break;
 
 			//LOG_TRACE_ARGS("writing %d blocks\n", i);
-			status = ocfs_write_bhs(osb, bhs, i, 0, 
+			status = ocfs_write_bhs(osb, bhs, i,
 						system_file ? inode : NULL);
 			if (status) {
 				LOG_ERROR_STATUS(status);
Index: src/buffer_head_io.c
===================================================================
--- src/buffer_head_io.c	(revision 1426)
+++ src/buffer_head_io.c	(working copy)
@@ -64,7 +64,7 @@
 }
 
 int ocfs_write_bhs (ocfs_super *osb, struct buffer_head *bhs[], 
-		    int nr, int flags, struct inode *inode)
+		    int nr, struct inode *inode)
 {
 	int status = 0;
 	int i;
@@ -75,8 +75,8 @@
 	my_timing_t begin, end; 
 #endif
 	
-	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %llu, nr=%d, flags=%u, inode=%p)\n", 
-		       (unsigned long long)bhs[0]->b_blocknr, nr, flags, inode);
+	LOG_ENTRY_ARGS("(bh[0]->b_blocknr = %llu, nr=%d, inode=%p)\n", 
+		       (unsigned long long)bhs[0]->b_blocknr, nr, inode);
 #ifdef OCFS_DBG_TIMING
 	rdtsc (begin.lohi[0], begin.lohi[1]);
 #endif
@@ -94,17 +94,6 @@
 
 	sb = osb->sb;
 
-	/* we don't ever want cached writes -- those should go to the
-	 * journal so we can control when they actually hit disk and
-	 * so we can make sure they never get overwritten by a
-	 * subsequent read. */
-	if (flags & OCFS_BH_CACHED) {
-		LOG_TRACE_STR("asking for a cached write!");
-		status = -EINVAL;
-		LOG_ERROR_STATUS(status);
-		goto bail;
-	}
-
 	for (i = 0 ; i < nr ; i++) {
 		bh = bhs[i];
 		if (bh == NULL) {
Index: src/buffer_head_io.h
===================================================================
--- src/buffer_head_io.h	(revision 1426)
+++ src/buffer_head_io.h	(working copy)
@@ -41,7 +41,6 @@
 /* Yosh made me do it. */
 static inline int ocfs_write_bh  (ocfs_super          *osb, 
 				  struct buffer_head  *bh, 
-				  int                  flags, 
 				  struct inode        *inode);
 static inline int ocfs_read_bh   (ocfs_super          *osb, 
 				  __u64                off, 
@@ -52,7 +51,6 @@
 int ocfs_write_bhs (ocfs_super          *osb,
 		    struct buffer_head  *bh[], 
 		    int                  nr, 
-		    int                  flags, 
 		    struct inode        *inode);
 int ocfs_read_bhs  (ocfs_super          *osb, 
 		    __u64                off,
@@ -161,13 +159,13 @@
 } while (0)
 
 static inline int ocfs_write_bh (ocfs_super * osb, struct buffer_head *bh, 
-				 int flags, struct inode *inode)
+				 struct inode *inode)
 {
 	int status;
 	
 	IO_FUNC_TIMING_DECL
 
-	status = ocfs_write_bhs (osb, &bh, 1, flags, inode);
+	status = ocfs_write_bhs (osb, &bh, 1, inode);
 
 	IO_FUNC_TIMING_PRINT("ocfs_write_bh", status);
 
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 1426)
+++ src/alloc.c	(working copy)
@@ -1063,7 +1063,7 @@
 	parent_blk = last_eb_blkno = eb1->h_blkno;
 
 	/* This needs to be a sync write OR journalled to be safe. */
-	status = ocfs_write_bhs(osb, bhs, numbhs, 0, inode);
+	status = ocfs_write_bhs(osb, bhs, numbhs, inode);
 	if (status < 0) {
 		LOG_ERROR_STATUS (status);
 		goto finally;
@@ -4197,7 +4197,7 @@
 	alloc = (ocfs2_dinode *) alloc_bh->b_data;
 	ocfs_clear_local_alloc(alloc);
 
-	status = ocfs_write_bh(osb, alloc_bh, 0, inode);
+	status = ocfs_write_bh(osb, alloc_bh, inode);
 	if (status < 0)
 		LOG_ERROR_STATUS(status);
 
