From: Christoph Hellwig <hch@lst.de>
Date: Fri Sep  3 04:12:10 2004
Subject: [Ocfs2-devel] [PATCH] remove unused prototypes from file.c
Message-ID: <20040903091205.GB32029@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/file.c
===================================================================
--- src/file.c	(revision 1418)
+++ src/file.c	(working copy)
@@ -53,13 +53,7 @@
 
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_FILE
 
-extern struct semaphore recovery_list_sem;
-extern spinlock_t oin_num_ext_lock;
 
-static int ocfs_change_file_attrib(ocfs_super *osb, struct iattr *attr,
-				   struct inode *inode);
-static int ocfs_truncate_file(ocfs_super *osb, __u64 file_size,
-			      struct inode *inode);
 static int ocfs2_zero_extend(struct inode *inode);
 
 static void ocfs_fe_set_attributes(ocfs2_dinode *fe, struct iattr *attr)
