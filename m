From: Jan Kara <jack@suse.cz>
Date: Wed, 28 Feb 2018 12:17:58 +0100
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: Fix quota recovery failure on
	unmount
In-Reply-To: <20180228111802.23967-1-jack@suse.cz>
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <20180228111802.23967-3-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When filesystem is unmounted while there is still some recovery work
going on, it can happen that quotas get disabled before quota recovery
is complete resulting in failed quota recovery and inconsistent quota
accounting. Move disabling of recovery in ocfs2_dismount_volume() before
disabling of quotas to fix this race.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ffa4952d432b..14c3d5ee6e24 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1904,6 +1904,13 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
+	/*
+	 * This will disable recovery and flush any recovery work. This needs
+	 * to happen before disabling quotas as quota recovery needs quotas
+	 * enabled.
+	 */
+	ocfs2_recovery_exit(osb);
+
 	ocfs2_disable_quotas(osb);
 
 	/* All dquots should be freed by now */
@@ -1915,9 +1922,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_truncate_log_shutdown(osb);
 
-	/* This will disable recovery and flush any recovery work. */
-	ocfs2_recovery_exit(osb);
-
 	ocfs2_journal_shutdown(osb);
 
 	ocfs2_sync_blockdev(sb);
-- 
2.13.6
