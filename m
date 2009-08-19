From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:36 -0700
Subject: [Ocfs2-devel] [PATCH 11/14] ocfs2: Gell into ocfs2_xa_set()
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-12-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xa_set() wraps the ocfs2_xa_prepare_entry()/ocfs2_xa_store_value()
logic.  Both callers can now use the same routine.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   71 +++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a4ee086..7527546 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1988,6 +1988,40 @@ static int ocfs2_xa_store_value(struct ocfs2_xa_loc *loc,
 	return rc;
 }
 
+static int ocfs2_xa_set(struct ocfs2_xa_loc *loc,
+			struct ocfs2_xattr_info *xi,
+			struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int ret;
+	u32 name_hash = ocfs2_xattr_name_hash(loc->xl_inode, xi->xi_name,
+					      xi->xi_name_len);
+
+	ret = ocfs2_xa_journal_access(ctxt->handle, loc,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_xa_prepare_entry(loc, xi, name_hash, ctxt);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_xa_store_value(loc, xi, ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ocfs2_xa_journal_dirty(ctxt->handle, loc);
+
+out:
+	return ret;
+}
+
 static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
 				     struct inode *inode,
 				     struct buffer_head *bh,
@@ -2062,8 +2096,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
 	handle_t *handle = ctxt->handle;
 	int ret;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
-					      xi->xi_name_len);
 	struct ocfs2_xa_loc loc;
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL))
@@ -2084,14 +2116,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	else
 		ocfs2_init_xattr_block_xa_loc(&loc, inode, xs->xattr_bh,
 					      xs->not_found ? NULL : xs->here);
-	ret = ocfs2_xa_journal_access(handle, &loc,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
 
-	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash, ctxt);
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
@@ -2099,14 +2125,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 	xs->here = loc.xl_entry;
 
-	ret = ocfs2_xa_store_value(&loc, xi, ctxt);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ocfs2_xa_journal_dirty(handle, &loc);
-
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
 	    (flag & OCFS2_INLINE_XATTR_FL)) {
 		struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -5097,8 +5115,6 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 	int ret;
 	u64 blkno;
 	struct ocfs2_xa_loc loc;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
-					      xi->xi_name_len);
 
 	if (!xs->bucket->bu_bhs[1]) {
 		blkno = bucket_blkno(xs->bucket);
@@ -5112,14 +5128,7 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
-	ret = ocfs2_xa_journal_access(ctxt->handle, &loc,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash, ctxt);
+	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
@@ -5127,14 +5136,6 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 	}
 	xs->here = loc.xl_entry;
 
-	ret = ocfs2_xa_store_value(&loc, xi, ctxt);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ocfs2_xa_journal_dirty(ctxt->handle, &loc);
-
 out:
 	return ret;
 }
-- 
1.6.3.3
