From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Sun Mar 14 18:58:58 2004
Subject: [Ocfs2-devel] [PATCH]bugfix for unlinking on 2.6 kernel
Message-ID: <200403150058.i2F0wnIc001649@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On a 2.6 kernel, sys_unlink will wrap the call to the filesystem
unlink function with atomic_inc/atomic_dec of the inode->i_count.

The following minimal patch fixes ocfs_unlink to take this into
consideration.  (Without this patch attempting to delete any file
on a ocfs2 volume from a 2.6 bases system would result in an -EBUSY
error.)

    --rusty

Index: src/namei.c
===================================================================
--- src/namei.c	(revision 776)
+++ src/namei.c	(working copy)
@@ -575,7 +575,15 @@
 	__u64 parentOff, fileOff;
 	bool do_release = false;
 	struct inode *parentInode = dentry->d_parent->d_inode;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	/* 
+	 * On a 2.6 kernel sys_unlink will increment the inode 
+	 * count before calling the filesystem unlink function
+	 */
+	int max_cnt = 3; /* one for this process, inode hash, and sys_unlink */
+#else
 	int max_cnt = 2; /* one for this process and one for inode hash */
+#endif
 
 	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", dir, dentry,
                         dentry->d_name.len, dentry->d_name.name);
