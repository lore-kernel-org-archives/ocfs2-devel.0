From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jul 27 13:19:51 2004
Subject: [Ocfs2-devel] patch to improve directory creation performance
Message-ID: <3ACA40606221794F80A5670F0AF15F8404FB8C0D@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We found the reason that cause the directory creation is slow again in
the new version.
It is becuase in ocfs_extend_file, it will write zero to new allocated
block.For directory,
it is not needed.
See the patch.

Now the directory creation speed is improved from 700/s to 5000/s.


------------------------------------------------------------------------
----------------------
Index: file.c
===================================================================
--- file.c      (revision 1306)
+++ file.c      (working copy)
@@ -1171,6 +1171,7 @@

 #define        OCFS_MAX_ZERO_BLOCKS (4096)

+       if(!S_ISDIR(inode->i_mode)) {
        down(&OCFS_I(inode)->ip_sem);
        if (!(OCFS_I(inode)->ip_open_flags &
OCFS_OIN_OPEN_FOR_DIRECTIO)) {
                struct buffer_head **bhs = NULL;
@@ -1237,7 +1238,7 @@
                kfree(bhs);
        } else
                up(&OCFS_I(inode)->ip_sem);
-
+       }
        ext_alloc_inode = ocfs_get_system_file_inode(osb,
EXTENT_ALLOC_BITMAP_SYSTEM_INODE, osb->node_num);
        if (!ext_alloc_inode) {
                status = -EFAIL;
