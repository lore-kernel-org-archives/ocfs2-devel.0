From: wengang wang <wen.gang.wang@oracle.com>
Date: Fri,  1 May 2009 12:56:25 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] OCFS2: speed up dlm_lock_resouce
	hash_table lookups
Message-ID: <200905010457.n414vaCB013945@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

enlarge hash table.

mainline git commit: ffae48e79e56fe63589049a0bf3512bcbf7a4327
Authored-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
--
Index: ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h
===================================================================
--- ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 3)
+++ ocfs2-1.2/fs/ocfs2/dlm/dlmcommon.h	(revision 4)
@@ -37,7 +37,7 @@
 #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
 #define DLM_THREAD_MS                  200   // flush at least every 200 ms
 
-#define DLM_HASH_SIZE_DEFAULT	(1 << 14)
+#define DLM_HASH_SIZE_DEFAULT	(1 << 17)
 #if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
 # define DLM_HASH_PAGES		1
 #else
