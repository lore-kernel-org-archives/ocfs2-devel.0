From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 19 22:14:23 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in symlink.c
Message-ID: <200402200414.i1K4EDIe004275@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch ports symlink.c to 2.6 by converting to the
newer wait_on_page_locked() and PageUpdate() functions.

    --rusty

Index: src/symlink.c
===================================================================
--- src/symlink.c	(revision 32)
+++ src/symlink.c	(working copy)
@@ -154,8 +154,15 @@
 				NULL);
 	if (IS_ERR(page))
 		goto sync_fail;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	wait_on_page_locked(page);
+	if (!PageUptodate(page))
+
+#else
 	wait_on_page(page);
 	if (!Page_Uptodate(page))
+
+#endif
 		goto async_fail;
 	*ppage = page;
 	return kmap(page);
