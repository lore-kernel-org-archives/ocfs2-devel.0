From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Mar 19 16:56:50 2004
Subject: [Ocfs2-devel] [PATCH]Warning fix for dlm.c
Message-ID: <200403192256.i2JMuRT6003479@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch fixes a couple of minor warnings about lockflags
and lock_path not being used.

    --rusty


Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 793)
+++ src/dlm.c	(working copy)
@@ -1233,12 +1233,10 @@
 	ocfs_lock_res *lockres = NULL;
 	int k = 0;
 	struct buffer_head *tmpbh = NULL, **b = NULL;
-	int lockflags = (lock_id >= osb->vol_layout.bitmap_off ? OCFS_BH_CACHED : 0);
 	/* TODO: 40 bytes of "bool" sitting on the stack for now. move    */
 	/*       mutually exclusive flags into an enum and switch on them */
 	bool disk_vote = false;
 	bool no_owner = false, owner_dead = false, wait_on_recovery = false;
-	int lock_path = invalid_path;
 	__u32 extra_lock_flags = 0;
 
 	LOG_ENTRY_ARGS ("(0x%08x, %u.%u, %u, %u, 0x%08x, 0x%08x)\n", osb,
