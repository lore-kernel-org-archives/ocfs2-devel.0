From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  3 Sep 2008 20:03:40 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Add the 'inode64' mount option.
In-Reply-To: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1220497421-8606-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Now that ocfs2 limits inode numbers to 32bits, add a mount option to
disable the limit.  This parallels XFS.  64bit systems can handle the
larger inode numbers.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    1 +
 fs/ocfs2/suballoc.c |    5 +++--
 fs/ocfs2/super.c    |   17 +++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 7f625f2..ca89e65 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -184,6 +184,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
 	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
+	OCFS2_MOUNT_INODE64 = 1 << 6,	/* Allow inode numbers > 2^32 */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 65e2bd5..b783806 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -592,9 +592,10 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	/*
 	 * stat(2) can't handle i_ino > 32bits, so we tell the
 	 * lower levels not to allocate us a block group past that
-	 * limit.
+	 * limit.  The 'inode64' mount option avoids this behavior.
 	 */
-	(*ac)->ac_max_block = (u32)~0U;
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_INODE64))
+		(*ac)->ac_max_block = (u32)~0U;
 
 	/*
 	 * slot is set when we successfully steal inode from other nodes.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 88255d3..260da3a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -154,6 +154,7 @@ enum {
 	Opt_localalloc,
 	Opt_localflocks,
 	Opt_stack,
+	Opt_inode64,
 	Opt_err,
 };
 
@@ -173,6 +174,7 @@ static match_table_t tokens = {
 	{Opt_localalloc, "localalloc=%d"},
 	{Opt_localflocks, "localflocks"},
 	{Opt_stack, "cluster_stack=%s"},
+	{Opt_inode64, "inode64"},
 	{Opt_err, NULL}
 };
 
@@ -406,6 +408,15 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
+	/* Probably don't want this on remount; it might
+	 * mess with other nodes */
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_INODE64) &&
+	    (parsed_options.mount_opt & OCFS2_MOUNT_INODE64)) {
+		ret = -EINVAL;
+		mlog(ML_ERROR, "Cannot enable inode64 on remount\n");
+		goto out;
+	}
+
 	/* We're going to/from readonly mode. */
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY)) {
 		/* Lock here so the check of HARD_RO and the potential
@@ -918,6 +929,9 @@ static int ocfs2_parse_options(struct super_block *sb,
 			       OCFS2_STACK_LABEL_LEN);
 			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
 			break;
+		case Opt_inode64:
+			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -980,6 +994,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
 
+	if (opts & OCFS2_MOUNT_INODE64)
+		seq_printf(s, ",inode64");
+
 	return 0;
 }
 
-- 
1.5.6.3
