From: Christoph Hellwig <hch@lst.de>
Date: Mon Aug 30 08:46:38 2004
Subject: [Ocfs2-devel] [PATCH] simplify and cleanup ocfs_file_release
Message-ID: <20040830134633.GA17560@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 - add private variable ocfs_inode_private *oip to get rid of the
   gazillions of OCFS_I calls
 - removed check for root inode - root inode is always a directory
   so the directory check triggers
 - but actually we don't need the directory check either because
   directories can never be opened O_DIRECT
 - remove usage of obsfucation macros for bitmasks
 - clear OCFS_OIN_OPEN_FOR_DIRECTIO unconditionally on last close,
   either it was set or not, after clearing it'll be unset
 - remove "PURE_EVIL"
 - reformat to match kernel coding style


Index: src/file.c
===================================================================
--- src/file.c	(revision 1398)
+++ src/file.c	(working copy)
@@ -256,67 +256,23 @@
 	return ret;
 }				/* ocfs_file_open */
 
-/*
- * ocfs_file_release()
- *
- */
-static int ocfs_file_release (struct inode *inode, struct file *file)
+static int ocfs_file_release(struct inode *inode, struct file *file)
 {
-	ocfs_super * osb;
-	struct dentry *dentry;
-	int last_close = 0;
-	int dec = 0;
+	ocfs_inode_private *oip = OCFS_I(inode);
 
 	LOG_SET_CONTEXT(RELEASE);
-
-	LOG_ENTRY_ARGS ("(0x%p, 0x%p, '%*s')\n", inode, file,
+	LOG_ENTRY_ARGS("(0x%p, 0x%p, '%*s')\n", inode, file,
 			file->f_dentry->d_name.len, file->f_dentry->d_name.name);
 
-	dentry = file->f_dentry;
+	down(&oip->ip_sem);
+	if (!--oip->ip_open_cnt)
+		oip->ip_open_flags &= ~OCFS_OIN_OPEN_FOR_DIRECTIO;
+	up(&oip->ip_sem);
 
-#ifdef PURE_EVIL
-	if (evil_filename_check(EVIL_DENTRY, dentry)) {
-		LOG_ERROR_ARGS("EVIL FRELEASE: mode=%d\n", file->f_flags);
-	}
-#endif
-
-	osb = OCFS_SB(inode->i_sb);
-
-	/* dir */
-	if (S_ISDIR (inode->i_mode)) {
-		/* fix all this - need a real open/close for directories */
-		goto bail;
-	}
-
-	down (&(OCFS_I(inode)->ip_sem));
-	OCFS_I(inode)->ip_open_cnt--;
-	if (!OCFS_I(inode)->ip_open_cnt) 
-		last_close = 1;
-
-	if (inode == osb->root_inode) {
-		up (&(OCFS_I(inode)->ip_sem));
-		goto bail;
-	}
-
-	LOG_TRACE_ARGS ("openhandles: %d / osbfiles: %lld / refcount: %d\n",
-			OCFS_I(inode)->ip_open_cnt, osb->file_open_cnt,
-			atomic_read(&dentry->d_count)); 
-
-	if (last_close 
-	    && (OCFS_I(inode)->ip_open_flags & OCFS_OIN_OPEN_FOR_DIRECTIO))
-		OCFS_CLEAR_FLAG(OCFS_I(inode)->ip_open_flags, 
-				OCFS_OIN_OPEN_FOR_DIRECTIO);
-	up (&(OCFS_I(inode)->ip_sem));
-
-bail:
-	if (dec)
-		iput(inode);
-
-	LOG_EXIT_INT (0);
-
+	LOG_EXIT_INT(0);
 	LOG_CLEAR_CONTEXT();
 	return 0;
-}				/* ocfs_file_release */
+}
 
 /* 
  * ocfs_inode_fill_ext_map()
