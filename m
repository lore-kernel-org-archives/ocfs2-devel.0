From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar 22 16:51:27 2004
Subject: [Ocfs2-devel] [PATCH]Initialize lockres->cache_list
Message-ID: <200403222250.i2MMouhY003199@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a small patch to initialize the cache_list list_head
while initializing a new lockres.

    --rusty

Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 804)
+++ src/dlm.c	(working copy)
@@ -1056,6 +1056,8 @@
 	lockres->lock_holders = 0;
 	LOG_TRACE_ARGS("lockres->lock_holders = %u\n", lockres->lock_holders);
 
+	INIT_LIST_HEAD(&lockres->cache_list);
+
 	LOG_EXIT ();
 	return;
 }				/* ocfs_init_lockres */
