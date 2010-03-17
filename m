From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Mar 2010 23:59:12 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations for
	directory data
In-Reply-To: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
Message-ID: <1268809154-1020-4-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Use the reservations system for unindexed dir tree allocations. We
don't bother with the indexed tree as reads from it are mostly random
anyway. By default this behavior is turned off and can be turned on
via mount option 'dir_resv'. Workloads which create many large
directories will want to turn it on.

A future improvement will be to use a different window size for
directory inodes. Once done, we should change the default for this
feature to be enabled.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    2 ++
 fs/ocfs2/dir.c                      |    4 ++++
 fs/ocfs2/ocfs2.h                    |    2 ++
 fs/ocfs2/suballoc.c                 |    1 +
 fs/ocfs2/super.c                    |   15 +++++++++++++++
 5 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 412df90..40fc8d1 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -83,3 +83,5 @@ noacl		(*)	Disables POSIX Access Control Lists support.
 resv_level=4	(*)	Set how agressive allocation reservations will be.
 			Valid values are between 0 (reservations off) to 8
 			(maximum space for reservations).
+no_dir_resv	(*)	Don't get allocation reservations on directory inodes.
+dir_resv		Get allocation reservations on directory inodes.
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 28c3ec2..e74bd18 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2993,6 +2993,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * if we only get one now, that's enough to continue. The rest
 	 * will be claimed after the conversion to extents.
 	 */
+	if (osb->s_mount_opt & OCFS2_MOUNT_DIR_RESV)
+		data_ac->ac_resv = &oi->ip_la_data_resv;
 	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
@@ -3371,6 +3373,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 				mlog_errno(status);
 			goto bail;
 		}
+		if (osb->s_mount_opt & OCFS2_MOUNT_DIR_RESV)
+			data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
 
 		credits = ocfs2_calc_extend_credits(sb, el, 1);
 	} else {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e0c6d5e..c3e3758 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -255,6 +255,8 @@ enum ocfs2_mount_options
 						   control lists */
 	OCFS2_MOUNT_USRQUOTA = 1 << 10, /* We support user quotas */
 	OCFS2_MOUNT_GRPQUOTA = 1 << 11, /* We support group quotas */
+	OCFS2_MOUNT_DIR_RESV	= 1 << 12, /* Get reservations
+					    * on directories */
 };
 
 #define OCFS2_OSB_SOFT_RO			0x0001
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index c30b644..7b76926 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -137,6 +137,7 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 	}
 	brelse(ac->ac_bh);
 	ac->ac_bh = NULL;
+	ac->ac_resv = NULL;
 }
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index db354d1..b1bc5d2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -177,6 +177,8 @@ enum {
 	Opt_usrquota,
 	Opt_grpquota,
 	Opt_resv_level,
+	Opt_dir_resv,
+	Opt_no_dir_resv,
 	Opt_err,
 };
 
@@ -204,6 +206,8 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_grpquota, "grpquota"},
 	{Opt_resv_level, "resv_level=%u"},
+	{Opt_dir_resv, "dir_resv"},
+	{Opt_no_dir_resv, "no_dir_resv"},
 	{Opt_err, NULL}
 };
 
@@ -1445,6 +1449,12 @@ static int ocfs2_parse_options(struct super_block *sb,
 			    option < OCFS2_MAX_RESV_LEVEL)
 				mopt->resv_level = option;
 			break;
+		case Opt_dir_resv:
+			mopt->mount_opt |= OCFS2_MOUNT_DIR_RESV;
+			break;
+		case Opt_no_dir_resv:
+			mopt->mount_opt &= ~OCFS2_MOUNT_DIR_RESV;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1529,6 +1539,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->osb_resv_level != OCFS2_DEFAULT_RESV_LEVEL)
 		seq_printf(s, ",resv_level=%d", osb->osb_resv_level);
 
+	if (opts & OCFS2_MOUNT_DIR_RESV)
+		seq_printf(s, ",dir_resv");
+	else
+		seq_printf(s, ",no_dir_resv");
+
 	return 0;
 }
 
-- 
1.6.4.2
