From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar 18 10:04:03 2004
Subject: [Ocfs2-devel] [PATCH]remove oin's needs_flush_list
Message-ID: <200403181600.i2IG0Xj4027264@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a very simple patch to remove the needs_flush_list
list_head and in_needs_flush_list boolean members of ocfs_inode.

This is dead code.

    --rusty

Index: src/oin.c
===================================================================
--- src/oin.c	(revision 787)
+++ src/oin.c	(working copy)
@@ -753,10 +753,6 @@
 		}
 
 		lockResource->oin = NULL;
-		if (oin->in_needs_flush_list) {
-			list_del (& (oin->needs_flush_list));
-			oin->in_needs_flush_list = false;
-		}
 		if (lockResource->in_cache_list) {
 			list_del (& (lockResource->cache_list));
 			lockResource->in_cache_list = false;
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 787)
+++ src/inc/ocfs.h	(working copy)
@@ -1838,7 +1838,6 @@
 	ocfs_obj_id obj_id;
 	struct inode *inode;
 	struct _ocfs_super *osb;	/* ocfs_inode belongs to this volume */
-	struct list_head needs_flush_list;
 	struct list_head recovery_list;
 	ocfs_sem main_res;
 	struct semaphore extend_sem;
@@ -1853,7 +1852,6 @@
 	__u32 oin_flags;
 	bool needs_verification;
 	bool cache_enabled;
-	bool in_needs_flush_list;
 	bool journal_inode;    /* is this the journal oin? */
 };
 
