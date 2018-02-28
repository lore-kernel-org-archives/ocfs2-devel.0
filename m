From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:18:02 +0100
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Do not fail remount when mounted
	without heartbeat option
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-7-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When a filesystem is mounted without any options, the mount succeeds
however remounting is later not possible as the kernel complains:

(mount,568,0):ocfs2_remount:657 ERROR: Cannot change heartbeat mode on
remount

The problem is that in this case no heartbeat option got set and so
remount with heartbeat=none as shown in /proc/mounts is considered
to be a change of hearbeat mode.

Fix the problem by defaulting heartbeat mode to 'none' and making sure
it gets set when no mount options are specified.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index af4481b98c65..45d59766a357 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1289,10 +1289,8 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 	mopt->dir_resv_level = -1;
 
-	if (!options) {
-		status = 1;
-		goto bail;
-	}
+	if (!options)
+		goto check_opts;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		if (!*p)
@@ -1486,15 +1484,21 @@ static int ocfs2_parse_options(struct super_block *sb,
 		}
 	}
 
+check_opts:
 	if (user_stack == 0) {
+		int weight;
+
 		/* Ensure only one heartbeat mode */
 		tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL |
 					 OCFS2_MOUNT_HB_GLOBAL |
 					 OCFS2_MOUNT_HB_NONE);
-		if (hweight32(tmp) != 1) {
+		weight = hweight32(tmp);
+		if (weight > 1) {
 			mlog(ML_ERROR, "Invalid heartbeat mount options\n");
 			status = 0;
 			goto bail;
+		} else if (weight == 0) {
+			mopt->mount_opt |= OCFS2_MOUNT_HB_NONE;
 		}
 	}
 
-- 
2.13.6
