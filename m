From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:08:58 +0200
Subject: [Ocfs2-devel] [PATCH 4/5] Convert disabling of sparse feature to
	use new code in libocfs2
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <1255543739-23844-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Make code handling update of quota information when disabling
sparse feature use new generic code in libocfs2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/feature_sparse_files.c |  100 ++++++----------------------------
 1 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/tunefs.ocfs2/feature_sparse_files.c b/tunefs.ocfs2/feature_sparse_files.c
index d4dff34..4f8c0db 100644
--- a/tunefs.ocfs2/feature_sparse_files.c
+++ b/tunefs.ocfs2/feature_sparse_files.c
@@ -448,8 +448,6 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 	struct list_head *pos;
 	struct sparse_file *file;
 	struct tools_progress *prog;
-	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
-	int has_usrquota, has_grpquota;
 	ocfs2_quota_hash *usrhash = NULL, *grphash = NULL;
 
 	prog = tools_progress_start("Filling holes", "filling",
@@ -459,32 +457,14 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 		goto out;
 	}
 
-	has_usrquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
-					OCFS2_FEATURE_RO_COMPAT_USRQUOTA);
-	has_grpquota = OCFS2_HAS_RO_COMPAT_FEATURE(super,
-					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA);
-	if (has_usrquota) {
-		ret = ocfs2_init_fs_quota_info(fs, USRQUOTA);
-		if (ret)
-			goto out;
-		ret = ocfs2_read_global_quota_info(fs, USRQUOTA);
-		if (ret)
-			goto out;
-		ret = ocfs2_new_quota_hash(&usrhash);
-		if (ret)
-			goto out;
-	}
-	if (has_grpquota) {
-		ret = ocfs2_init_fs_quota_info(fs, GRPQUOTA);
-		if (ret)
-			goto out;
-		ret = ocfs2_read_global_quota_info(fs, GRPQUOTA);
-		if (ret)
-			goto out;
-		ret = ocfs2_new_quota_hash(&grphash);
-		if (ret)
-			goto out;
-	}
+
+	ret = ocfs2_load_fs_quota_info(fs);
+	if (ret)
+		goto out;
+
+	ret = ocfs2_init_quota_change(fs, &usrhash, &grphash);
+	if (ret)
+		goto out;
 
 	ret = ocfs2_malloc_block(fs->fs_io, &buf);
 	if (ret)
@@ -497,7 +477,7 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 		if (ret)
 			break;
 
-		if (!file->truncate && !has_usrquota && !has_grpquota)
+		if (!file->truncate && !usrhash && !grphash)
 			continue;
 
 		ret = ocfs2_read_inode(fs, file->blkno, buf);
@@ -511,7 +491,6 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 		}
 		if (di->i_clusters != file->old_clusters) {
 			long long change;
-			ocfs2_cached_dquot *udquot = NULL, *gdquot = NULL;
 
 			if (di->i_clusters > file->old_clusters) {
 				change = ocfs2_clusters_to_bytes(fs,
@@ -521,64 +500,21 @@ static errcode_t fill_sparse_files(ocfs2_filesys *fs,
 					file->old_clusters - di->i_clusters);
 			}
 
-			if (has_usrquota) {
-				ret = ocfs2_find_quota_hash(usrhash, di->i_uid,
-							    &udquot);
-				if (ret)
-					break;
-				if (!udquot) {
-					ret = ocfs2_read_dquot(fs, USRQUOTA,
-							       di->i_uid,
-							       &udquot);
-					if (ret)
-						break;
-					ret = ocfs2_insert_quota_hash(usrhash,
-								      udquot);
-					if (ret)
-						break;
-				}
-				udquot->d_ddquot.dqb_curspace += change;
-			}
-			if (has_grpquota) {
-				ret = ocfs2_find_quota_hash(grphash, di->i_gid,
-							    &gdquot);
-				if (ret)
-					break;
-				if (!gdquot) {
-					ret = ocfs2_read_dquot(fs, GRPQUOTA,
-							       di->i_gid,
-							       &gdquot);
-					if (ret)
-						break;
-					ret = ocfs2_insert_quota_hash(grphash,
-								      gdquot);
-					if (ret)
-						break;
-				}
-				gdquot->d_ddquot.dqb_curspace += change;
-			}
+			ret = ocfs2_apply_quota_change(fs, usrhash, grphash,
+						       di->i_uid, di->i_gid,
+						       change, 0);
+			if (ret)
+				break;
 		}
 	}
 
 	ocfs2_free(&buf);
 
 out:
-	if (usrhash) {
-		err = ocfs2_write_release_dquots(fs, USRQUOTA, usrhash);
-		if (!ret)
-			ret = err;
-		err = ocfs2_free_quota_hash(usrhash);
-		if (!ret)
-			ret = err;
-	}
-	if (grphash) {
-		err = ocfs2_write_release_dquots(fs, GRPQUOTA, grphash);
-		if (!ret)
-			ret = err;
-		err = ocfs2_free_quota_hash(grphash);
-		if (!ret)
-			ret = err;
-	}
+	err = ocfs2_finish_quota_change(fs, usrhash, grphash);
+	if (!ret)
+		ret = err;
+
 	if (prog)
 		tools_progress_stop(prog);
 
-- 
1.6.0.2
