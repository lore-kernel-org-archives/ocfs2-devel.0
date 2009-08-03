From: Jan Kara <jack@suse.cz>
Date: Mon,  3 Aug 2009 15:23:37 +0200
Subject: [Ocfs2-devel] [PATCH 7/9] Add quota support to tunefs.ocfs2
In-Reply-To: <1249305819-7658-1-git-send-email-jack@suse.cz>
References: <1249305819-7658-1-git-send-email-jack@suse.cz>
Message-ID: <1249305819-7658-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Implement setting of quota feature via tunefs.ocfs2. Also properly create /
delete local quota files when number of slots increases / decreases, update
quota information when sparse feature gets disabled.

Implement setting of interval in which we sync changes in local quota file to
the global quota file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/Makefile                     |    6 +-
 tunefs.ocfs2/feature_quota.c              |  418 +++++++++++++++++++++++++++++
 tunefs.ocfs2/feature_sparse_files.c       |   68 +++++-
 tunefs.ocfs2/ocfs2ne.c                    |   26 ++
 tunefs.ocfs2/op_features.c                |    4 +
 tunefs.ocfs2/op_set_quota_sync_interval.c |  170 ++++++++++++
 tunefs.ocfs2/op_set_slot_count.c          |   91 ++++++-
 7 files changed, 776 insertions(+), 7 deletions(-)
 create mode 100644 tunefs.ocfs2/feature_quota.c
 create mode 100644 tunefs.ocfs2/op_set_quota_sync_interval.c

diff --git a/tunefs.ocfs2/Makefile b/tunefs.ocfs2/Makefile
index fd244d8..d28da81 100644
--- a/tunefs.ocfs2/Makefile
+++ b/tunefs.ocfs2/Makefile
@@ -24,7 +24,8 @@ OCFS2NE_FEATURES =			\
 	feature_metaecc			\
 	feature_sparse_files		\
 	feature_unwritten_extents	\
-	feature_xattr
+	feature_xattr			\
+	feature_quota
 
 OCFS2NE_OPERATIONS =			\
 	op_cloned_volume		\
@@ -36,7 +37,8 @@ OCFS2NE_OPERATIONS =			\
 	op_set_label			\
 	op_set_journal_size		\
 	op_set_slot_count		\
-	op_update_cluster_stack
+	op_update_cluster_stack		\
+	op_set_quota_sync_interval	\
 
 sbindir = $(root_sbindir)
 SBIN_PROGRAMS = tunefs.ocfs2
