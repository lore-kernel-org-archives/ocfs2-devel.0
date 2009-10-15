From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Oct 2009 14:54:04 +0200
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Change acl mount option handling
In-Reply-To: <1255611245-27340-1-git-send-email-jack@suse.cz>
References: <1255611245-27340-1-git-send-email-jack@suse.cz>
Message-ID: <1255611245-27340-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change acl mount options handling to match the one of XFS and BTRFS and
hopefully it is also easier to use now. When admin does not specify any
acl mount option, acls are enabled if and only if the filesystem has
xattr feature enabled. If admin specifies 'acl' mount option, we fail
the mount if the filesystem does not have xattr feature and thus acls
cannot be enabled.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/ocfs2.h |    8 +++--
 fs/ocfs2/super.c |   82 +++++++++++++++++++++++++++++-------------------------
 2 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index eae4046..35ad46c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -250,9 +250,11 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
 	OCFS2_MOUNT_NOUSERXATTR = 1 << 6, /* No user xattr */
 	OCFS2_MOUNT_INODE64 = 1 << 7,	/* Allow inode numbers > 2^32 */
-	OCFS2_MOUNT_POSIX_ACL = 1 << 8,	/* POSIX access control lists */
-	OCFS2_MOUNT_USRQUOTA = 1 << 9, /* We support user quotas */
-	OCFS2_MOUNT_GRPQUOTA = 1 << 10, /* We support group quotas */
+	OCFS2_MOUNT_POSIX_ACL = 1 << 8,	/* Force POSIX access control lists */
+	OCFS2_MOUNT_NO_POSIX_ACL = 1 << 9,	/* Disable POSIX access
+						   control lists */
+	OCFS2_MOUNT_USRQUOTA = 1 << 10, /* We support user quotas */
+	OCFS2_MOUNT_GRPQUOTA = 1 << 11, /* We support group quotas */
 };
 
 #define OCFS2_OSB_SOFT_RO			0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f2413f8..d6a0d6a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -101,6 +101,8 @@ struct mount_options
 static int ocfs2_parse_options(struct super_block *sb, char *options,
 			       struct mount_options *mopt,
 			       int is_remount);
+static int ocfs2_check_set_options(struct super_block *sb,
+				   struct mount_options *options);
 static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt);
 static void ocfs2_put_super(struct super_block *sb);
 static int ocfs2_mount_volume(struct super_block *sb);
@@ -601,7 +603,8 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 
 	lock_kernel();
 
-	if (!ocfs2_parse_options(sb, data, &parsed_options, 1)) {
+	if (!ocfs2_parse_options(sb, data, &parsed_options, 1) ||
+	    !ocfs2_check_set_options(sb, &parsed_options)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -692,8 +695,6 @@ unlock_osb:
 	if (!ret) {
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
-		if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
-			parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
@@ -1010,31 +1011,16 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	brelse(bh);
 	bh = NULL;
 
-	if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
-		parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
-
+	if (!ocfs2_check_set_options(sb, &parsed_options)) {
+		status = -EINVAL;
+		goto read_super_error;
+	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
 	osb->osb_commit_interval = parsed_options.commit_interval;
 	osb->local_alloc_default_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
 	osb->local_alloc_bits = osb->local_alloc_default_bits;
-	if (osb->s_mount_opt & OCFS2_MOUNT_USRQUOTA &&
-	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
-					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
-		status = -EINVAL;
-		mlog(ML_ERROR, "User quotas were requested, but this "
-		     "filesystem does not have the feature enabled.\n");
-		goto read_super_error;
-	}
-	if (osb->s_mount_opt & OCFS2_MOUNT_GRPQUOTA &&
-	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
-					 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
-		status = -EINVAL;
-		mlog(ML_ERROR, "Group quotas were requested, but this "
-		     "filesystem does not have the feature enabled.\n");
-		goto read_super_error;
-	}
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -1244,6 +1230,40 @@ static struct file_system_type ocfs2_fs_type = {
 	.next           = NULL
 };
 
+static int ocfs2_check_set_options(struct super_block *sb,
+				   struct mount_options *options)
+{
+	if (options->mount_opt & OCFS2_MOUNT_USRQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		mlog(ML_ERROR, "User quotas were requested, but this "
+		     "filesystem does not have the feature enabled.\n");
+		return 0;
+	}
+	if (options->mount_opt & OCFS2_MOUNT_GRPQUOTA &&
+	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
+					 OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		mlog(ML_ERROR, "Group quotas were requested, but this "
+		     "filesystem does not have the feature enabled.\n");
+		return 0;
+	}
+	if (options->mount_opt & OCFS2_MOUNT_POSIX_ACL &&
+	    !OCFS2_HAS_INCOMPAT_FEATURE(sb, OCFS2_FEATURE_INCOMPAT_XATTR)) {
+		mlog(ML_ERROR, "ACL support requested but extended attributes "
+		     "feature is not enabled\n");
+		return 0;
+	}
+	/* No ACL setting specified? Use XATTR feature... */
+	if (!(options->mount_opt & (OCFS2_MOUNT_POSIX_ACL |
+				    OCFS2_MOUNT_NO_POSIX_ACL))) {
+		if (OCFS2_HAS_INCOMPAT_FEATURE(sb, OCFS2_FEATURE_INCOMPAT_XATTR))
+			options->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
+		else
+			options->mount_opt |= OCFS2_MOUNT_NO_POSIX_ACL;
+	}
+	return 1;
+}
+
 static int ocfs2_parse_options(struct super_block *sb,
 			       char *options,
 			       struct mount_options *mopt,
@@ -1391,31 +1411,17 @@ static int ocfs2_parse_options(struct super_block *sb,
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
 			break;
 		case Opt_usrquota:
-			/* We check only on remount, otherwise features
-			 * aren't yet initialized. */
-			if (is_remount && !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
-			    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
-				mlog(ML_ERROR, "User quota requested but "
-				     "filesystem feature is not set\n");
-				status = 0;
-				goto bail;
-			}
 			mopt->mount_opt |= OCFS2_MOUNT_USRQUOTA;
 			break;
 		case Opt_grpquota:
-			if (is_remount && !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
-			    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
-				mlog(ML_ERROR, "Group quota requested but "
-				     "filesystem feature is not set\n");
-				status = 0;
-				goto bail;
-			}
 			mopt->mount_opt |= OCFS2_MOUNT_GRPQUOTA;
 			break;
 		case Opt_acl:
 			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
+			mopt->mount_opt &= ~OCFS2_MOUNT_NO_POSIX_ACL;
 			break;
 		case Opt_noacl:
+			mopt->mount_opt |= OCFS2_MOUNT_NO_POSIX_ACL;
 			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 			break;
 		default:
-- 
1.6.0.2
