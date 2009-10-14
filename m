From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:08:57 +0200
Subject: [Ocfs2-devel] [PATCH 3/5] Quota support for disabling inline-data
	feature
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <1255543739-23844-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When disabling inline-data feature, space occupied by files changes
and thus we have to update quota information accordingly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tunefs.ocfs2/feature_inline_data.c |   42 +++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/tunefs.ocfs2/feature_inline_data.c b/tunefs.ocfs2/feature_inline_data.c
index 77ddb42..9e1d07f 100644
--- a/tunefs.ocfs2/feature_inline_data.c
+++ b/tunefs.ocfs2/feature_inline_data.c
@@ -170,31 +170,63 @@ static void empty_inline_data_context(struct inline_data_context *ctxt)
 static errcode_t expand_inline_data(ocfs2_filesys *fs,
 				    struct inline_data_context *ctxt)
 {
-	errcode_t ret = 0;
+	errcode_t ret = 0, err;
 	struct list_head *pos;
 	struct inline_data_inode *idi;
 	ocfs2_cached_inode *ci = NULL;
 	struct tools_progress *prog;
+	struct ocfs2_super_block *super = OCFS2_RAW_SB(fs->fs_super);
+	ocfs2_quota_hash *usrhash = NULL, *grphash = NULL;
+	uint32_t uid, gid;
+	long long change;
 
 	prog = tools_progress_start("Expanding inline files", "expanding",
 				    ctxt->more_clusters);
 	if (!ctxt->prog)
 		return TUNEFS_ET_NO_MEMORY;
 
+	ret = ocfs2_load_fs_quota_info(fs);
+	if (ret)
+		goto out;
+
+	ret = ocfs2_init_quota_change(fs, &usrhash, &grphash);
+	if (ret)
+		goto out;
+
 	list_for_each(pos, &ctxt->inodes) {
 		idi = list_entry(pos, struct inline_data_inode, list);
 
 		ret = ocfs2_read_cached_inode(fs, idi->blkno, &ci);
-		if (!ret) {
-			ret = ocfs2_convert_inline_data_to_extents(ci);
+		if (ret)
+			break;
+
+		ret = ocfs2_convert_inline_data_to_extents(ci);
+		if (ret) {
 			ocfs2_free_cached_inode(fs, ci);
+			break;
 		}
-
+		if (ci->ci_inode->i_flags & OCFS2_SYSTEM_FL &&
+		    idi->blkno != super->s_root_blkno) {
+			ocfs2_free_cached_inode(fs, ci);
+			goto next;
+		}
+		change = ocfs2_clusters_to_bytes(fs,
+						 ci->ci_inode->i_clusters);
+		uid = ci->ci_inode->i_uid;
+		gid = ci->ci_inode->i_gid;
+		ocfs2_free_cached_inode(fs, ci);
+
+		ret = ocfs2_apply_quota_change(fs, usrhash, grphash, uid, gid,
+					       change, 0);
 		if (ret)
 			break;
-
+next:
 		tools_progress_step(prog, 1);
 	}
+out:
+	err = ocfs2_finish_quota_change(fs, usrhash, grphash);
+	if (!ret)
+		ret = err;
 
 	tools_progress_stop(prog);
 
-- 
1.6.0.2
