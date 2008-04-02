From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:14:25 -0700
Subject: [Ocfs2-devel] [PATCH 15/62] ocfs2: Fill node number during cluster
	stack init
In-Reply-To: <12071673481928-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
Message-ID: <12071673492775-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

It doesn't make sense to query for a node number before connecting to the
cluster stack. This should be safe to do because node_num is only just
printed,
and we're actually only moving the setting of node num a small amount
further in the mount process.

[ Disconnect when node query fails -- Joel ]

Reviewed-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |   13 ++++++++++++-
 fs/ocfs2/super.c   |   33 ---------------------------------
 2 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 05fd016..c7653bb 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2459,8 +2459,10 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb)) {
+		osb->node_num = 0;
 		goto local;
+	}
 
 	status = ocfs2_dlm_init_debug(osb);
 	if (status < 0) {
@@ -2487,6 +2489,15 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto bail;
 	}
 
+	status = ocfs2_cluster_this_node(&osb->node_num);
+	if (status < 0) {
+		mlog_errno(status);
+		mlog(ML_ERROR,
+		     "could not find this host's node number\n");
+		ocfs2_cluster_disconnect(conn);
+		goto bail;
+	}
+
 local:
 	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
 	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8f536b3..fa9c46e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -108,7 +108,6 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait);
 static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb);
 static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb);
 static void ocfs2_release_system_inodes(struct ocfs2_super *osb);
-static int ocfs2_fill_local_node_info(struct ocfs2_super *osb);
 static int ocfs2_check_volume(struct ocfs2_super *osb);
 static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			       struct buffer_head *bh,
@@ -1126,32 +1125,6 @@ static int ocfs2_get_sector(struct super_block *sb,
 	return 0;
 }
 
-/* ocfs2 1.0 only allows one cluster and node identity per kernel image. */
-static int ocfs2_fill_local_node_info(struct ocfs2_super *osb)
-{
-	int status;
-
-	/* XXX hold a ref on the node while mounte?  easy enough, if
-	 * desirable. */
-	if (ocfs2_mount_local(osb))
-		osb->node_num = 0;
-	else {
-		status = ocfs2_cluster_this_node(&osb->node_num);
-		if (status < 0) {
-			mlog_errno(status);
-			mlog(ML_ERROR,
-			     "could not find this host's node number\n");
-			goto bail;
-		}
-	}
-
-	mlog(0, "I am node %u\n", osb->node_num);
-
-	status = 0;
-bail:
-	return status;
-}
-
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
@@ -1163,12 +1136,6 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	if (ocfs2_is_hard_readonly(osb))
 		goto leave;
 
-	status = ocfs2_fill_local_node_info(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.4.1
