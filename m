From: Christoph Hellwig <hch@lst.de>
Date: Mon Sep 20 06:50:04 2004
Subject: [Ocfs2-devel] [PATCH] cleanup ocfs_file_open
Message-ID: <20040920114955.GA23671@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 - use a local ocfs_inode_private variable instead of using OCFS_I
   a million times
 - remove PURE_EVIL hack
 - remove unuse variable fe_bh


Index: src/file.c
===================================================================
--- src/file.c	(revision 1475)
+++ src/file.c	(working copy)
@@ -120,44 +120,35 @@
 {
 	int ret =0, err = 0, status = 0, first_open = 0;
 	int mode = file->f_flags;
-	ocfs_super *osb = NULL;
-	struct buffer_head *fe_bh = NULL;
+	ocfs_super *osb = OCFS_SB(inode->i_sb);
+	ocfs_inode_private *oip = OCFS_I(inode);
 
 	LOG_ENTRY_ARGS ("(0x%p, 0x%p, '%*s')\n", inode, file, 
 			file->f_dentry->d_name.len, 
 			file->f_dentry->d_name.name);
 
-	osb = OCFS_SB(inode->i_sb);
-
-#ifdef PURE_EVIL	
-	if (evil_filename_check(EVIL_FILE, file)) {
-		LOG_ERROR_ARGS("EVIL FOPEN: mode=%d\n", mode);
-	}
-#endif
-
 	if (osb->osb_flags & OCFS_OSB_FLAGS_SHUTDOWN) {
 		LOG_ERROR_STR ("Volume has been shutdown");
 		status = -EACCES;
 		goto leave;
 	}
 
-	if (atomic_read(&OCFS_I(inode)->ip_needs_verification)) {
-		down_read (&(OCFS_I(inode)->ip_io_sem));
+	if (atomic_read(&oip->ip_needs_verification)) {
+		down_read (&oip->ip_io_sem);
 		status = ocfs_verify_update_inode (osb, inode);
-		up_read (&(OCFS_I(inode)->ip_io_sem));
+		up_read(&oip->ip_io_sem);
 		if (status < 0) {
 			LOG_ERROR_STATUS (status);
 			goto leave;
 		}
 	}
 
-	down(&(OCFS_I(inode)->ip_sem));
-	if (!OCFS_I(inode)->ip_open_cnt) {
+	down(&oip->ip_sem);
+	if (!oip->ip_open_cnt++) {
 		first_open = 1;
-		OCFS_I(inode)->ip_open_flags |= OCFS_IN_FIRST_OPEN;
+		oip->ip_open_flags |= OCFS_IN_FIRST_OPEN;
 	}
-	OCFS_I(inode)->ip_open_cnt++;
-	up(&(OCFS_I(inode)->ip_sem));
+	up(&oip->ip_sem);
 
 	if (!first_open)
 		status = ocfs_wait_on_first_open(osb, inode);
@@ -165,8 +156,8 @@
 	if (status < 0) {
 		if (status != -EINTR)
 			LOG_ERROR_STATUS(status);
-		down(&(OCFS_I(inode)->ip_sem));
-		OCFS_I(inode)->ip_open_cnt--;
+		down(&oip->ip_sem);
+		oip->ip_open_cnt--;
 		goto leave_unlock;
 	}
 
@@ -179,37 +170,37 @@
 	    && (first_open || (mode & (O_WRONLY|O_RDWR))))
 		status = ocfs_notify_on_open(osb, inode);
 
-	down (&(OCFS_I(inode)->ip_sem));
+	down(&oip->ip_sem);
 	if (first_open) {
-		OCFS_I(inode)->ip_open_flags &= ~OCFS_IN_FIRST_OPEN;
+		oip->ip_open_flags &= ~OCFS_IN_FIRST_OPEN;
 		ocfs_notify_openers(osb);
 	}
 
 	if (status < 0) {
-		OCFS_I(inode)->ip_open_cnt--;
+		oip->ip_open_cnt--;
 		LOG_ERROR_STATUS(status);
 		goto leave_unlock;
 	}
 
-	if (OCFS_I(inode)->ip_open_cnt > 1) {
+	if (oip->ip_open_cnt > 1) {
 		/*  We're not the only person who has it open right
 		 *  now so lets check whether the requested
 		 *  access/share access conflicts with the existing
 		 *  open operations. */
 
 		LOG_TRACE_ARGS ("oin->ip_open_cnt > 0! : %u\n", 
-				OCFS_I(inode)->ip_open_cnt);
+				oip->ip_open_cnt);
 		if (!(mode & O_DIRECT)) {
-			if ((OCFS_I(inode)->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO) && !(mode & O_RDONLY)) {
-				OCFS_I(inode)->ip_open_cnt--;
+			if ((oip->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO) && !(mode & O_RDONLY)) {
+				oip->ip_open_cnt--;
 				status = -EACCES;
 				LOG_TRACE_STR("file is already open O_DIRECT, "
 						"cannot open non O_DIRECT");
 				goto leave_unlock;
 			}
 		} else if (mode & O_DIRECT) {
-			if (!(OCFS_I(inode)->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO)) {
-				OCFS_I(inode)->ip_open_cnt--;
+			if (!(oip->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO)) {
+				oip->ip_open_cnt--;
 				status = -EACCES;
 				LOG_TRACE_STR("file is already open non "  \
 					      "O_DIRECT, cannot open "     \
@@ -220,18 +211,14 @@
 		status = 0;
 	} else {
 		if (mode & O_DIRECT)
-			OCFS_SET_FLAG(OCFS_I(inode)->ip_open_flags, OCFS_OIN_OPEN_FOR_DIRECTIO);
+			OCFS_SET_FLAG(oip->ip_open_flags, OCFS_OIN_OPEN_FOR_DIRECTIO);
 		else
-			OCFS_CLEAR_FLAG(OCFS_I(inode)->ip_open_flags, OCFS_OIN_OPEN_FOR_DIRECTIO);
+			OCFS_CLEAR_FLAG(oip->ip_open_flags, OCFS_OIN_OPEN_FOR_DIRECTIO);
 	}
 
 leave_unlock:
-	up (&(OCFS_I(inode)->ip_sem));
+	up(&oip->ip_sem);
 leave:
-
-	if (fe_bh)
-		brelse(fe_bh);
-
 	if (status < 0) {
 		if (status != -ENOENT && status != -ENOMEM &&
 			status != -EACCES && status != -EINTR) {
