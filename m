From: Christoph Hellwig <hch@lst.de>
Date: Wed Jun  2 13:10:23 2004
Subject: [Ocfs2-devel] [PATCH] start centralizing kernel compat mess
Message-ID: <20040602091432.GC22363@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 969)
+++ src/inode.c	(working copy)
@@ -33,6 +33,8 @@
 #include "inc/ocfs.h"
 #include "inc/ocfs_journal.h"
 
+#include "kcompat.h"
+
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_INODE
 
 extern struct semaphore recovery_list_sem;
@@ -790,11 +792,7 @@
 	memcpy (kaddr, symname, len - 1);
 	mapping->a_ops->commit_write (NULL, page, 0, len - 1);
 	err = mapping->a_ops->readpage (NULL, page);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	wait_on_page_locked (page);
-#else
-	wait_on_page (page);
-#endif
 	page_cache_release (page);
 	if (err < 0)
 		goto fail;
@@ -802,11 +800,7 @@
 	return 0;
 
 fail_map:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	unlock_page (page);
-#else
-	UnlockPage (page);
-#endif
 	page_cache_release (page);
 fail:
 	return err;
Index: src/symlink.c
===================================================================
--- src/symlink.c	(revision 969)
+++ src/symlink.c	(working copy)
@@ -34,10 +34,11 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/utsname.h>
 
 #include "inc/ocfs_log.h"
 #include "inc/ocfs.h"
-#include <linux/utsname.h>
+#include "kcompat.h"
 
 #define OCFS_DEBUG_CONTEXT    OCFS_DEBUG_CONTEXT_SYMLINK
 
@@ -160,15 +161,8 @@
 				NULL);
 	if (IS_ERR(page))
 		goto sync_fail;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	wait_on_page_locked(page);
 	if (!PageUptodate(page))
-
-#else
-	wait_on_page(page);
-	if (!Page_Uptodate(page))
-
-#endif
 		goto async_fail;
 	*ppage = page;
 	return kmap(page);
--- /dev/null	2004-05-30 14:45:31.000000000 +0200
+++ src/kcompat.h	2004-06-02 11:05:24.430188496 +0200
@@ -0,0 +1,12 @@
+#ifndef _KCOMPAT_H
+#define _KCOMPAT_H
+
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
+#define wait_on_page_locked(p)	wait_on_page(p)
+#define unlock_page(p)		UnlockPage(p)
+#define Page_Uptodate(p)	PageUptodate(p)
+#endif
+
+#endif /* _KCOMPAT_H */
