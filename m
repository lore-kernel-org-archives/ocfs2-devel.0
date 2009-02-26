From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:15:03 +0100
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: Correct ordering of ip_alloc_sem
	and localloc locks for directories
In-Reply-To: <1235679305-3920-5-git-send-email-jack@suse.cz>
References: <y> <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
	<1235679305-3920-5-git-send-email-jack@suse.cz>
Message-ID: <1235679305-3920-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We use ordering ip_alloc_sem -> local alloc locks in ocfs2_write_begin().
So change lock ordering in ocfs2_extend_dir() and ocfs2_expand_inline_dir()
to also use this lock ordering.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dir.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e71160c..1d6e901 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2900,6 +2900,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	alloc = ocfs2_clusters_for_bytes(sb, bytes);
 	dx_alloc = 0;
 
+	down_write(&oi->ip_alloc_sem);
+
 	if (ocfs2_supports_indexed_dirs(osb)) {
 		credits += ocfs2_add_dir_index_credits(sb);
 
@@ -2940,8 +2942,6 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/*
 	 * Prepare for worst case allocation scenario of two separate
 	 * extents in the unindexed tree.
@@ -2953,7 +2953,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_sem;
+		goto out;
 	}
 
 	if (vfs_dq_alloc_space_nodirty(dir,
@@ -3172,10 +3172,8 @@ out_commit:
 
 	ocfs2_commit_trans(osb, handle);
 
-out_sem:
-	up_write(&oi->ip_alloc_sem);
-
 out:
+	up_write(&oi->ip_alloc_sem);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 	if (meta_ac)
@@ -3322,11 +3320,15 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 		brelse(new_bh);
 		new_bh = NULL;
 
+		down_write(&OCFS2_I(dir)->ip_alloc_sem);
+		drop_alloc_sem = 1;
 		dir_i_size = i_size_read(dir);
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
 		goto do_extend;
 	}
 
+	down_write(&OCFS2_I(dir)->ip_alloc_sem);
+	drop_alloc_sem = 1;
 	dir_i_size = i_size_read(dir);
 	mlog(0, "extending dir %llu (i_size = %lld)\n",
 	     (unsigned long long)OCFS2_I(dir)->ip_blkno, dir_i_size);
@@ -3370,9 +3372,6 @@ do_extend:
 		credits++; /* For attaching the new dirent block to the
 			    * dx_root */
 
-	down_write(&OCFS2_I(dir)->ip_alloc_sem);
-	drop_alloc_sem = 1;
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -3435,10 +3434,10 @@ bail_bh:
 	*new_de_bh = new_bh;
 	get_bh(*new_de_bh);
 bail:
-	if (drop_alloc_sem)
-		up_write(&OCFS2_I(dir)->ip_alloc_sem);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
+	if (drop_alloc_sem)
+		up_write(&OCFS2_I(dir)->ip_alloc_sem);
 
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-- 
1.6.0.2
