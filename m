From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 17 12:45:22 2004
Subject: [Ocfs2-devel] [PATCH]removing oin from ocfs_file
Message-ID: <200402171845.i1HIjARf004739@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Here is a very small patch to svn version 31 that removes
the unused oin pointer in the ocfs_file structure (as
called for in the TODO list.)

Verified that the field really isn't being used anywhere.

     --rusty


Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 31)
+++ src/inc/ocfs.h	(working copy)
@@ -1782,7 +1782,6 @@
 typedef struct _ocfs_file
 {
 	ocfs_obj_id obj_id;
-	struct _ocfs_inode *oin;	/* ptr to the assoc. ocfs_inode */
 	__u64 curr_byte_off;
 	__s64 curr_dir_off;
 	struct buffer_head **curr_dir_buf;
Index: TODO
===================================================================
--- TODO	(revision 31)
+++ TODO	(working copy)
@@ -25,8 +25,6 @@
 
 * finish mkfs to really create a filesystem.
 
-* take the oin field off the ofile structure.
-
 * System files should be locked with cache lock, and we need inodes
   for them so that we can cache our reads to them. This can also count
   for the main bitmap. Data writes to the bitmap files can be
