From: Jan Kara <jack@suse.cz>
Date: Tue, 28 Jul 2009 12:18:41 +0200
Subject: [Ocfs2-devel] [PATCH 09/10] Implement quota support for disabling
	SPARSE feature
In-Reply-To: <1248776322-14987-1-git-send-email-jack@suse.cz>
References: <1248776322-14987-1-git-send-email-jack@suse.cz>
Message-ID: <1248776322-14987-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When filling holes after disabling SPARSE feature, we have to
properly update quota information.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/feature_sparse_files.c |   68 ++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 4 deletions(-)

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
-- 
1.6.0.2
