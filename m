From: Mark Fasheh <mfasheh@suse.com>
Date: Mon,  5 Apr 2010 18:17:16 -0700
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Add dir_resv_level mount option
In-Reply-To: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
References: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
Message-ID: <1270516636-12180-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The default behavior for directory reservations stays the same, but we add a
mount option so people can tweak the size of directory reservations
according to their workloads.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    4 ++++
 fs/ocfs2/dir.c                      |    6 ++++--
 fs/ocfs2/ocfs2.h                    |    1 +
 fs/ocfs2/reservations.c             |    9 ++++++---
 fs/ocfs2/reservations.h             |    2 ++
 fs/ocfs2/super.c                    |   23 +++++++++++++++++++++++
 6 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 32339e5..1f7ae14 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -83,3 +83,7 @@ noacl		(*)	Disables POSIX Access Control Lists support.
 resv_level=2	(*)	Set how agressive allocation reservations will be.
 			Valid values are between 0 (reservations off) to 8
 			(maximum space for reservations).
+dir_resv_level=	(*)	By default, directory reservations will scale with file
+			reservations - users should rarely need to change this
+			value. If allocation reservations are turned off, this
+			option will have no effect.
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b71acf3..dce39da 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2993,7 +2993,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	 * if we only get one now, that's enough to continue. The rest
 	 * will be claimed after the conversion to extents.
 	 */
-	data_ac->ac_resv = &oi->ip_la_data_resv;
+	if (ocfs2_dir_resv_allowed(osb))
+		data_ac->ac_resv = &oi->ip_la_data_resv;
 	ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off, &len);
 	if (ret) {
 		mlog_errno(ret);
@@ -3373,7 +3374,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
+		if (ocfs2_dir_resv_allowed(osb))
+			data_ac->ac_resv = &OCFS2_I(dir)->ip_la_data_resv;
 
 		credits = ocfs2_calc_extend_credits(sb, el, 1);
 	} else {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 72e6eef..e946936 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -353,6 +353,7 @@ struct ocfs2_super
 	struct ocfs2_reservation_map	osb_la_resmap;
 
 	unsigned int	osb_resv_level;
+	unsigned int	osb_dir_resv_level;
 
 	/* Next three fields are for local node slot recovery during
 	 * mount. */
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 87fa357..6497bcc 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -44,7 +44,11 @@ DEFINE_SPINLOCK(resv_lock);
 
 #define	OCFS2_MIN_RESV_WINDOW_BITS	8
 #define	OCFS2_MAX_RESV_WINDOW_BITS	1024
-#define	OCFS2_RESV_DIR_WINDOW_BITS	OCFS2_MIN_RESV_WINDOW_BITS
+
+int ocfs2_dir_resv_allowed(struct ocfs2_super *osb)
+{
+	return (osb->osb_resv_level && osb->osb_dir_resv_level);
+}
 
 static unsigned int ocfs2_resv_window_bits(struct ocfs2_reservation_map *resmap,
 					   struct ocfs2_alloc_reservation *resv)
@@ -56,8 +60,7 @@ static unsigned int ocfs2_resv_window_bits(struct ocfs2_reservation_map *resmap,
 		/* 8, 16, 32, 64, 128, 256, 512, 1024 */
 		bits = 4 << osb->osb_resv_level;
 	} else {
-		/* For now, treat directories the same as files. */
-		bits = 4 << osb->osb_resv_level;
+		bits = 4 << osb->osb_dir_resv_level;
 	}
 	return bits;
 }
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 022aff6..25b0c0e 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -67,6 +67,8 @@ void ocfs2_resv_init_once(struct ocfs2_alloc_reservation *resv);
 void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
 			 unsigned int flags);
 
+int ocfs2_dir_resv_allowed(struct ocfs2_super *osb);
+
 /**
  * ocfs2_resv_discard() - truncate a reservation
  * @resmap:
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index bca1ed3..9f0e211 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -95,6 +95,7 @@ struct mount_options
 	signed short	slot;
 	int		localalloc_opt;
 	unsigned int	resv_level;
+	int		dir_resv_level;
 	char		cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
 };
 
@@ -177,6 +178,7 @@ enum {
 	Opt_usrquota,
 	Opt_grpquota,
 	Opt_resv_level,
+	Opt_dir_resv_level,
 	Opt_err,
 };
 
@@ -204,6 +206,7 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_grpquota, "grpquota"},
 	{Opt_resv_level, "resv_level=%u"},
+	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1030,6 +1033,11 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	ocfs2_la_set_sizes(osb, parsed_options.localalloc_opt);
 	osb->osb_resv_level = parsed_options.resv_level;
+	osb->osb_dir_resv_level = parsed_options.resv_level;
+	if (parsed_options.dir_resv_level == -1)
+		osb->osb_dir_resv_level = parsed_options.resv_level;
+	else
+		osb->osb_dir_resv_level = parsed_options.dir_resv_level;
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -1291,6 +1299,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->localalloc_opt = -1;
 	mopt->cluster_stack[0] = '\0';
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
+	mopt->dir_resv_level = -1;
 
 	if (!options) {
 		status = 1;
@@ -1445,6 +1454,17 @@ static int ocfs2_parse_options(struct super_block *sb,
 			    option < OCFS2_MAX_RESV_LEVEL)
 				mopt->resv_level = option;
 			break;
+		case Opt_dir_resv_level:
+			if (is_remount)
+				break;
+			if (match_int(&args[0], &option)) {
+				status = 0;
+				goto bail;
+			}
+			if (option >= OCFS2_MIN_RESV_LEVEL &&
+			    option < OCFS2_MAX_RESV_LEVEL)
+				mopt->dir_resv_level = option;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1529,6 +1549,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (osb->osb_resv_level != OCFS2_DEFAULT_RESV_LEVEL)
 		seq_printf(s, ",resv_level=%d", osb->osb_resv_level);
 
+	if (osb->osb_dir_resv_level != osb->osb_resv_level)
+		seq_printf(s, ",dir_resv_level=%d", osb->osb_resv_level);
+
 	return 0;
 }
 
-- 
1.6.4.2
