From: Christoph Hellwig <hch@lst.de>
Date: Mon Jun 14 08:04:19 2004
Subject: [Ocfs2-devel] [PATCH] use huge_{de,en}_code_dev directly
Message-ID: <20040614130415.GA29963@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

no need for wrappers, just implement the 2.6ish function names on 2.4
aswell.


Index: src/ocfs_compat.h
===================================================================
--- src/ocfs_compat.h	(revision 1091)
+++ src/ocfs_compat.h	(working copy)
@@ -82,13 +88,13 @@
 }
 #endif
 
-static inline dev_t ocfs_decode_dev(u64 val)
+static inline dev_t huge_decode_dev(u64 val)
 {
 	u16 val16 = (u16)(val & 0xFFFFULL);
 	return MKDEV((val16 >> 8) & 0xFF, val16 & 0xFF);
 }
 
-static inline u64 ocfs_encode_dev(dev_t dev)
+static inline u64 huge_encode_dev(dev_t dev)
 {
 	return (u64)((MAJOR(dev) << 8) | MINOR(dev));
 }
@@ -99,16 +105,6 @@
 
 #define ocfs_get_seconds(t) ((t).tv_sec)
 
-static inline dev_t ocfs_decode_dev(u64 val)
-{
-	return huge_decode_dev(val);
-}
-
-static inline u64 ocfs_encode_dev(dev_t dev)
-{
-	return huge_encode_dev(dev);
-}
-
 #endif  /* LINUX_VERSION_CODE < 2.6 */
 
 #ifndef BITS_TO_LONGS
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 1091)
+++ src/namei.c	(working copy)
@@ -438,7 +436,7 @@
 	fe->i_gid = current->fsgid;
 	fe->i_mode = mode;
 	if (S_ISCHR (mode) || S_ISBLK (mode))
-		fe->id1.dev1.i_rdev = ocfs_encode_dev(dev);
+		fe->id1.dev1.i_rdev = huge_encode_dev(dev);
 
 	if (S_ISLNK (mode) || S_ISDIR (mode) || S_ISREG (mode)) 
 		atomic_set(GET_INODE_CLEAN_SEQ(inode), atomic_read(&osb->clean_buffer_seq));
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1091)
+++ src/inode.c	(working copy)
@@ -366,8 +366,7 @@
 
 	inode->i_version = 1;
 	inode->i_generation = le32_to_cpu(fe->i_generation);
-	inode->i_rdev =
-		ocfs_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+	inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 	inode->i_mode = fe->i_mode;
 	inode->i_uid = fe->i_uid;
 	inode->i_gid = fe->i_gid;
@@ -533,7 +532,7 @@
 	fe = OCFS_BH_GET_DATA_READ(bh);
 	sysfile = le32_to_cpu(fe->i_flags) & OCFS2_SYSTEM_FL;
 	if (S_ISCHR(fe->i_mode) || S_ISBLK(fe->i_mode))
-    		inode->i_rdev = ocfs_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
+    		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
 
 	ocfs_populate_inode (inode, fe, 0);
 
@@ -2037,7 +2034,7 @@
 	     	    S_ISSOCK(fe->i_mode)) {
 			inode->i_rdev = OCFS_NODEV;
 			init_special_inode(inode, inode->i_mode,
-					   ocfs_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev)));
+					   huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev)));
 		}
 
 		fel = &fe->id2.i_list;
