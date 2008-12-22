From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:48:34 -0800
Subject: [Ocfs2-devel] [PATCH 53/56] ocfs2: Move buckets up into
	ocfs2_add_new_xattr_cluster().
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-54-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

Lift the buckets from ocfs2_adjust_xattr_cross_cluster() up into
ocfs2_add_new_xattr_cluster().  Now ocfs2_adjust_xattr_cross_cluster()
doesn't deal with buffer_heads.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |  100 ++++++++++++++++++++++++++---------------------------
 1 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2f16f50..4b24704 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4080,44 +4080,19 @@ static int ocfs2_divide_xattr_cluster(struct inode *inode,
  */
 static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 					    handle_t *handle,
-					    struct buffer_head **first_bh,
-					    struct buffer_head **header_bh,
+					    struct ocfs2_xattr_bucket *first,
+					    struct ocfs2_xattr_bucket *target,
 					    u64 new_blk,
-					    u64 prev_blk,
 					    u32 prev_clusters,
 					    u32 *v_start,
 					    int *extend)
 {
 	int ret;
-	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
-	     (unsigned long long)prev_blk, prev_clusters,
+	     (unsigned long long)bucket_blkno(first), prev_clusters,
 	     (unsigned long long)new_blk);
 
-	/* The first bucket of the original extent */
-	first = ocfs2_xattr_bucket_new(inode);
-	/* The target bucket for insert */
-	target = ocfs2_xattr_bucket_new(inode);
-	if (!first || !target) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
-
-	BUG_ON(prev_blk != (*first_bh)->b_blocknr);
-	ret = ocfs2_read_xattr_bucket(first, prev_blk);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_read_xattr_bucket(target, (*header_bh)->b_blocknr);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1) {
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
 							  handle,
@@ -4125,46 +4100,33 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 							  new_blk,
 							  prev_clusters,
 							  v_start);
-		if (ret) {
+		if (ret)
 			mlog_errno(ret);
-			goto out;
-		}
-
-		/* Did first+target get moved? */
-		if (prev_blk != bucket_blkno(first)) {
-			brelse(*first_bh);
-			*first_bh = first->bu_bhs[0];
-			get_bh(*first_bh);
-
-			brelse(*header_bh);
-			*header_bh = target->bu_bhs[0];
-			get_bh(*header_bh);
-		}
 	} else {
 		/* The start of the last cluster in the first extent */
 		u64 last_blk = bucket_blkno(first) +
 			((prev_clusters - 1) *
 			 ocfs2_clusters_to_blocks(inode->i_sb, 1));
 
-		if (prev_clusters > 1 && bucket_blkno(target) != last_blk)
+		if (prev_clusters > 1 && bucket_blkno(target) != last_blk) {
 			ret = ocfs2_mv_xattr_buckets(inode, handle,
 						     bucket_blkno(first),
 						     last_blk, new_blk, 0,
 						     v_start);
-		else {
+			if (ret)
+				mlog_errno(ret);
+		} else {
 			ret = ocfs2_divide_xattr_cluster(inode, handle,
 							 last_blk, new_blk,
 							 v_start);
+			if (ret)
+				mlog_errno(ret);
 
 			if ((bucket_blkno(target) == last_blk) && extend)
 				*extend = 0;
 		}
 	}
 
-out:
-	ocfs2_xattr_bucket_free(first);
-	ocfs2_xattr_bucket_free(target);
-
 	return ret;
 }
 
@@ -4202,6 +4164,7 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	handle_t *handle = ctxt->handle;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
+	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
 	     "previous xattr blkno = %llu\n",
@@ -4210,6 +4173,29 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
+	/* The first bucket of the original extent */
+	first = ocfs2_xattr_bucket_new(inode);
+	/* The target bucket for insert */
+	target = ocfs2_xattr_bucket_new(inode);
+	if (!first || !target) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	BUG_ON(prev_blkno != (*first_bh)->b_blocknr);
+	ret = ocfs2_read_xattr_bucket(first, prev_blkno);
+	if (ret) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
+	ret = ocfs2_read_xattr_bucket(target, (*header_bh)->b_blocknr);
+	if (ret) {
+		mlog_errno(ret);
+		goto leave;
+	}
+
 	ret = ocfs2_journal_access(handle, inode, root_bh,
 				   OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
@@ -4250,10 +4236,9 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 	} else {
 		ret = ocfs2_adjust_xattr_cross_cluster(inode,
 						       handle,
-						       first_bh,
-						       header_bh,
+						       first,
+						       target,
 						       block,
-						       prev_blkno,
 						       prev_clusters,
 						       &v_start,
 						       extend);
@@ -4261,6 +4246,17 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 			mlog_errno(ret);
 			goto leave;
 		}
+
+		/* Did first+target get moved? */
+		if (prev_blkno != bucket_blkno(first)) {
+			brelse(*first_bh);
+			*first_bh = first->bu_bhs[0];
+			get_bh(*first_bh);
+
+			brelse(*header_bh);
+			*header_bh = target->bu_bhs[0];
+			get_bh(*header_bh);
+		}
 	}
 
 	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
@@ -4277,6 +4273,8 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		mlog_errno(ret);
 
 leave:
+	ocfs2_xattr_bucket_free(first);
+	ocfs2_xattr_bucket_free(target);
 	return ret;
 }
 
-- 
1.5.6