diff --git a/tunefs.ocfs2/feature_quota.c b/tunefs.ocfs2/feature_quota.c
new file mode 100644
index 0000000..b734d49
--- /dev/null
+++ b/tunefs.ocfs2/feature_quota.c
@@ -0,0 +1,418 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * feature_quota.c
+ *
+ * ocfs2 tune utility for enabling and disabling quota support.
+ *
+ * Copyright (C) 2008 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <inttypes.h>
+#include <assert.h>
+
+#include "ocfs2/ocfs2.h"
+
+#include "libocfs2ne.h"
+
+static char *type2name(int type)
+{
+	if (type == USRQUOTA)
+		return "user";
+	return "group";
+}
+
+static errcode_t create_system_file(ocfs2_filesys *fs, int type, int node)
+{
+	char fname[OCFS2_MAX_FILENAME_LEN];
+	uint64_t blkno;
+	errcode_t ret;
+
+	ocfs2_sprintf_system_inode_name(fname, sizeof(fname),
+		type, node);
+	ret = ocfs2_lookup(fs, fs->fs_sysdir_blkno, fname, strlen(fname), NULL,
+			   &blkno);
+	if (!ret) {
+		verbosef(VL_APP, "System file \"%s\" already exists!\n",
+			 fname);
+		return 0;
+	}
+	ret = ocfs2_new_system_inode(fs, &blkno,
+				ocfs2_system_inodes[type].si_mode,
+				ocfs2_system_inodes[type].si_iflags);
+	if (ret) {
+		tcom_err(ret, "while creating system file \"%s\"", fname);
+		return ret;
+	}
+
+	ret = ocfs2_link(fs, fs->fs_sysdir_blkno, fname, blkno,
+			 OCFS2_FT_REG_FILE);
+	if (ret) {
+		tcom_err(ret, "while linking file \"%s\" in the system "
+			 "directory", fname);
+		return ret;
+	}
+	return 0;
+}
+
+static errcode_t create_quota_files(ocfs2_filesys *fs, int type,
+				    struct tools_progress *prog)
+{
+	ocfs2_quota_hash *hash;
+	errcode_t ret;
+	int num_slots = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
+	int i;
+	int local_type = (type == USRQUOTA) ?
+				LOCAL_USER_QUOTA_SYSTEM_INODE :
+				LOCAL_GROUP_QUOTA_SYSTEM_INODE;
+	int global_type = (type == USRQUOTA) ?
+				USER_QUOTA_SYSTEM_INODE :
+				GROUP_QUOTA_SYSTEM_INODE;
+
+	verbosef(VL_APP, "Creating %s quota system files\n", type2name(type));
+	ret = create_system_file(fs, global_type, 0);
+	if (ret)
+		return ret;
+	for (i = 0; i < num_slots; i++) {
+		ret = create_system_file(fs, local_type, i);
+		if (ret)
+			return ret;
+	}
+	tools_progress_step(prog, 1);
+
+	verbosef(VL_APP, "Initializing global %s quota file\n",
+		 type2name(type));
+	ret = ocfs2_init_fs_quota_info(fs, type);
+	if (ret) {
+		tcom_err(ret, "while looking up global %s quota file",
+			 type2name(type));
+		return ret;
+	}
+	fs->qinfo[type].flags = 0;
+	fs->qinfo[type].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
+	fs->qinfo[type].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
+	fs->qinfo[type].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
+
+	ret = ocfs2_init_global_quota_file(fs, type);
+	if (ret) {
+		tcom_err(ret, "while initilizing global %s quota files",
+			 type2name(type));
+		return ret;
+	}
+	tools_progress_step(prog, 1);
+
+	verbosef(VL_APP, "Initializing local %s quota files\n",
+		 type2name(type));
+	ret = ocfs2_init_local_quota_files(fs, type);
+	if (ret) {
+		tcom_err(ret, "while initilizing local %s quota files",
+			 type2name(type));
+		return ret;
+	}
+	tools_progress_step(prog, 1);
+
+	verbosef(VL_APP, "Computing %s quota usage\n",
+		 type2name(type));
+	ret = ocfs2_new_quota_hash(&hash);
+	if (ret) {
+		tcom_err(ret, "while creating quota hash");
+		return ret;
+	}
+	if (type == USRQUOTA)
+		ret = ocfs2_compute_quota_usage(fs, hash, NULL);
+	else
+		ret = ocfs2_compute_quota_usage(fs, NULL, hash);
+	if (ret) {
+		tcom_err(ret, "while scanning filesystem to gather "
+			 "quota usage");
+		return ret;
+	}
+	tools_progress_step(prog, 1);
+
+	verbosef(VL_APP, "Write %s quotas to file\n",
+		 type2name(type));
+	ret = ocfs2_write_release_dquots(fs, type, hash);
+	if (ret) {
+		tcom_err(ret, "while writing %s quota usage to disk",
+			 type2name(type));
+		return ret;
+	}
+	tools_progress_step(prog, 1);
+
+	ret = ocfs2_free_quota_hash(hash);
+	if (ret)
+		tcom_err(ret, "while freeing quota hash");
+	return ret;
+}
+
+struct remove_quota_files_ctxt {
+	ocfs2_filesys *fs;
+	errcode_t err;
+	int type;
+};
+
+static int remove_quota_files_iterate(struct ocfs2_dir_entry *dirent,
+				      int offset, int blocksize, char *buf,
+				      void *priv_data)
+{
+	struct remove_quota_files_ctxt *ctxt = priv_data;
+	char dname[OCFS2_MAX_FILENAME_LEN];
+	char wname[OCFS2_MAX_FILENAME_LEN];
+	errcode_t ret;
+	int tail, i;
+	int ret_flags = 0;
+
+	strncpy(dname, dirent->name, dirent->name_len);
+	dname[dirent->name_len] = 0;
+
+	/* Check whether entry is quota file of type we want - i.e. matching
+	 * aquota.user:[0-9][0-9][0-9][0-9] or aquota.user for type == USRQUOTA
+	 * and similarly for type == GRPQUOTA */
+	strcpy(wname, "aquota.");
+	strcat(wname, type2name(ctxt->type));
+	tail = strlen(wname);
+	if (strncmp(dname, wname, tail))
+		return 0;
+	if (dname[tail] == ':') {	/* May be local file? */
+		tail++;
+		for (i = 0; i < 4; i++)
+			if (dname[tail + i] < '0' || dname[tail + i] > '9')
+				return 0;
+		if (dname[tail + i])
+			return 0;
+	} else if (dname[tail])		/* May be global file? */
+		return 0;
+
+	verbosef(VL_APP, "Deleting quota file %s\n",
+		 dname);
+	ret = ocfs2_truncate(ctxt->fs, dirent->inode, 0);
+	if (ret) {
+		tcom_err(ret, "while truncating quota file \"%s\"", dname);
+		ret_flags |= OCFS2_DIRENT_ERROR;
+		ctxt->err = ret;
+		goto out;
+	}
+	ret = ocfs2_delete_inode(ctxt->fs, dirent->inode);
+	if (ret) {
+		tcom_err(ret, "while deleting quota file \"%s\"", dname);
+		ret_flags |= OCFS2_DIRENT_ERROR;
+		ctxt->err = ret;
+	} else {
+		dirent->inode = 0;
+		ret_flags |= OCFS2_DIRENT_CHANGED;
+	}
+out:
+	return ret_flags;
+}
+
+static errcode_t remove_quota_files(ocfs2_filesys *fs, int type,
+				    struct tools_progress *prog)
+{
+	struct remove_quota_files_ctxt ctxt = {
+		.fs = fs,
+		.type = type,
+		.err = 0,
+	};
+
+	ocfs2_dir_iterate(fs, fs->fs_sysdir_blkno,
+			  OCFS2_DIRENT_FLAG_EXCLUDE_DOTS, NULL,
+			  remove_quota_files_iterate, &ctxt);
+	tools_progress_step(prog, 1);
+	return ctxt.err;
+}
+
+static int enable_usrquota(ocfs2_filesys *fs, int flags)
+{
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	errcode_t ret;
+	struct tools_progress *prog = NULL;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(super,
+	    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		verbosef(VL_APP, "User quotas are already enabled; "
+			 "nothing to enable\n");
+		return 0;
+	}
+
+	if (!tools_interact("Enable user quota feature on device "
+			    "\"%s\"? ",
+			    fs->fs_devname))
+		return 0;
+
+	prog = tools_progress_start("Enabling user quota", "usrquota", 6);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing progress display");
+		return ret;
+	}
+	tunefs_block_signals();
+	ret = create_quota_files(fs, USRQUOTA, prog);
+	if (ret) {
+		tcom_err(ret, "while creating user quota files");
+		goto bail;
+	}
+	OCFS2_SET_RO_COMPAT_FEATURE(super,
+				    OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
+	ret = ocfs2_write_super(fs);
+	tools_progress_step(prog, 1);
+bail:
+	tunefs_unblock_signals();
+	tools_progress_stop(prog);
+	return ret;
+}
+
+static int disable_usrquota(ocfs2_filesys *fs, int flags)
+{
+	errcode_t ret;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	struct tools_progress *prog = NULL;
+
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(super,
+	    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		verbosef(VL_APP, "User quotas are already disabled; "
+			 "nothing to disable\n");
+		return 0;
+	}
+
+	if (!tools_interact("Disable user quota feature on device "
+			    "\"%s\"? ",
+			    fs->fs_devname))
+		return 0;
+
+	prog = tools_progress_start("Disabling user quota", "nousrquota", 2);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing progress display");
+		return ret;
+	}
+	tunefs_block_signals();
+	ret = remove_quota_files(fs, USRQUOTA, prog);
+	if (ret) {
+		tcom_err(ret, "while removing user quota files");
+		goto bail;
+	}
+	OCFS2_CLEAR_RO_COMPAT_FEATURE(super,
+				      OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
+	ret = ocfs2_write_super(fs);
+	tools_progress_step(prog, 1);
+bail:
+	tunefs_unblock_signals();
+	tools_progress_stop(prog);
+	return ret;
+}
+
+static int enable_grpquota(ocfs2_filesys *fs, int flags)
+{
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	errcode_t ret;
+	struct tools_progress *prog = NULL;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(super,
+	    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		verbosef(VL_APP, "Group quotas are already enabled; "
+			 "nothing to enable\n");
+		return 0;
+	}
+
+	if (!tools_interact("Enable group quota feature on device "
+			    "\"%s\"? ",
+			    fs->fs_devname))
+		return 0;
+	prog = tools_progress_start("Enabling group quota", "grpquota", 6);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing progress display");
+		return ret;
+	}
+
+	tunefs_block_signals();
+	ret = create_quota_files(fs, GRPQUOTA, prog);
+	if (ret) {
+		tcom_err(ret, "while creating group quota files");
+		goto bail;
+	}
+	OCFS2_SET_RO_COMPAT_FEATURE(super,
+				    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+	ret = ocfs2_write_super(fs);
+	tools_progress_step(prog, 1);
+bail:
+	tools_progress_stop(prog);
+	tunefs_unblock_signals();
+	return ret;
+}
+
+static int disable_grpquota(ocfs2_filesys *fs, int flags)
+{
+	errcode_t ret;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	struct tools_progress *prog = NULL;
+
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(super,
+	    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		verbosef(VL_APP, "Group quotas are already disabled; "
+			 "nothing to disable\n");
+		return 0;
+	}
+
+	if (!tools_interact("Disable group quota feature on device "
+			    "\"%s\"? ",
+			    fs->fs_devname))
+		return 0;
+	prog = tools_progress_start("Disabling user quota", "nousrquota", 2);
+	if (!prog) {
+		ret = TUNEFS_ET_NO_MEMORY;
+		tcom_err(ret, "while initializing progress display");
+		return ret;
+	}
+
+	tunefs_block_signals();
+	ret = remove_quota_files(fs, GRPQUOTA, prog);
+	if (ret) {
+		tcom_err(ret, "while removing group quota files");
+		goto bail;
+	}
+	OCFS2_CLEAR_RO_COMPAT_FEATURE(super,
+				      OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+	ret = ocfs2_write_super(fs);
+	tools_progress_step(prog, 1);
+bail:
+	tools_progress_stop(prog);
+	tunefs_unblock_signals();
+	return ret;
+}
+
+DEFINE_TUNEFS_FEATURE_RO_COMPAT(usrquota,
+				OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+				TUNEFS_FLAG_RW | TUNEFS_FLAG_ALLOCATION,
+				enable_usrquota,
+				disable_usrquota);
+
+DEFINE_TUNEFS_FEATURE_RO_COMPAT(grpquota,
+				OCFS2_FEATURE_RO_COMPAT_GRPQUOTA,
+				TUNEFS_FLAG_RW | TUNEFS_FLAG_ALLOCATION,
+				enable_grpquota,
+				disable_grpquota);
+#ifdef DEBUG_EXE
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = tunefs_feature_main(argc, argv, &usrquota_feature);
+	if (ret)
+		return ret;
+	return tunefs_feature_main(argc, argv, &grpquota_feature);
+}
+#endif
diff --git a/tunefs.ocfs2/feature_sparse_files.c b/tunefs.ocfs2/feature_sparse_files.c
index 044523f..65db46b 100644
--- a/tunefs.ocfs2/feature_sparse_files.c
+++ b/tunefs.ocfs2/feature_sparse_files.c
@@ -53,6 +53,7 @@ struct sparse_file {
 	uint32_t holes_num;
 	uint32_t hole_clusters;
 	int truncate;
+	uint32_t old_clusters;
 };
 
 struct fill_hole_context {
@@ -295,6 +296,7 @@ static errcode_t hole_iterate(ocfs2_filesys *fs, struct ocfs2_dinode *di,
 
 	file->blkno = di->i_blkno;
 	INIT_LIST_HEAD(&file->holes);
+	file->old_clusters = di->i_clusters;
 	ret = find_holes_in_file(fs, di, file);
 	if (ret)
 		goto bail;
@@ -439,6 +441,8 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 	struct list_head *pos;
 	struct sparse_file *file;
 	struct tools_progress *prog;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	int has_usrquota, has_grpquota;
 
 	prog = tools_progress_start("Filling holes", "filling",
 				    ctxt->holecount);
@@ -447,6 +451,27 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 		goto out;
 	}
 
+	has_usrquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
+	has_grpquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+	if (has_usrquota) {
+		ret = ocfs2_init_fs_quota_info(fs, USRQUOTA);
+		if (ret)
+			goto out;
+		ret = ocfs2_read_global_quota_info(fs, USRQUOTA);
+		if (ret)
+			goto out;
+	}
+	if (has_grpquota) {
+		ret = ocfs2_init_fs_quota_info(fs, GRPQUOTA);
+		if (ret)
+			goto out;
+		ret = ocfs2_read_global_quota_info(fs, GRPQUOTA);
+		if (ret)
+			goto out;
+	}
+
 	ret = ocfs2_malloc_block(fs->fs_io, &buf);
 	if (ret)
 		goto out;
@@ -458,16 +483,51 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 		if (ret)
 			break;
 
-		if (!file->truncate)
+		if (!file->truncate && !has_usrquota && !has_grpquota)
 			continue;
 
 		ret = ocfs2_read_inode(fs, file->blkno, buf);
 		if (ret)
 			break;
 		di = (struct ocfs2_dinode *)buf;
-		ret = truncate_to_i_size(fs, di, NULL);
-		if (ret)
-			break;
+		if (file->truncate) {
+			ret = truncate_to_i_size(fs, di, NULL);
+			if (ret)
+				break;
+		}
+		if (di->i_clusters != file->old_clusters) {
+			long long change;
+			ocfs2_cached_dquot *udquot, *gdquot;
+
+			if (di->i_clusters > file->old_clusters) {
+				change = ocfs2_clusters_to_bytes(fs,
+					di->i_clusters - file->old_clusters);
+			} else {
+				change = -ocfs2_clusters_to_bytes(fs,
+					file->old_clusters - di->i_clusters);
+			}
+
+			if (has_usrquota) {
+				ret = ocfs2_read_dquot(fs, USRQUOTA, di->i_uid,
+						       &udquot);
+				if (ret)
+					break;
+				udquot->d_ddquot.dqb_curspace += change;
+				ret = ocfs2_write_dquot(fs, USRQUOTA, udquot);
+				if (ret)
+					break;
+			}
+			if (has_grpquota) {
+				ret = ocfs2_read_dquot(fs, GRPQUOTA, di->i_gid,
+						       &gdquot);
+				if (ret)
+					break;
+				gdquot->d_ddquot.dqb_curspace += change;
+				ret = ocfs2_write_dquot(fs, GRPQUOTA, gdquot);
+				if (ret)
+					break;
+			}
+		}
 	}
 
 	ocfs2_free(&buf);
