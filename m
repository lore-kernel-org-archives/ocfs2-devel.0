From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar 18 10:15:11 2004
Subject: [Ocfs2-devel] [PATCH]Fix for 2.6 unmount crash
Message-ID: <200403181614.i2IGEMH1028597@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch catches the scenario where a dismount has already
been started, and a ocfs_release_cached_oin() has been kicked
off as a result of ocfs_inode_hash_destroy() calling iput()
on any remaining inodes.

http://oss.oracle.com/bugzilla/show_bug.cgi?id=47

This will cause a 2.6 system built with memory debugging to 
crash (indicating that we are doing something wrong, which is using
our cache objects after we have free'ed them.)

I haven't seen a crash on 2.4 due to this, but a 2.4 system does
come across this scenario (but it just doesn't crash.)

    --rusty

Index: src/oin.c
===================================================================
--- src/oin.c	(revision 787)
+++ src/oin.c	(working copy)
@@ -705,6 +705,17 @@
 	if (oin == NULL)
 		goto bail;
 
+	/*
+	 * If the OCFS_OSB_FLAGS_BEING_DISMOUNTED flag has
+	 * already been set, then the lockres hash has already
+	 * been cleaned out which means that we have a lock_res
+	 * pointer that points to free memory.
+	 */
+	if (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED) {
+		oin->lock_res = NULL;
+		goto bail;
+	}
+
 	ocfs_down_sem (&(oin->main_res), true);
 	bAcquiredOIN = true;
         inode = oin->inode;
