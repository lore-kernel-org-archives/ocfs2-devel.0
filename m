From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:21 -0700
Subject: [Ocfs2-devel] [PATCH 3/8] ocfs2: Correct ordering of ip_alloc_sem
	and localloc locks for directories
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jan Kara <jack@suse.cz>

Mainline commit edd45c08499a3e9d4c25431cd2b6a9ce5f692c92

We use ordering ip_alloc_sem -> local alloc locks in ocfs2_write_begin().
So change lock ordering in ocfs2_extend_dir() and ocfs2_expand_inline_dir()
to also use this lock ordering.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6389c05..f251c1a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1197,6 +1197,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 
 	alloc = ocfs2_clusters_for_bytes(sb, bytes);
 
+	down_write(&oi->ip_alloc_sem);
+
 	/*
 	 * We should never need more than 2 clusters for this -
 	 * maximum dirent size is far less than one block. In fact,
@@ -1213,8 +1215,6 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/*
 	 * Prepare for worst case allocation scenario of two separate
 	 * extents.
@@ -1226,7 +1226,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_sem;
+		goto out;
 	}
 
 	/*
@@ -1353,10 +1353,8 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
-out_sem:
-	up_write(&oi->ip_alloc_sem);
-
 out:
+	up_write(&oi->ip_alloc_sem);
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
 
@@ -1468,11 +1466,15 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
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
@@ -1511,9 +1513,6 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	}
 
 do_extend:
-	down_write(&OCFS2_I(dir)->ip_alloc_sem);
-	drop_alloc_sem = 1;
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -1560,10 +1559,10 @@ bail_bh:
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
1.6.0.4