diff --git a/tunefs.ocfs2/ocfs2ne.c b/tunefs.ocfs2/ocfs2ne.c
index c9051a4..48760c6 100644
--- a/tunefs.ocfs2/ocfs2ne.c
+++ b/tunefs.ocfs2/ocfs2ne.c
@@ -98,6 +98,8 @@ extern struct tunefs_operation set_label_op;
 extern struct tunefs_operation set_slot_count_op;
 extern struct tunefs_operation update_cluster_stack_op;
 extern struct tunefs_operation cloned_volume_op;
+extern struct tunefs_operation set_usrquota_sync_interval_op;
+extern struct tunefs_operation set_grpquota_sync_interval_op;
 
 /* List of operations we're going to run */
 static LIST_HEAD(tunefs_run_list);
@@ -583,6 +585,28 @@ static struct tunefs_option journal_option = {
 	.opt_handle	= handle_journal_arg,
 };
 
+static struct tunefs_option set_usrquota_sync_interval_option = {
+	.opt_option	= {
+		.name		= "usrquota-sync-interval",
+		.val		= 256,
+		.has_arg	= 1,
+	},
+	.opt_help	= "   --usrquota-sync-interval <interval>",
+	.opt_handle	= generic_handle_arg,
+	.opt_op		= &set_usrquota_sync_interval_op,
+};
+
+static struct tunefs_option set_grpquota_sync_interval_option = {
+	.opt_option	= {
+		.name		= "grpquota-sync-interval",
+		.val		= 257,
+		.has_arg	= 1,
+	},
+	.opt_help	= "   --grpquota-sync-interval <interval>",
+	.opt_handle	= generic_handle_arg,
+	.opt_op		= &set_grpquota_sync_interval_op,
+};
+
 /* The order here creates the order in print_usage() */
 static struct tunefs_option *options[] = {
 	&help_option,
@@ -603,6 +627,8 @@ static struct tunefs_option *options[] = {
 	&features_option,
 	&update_cluster_stack_option,
 	&cloned_volume_option,
+	&set_usrquota_sync_interval_option,
+	&set_grpquota_sync_interval_option,
 	&yes_option,
 	&no_option,
 	NULL,
diff --git a/tunefs.ocfs2/op_features.c b/tunefs.ocfs2/op_features.c
index ee9442e..afcc1f4 100644
--- a/tunefs.ocfs2/op_features.c
+++ b/tunefs.ocfs2/op_features.c
@@ -41,6 +41,8 @@ extern struct tunefs_feature metaecc_feature;
 extern struct tunefs_feature sparse_files_feature;
 extern struct tunefs_feature unwritten_extents_feature;
 extern struct tunefs_feature xattr_feature;
+extern struct tunefs_feature usrquota_feature;
+extern struct tunefs_feature grpquota_feature;
 
 /* List of features supported by ocfs2ne */
 static struct tunefs_feature *features[] = {
@@ -52,6 +54,8 @@ static struct tunefs_feature *features[] = {
 	&sparse_files_feature,
 	&unwritten_extents_feature,
 	&xattr_feature,
+	&usrquota_feature,
+	&grpquota_feature,
 	NULL,
 };
 
diff --git a/tunefs.ocfs2/op_set_quota_sync_interval.c b/tunefs.ocfs2/op_set_quota_sync_interval.c
new file mode 100644
index 0000000..12b70b5
--- /dev/null
+++ b/tunefs.ocfs2/op_set_quota_sync_interval.c
@@ -0,0 +1,170 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * op_set_quota_sync_interval.c
+ *
+ * ocfs2 tune utility for updating interval for syncing quota structures
+ * to global quota file.
+ *
+ * Copyright (C) 2009 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <ctype.h>
+#include <inttypes.h>
+
+#include "ocfs2/ocfs2.h"
+
+#include "libocfs2ne.h"
+
+static char *type2name(int type)
+{
+	if (type == USRQUOTA)
+		return "user";
+	return "group";
+}
+
+static int update_sync_interval(ocfs2_filesys *fs, int type,
+				unsigned long syncms)
+{
+	errcode_t err;
+	struct tools_progress *prog;
+	int feature = (type == USRQUOTA) ? OCFS2_FEATURE_RO_COMPAT_USRQUOTA :
+					   OCFS2_FEATURE_RO_COMPAT_GRPQUOTA;
+	struct ocfs2_global_disk_dqinfo *qinfo;
+
+	if (!OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super), feature)) {
+		errorf("The %s quota is not enabled on device \"%s\"\n",
+		       type2name(type), fs->fs_devname);
+		return 1;
+	}
+	err = ocfs2_init_fs_quota_info(fs, type);
+	if (err) {
+		tcom_err(err, "while looking up %s quota file on device "
+			 "\"%s\"", type2name(type), fs->fs_devname);
+		return 1;
+	}
+	err = ocfs2_read_global_quota_info(fs, type);
+	if (err) {
+		tcom_err(err, "while reading %s quota info on device \"%s\"",
+			 type2name(type), fs->fs_devname);
+		return 1;
+	}
+	qinfo = &fs->qinfo[type].qi_info;
+	if (qinfo->dqi_syncms == syncms) {
+		verbosef(VL_APP,
+			 "Device \"%s\" already has interval %lu set; "
+			 "nothing to do\n", fs->fs_devname, syncms);
+		return 0;
+	}
+
+	if (!tools_interact("Change quota syncing interval on device \"%s\" "
+			    "from %lu to %lu? ", fs->fs_devname,
+			    (unsigned long)qinfo->dqi_syncms, syncms))
+		return 0;
+
+	prog = tools_progress_start("Setting syncing interval", "interval", 1);
+	if (!prog) {
+		tcom_err(err, "while initializing the progress display");
+		return 1;
+	}
+
+	tunefs_block_signals();
+	qinfo->dqi_syncms = syncms;
+	err = ocfs2_write_global_quota_info(fs, type);
+	tunefs_unblock_signals();
+
+	tools_progress_step(prog, 1);
+	tools_progress_stop(prog);
+
+	if (err) {
+		tcom_err(err,
+			 "- unable to update %s quota syncing interval on "
+			 "device \"%s\"", type2name(type), fs->fs_devname);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int set_quota_sync_interval_parse_option(struct tunefs_operation *op,
+						char *arg)
+{
+	int rc = 1;
+	unsigned long interval;
+	char *ptr;
+
+	if (!arg) {
+		errorf("No interval specified\n");
+		goto out;
+	}
+
+	interval = strtoul(arg, &ptr, 10);
+	if (*ptr != 0) {
+		errorf("Invalid number: %s", arg);
+		goto out;
+	}
+
+	if (interval < 100 || interval == ULONG_MAX ||
+	    interval > ~(uint32_t)0) {
+		errorf("Quota sync interval is out of range (minimum is 100,"
+		       " maximum is 4294967295): %s\n", arg);
+		goto out;
+	}
+
+	op->to_private = (void *)interval;
+	rc = 0;
+out:
+	return rc;
+}
+
+static int set_usrquota_sync_interval_run(struct tunefs_operation *op,
+					  ocfs2_filesys *fs,
+					  int flags)
+{
+	return update_sync_interval(fs, USRQUOTA,
+				    (unsigned long)op->to_private);
+}
+
+static int set_grpquota_sync_interval_run(struct tunefs_operation *op,
+					  ocfs2_filesys *fs,
+					  int flags)
+{
+	return update_sync_interval(fs, GRPQUOTA,
+				    (unsigned long)op->to_private);
+}
+
+
+DEFINE_TUNEFS_OP(set_usrquota_sync_interval,
+		 "Usage: op_set_usrquota_sync_interval [opts] <device> <interval in ms>\n",
+		 TUNEFS_FLAG_RW,
+		 set_quota_sync_interval_parse_option,
+		 set_usrquota_sync_interval_run);
+
+DEFINE_TUNEFS_OP(set_grpquota_sync_interval,
+		 "Usage: op_set_grpquota_sync_interval [opts] <device> <interval in ms>\n",
+		 TUNEFS_FLAG_RW,
+		 set_quota_sync_interval_parse_option,
+		 set_grpquota_sync_interval_run);
+
+#ifdef DEBUG_EXE
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = tunefs_op_main(argc, argv, &set_usrquota_sync_interval_op);
+	if (ret)
+		return ret;
+	return tunefs_op_main(argc, argv, &set_grpquota_sync_interval_op);
+}
+#endif
diff --git a/tunefs.ocfs2/op_set_slot_count.c b/tunefs.ocfs2/op_set_slot_count.c
index 7d94b98..46ce2de 100644
--- a/tunefs.ocfs2/op_set_slot_count.c
+++ b/tunefs.ocfs2/op_set_slot_count.c
@@ -56,6 +56,7 @@ static errcode_t add_slots(ocfs2_filesys *fs, int num_slots)
 {
 	errcode_t ret;
 	uint16_t old_num = OCFS2_RAW_SB(fs->fs_super)->s_max_slots;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
 	char fname[OCFS2_MAX_FILENAME_LEN];
 	uint64_t blkno;
 	int i, j, max_slots;
@@ -83,6 +84,14 @@ static errcode_t add_slots(ocfs2_filesys *fs, int num_slots)
 
 	ret = 0;
 	for (i = OCFS2_LAST_GLOBAL_SYSTEM_INODE + 1; i < NUM_SYSTEM_INODES; ++i) {
+		if (i == LOCAL_USER_QUOTA_SYSTEM_INODE &&
+		    !OCFS2_HAS_RO_COMPAT_FEATURE(super,
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA))
+			continue;
+		if (i == LOCAL_GROUP_QUOTA_SYSTEM_INODE &&
+		    !OCFS2_HAS_RO_COMPAT_FEATURE(super,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA))
+			continue;
 		for (j = old_num; j < num_slots; ++j) {
 			ocfs2_sprintf_system_inode_name(fname,
 							OCFS2_MAX_FILENAME_LEN,
@@ -141,6 +150,32 @@ static errcode_t add_slots(ocfs2_filesys *fs, int num_slots)
 					error_message(ret), blkno, fname);
 				goto bail;
 			}
+			/* Initialize quota files */
+			if (i == LOCAL_USER_QUOTA_SYSTEM_INODE) {
+				verbosef(VL_APP, "Initializing local user "
+					 "quota file\n");
+				ret = ocfs2_init_local_quota_file(fs, USRQUOTA,
+								  blkno);
+				if (ret) {
+					verbosef(VL_APP,
+						 "%s while initializing user "
+						 "quota file %s\n",
+						 error_message(ret), fname);
+					goto bail;
+				}
+			} else if (i == LOCAL_GROUP_QUOTA_SYSTEM_INODE) {
+				verbosef(VL_APP, "Initializing local group "
+					 "quota file\n");
+				ret = ocfs2_init_local_quota_file(fs, GRPQUOTA,
+								  blkno);
+				if (ret) {
+					verbosef(VL_APP,
+						 "%s while initializing group "
+						 "quota file %s\n",
+						 error_message(ret), fname);
+					goto bail;
+				}
+			}
 			verbosef(VL_APP, "System file \"%s\" created\n",
 				 fname);
 			tools_progress_step(prog, 1);
@@ -585,6 +620,54 @@ bail:
 	return ret;
 }
 
+static errcode_t truncate_quota_file(ocfs2_filesys *fs,
+				     uint16_t removed_slot,
+				     int type)
+{
+	errcode_t ret;
+	uint64_t blkno;
+	char fname[OCFS2_MAX_FILENAME_LEN];
+	int local_type = (type == USRQUOTA) ? LOCAL_USER_QUOTA_SYSTEM_INODE :
+					      LOCAL_GROUP_QUOTA_SYSTEM_INODE;
+
+	ocfs2_sprintf_system_inode_name(fname, OCFS2_MAX_FILENAME_LEN,
+					local_type, removed_slot);
+	verbosef(VL_APP, "Truncating quota file \"%s\"\n", fname);
+
+	ret = ocfs2_lookup_system_inode(fs, local_type, removed_slot, &blkno);
+	if (!ret) {
+		ret = ocfs2_truncate(fs, blkno, 0);
+		if (!ret)
+			verbosef(VL_APP, "Quota file \"%s\" truncated\n",
+				 fname);
+		else
+			verbosef(VL_APP,
+				 "%s while truncating quota file \"%s\"\n",
+				 error_message(ret), fname);
+	} else
+		verbosef(VL_APP,
+			 "%s while looking up quota file \"%s\"\n",
+			 error_message(ret), fname);
+
+	return ret;
+}
+
+static errcode_t truncate_quota_files(ocfs2_filesys *fs,
+				      uint16_t removed_slot)
+{
+	errcode_t ret = 0;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA))
+		ret = truncate_quota_file(fs, removed_slot, USRQUOTA);
+	if (ret)
+		return ret;
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA))
+		ret = truncate_quota_file(fs, removed_slot, GRPQUOTA);
+	return ret;
+}
+
 static errcode_t truncate_orphan_dir(ocfs2_filesys *fs,
 				     uint16_t removed_slot)
 {
@@ -887,7 +970,7 @@ static errcode_t remove_slots(ocfs2_filesys *fs, int num_slots)
 
 	/* We have seven steps in removing each slot */
 	prog = tools_progress_start("Removing slots", "rmslots",
-				    (old_num - num_slots) * 7);
+				    (old_num - num_slots) * 8);
 	if (!prog) {
 		ret = TUNEFS_ET_NO_MEMORY;
 		goto bail;
@@ -930,6 +1013,12 @@ static errcode_t remove_slots(ocfs2_filesys *fs, int num_slots)
 			goto bail;
 		tools_progress_step(prog, 1);
 
+		/* truncate local quota files */
+		ret = truncate_quota_files(fs, removed_slot);
+		if (ret)
+			goto bail;
+		tools_progress_step(prog, 1);
+
 		/* Now, we decrease the max_slots first and then remove the
 		 * slots for the reason that:
 		 *
-- 
1.6.0.2
