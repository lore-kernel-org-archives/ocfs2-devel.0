From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar 23 22:11:59 2004
Subject: [Ocfs2-devel] [PATCH]Enable 2.6 file data flushing
Message-ID: <200403240411.i2O4BrRr014124@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following small patch makes a 2.6 built kernel flush it's 
data buffers to disk on ocfs_sync_inode, fixing bug #46

http://oss.oracle.com/bugzilla/show_bug.cgi?id=46

    --rusty

Index: src/file.c
===================================================================
--- src/file.c	(revision 807)
+++ src/file.c	(working copy)
@@ -68,6 +68,7 @@
 {
 	int status;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	filemap_fdatawrite(inode->i_mapping);	
 	status = sync_mapping_buffers(inode->i_mapping);
 #else
 	status = fsync_inode_buffers(inode);
