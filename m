From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Sun Aug 22 22:07:46 2004
Subject: [Ocfs2-devel] [Patch] fix bug 123 - dead lock when truncate
Message-ID: <3ACA40606221794F80A5670F0AF15F840542F38B@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the call stack
ocfs_setattr ->
ocfs2_zero_extend->ocfs_get_block->ocfs_lookup_file_allocation
There are two down_write(&OCFS_I(inode)->ip_io_sem)
file.c +1549
alloc.c +4179

------------------------------------------------------------------------
------------------------------------------
Index: file.c
===================================================================
--- file.c  (revision 1370)
+++ file.c  (working copy)
@@ -1471,7 +1471,9 @@
            OCFS_I(inode)->ip_mmu_private = inode->i_size;
        }
        up (&(OCFS_I(inode)->ip_sem));
+       up_write(&OCFS_I(inode)->ip_io_sem);
        status = ocfs2_zero_extend(inode);
+       down_write(&OCFS_I(inode)->ip_io_sem);
        if (status < 0) {
            LOG_ERROR_STATUS(status);
            goto bail;

-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)


xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
