From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 31 Jan 2011 11:31:04 -0800
Subject: [Ocfs2-devel] ocfs2: Check heartbeat mode for kernel stacks only
Message-ID: <20110131193104.GG23899@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 2c442719e90a44a6982c033d69df4aae4b167cfa added some checks for proper
heartbeat mode when the o2cb stack is running.  Unfortunately, it didn't
take into account that a userpsace stack could be running. Fix this by only
doing the check if o2cb is in use. This patch allows userspace stacks to
mount the fs again.

Cc: stable at kernel.org
Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Index: linux-2.6.32-SLE11-SP1/fs/ocfs2/super.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/fs/ocfs2/super.c
+++ linux-2.6.32-SLE11-SP1/fs/ocfs2/super.c
@@ -1331,7 +1331,7 @@ static int ocfs2_parse_options(struct su
 			       struct mount_options *mopt,
 			       int is_remount)
 {
-	int status;
+	int status, user_stack = 0;
 	char *p;
 	u32 tmp;
 
@@ -1474,6 +1474,15 @@ static int ocfs2_parse_options(struct su
 			memcpy(mopt->cluster_stack, args[0].from,
 			       OCFS2_STACK_LABEL_LEN);
 			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
+			/*
+			 * Open code the memcmp here as we don't have
+			 * an osb to pass to
+			 * ocfs2_userspace_stack().
+			 */
+			if (memcmp(mopt->cluster_stack,
+				   OCFS2_CLASSIC_CLUSTER_STACK,
+				   OCFS2_STACK_LABEL_LEN))
+				user_stack = 1;
 			break;
 		case Opt_inode64:
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
@@ -1529,13 +1538,16 @@ static int ocfs2_parse_options(struct su
 		}
 	}
 
-	/* Ensure only one heartbeat mode */
-	tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
-				 OCFS2_MOUNT_HB_NONE);
-	if (hweight32(tmp) != 1) {
-		mlog(ML_ERROR, "Invalid heartbeat mount options\n");
-		status = 0;
-		goto bail;
+	if (user_stack == 0) {
+		/* Ensure only one heartbeat mode */
+		tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL |
+					 OCFS2_MOUNT_HB_GLOBAL |
+					 OCFS2_MOUNT_HB_NONE);
+		if (hweight32(tmp) != 1) {
+			mlog(ML_ERROR, "Invalid heartbeat mount options\n");
+			status = 0;
+			goto bail;
+		}
 	}
 
 	status = 1;
