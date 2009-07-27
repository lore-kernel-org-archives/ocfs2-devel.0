From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jul 2009 19:53:33 +0200
Subject: [Ocfs2-devel] [PATCH 5/8] Quota support for fsck.ocfs2
In-Reply-To: <1248717216-26617-1-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
Message-ID: <1248717216-26617-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After the filesystem is fixed, scan quota files and try to gather as much
information about set limits as possible. Then scan the filesystem to
compute correct quota usage and dump all the gathered information into
freshly created quota files.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fsck.ocfs2/Makefile               |    2 +
 fsck.ocfs2/fsck.c                 |    9 +
 fsck.ocfs2/fsck.ocfs2.checks.8.in |   30 ++
 fsck.ocfs2/include/pass5.h        |   32 +++
 fsck.ocfs2/pass5.c                |  534 +++++++++++++++++++++++++++++++++++++
 5 files changed, 607 insertions(+), 0 deletions(-)
 create mode 100644 fsck.ocfs2/include/pass5.h
 create mode 100644 fsck.ocfs2/pass5.c

diff --git a/fsck.ocfs2/Makefile b/fsck.ocfs2/Makefile
index 7f6e547..850e106 100644
--- a/fsck.ocfs2/Makefile
+++ b/fsck.ocfs2/Makefile
@@ -28,6 +28,7 @@ CFILES =	fsck.c		\
 		pass2.c 	\
 		pass3.c 	\
 		pass4.c 	\
+		pass5.c		\
 		problem.c 	\
 		slot_recovery.c \
 		strings.c 	\
@@ -46,6 +47,7 @@ HFILES = 	include/fsck.h		\
 		include/pass2.h		\
 		include/pass3.h		\
 		include/pass4.h		\
+		include/pass5.h		\
 		include/problem.h	\
 		include/slot_recovery.h	\
 		include/strings.h	\
diff --git a/fsck.ocfs2/fsck.c b/fsck.ocfs2/fsck.c
index a686886..fe15783 100644
--- a/fsck.ocfs2/fsck.c
+++ b/fsck.ocfs2/fsck.c
@@ -30,6 +30,8 @@
  * pass2.c: verify directory entries, record some linkage metadata
  * pass3.c: make sure all dirs are reachable
  * pass4.c: resolve inode's link counts, move disconnected inodes to lost+found
+ * pass5.c: load global quota file, merge node-local quota files to global
+ *          quota file, recompute quota usage and recreate quota files
  *
  * When hacking on this keep the following in mind:
  *
@@ -64,6 +66,7 @@
 #include "pass2.h"
 #include "pass3.h"
 #include "pass4.h"
+#include "pass5.h"
 #include "problem.h"
 #include "util.h"
 #include "slot_recovery.h"
@@ -917,6 +920,12 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
+	ret = o2fsck_pass5(ost);
+	if (ret) {
+		com_err(whoami, ret, "while performing pass 5");
+		goto done;
+	}
+
 done:
 	if (ret)
 		fsck_mask |= FSCK_ERROR;
diff --git a/fsck.ocfs2/fsck.ocfs2.checks.8.in b/fsck.ocfs2/fsck.ocfs2.checks.8.in
index 739b867..f70f48d 100644
--- a/fsck.ocfs2/fsck.ocfs2.checks.8.in
+++ b/fsck.ocfs2/fsck.ocfs2.checks.8.in
@@ -851,6 +851,36 @@ does not match the number of buckets found by fsck.
 
 Answering yes will change this to the correct count.
 
+\" pass5.c
+
+.SS "QMAGIC_INVALID"
+The magic number in the header of quota file does not match the proper
+number.
+
+Answering yes will make fsck use values in the quota file header anyway.
+
+.SS "QTREE_BLK_INVALID"
+Block with references to other blocks with quota data is corrupted.
+
+Answering yes will make fsck use references in the block.
+
+.SS "DQBLK_INVALID"
+The structure with quota limits was found in a corrupted block.
+
+Answering yes will use the values of limits for the user / group.
+
+.SS "DUP_DQBLK_INVALID"
+The structure with quota limits was found in a corrupted block
+and fsck has already found quota limits for this user / group.
+
+Answering yes will use new values of limits for the user / group.
+
+.SS "DUP_DQBLK_VALID"
+The structure with quota limits was found in a correct block
+but fsck has already found quota limits for this user / group.
+
+Answering yes will use new values of limits for the user / group.
+
 .SH "SEE ALSO"
 .BR fsck.ocfs2(8)
 
