From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 14 Nov 2008 11:17:52 +0800
Subject: [Ocfs2-devel] [PATCH 10/10] ocfs2: add mount option and Kconfig
	option for acl
In-Reply-To: <491CEC4D.1090306@oracle.com>
References: <491CEC4D.1090306@oracle.com>
Message-ID: <1226632672-20034-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch add Kconfig option "CONFIG_OCFS2_FS_POSIX_ACL"
and mount option "acl" for enable acl.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    4 ++--
 fs/Kconfig                          |    9 +++++++++
 fs/ocfs2/super.c                    |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 4340cc8..578209c 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -28,13 +28,11 @@ Manish Singh  <manish.singh@oracle.com>
 Caveats
 =======
 Features which OCFS2 does not support yet:
-	- extended attributes
 	- quotas
 	- cluster aware flock
 	- cluster aware lockf
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
-	- POSIX ACLs
 
 Mount options
 =============
@@ -82,3 +80,5 @@ inode64			Indicates that Ocfs2 is allowed to create inodes at
 			bits of significance.
 user_xattr	(*)	Enables Extended User Attributes.
 nouser_xattr		Disables Extended User Attributes.
+acl			Enables POSIX Access Control Lists support.
+noacl		(*)	Disables POSIX Access Control Lists support.
diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..3af6024 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -268,6 +268,15 @@ config OCFS2_COMPAT_JBD
 	  is backwards compatible with JBD.  It is safe to say N here.
 	  However, if you really want to use the original JBD, say Y here.
 
+config OCFS2_FS_POSIX_ACL
+	bool "OCFS2 POSIX Access Control Lists"
+	depends on OCFS2_FS
+	select FS_POSIX_ACL
+	default n
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  groups beyond the owner/group/world scheme.
+
 endif # BLOCK
 
 config DNOTIFY
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 304b63a..9e7accc 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -158,6 +158,8 @@ enum {
 	Opt_user_xattr,
 	Opt_nouser_xattr,
 	Opt_inode64,
+	Opt_acl,
+	Opt_noacl,
 	Opt_err,
 };
 
@@ -180,6 +182,8 @@ static const match_table_t tokens = {
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_inode64, "inode64"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
 	{Opt_err, NULL}
 };
 
@@ -466,6 +470,8 @@ unlock_osb:
 	if (!ret) {
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
+		if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
+			parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
@@ -651,6 +657,10 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	brelse(bh);
 	bh = NULL;
+
+	if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
+		parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
+
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
@@ -664,6 +674,9 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
+
 	/* Hard readonly mode only if: bdev_read_only, MS_RDONLY,
 	 * heartbeat=none */
 	if (bdev_read_only(sb->s_bdev)) {
@@ -945,6 +958,19 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_inode64:
 			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
 			break;
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+		case Opt_acl:
+			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
+			break;
+		case Opt_noacl:
+			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
+			break;
+#else
+		case Opt_acl:
+		case Opt_noacl:
+			printk(KERN_INFO "ocfs2 (no)acl options not supported\n");
+			break;
+#endif
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1017,6 +1043,13 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (opts & OCFS2_MOUNT_INODE64)
 		seq_printf(s, ",inode64");
 
+#ifdef CONFIG_OCFS2_FS_POSIX_ACL
+	if (opts & OCFS2_MOUNT_POSIX_ACL)
+		seq_printf(s, ",acl");
+	else
+		seq_printf(s, ",noacl");
+#endif
+
 	return 0;
 }
 
-- 
1.5.4.1
