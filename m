From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jul 2009 19:53:34 +0200
Subject: [Ocfs2-devel] [PATCH 6/8] Quota support for mkfs.ocfs2
In-Reply-To: <1248717216-26617-1-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
Message-ID: <1248717216-26617-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mkfs.ocfs2/mkfs.c          |  146 +++++++++++++++++++++++++++++++++++++++++++-
 mkfs.ocfs2/mkfs.h          |    1 +
 mkfs.ocfs2/mkfs.ocfs2.8.in |   16 +++++
 3 files changed, 162 insertions(+), 1 deletions(-)

diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
index 6acc6e6..8496d03 100644
--- a/mkfs.ocfs2/mkfs.c
+++ b/mkfs.ocfs2/mkfs.c
@@ -98,12 +98,16 @@ static SystemFileInfo system_files[] = {
 	{ "slot_map", SFI_OTHER, 1, S_IFREG | 0644 },
 	{ "heartbeat", SFI_HEARTBEAT, 1, S_IFREG | 0644 },
 	{ "global_bitmap", SFI_CLUSTER, 1, S_IFREG | 0644 },
+	{ "aquota.user", SFI_QUOTA, 1, S_IFREG | 0644 },
+	{ "aquota.group", SFI_QUOTA, 1, S_IFREG | 0644 },
 	{ "orphan_dir:%04d", SFI_OTHER, 0, S_IFDIR | 0755 },
 	{ "extent_alloc:%04d", SFI_CHAIN, 0, S_IFREG | 0644 },
 	{ "inode_alloc:%04d", SFI_CHAIN, 0, S_IFREG | 0644 },
 	{ "journal:%04d", SFI_JOURNAL, 0, S_IFREG | 0644 },
 	{ "local_alloc:%04d", SFI_LOCAL_ALLOC, 0, S_IFREG | 0644 },
-	{ "truncate_log:%04d", SFI_TRUNCATE_LOG, 0, S_IFREG | 0644 }
+	{ "truncate_log:%04d", SFI_TRUNCATE_LOG, 0, S_IFREG | 0644 },
+	{ "aquota.user:%04d", SFI_QUOTA, 0, S_IFREG | 0644 },
+	{ "aquota.group:%04d", SFI_QUOTA, 0, S_IFREG | 0644 },
 };
 
 struct fs_type_translation {
@@ -226,6 +230,23 @@ static void mkfs_init_dir_trailer(State *s, DirData *dir, void *buf)
 	}
 }
 
+/* Should we skip this inode because of features enabled / disabled? */
+static int feature_skip(State *s, int system_inode)
+{
+	switch (system_inode) {
+		case USER_QUOTA_SYSTEM_INODE:
+		case LOCAL_USER_QUOTA_SYSTEM_INODE:
+			return !(s->feature_flags.opt_ro_compat &
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
+		case GROUP_QUOTA_SYSTEM_INODE:
+		case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
+			return !(s->feature_flags.opt_ro_compat &
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+		default:
+			return 0;
+	}
+}
+
 static inline uint32_t system_dir_bytes_needed(State *s)
 {
 	int each = OCFS2_DIR_REC_LEN(SYSTEM_FILE_NAME_MAX);
@@ -233,6 +254,114 @@ static inline uint32_t system_dir_bytes_needed(State *s)
 	return each * sys_blocks_needed(s->initial_slots);
 }
 
+static void format_quota_files(State *s, ocfs2_filesys *fs)
+{
+	errcode_t ret;
+	ocfs2_quota_hash *usr_hash = NULL, *grp_hash = NULL;
+
+	/* Write correct data into quota files */
+	if (!feature_skip(s, USER_QUOTA_SYSTEM_INODE)) {
+		ret = ocfs2_init_fs_quota_info(fs, USRQUOTA);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while looking up global user quota file");
+			goto error;
+		}
+		fs->qinfo[USRQUOTA].flags = 0;
+		fs->qinfo[USRQUOTA].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
+		fs->qinfo[USRQUOTA].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
+		fs->qinfo[USRQUOTA].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
+
+		ret = ocfs2_new_quota_hash(&usr_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while creating user quota hash.");
+			goto error;
+		}
+		ret = ocfs2_init_global_quota_file(fs, USRQUOTA);
+		if (ret) {
+			com_err(s->progname, ret, "while creating global user "
+				"quota file");
+			goto error;
+		}
+		ret = ocfs2_init_local_quota_files(fs, USRQUOTA);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while initializing local user quota files");
+			goto error;
+		}
+	}
+	if (!feature_skip(s, GROUP_QUOTA_SYSTEM_INODE)) {
+		ret = ocfs2_init_fs_quota_info(fs, GRPQUOTA);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while looking up global group quota file");
+			goto error;
+		}
+		fs->qinfo[GRPQUOTA].flags = 0;
+		fs->qinfo[GRPQUOTA].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
+		fs->qinfo[GRPQUOTA].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
+		fs->qinfo[GRPQUOTA].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
+		ret = ocfs2_new_quota_hash(&usr_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while creating group quota hash.");
+			goto error;
+		}
+		ret = ocfs2_init_global_quota_file(fs, GRPQUOTA);
+		if (ret) {
+			com_err(s->progname, ret, "while creating global group "
+				"quota file");
+			goto error;
+		}
+
+		ret = ocfs2_init_local_quota_files(fs, GRPQUOTA);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while initializing local group quota files");
+			goto error;
+		}
+	}
+
+	ret = ocfs2_compute_quota_usage(fs, usr_hash, grp_hash);
+	if (ret) {
+		com_err(s->progname, ret, "while computing quota usage");
+		goto error;
+	}
+	if (usr_hash) {
+		ret = ocfs2_write_release_dquots(fs, USRQUOTA, usr_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while writing user quota usage");
+			goto error;
+		}
+		ret = ocfs2_free_quota_hash(usr_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while releasing user quota hash");
+			goto error;
+		}
+	}
+	if (grp_hash) {
+		ret = ocfs2_write_release_dquots(fs, GRPQUOTA, grp_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while writing group quota usage");
+			goto error;
+		}
+		ret = ocfs2_free_quota_hash(grp_hash);
+		if (ret) {
+			com_err(s->progname, ret,
+				"while releasing group quota hash");
+			goto error;
+		}
+	}
+	return;
+error:
+	clear_both_ends(s);
+	exit(1);
+}
+
 static void finish_normal_format(State *s)
 {
 	errcode_t ret;
@@ -304,6 +433,14 @@ static void finish_normal_format(State *s)
 	if (!s->quiet)
 		printf("done\n");
 
+	if (!s->quiet)
+		printf("Formatting quota files: ");
+
+	format_quota_files(s, fs);
+
+	if (!s->quiet)
+		printf("done\n");
+
 	ocfs2_close(fs);
 }
 
