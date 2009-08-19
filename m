From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:32 -0700
Subject: [Ocfs2-devel] [PATCH 07/14] ocfs2: Handle value tree roots in
	ocfs2_xa_set_inline_value()
In-Reply-To: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1250711679-12441-8-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Previously the xattr code would send in a fake value, containing a tree
root, to the function that installed name+value pairs.  Instead, we pass
the real value to ocfs2_xa_set_inline_value(), and it notices that the
value cannot fit.  Thus, it installs a tree root.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   54 ++++++++++++++++--------------------------------------
 1 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a69bdaf..0f24e0a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1895,11 +1895,16 @@ static void ocfs2_xa_store_inline_value(struct ocfs2_xa_loc *loc,
 {
 	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
 	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
-	int size = namevalue_size_xi(xi);
+	int inline_value_size = namevalue_size_xi(xi) - name_size;
+	const void *value = xi->xi_value;
 	char *nameval_buf;
 
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+		value = &def_xv;
+		inline_value_size = OCFS2_XATTR_ROOT_SIZE;
+	}
 	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
-	memcpy(nameval_buf + name_size, xi->xi_value, size - name_size);
+	memcpy(nameval_buf + name_size, value, inline_value_size);
 }
 
 static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
@@ -1978,13 +1983,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
 					      xi->xi_name_len);
 	struct ocfs2_xa_loc loc;
-	struct ocfs2_xattr_info xi_l = {
-		.xi_name_index = xi->xi_name_index,
-		.xi_name = xi->xi_name,
-		.xi_name_len = xi->xi_name_len,
-		.xi_value = xi->xi_value,
-		.xi_value_len = xi->xi_value_len,
-	};
 	struct ocfs2_xattr_value_buf vb = {
 		.vb_bh = xs->xattr_bh,
 		.vb_access = ocfs2_journal_access_di,
@@ -2014,16 +2012,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		free += ocfs2_xe_entry_usage(xs->here);
 
 	/* Check free space in inode or block */
-	if (xi->xi_value) {
-		if (free < ocfs2_xi_entry_usage(xi)) {
-			ret = -ENOSPC;
-			goto out;
-		}
-		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
-			size_l = namevalue_size_xi(xi);
-			xi_l.xi_value = (void *)&def_xv;
-			xi_l.xi_value_len = OCFS2_XATTR_ROOT_SIZE;
-		}
+	if (xi->xi_value && (free < ocfs2_xi_entry_usage(xi))) {
+		ret = -ENOSPC;
+		goto out;
 	}
 
 	if (!xs->not_found) {
@@ -4991,8 +4982,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 					   handle_t *handle,
 					   struct ocfs2_xattr_info *xi,
 					   struct ocfs2_xattr_search *xs,
-					   u32 name_hash,
-					   int local)
+					   u32 name_hash)
 {
 	int ret;
 	u64 blkno;
@@ -5293,13 +5283,14 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 				     struct ocfs2_xattr_search *xs,
 				     struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret, local = 1;
+	int ret;
 	size_t value_len;
 	char *val = (char *)xi->xi_value;
 	struct ocfs2_xattr_entry *xe = xs->here;
 	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
 					      xi->xi_name_len);
 
+	value_len = xi->xi_value_len;
 	if (!xs->not_found && !ocfs2_xattr_is_local(xe)) {
 		/*
 		 * We need to truncate the xattr storage first.
@@ -5313,9 +5304,7 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		 * the modification to the xattr block will be done
 		 * by following steps.
 		 */
-		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
-			value_len = xi->xi_value_len;
-		else
+		if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
 			value_len = 0;
 
 		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
@@ -5328,26 +5317,15 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 			goto set_value_outside;
 	}
 
-	value_len = xi->xi_value_len;
 	/* So we have to handle the inside block change now. */
-	if (value_len > OCFS2_XATTR_INLINE_SIZE) {
-		/*
-		 * If the new value will be stored outside of block,
-		 * initalize a new empty value root and insert it first.
-		 */
-		local = 0;
-		xi->xi_value = &def_xv;
-		xi->xi_value_len = OCFS2_XATTR_ROOT_SIZE;
-	}
-
 	ret = ocfs2_xattr_set_entry_in_bucket(inode, ctxt->handle, xi, xs,
-					      name_hash, local);
+					      name_hash);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	if (value_len <= OCFS2_XATTR_INLINE_SIZE)
+	if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
 		goto out;
 
 	/* allocate the space now for the outside block storage. */
-- 
1.6.3.3
