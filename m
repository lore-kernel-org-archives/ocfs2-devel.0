From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:13:48 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in namei.c
Message-ID: <200402200413.i1K4DhZU004262@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch fixes more of the same 2.6 porting issues
for namei.c.  Specifically, moving away from the now gone kdev_t
references, and adapting to the new timespec values.

    --rusty

Index: src/namei.c
===================================================================
--- src/namei.c	(revision 32)
+++ src/namei.c	(working copy)
@@ -124,7 +124,7 @@
 		 * and insert it into the hash. It's not bound yet --
 		 * read_inode2 binds the actual inode to it. */
 		ino = ocfs_inode_hash_insert(osb, inode_off, fe_off);
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		inode = ocfs_iget (sb, &args);
 #else
 		inode =
@@ -365,13 +365,8 @@
 	fe->gid = current->fsgid;
 	fe->prot_bits = mode & 0007777;
 	if (S_ISCHR (mode) || S_ISBLK (mode)) {
-#ifdef LINUX_2_5
-		fe->dev_major = major (to_kdev_t(dev));
-		fe->dev_minor = minor (to_kdev_t(dev));
-#else
 		fe->dev_major = MAJOR (dev);
 		fe->dev_minor = MINOR (dev);
-#endif
 	} else {
 		fe->dev_major = MAJOR (dir->i_sb->s_dev);
 		fe->dev_minor = MINOR (dir->i_sb->s_dev);
@@ -1256,7 +1251,7 @@
 
 	old_inode->i_nlink++;
 	if (new_inode) {
-		new_dir->i_mtime = new_dir->i_ctime = OCFS_CURRENT_TIME;
+		new_dir->i_mtime = new_dir->i_ctime = CURRENT_TIME;
 		if (S_ISDIR (old_inode->i_mode))
 			new_inode->i_nlink--;
 		new_inode->i_nlink--;
@@ -1266,7 +1261,7 @@
 	}
 	old_inode->i_nlink--;
 	if (S_ISDIR (old_inode->i_mode)) {
-		new_dir->i_mtime = new_dir->i_ctime = OCFS_CURRENT_TIME;
+		new_dir->i_mtime = new_dir->i_ctime = CURRENT_TIME;
 		old_dir->i_nlink--;
 	}
 
@@ -1416,11 +1411,7 @@
 		goto abort_trans;
 	}
 
-#ifdef LINUX_2_5
-	inode->i_rdev = to_kdev_t(OCFS_NODEV);
-#else
 	inode->i_rdev = OCFS_NODEV;
-#endif	
 
 	if (ocfs_inc_icount(inode) < 0)
 		BUG();
