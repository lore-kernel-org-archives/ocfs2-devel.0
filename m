From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:30 -0800
Subject: [Ocfs2-devel] [PATCH 15/35] ocfs2: Use ocfs2_xattr_value_buf in
	ocfs2_xattr_set_entry().
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-16-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

ocfs2_xattr_set_entry is the function that knows what type of block it
is setting into.  This is what we wanted from ocfs2_xattr_value_buf.
Plus, moving the value buf up into ocfs2_xattr_set_entry() allows us to
pass it into ocfs2_xattr_set_value_outside() and ocfs2_xattr_cleanup().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   53 +++++++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 6a05612..c08b5e8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1252,6 +1252,7 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 			       handle_t *handle,
 			       struct ocfs2_xattr_info *xi,
 			       struct ocfs2_xattr_search *xs,
+			       struct ocfs2_xattr_value_buf *vb,
 			       size_t offs)
 {
 	int ret = 0;
@@ -1259,8 +1260,8 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 	void *val = xs->base + offs;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 
-	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = vb->vb_access(handle, inode, vb->vb_bh,
+			    OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -1271,7 +1272,7 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 	memset((void *)xs->here, 0, sizeof(struct ocfs2_xattr_entry));
 	memset(val, 0, size);
 
-	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
+	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
 	if (ret < 0)
 		mlog_errno(ret);
 out:
@@ -1318,6 +1319,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 					 struct ocfs2_xattr_info *xi,
 					 struct ocfs2_xattr_search *xs,
 					 struct ocfs2_xattr_set_ctxt *ctxt,
+					 struct ocfs2_xattr_value_buf *vb,
 					 size_t offs)
 {
 	size_t name_len = strlen(xi->name);
@@ -1325,10 +1327,6 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	struct ocfs2_xattr_value_root *xv = NULL;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 	int ret = 0;
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh = xs->xattr_bh,
-		.vb_access = ocfs2_journal_access
-	};
 
 	memset(val, 0, size);
 	memcpy(val, xi->name, name_len);
@@ -1339,19 +1337,19 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	xv->xr_list.l_tree_depth = 0;
 	xv->xr_list.l_count = cpu_to_le16(1);
 	xv->xr_list.l_next_free_rec = 0;
-	vb.vb_xv = xv;
+	vb->vb_xv = xv;
 
-	ret = ocfs2_xattr_value_truncate(inode, &vb, xi->value_len, ctxt);
+	ret = ocfs2_xattr_value_truncate(inode, vb, xi->value_len, ctxt);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, &vb, offs);
+	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, vb, offs);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
-	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb.vb_xv,
+	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb->vb_xv,
 					      xi->value, xi->value_len);
 	if (ret < 0)
 		mlog_errno(ret);
@@ -1488,6 +1486,16 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		.value = xi->value,
 		.value_len = xi->value_len,
 	};
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = xs->xattr_bh,
+		.vb_access = ocfs2_journal_access_di,
+	};
+
+	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
+		BUG_ON(xs->xattr_bh == xs->inode_bh);
+		vb.vb_access = ocfs2_journal_access_xb;
+	} else
+		BUG_ON(xs->xattr_bh != xs->inode_bh);
 
 	/* Compute min_offs, last and free space. */
 	last = xs->header->xh_entries;
@@ -1543,18 +1551,14 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		if (ocfs2_xattr_is_local(xs->here) && size == size_l) {
 			/* Replace existing local xattr with tree root */
 			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
-							    ctxt, offs);
+							    ctxt, &vb, offs);
 			if (ret < 0)
 				mlog_errno(ret);
 			goto out;
 		} else if (!ocfs2_xattr_is_local(xs->here)) {
 			/* For existing xattr which has value outside */
-			struct ocfs2_xattr_value_buf vb = {
-				.vb_bh = xs->xattr_bh,
-				.vb_xv = (struct ocfs2_xattr_value_root *)
-					(val + OCFS2_XATTR_SIZE(name_len)),
-				.vb_access = ocfs2_journal_access,
-			};
+			vb.vb_xv = (struct ocfs2_xattr_value_root *)
+				(val + OCFS2_XATTR_SIZE(name_len));
 
 			if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
 				/*
@@ -1605,16 +1609,16 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		}
 	}
 
-	ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = vb.vb_access(handle, inode, vb.vb_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1674,7 +1678,8 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		 * This is the second step for value size > INLINE_SIZE.
 		 */
 		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
-		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt, offs);
+		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt,
+						    &vb, offs);
 		if (ret < 0) {
 			int ret2;
 
@@ -1684,7 +1689,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 			 * the junk tree root we have already set in local.
 			 */
 			ret2 = ocfs2_xattr_cleanup(inode, ctxt->handle,
-						   xi, xs, offs);
+						   xi, xs, &vb, offs);
 			if (ret2 < 0)
 				mlog_errno(ret2);
 		}
-- 
1.5.6