diff --git a/fsck.ocfs2/include/pass5.h b/fsck.ocfs2/include/pass5.h
new file mode 100644
index 0000000..dfd27cd
--- /dev/null
+++ b/fsck.ocfs2/include/pass5.h
@@ -0,0 +1,32 @@
+/*
+ * pass5.h
+ *
+ * Copyright (C) 2009 Novell Corporation.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Author: Jan Kara
+ */
+
+#ifndef __O2FSCK_PASS5_H__
+#define __O2FSCK_PASS5_H__
+
+#include "fsck.h"
+
+errcode_t o2fsck_pass5(o2fsck_state *ost);
+
+#endif /* __O2FSCK_PASS4_H__ */
+
diff --git a/fsck.ocfs2/pass5.c b/fsck.ocfs2/pass5.c
new file mode 100644
index 0000000..b64898a
--- /dev/null
+++ b/fsck.ocfs2/pass5.c
@@ -0,0 +1,534 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * Copyright (C) 2009 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License, version 2,  as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * --
+ * Pass 5 tries to read as much data as possible from the global quota file.
+ * (we are interested mainly in limits for users and groups). After that we
+ * scan the filesystem and recompute quota usage for each user / group and
+ * finally we dump all the information into freshly created quota files.
+ *
+ * At this pass, filesystem should be already sound, so we use libocfs2
+ * functions for low-level operations.
+ *
+ * FIXME: We could also check node-local quota files and use limits there.
+ *        For now we just discard them.
+ */
+#include <string.h>
+#include <inttypes.h>
+#include <time.h>
+
+#include "ocfs2/ocfs2.h"
+#include "ocfs2/bitops.h"
+#include "ocfs2/byteorder.h"
+
+#include "fsck.h"
+#include "pass5.h"
+#include "problem.h"
+#include "strings.h"
+#include "util.h"
+
+static const char *whoami = "pass5";
+static char *qbmp[MAXQUOTAS];
+static ocfs2_quota_hash *qhash[MAXQUOTAS];
+
+static char *type2name(int type)
+{
+	if (type == USRQUOTA)
+		return "user";
+	return "group";
+}
+
+static errcode_t o2fsck_release_dquot(ocfs2_cached_dquot *dquot, void *p)
+{
+	ocfs2_quota_hash *hash = p;
+
+	ocfs2_remove_quota_hash(hash, dquot);
+	ocfs2_free(&dquot);
+	return 0;
+}
+
+static int check_blkref(uint32_t block, uint32_t maxblocks)
+{
+	if (block < OCFS2_GLOBAL_TREE_BLK || block >= maxblocks)
+		return 0;
+	return 1;
+}
+
+static errcode_t o2fsck_validate_blk(ocfs2_filesys *fs, char *buf)
+{
+	struct ocfs2_disk_dqtrailer *dqt =
+				ocfs2_block_dqtrailer(fs->fs_blocksize, buf);
+	return ocfs2_validate_meta_ecc(fs, buf, &dqt->dq_check);
+}
+
+static int o2fsck_valid_quota_info(ocfs2_filesys *fs, int type,
+				   struct ocfs2_disk_dqheader *header,
+				   struct ocfs2_global_disk_dqinfo *info)
+{
+	uint32_t magics[MAXQUOTAS] = OCFS2_GLOBAL_QMAGICS;
+	int versions[MAXQUOTAS] = OCFS2_GLOBAL_QVERSIONS;
+
+	if (header->dqh_magic != magics[type] ||
+	    header->dqh_version > versions[type])
+		return 0;
+	if (info->dqi_blocks !=
+	    fs->qinfo[type].qi_inode->ci_inode->i_size / fs->fs_blocksize)
+		return 0;
+	if ((info->dqi_free_blk &&
+	     !check_blkref(info->dqi_free_blk, info->dqi_blocks)) ||
+	    (info->dqi_free_entry &&
+	     !check_blkref(info->dqi_free_entry, info->dqi_blocks)))
+		return 0;
+	return 1;
+}
+
+static errcode_t o2fsck_read_blk(ocfs2_filesys *fs, int type, char *buf,
+				 uint32_t blk)
+{
+	uint32_t got;
+	errcode_t ret;
+
+	ret = ocfs2_file_read(fs->qinfo[type].qi_inode, buf, fs->fs_blocksize,
+			      blk * fs->fs_blocksize, &got);
+	if (ret)
+		return ret;
+	if (got != fs->fs_blocksize)
+		return OCFS2_ET_SHORT_READ;
+	return 0;
+}
+
+static errcode_t o2fsck_check_info(o2fsck_state *ost, int type)
+{
+	errcode_t ret;
+	ocfs2_filesys *fs = ost->ost_fs;
+	char *buf;
+	struct ocfs2_disk_dqheader *header;
+	struct ocfs2_global_disk_dqinfo *info;
+	uint64_t blocks;
+	int checksum_valid;
+
+	ret = ocfs2_malloc_blocks(fs->fs_io, fs->fs_blocksize, &buf);
+	if (ret) {
+		com_err(whoami, ret, "while allocating block buffer");
+		goto set_default;
+	}
+	ret = o2fsck_read_blk(fs, type, buf, 0);
+	if (ret) {
+		com_err(whoami, ret, "while reading global %s quota info "
+			"block", type2name(type));
+		goto set_default;
+	}
+	checksum_valid = !o2fsck_validate_blk(fs, buf);
+	header = (struct ocfs2_disk_dqheader *)buf;
+	info = (struct ocfs2_global_disk_dqinfo *)(buf + OCFS2_GLOBAL_INFO_OFF);
+	ocfs2_swap_quota_header(header);
+	ocfs2_swap_quota_global_info(info);
+	if ((!checksum_valid ||
+	     !o2fsck_valid_quota_info(fs, type, header, info)) &&
+	    !prompt(ost, PN, PR_QMAGIC_INVALID, "%s quota info looks corrupt."
+		    " Use its content:\nBlock grace time: %"PRIu32" sec\n"
+		    "Inode grace time: %"PRIu32" sec\n"
+		    "Cluster quota sync time: %"PRIu32" ms\n",
+		    type2name(type), info->dqi_bgrace, info->dqi_igrace,
+		    info->dqi_syncms)) {
+		goto set_default;
+	}
+	fs->qinfo[type].qi_info.dqi_bgrace = info->dqi_bgrace;
+	fs->qinfo[type].qi_info.dqi_igrace = info->dqi_igrace;
+	fs->qinfo[type].qi_info.dqi_syncms = info->dqi_syncms;
+	goto set_blocks;
+set_default:
+	fs->qinfo[type].qi_info.dqi_bgrace = OCFS2_DEF_BLOCK_GRACE;
+	fs->qinfo[type].qi_info.dqi_igrace = OCFS2_DEF_INODE_GRACE;
+	fs->qinfo[type].qi_info.dqi_syncms = OCFS2_DEF_QUOTA_SYNC;
+set_blocks:
+	blocks = fs->qinfo[type].qi_inode->ci_inode->i_size / fs->fs_blocksize;
+	if (blocks > (1ULL << 32) - 1)
+		fs->qinfo[type].qi_info.dqi_blocks = (1ULL << 32) - 1;
+	else
+		fs->qinfo[type].qi_info.dqi_blocks = blocks;
+	return ret;
+}
+
+/* Check whether a reference to a tree block is sane */
+static int o2fsck_check_tree_ref(o2fsck_state *ost, int type, uint32_t blk,
+				 int depth)
+{
+	ocfs2_filesys *fs = ost->ost_fs;
+	uint32_t blocks = fs->qinfo[type].qi_info.dqi_blocks;
+
+	/* Bogus block number? */
+	if (!check_blkref(blk, blocks)) {
+		verbosef("ignoring invalid %s quota block reference %"PRIu32,
+			 type2name(type), blk);
+		return 0;
+	}
+	/* Already scanned block? */
+	if (depth < ocfs2_qtree_depth(fs->fs_blocksize) &&
+	    ocfs2_test_bit(blk, qbmp[type])) {
+		verbosef("ignoring duplicate %s quota block reference %"PRIu32,
+			 type2name(type), blk);
+		return 0;
+	}
+	return 1;
+}
+
+/* Read the block, check dquot structures in it */
+static errcode_t o2fsck_check_data_blk(o2fsck_state *ost, int type,
+				       uint32_t blk, char *buf)
+{
+	ocfs2_filesys *fs = ost->ost_fs;
+	errcode_t ret;
+	struct ocfs2_global_disk_dqdbheader *dh =
+			(struct ocfs2_global_disk_dqdbheader *)buf;
+	int str_in_blk = ocfs2_global_dqstr_in_blk(fs->fs_blocksize);
+	int i;
+	struct ocfs2_global_disk_dqblk *ddquot;
+	ocfs2_cached_dquot *dquot;
+	uint32_t blocks = fs->qinfo[type].qi_info.dqi_blocks;
+	int valid;
+
+	ocfs2_set_bit(blk, qbmp[type]);
+	ret = o2fsck_read_blk(fs, type, buf, blk);
+	if (ret) {
+		com_err(whoami, ret,
+			"while reading %s quota file block %"PRIu32,
+			type2name(type), blk);
+		return ret;
+	}
+	ret = o2fsck_validate_blk(fs, buf);
+	if (ret) {
+		verbosef("%s: invalid checksum in %s quota leaf block (block %"
+			 PRIu32")", error_message(ret), type2name(type), blk);
+		valid = 0;
+	}
+	ocfs2_swap_quota_leaf_block_header(dh);
+	if ((dh->dqdh_next_free && !check_blkref(dh->dqdh_next_free, blocks)) ||
+	    (dh->dqdh_prev_free && !check_blkref(dh->dqdh_prev_free, blocks)) ||
+	    dh->dqdh_entries > str_in_blk) {
+		verbosef("corrupt %s quota leaf block header (block %"PRIu32")",
+			 type2name(type), blk);
+		valid = 0;
+	}
+	ddquot = (struct ocfs2_global_disk_dqblk *)(buf +
+			sizeof(struct ocfs2_global_disk_dqdbheader));
+	for (i = 0; i < str_in_blk; i++, ddquot++) {
+		if (ocfs2_qtree_entry_unused(ddquot))
+			continue;
+		ocfs2_swap_quota_global_dqblk(ddquot);
+		ret = ocfs2_find_quota_hash(qhash[type], ddquot->dqb_id,
+					    &dquot);
+		if (ret) {
+			com_err(whoami, ret,
+				"while searching in %s quota hash",
+				type2name(type));
+			return ret;
+		}
+		if (dquot && valid) {
+			if (!prompt(ost, PY, PR_DUP_DQBLK_VALID,
+				    "Duplicate %s quota structure for id %"
+				    PRIu32":\nCurrent quota limits: Inode: %"
+				    PRIu64" %"PRIu64" Space: %"PRIu64" %"
+				    PRIu64"\nFound quota limits: Inode: %"
+				    PRIu64" %"PRIu64" Space: %"PRIu64" %"
+				    PRIu64"\nUse found limits?",
+				    type2name(type), ddquot->dqb_id,
+				    dquot->d_ddquot.dqb_isoftlimit,
+				    dquot->d_ddquot.dqb_ihardlimit,
+				    dquot->d_ddquot.dqb_bsoftlimit,
+				    dquot->d_ddquot.dqb_bhardlimit,
+				    ddquot->dqb_isoftlimit,
+				    ddquot->dqb_ihardlimit,
+				    ddquot->dqb_bsoftlimit,
+				    ddquot->dqb_bhardlimit))
+				continue;
+		} else if (dquot && !valid) {
+			if (!prompt(ost, PN, PR_DUP_DQBLK_INVALID,
+				    "Found %s quota structure for id %"PRIu32
+				    " in a corrupted block and already have "
+				    "values for this id:\nCurrent quota "
+				    "limits: Inode: %"PRIu64" %"PRIu64" Space:"
+				    " %"PRIu64" %"PRIu64"\nFound quota limits:"
+				    " Inode: %"PRIu64" %"PRIu64" Space: %"
+				    PRIu64" %"PRIu64"\nUse found limits?",
+				    type2name(type), ddquot->dqb_id,
+				    dquot->d_ddquot.dqb_isoftlimit,
+				    dquot->d_ddquot.dqb_ihardlimit,
+				    dquot->d_ddquot.dqb_bsoftlimit,
+				    dquot->d_ddquot.dqb_bhardlimit,
+				    ddquot->dqb_isoftlimit,
+				    ddquot->dqb_ihardlimit,
+				    ddquot->dqb_bsoftlimit,
+				    ddquot->dqb_bhardlimit))
+				continue;
+		} else if (!dquot && !valid) {
+			if (!prompt(ost, PN, PR_DQBLK_INVALID,
+				    "Found corrupted %s quota structure for id"
+				    " %"PRIu32":\nFound quota limits: Inode: %"
+				    PRIu64" %"PRIu64" Space: %"PRIu64" %"
+				    PRIu64"\nUse found limits?",
+				    type2name(type), ddquot->dqb_id,
+				    ddquot->dqb_isoftlimit,
+				    ddquot->dqb_ihardlimit,
+				    ddquot->dqb_bsoftlimit,
+				    ddquot->dqb_bhardlimit))
+				continue;
+		}
+
+		if (!dquot) {
+			ret = ocfs2_find_create_quota_hash(qhash[type],
+					ddquot->dqb_id, &dquot);
+			if (ret) {
+				com_err(whoami, ret, "while inserting quota"
+					" structure into hash");
+				return ret;
+			}
+		}
+		memcpy(&dquot->d_ddquot, ddquot,
+				sizeof(struct ocfs2_global_disk_dqblk));
+		dquot->d_ddquot.dqb_use_count = 0;
+		dquot->d_ddquot.dqb_curinodes = 0;
+		dquot->d_ddquot.dqb_curspace = 0;
+	}
+	return 0;
+}
+
+/* Read the block, check references in it */
+static errcode_t o2fsck_check_tree_blk(o2fsck_state *ost, int type,
+				       uint32_t blk, int depth,
+				       char *buf)
+{
+	ocfs2_filesys *fs = ost->ost_fs;
+	errcode_t ret;
+	int epb = (fs->fs_blocksize - OCFS2_QBLK_RESERVED_SPACE) >> 2;
+	int tree_depth = ocfs2_qtree_depth(fs->fs_blocksize);
+	int i;
+	uint32_t *refs = (uint32_t *)buf, actref;
+
+	ocfs2_set_bit(blk, qbmp[type]);
+	ret = o2fsck_read_blk(fs, type, buf, blk);
+	if (ret) {
+		com_err(whoami, ret,
+			"while reading %s quota file block %"PRIu32,
+			type2name(type), blk);
+		goto out;
+	}
+	ret = o2fsck_validate_blk(fs, buf);
+	if (ret &&
+	    !prompt(ost, PN, PR_QTREE_BLK_INVALID, "Corrupted %s quota tree "
+		    "block %"PRIu32" (checksum error: %s). Scan referenced "
+		    "blocks anyway?", type2name(type), blk,
+		    error_message(ret))) {
+		goto out;
+	}
+	for (i = 0; i < epb; i++) {
+		actref = le32_to_cpu(refs[i]);
+		if (!actref)
+			continue;
+		/* Valid block reference? */
+		if (o2fsck_check_tree_ref(ost, type, actref, depth + 1)) {
+			if (depth + 1 < tree_depth) {
+				ret = o2fsck_check_tree_blk(ost, type, actref,
+					depth + 1, buf + fs->fs_blocksize);
+			} else if (!ocfs2_test_bit(actref, qbmp[type])) {
+				ret = o2fsck_check_data_blk(ost, type, actref,
+					buf + fs->fs_blocksize);
+			}
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+static errcode_t load_quota_file(o2fsck_state *ost, int type)
+{
+	ocfs2_filesys *fs = ost->ost_fs;
+	char *buf = NULL;
+	errcode_t ret;
+
+	ret = ocfs2_init_fs_quota_info(fs, type);
+	if (ret) {
+		com_err(whoami, ret, "while looking up global %s quota file",
+			type2name(type));
+		goto out;
+	}
+	ret = o2fsck_check_info(ost, type);
+	/* Some fatal error happened? */
+	if (ret)
+		goto out;
+
+	ret = ocfs2_malloc0((fs->qinfo[type].qi_info.dqi_blocks + 7) / 8,
+			    qbmp + type);
+	if (ret) {
+		com_err(whoami, ret, "while allocating %s quota file block "
+			"bitmap", type2name(type));
+		goto out;
+	}
+	ret = ocfs2_malloc_blocks(fs->fs_io,
+		fs->fs_blocksize * (ocfs2_qtree_depth(fs->fs_blocksize) + 1),
+		&buf);
+	if (ret) {
+		com_err(whoami, ret,
+			"while allocating buffer for quota blocks");
+		goto out;
+	}
+
+	if (!o2fsck_check_tree_ref(ost, type, OCFS2_GLOBAL_TREE_BLK, 0))
+		goto out;
+	ret = o2fsck_check_tree_blk(ost, type, OCFS2_GLOBAL_TREE_BLK, 0, buf);
+out:
+	if (qbmp[type])
+		ocfs2_free(qbmp + type);
+	if (buf)
+		ocfs2_free(&buf);
+	return ret;
+}
+
+/* You have to write the inode yourself after calling this function! */
+static errcode_t truncate_cached_inode(ocfs2_filesys *fs,
+				       ocfs2_cached_inode *ci)
+{
+	uint32_t new_clusters;
+	errcode_t ret;
+
+	ret = ocfs2_zero_tail_and_truncate(fs, ci, 0, &new_clusters);
+	if (ret)
+		return ret;
+	ci->ci_inode->i_clusters = new_clusters;
+	if (new_clusters == 0)
+		ci->ci_inode->id2.i_list.l_tree_depth = 0;
+	ci->ci_inode->i_size = 0;
+
+	return 0;
+}
+
+static errcode_t recreate_quota_files(ocfs2_filesys *fs, int type)
+{
+	ocfs2_cached_inode *ci = fs->qinfo[type].qi_inode;
+	errcode_t ret;
+
+	ret = truncate_cached_inode(fs, ci);
+	if (ret) {
+		com_err(whoami, ret, "while truncating global %s quota file",
+			type2name(type));
+		return ret;
+	}
+
+	ret = ocfs2_init_global_quota_file(fs, type);
+	if (ret) {
+		com_err(whoami, ret,
+			"while reinitializing global %s quota file",
+			type2name(type));
+		return ret;
+	}
+	ret = ocfs2_write_release_dquots(fs, type, qhash[type]);
+	if (ret) {
+		com_err(whoami, ret, "while writing %s quota usage",
+			type2name(type));
+		return ret;
+	}
+
+	ret = ocfs2_init_local_quota_files(fs, type);
+	if (ret) {
+		com_err(whoami, ret,
+			"while initializing local quota files");
+		return ret;
+	}
+	return 0;
+}
+
+errcode_t o2fsck_pass5(o2fsck_state *ost)
+{
+	errcode_t ret;
+	ocfs2_filesys *fs = ost->ost_fs;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	int has_usrquota, has_grpquota;
+
+	has_usrquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
+				OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
+	has_grpquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
+				OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
+	/* Nothing to check? */
+	if (!has_usrquota && !has_grpquota)
+		return 0;
+	printf("Pass 5: Checking quota information.\n");
+	if (has_usrquota) {
+		ret = ocfs2_new_quota_hash(qhash + USRQUOTA);
+		if (ret) {
+			com_err(whoami, ret,
+				"while allocating user quota hash");
+			goto out;
+		}
+		ret = load_quota_file(ost, USRQUOTA);
+		if (ret)
+			goto out;
+	}
+	if (has_grpquota) {
+		ret = ocfs2_new_quota_hash(qhash + GRPQUOTA);
+		if (ret) {
+			com_err(whoami, ret,
+				"while allocating group quota hash");
+			goto out;
+		}
+		ret = load_quota_file(ost, GRPQUOTA);
+		if (ret)
+			goto out;
+	}
+	ret = ocfs2_compute_quota_usage(fs, qhash[USRQUOTA], qhash[GRPQUOTA]);
+	if (ret) {
+		com_err(whoami, ret, "while computing quota usage");
+		goto out;
+	}
+	if (has_usrquota) {
+		ret = recreate_quota_files(fs, USRQUOTA);
+		if (ret)
+			goto out;
+		ret = ocfs2_free_quota_hash(qhash[USRQUOTA]);
+		if (ret) {
+			com_err(whoami, ret, "while release user quota hash");
+			goto out;
+		}
+	}
+	if (has_grpquota) {
+		ret = recreate_quota_files(fs, GRPQUOTA);
+		if (ret)
+			goto out;
+		ret = ocfs2_free_quota_hash(qhash[GRPQUOTA]);
+		if (ret) {
+			com_err(whoami, ret, "while release group quota hash");
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	if (qhash[USRQUOTA]) {
+		ocfs2_iterate_quota_hash(qhash[USRQUOTA], o2fsck_release_dquot,
+					 qhash[USRQUOTA]);
+		ocfs2_free_quota_hash(qhash[USRQUOTA]);
+	}
+	if (qhash[GRPQUOTA]) {
+		ocfs2_iterate_quota_hash(qhash[GRPQUOTA], o2fsck_release_dquot,
+					 qhash[GRPQUOTA]);
+		ocfs2_free_quota_hash(qhash[GRPQUOTA]);
+	}
+	return ret;
+}
-- 
1.6.0.2