@@ -471,6 +608,8 @@ main(int argc, char **argv)
 	for (i = 0; i < NUM_SYSTEM_INODES; i++) {
 		if (hb_dev_skip(s, i))
 			continue;
+		if (feature_skip(s, i))
+			continue;
 
 		num = (system_files[i].global) ? 1 : s->initial_slots;
 		for (j = 0; j < num; j++) {
@@ -529,6 +668,8 @@ main(int argc, char **argv)
 	for (i = 0; i < NUM_SYSTEM_INODES; i++) {
 		if (hb_dev_skip(s, i))
 			continue;
+		if (feature_skip(s, i))
+			continue;
 
 		num = system_files[i].global ? 1 : s->initial_slots;
 		for (j = 0; j < num; j++) {
@@ -2432,6 +2573,9 @@ init_record(State *s, SystemFileDiskRecord *rec, int type, int mode)
 	case SFI_TRUNCATE_LOG:
 		rec->flags |= OCFS2_DEALLOC_FL;
 		break;
+	case SFI_QUOTA:
+		rec->flags |= OCFS2_QUOTA_FL;
+		break;
 	case SFI_OTHER:
 		break;
 	}
diff --git a/mkfs.ocfs2/mkfs.h b/mkfs.ocfs2/mkfs.h
index bd8ac45..969e4df 100644
--- a/mkfs.ocfs2/mkfs.h
+++ b/mkfs.ocfs2/mkfs.h
@@ -96,6 +96,7 @@ enum {
 	SFI_HEARTBEAT,
 	SFI_CHAIN,
 	SFI_TRUNCATE_LOG,
+	SFI_QUOTA,
 	SFI_OTHER
 };
 
diff --git a/mkfs.ocfs2/mkfs.ocfs2.8.in b/mkfs.ocfs2/mkfs.ocfs2.8.in
index 38433ee..d1f4011 100644
--- a/mkfs.ocfs2/mkfs.ocfs2.8.in
+++ b/mkfs.ocfs2/mkfs.ocfs2.8.in
@@ -146,6 +146,22 @@ arbitrary binary data. Attributes can be attached to all types of inodes: regula
 symbolic links, device nodes, etc. This feature is required for users wanting to use extended security
 facilities like POSIX ACLs or SELinux.
 .RE
+.RS 1.2i
+.TP
+\fBusrquota\fR
+Enable user quota support. With this feature enabled, filesystem will track amount of space
+and number of inodes (files, directories, symbolic links) each user owns. It is then possible
+to limit the maximum amount of space or inodes user can have. See a documentation of
+quota-tools package for more details.
+.RE
+.RS 1.2i
+.TP
+\fBgrpquota\fR
+Enable group quota support. With this feature enabled, filesystem will track amount of space
+and number of inodes (files, directories, symbolic links) each group owns. It is then possible
+to limit the maximum amount of space or inodes user can have. See a documentation of
+quota-tools package for more details.
+.RE
 
 .TP
 \fB\-\-fs\-feature\-level=\fR\fR\fIfeature\-level\fR
-- 
1.6.0.2
