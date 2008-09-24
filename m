From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 24 Sep 2008 15:01:18 -0700
Subject: [Ocfs2-devel] [PATCH 37/39] ocfs2: Add the 'inode64' mount option.
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Message-ID: <1222293680-15451-38-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Now that ocfs2 limits inode numbers to 32bits, add a mount option to
disable the limit.  This parallels XFS.  64bit systems can handle the
larger inode numbers.

[ Added description of inode64 mount option in ocfs2.txt. --Mark ]

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    4 ++++
 fs/ocfs2/ocfs2.h                    |    1 +
 fs/ocfs2/suballoc.c                 |    5 +++--
 fs/ocfs2/super.c                    |   17 +++++++++++++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index c318a8b..6acf1b4 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -76,3 +76,7 @@ localalloc=8(*)		Allows custom localalloc size in MB. If the value is too
 			large, the fs will silently revert it to the default.
 			Localalloc is not enabled for local mounts.
 localflocks		This disables cluster aware flock.
+inode64			Indicates that Ocfs2 is allowed to create inodes at
+			any location in the filesystem, including those which
+			will result in inode numbers occupying more than 32
+			bits of significance.
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6d3c10d..78ae4f8 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -189,6 +189,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
 	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
+	OCFS2_MOUNT_INODE64 = 1 << 7,	/* Allow inode numbers > 2^32 */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 213bdca..d7a6f92 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -601,9 +601,10 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
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
index 973d99f..f95469c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -157,6 +157,7 @@ enum {
 	Opt_stack,
 	Opt_user_xattr,
 	Opt_nouser_xattr,
+	Opt_inode64,
 	Opt_err,
 };
 
@@ -178,6 +179,7 @@ static match_table_t tokens = {
 	{Opt_stack, "cluster_stack=%s"},
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
+	{Opt_inode64, "inode64"},
 	{Opt_err, NULL}
 };
 
@@ -411,6 +413,15 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
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
@@ -930,6 +941,9 @@ static int ocfs2_parse_options(struct super_block *sb,
 			       OCFS2_STACK_LABEL_LEN);
 			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
 			break;
+		case Opt_inode64:
+			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -994,6 +1008,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",cluster_stack=%.*s", OCFS2_STACK_LABEL_LEN,
 			   osb->osb_cluster_stack);
 
+	if (opts & OCFS2_MOUNT_INODE64)
+		seq_printf(s, ",inode64");
+
 	return 0;
 }
 
-- 
1.5.4.5
