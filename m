From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri,  1 May 2009 12:56:06 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] OCFS2: speed up dlm_lockr_resouce
	hash_table lookups
Message-ID: <200905010457.n414v6O2029836@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

allocates at least one page.

mainline git commit: c8f33b6e86af74ee7b800f57cac7b3c8559318fe
Authored-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 2)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 3)
@@ -37,8 +37,12 @@
 #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
 #define DLM_THREAD_MS                  200   // flush at least every 200 ms
 
-#define DLM_HASH_SIZE		(1 << 14)
-#define DLM_HASH_PAGES		(DLM_HASH_SIZE / PAGE_SIZE)
+#define DLM_HASH_SIZE_DEFAULT	(1 << 14)
+#if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
+# define DLM_HASH_PAGES		1
+#else
+# define DLM_HASH_PAGES		(DLM_HASH_SIZE_DEFAULT / PAGE_SIZE)
+#endif
 #define DLM_BUCKETS_PER_PAGE	(PAGE_SIZE / sizeof(struct hlist_head))
 #define DLM_HASH_BUCKETS	(DLM_HASH_PAGES * DLM_BUCKETS_PER_PAGE)
 
