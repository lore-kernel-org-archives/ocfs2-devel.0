From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed May 26 05:05:13 2004
Subject: [Ocfs2-devel] patch for debugocfs
Message-ID: <3ACA40606221794F80A5670F0AF15F84047379C2@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It seems debugocfs -f does not work properly now, I make the follow
patch to fix it.

Index: libocfs/Common/inc/ocfsdisk.h
===================================================================
--- libocfs/Common/inc/ocfsdisk.h	(revision 42)
+++ libocfs/Common/inc/ocfsdisk.h	(working copy)
@@ -93,6 +93,17 @@
 	/* 32-bit: sizeof(fe) = 484 bytes */
 	/* 64-bit: sizeof(fe) = 488 bytes */
 	/* Need to account for that fact when the struct is extended. */
+	__u8 fe_reserved1[4];		  // UNUSED
+	union {
+		__u64 fe_private;
+		__u64 child_dirnode;              // NUMBER
RANGE(0,ULONG_LONG_MAX)
+		struct _bitinfo {
+			__u32 used_bits;
+			__u32 total_bits;
+		} bitinfo;
+	} u;     
+/* sizeof(fe) = 496 bytes */
+
 }
 ocfs_file_entry;			// END CLASS
 
Index: debugocfs/debugocfs.c
===================================================================
--- debugocfs/debugocfs.c	(revision 42)
+++ debugocfs/debugocfs.c	(working copy)
@@ -343,7 +343,7 @@
 		    if (mode == FIND_MODE_FILE || mode ==
FIND_MODE_FILE_EXTENT)
 			ret = offset;	// return the first part of the
dir chain
 		    else if (mode == FIND_MODE_DIR)
-			ret = fe->extents[0].disk_off;
+			ret = fe->u.child_dirnode;
 		    else if (mode == FIND_MODE_FILE_DATA)
 			get_file_data_mapping(vcb, fe, buf);
 
@@ -357,7 +357,7 @@
 		    }
 		    else if (mode == FIND_MODE_DIR)
 		    {
-			__u64 dir_off = fe->extents[0].disk_off;
+			__u64 dir_off = fe->u.child_dirnode;
 			foundDir = (ocfs_dir_node *)
malloc_aligned(DIR_NODE_SIZE);
 
 			while(1) {

-------------------
Intel China Software Lab.
iNet: 8-752-1806
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
