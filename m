From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:35:59 -0700
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
	ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-11-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_xa_prepare_entry() gets all the logic to add, remove, or modify
external value trees.  Now, when it exits, the entry is ready to receive
a value of any size.

ocfs2_xa_store_inline_value() becomes ocfs2_xa_store_value().  It can
store any value.

ocfs2_xattr_set_entry() loses all the allocation logic and just uses
these functions.  ocfs2_xattr_set_value_outside() disappears.

ocfs2_xattr_set_in_bucket() uses these functions and makes
ocfs2_xattr_set_entry_in_bucket() obsolete.  That goes away, as does
ocfs2_xattr_bucket_set_value_outside() and
ocfs2_xattr_bucket_value_truncate().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  611 ++++++++++++------------------------------------------
 1 files changed, 138 insertions(+), 473 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 1bc12fa..d922ad9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -579,24 +579,6 @@ static u32 ocfs2_xattr_name_hash(struct inode *inode,
 	return hash;
 }
 
-/*
- * ocfs2_xattr_hash_entry()
- *
- * Compute the hash of an extended attribute.
- */
-static void ocfs2_xattr_hash_entry(struct inode *inode,
-				   struct ocfs2_xattr_header *header,
-				   struct ocfs2_xattr_entry *entry)
-{
-	u32 hash = 0;
-	char *name = (char *)header + le16_to_cpu(entry->xe_name_offset);
-
-	hash = ocfs2_xattr_name_hash(inode, name, entry->xe_name_len);
-	entry->xe_name_hash = cpu_to_le32(hash);
-
-	return;
-}
-
 static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 {
 	return namevalue_size(name_len, value_len) +
@@ -1429,113 +1411,6 @@ out:
 	return ret;
 }
 
-static int ocfs2_xattr_cleanup(struct inode *inode,
-			       handle_t *handle,
-			       struct ocfs2_xattr_info *xi,
-			       struct ocfs2_xattr_search *xs,
-			       struct ocfs2_xattr_value_buf *vb,
-			       size_t offs)
-{
-	int ret = 0;
-	void *val = xs->base + offs;
-	size_t size = namevalue_size_xi(xi);
-
-	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
-			    OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-	/* Decrease xattr count */
-	le16_add_cpu(&xs->header->xh_count, -1);
-	/* Remove the xattr entry and tree root which has already be set*/
-	memset((void *)xs->here, 0, sizeof(struct ocfs2_xattr_entry));
-	memset(val, 0, size);
-
-	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
-	if (ret < 0)
-		mlog_errno(ret);
-out:
-	return ret;
-}
-
-static int ocfs2_xattr_update_entry(struct inode *inode,
-				    handle_t *handle,
-				    struct ocfs2_xattr_info *xi,
-				    struct ocfs2_xattr_search *xs,
-				    struct ocfs2_xattr_value_buf *vb,
-				    size_t offs)
-{
-	int ret;
-
-	ret = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
-			    OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	xs->here->xe_name_offset = cpu_to_le16(offs);
-	xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
-	if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
-		ocfs2_xattr_set_local(xs->here, 1);
-	else
-		ocfs2_xattr_set_local(xs->here, 0);
-	ocfs2_xattr_hash_entry(inode, xs->header, xs->here);
-
-	ret = ocfs2_journal_dirty(handle, vb->vb_bh);
-	if (ret < 0)
-		mlog_errno(ret);
-out:
-	return ret;
-}
-
-/*
- * ocfs2_xattr_set_value_outside()
- *
- * Set large size value in B tree.
- */
-static int ocfs2_xattr_set_value_outside(struct inode *inode,
-					 struct ocfs2_xattr_info *xi,
-					 struct ocfs2_xattr_search *xs,
-					 struct ocfs2_xattr_set_ctxt *ctxt,
-					 struct ocfs2_xattr_value_buf *vb,
-					 size_t offs)
-{
-	void *val = xs->base + offs;
-	struct ocfs2_xattr_value_root *xv = NULL;
-	size_t size = namevalue_size_xi(xi);
-	int ret = 0;
-
-	memset(val, 0, size);
-	memcpy(val, xi->xi_name, xi->xi_name_len);
-	xv = (struct ocfs2_xattr_value_root *)
-		(val + OCFS2_XATTR_SIZE(xi->xi_name_len));
-	xv->xr_clusters = 0;
-	xv->xr_last_eb_blk = 0;
-	xv->xr_list.l_tree_depth = 0;
-	xv->xr_list.l_count = cpu_to_le16(1);
-	xv->xr_list.l_next_free_rec = 0;
-	vb->vb_xv = xv;
-
-	ret = ocfs2_xattr_value_truncate(inode, vb, xi->xi_value_len, ctxt);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-	ret = ocfs2_xattr_update_entry(inode, ctxt->handle, xi, xs, vb, offs);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb,
-					      xi->xi_value, xi->xi_value_len);
-	if (ret < 0)
-		mlog_errno(ret);
-
-	return ret;
-}
-
 static int ocfs2_xa_has_space_helper(int needed_space, int free_start,
 				     int num_entries)
 {
@@ -2015,6 +1890,78 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 	}
 }
 
+static int ocfs2_xa_value_truncate(struct ocfs2_xa_loc *loc, u64 bytes,
+				   struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	struct ocfs2_xattr_value_buf vb;
+
+	ocfs2_xa_fill_value_buf(loc, &vb);
+	return ocfs2_xattr_value_truncate(loc->xl_inode, &vb, bytes, ctxt);
+}
+
+static void ocfs2_xa_install_value_root(struct ocfs2_xa_loc *loc)
+{
+	int name_size = OCFS2_XATTR_SIZE(loc->xl_entry->xe_name_len);
+	char *nameval_buf;
+
+	nameval_buf = ocfs2_xa_offset_pointer(loc,
+				le16_to_cpu(loc->xl_entry->xe_name_offset));
+	memcpy(nameval_buf + name_size, &def_xv, OCFS2_XATTR_ROOT_SIZE);
+}
+
+/*
+ * Take an existing entry and make it ready for the new value.  This
+ * won't allocate space, but it may free space.  It should be ready for
+ * ocfs2_xa_prepare_entry() to finish the work.
+ */
+static int ocfs2_xa_reuse_entry(struct ocfs2_xa_loc *loc,
+				struct ocfs2_xattr_info *xi,
+				struct ocfs2_xattr_set_ctxt *ctxt)
+{
+	int rc = 0;
+	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
+	char *nameval_buf;
+	int xe_local = ocfs2_xattr_is_local(loc->xl_entry);
+	int xi_local = xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE;
+
+	BUG_ON(OCFS2_XATTR_SIZE(loc->xl_entry->xe_name_len) !=
+	       name_size);
+
+	nameval_buf = ocfs2_xa_offset_pointer(loc,
+				le16_to_cpu(loc->xl_entry->xe_name_offset));
+	if (xe_local) {
+		memset(nameval_buf + name_size, 0,
+		       namevalue_size_xe(loc->xl_entry) - name_size);
+		if (!xi_local)
+			ocfs2_xa_install_value_root(loc);
+	} else {
+		if (xi_local) {
+			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
+			if (rc < 0) {
+				mlog_errno(rc);
+				goto out;
+			}
+			memset(nameval_buf + name_size, 0,
+			       namevalue_size_xe(loc->xl_entry) -
+			       name_size);
+		} else if (le64_to_cpu(loc->xl_entry->xe_value_size) >
+			   xi->xi_value_len) {
+			rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len,
+						     ctxt);
+			if (rc < 0) {
+				mlog_errno(rc);
+				goto out;
+			}
+		}
+	}
+
+	loc->xl_entry->xe_value_size = cpu_to_le64(xi->xi_value_len);
+	ocfs2_xattr_set_local(loc->xl_entry, xi_local);
+
+out:
+	return rc;
+}
+
 /*
  * Prepares loc->xl_entry to receive the new xattr.  This includes
  * properly setting up the name+value pair region.  If loc->xl_entry
@@ -2027,11 +1974,10 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
  */
 static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 				  struct ocfs2_xattr_info *xi,
-				  u32 name_hash)
+				  u32 name_hash,
+				  struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int rc = 0;
-	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
-	char *nameval_buf;
 
 	if (!xi->xi_value) {
 		ocfs2_xa_remove_entry(loc);
@@ -2044,13 +1990,10 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 
 	if (loc->xl_entry) {
 		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
-			nameval_buf = ocfs2_xa_offset_pointer(loc,
-				le16_to_cpu(loc->xl_entry->xe_name_offset));
-			memset(nameval_buf + name_size, 0,
-			       namevalue_size_xe(loc->xl_entry) - name_size);
-			loc->xl_entry->xe_value_size =
-				cpu_to_le64(xi->xi_value_len);
-			goto out;
+			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
+			if (rc)
+				goto out;
+			goto alloc_value;
 		}
 
 		ocfs2_xa_wipe_namevalue(loc);
@@ -2062,30 +2005,46 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 	 * name+value pair back from the end.
 	 */
 	ocfs2_xa_add_namevalue(loc, xi);
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+		ocfs2_xa_install_value_root(loc);
+
+alloc_value:
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+		rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len, ctxt);
+		if (rc < 0)
+			mlog_errno(rc);
+	}
 
 out:
 	return rc;
 }
 
 /*
- * Store the value portion of the name+value pair.  This is either an
- * inline value or the tree root of an external value.
+ * Store the value portion of the name+value pair.  This will skip
+ * values that are stored externally.  Their tree roots were set up
+ * by ocfs2_xa_prepare_entry().
  */
-static void ocfs2_xa_store_inline_value(struct ocfs2_xa_loc *loc,
-					struct ocfs2_xattr_info *xi)
+static int ocfs2_xa_store_value(struct ocfs2_xa_loc *loc,
+				struct ocfs2_xattr_info *xi,
+				struct ocfs2_xattr_set_ctxt *ctxt)
 {
+	int rc = 0;
 	int nameval_offset = le16_to_cpu(loc->xl_entry->xe_name_offset);
 	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
-	int inline_value_size = namevalue_size_xi(xi) - name_size;
-	const void *value = xi->xi_value;
 	char *nameval_buf;
+	struct ocfs2_xattr_value_buf vb;
 
-	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
-		value = &def_xv;
-		inline_value_size = OCFS2_XATTR_ROOT_SIZE;
-	}
+	ocfs2_xa_fill_value_buf(loc, &vb);
 	nameval_buf = ocfs2_xa_offset_pointer(loc, nameval_offset);
-	memcpy(nameval_buf + name_size, value, inline_value_size);
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+		rc = __ocfs2_xattr_set_value_outside(loc->xl_inode,
+						     ctxt->handle, &vb,
+						     xi->xi_value,
+						     xi->xi_value_len);
+	} else
+		memcpy(nameval_buf + name_size, xi->xi_value, xi->xi_value_len);
+
+	return rc;
 }
 
 static void ocfs2_init_dinode_xa_loc(struct ocfs2_xa_loc *loc,
@@ -2158,117 +2117,19 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				 struct ocfs2_xattr_set_ctxt *ctxt,
 				 int flag)
 {
-	struct ocfs2_xattr_entry *last;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	size_t min_offs = xs->end - xs->base;
-	size_t size_l = 0;
 	handle_t *handle = ctxt->handle;
-	int free, i, ret;
+	int ret;
 	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
 					      xi->xi_name_len);
 	struct ocfs2_xa_loc loc;
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_bh = xs->xattr_bh,
-		.vb_access = ocfs2_journal_access_di,
-	};
 
-	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
+	if (!(flag & OCFS2_INLINE_XATTR_FL))
 		BUG_ON(xs->xattr_bh == xs->inode_bh);
-		vb.vb_access = ocfs2_journal_access_xb;
-	} else
+	else
 		BUG_ON(xs->xattr_bh != xs->inode_bh);
 
-	/* Compute min_offs, last and free space. */
-	last = xs->header->xh_entries;
-
-	for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
-		size_t offs = le16_to_cpu(last->xe_name_offset);
-		if (offs < min_offs)
-			min_offs = offs;
-		last += 1;
-	}
-
-	free = min_offs - ((void *)last - xs->base) - OCFS2_XATTR_HEADER_GAP;
-	if (free < 0)
-		return -EIO;
-
-	if (!xs->not_found)
-		free += ocfs2_xe_entry_usage(xs->here);
-
-	/* Check free space in inode or block */
-	if (xi->xi_value && (free < ocfs2_xi_entry_usage(xi))) {
-		ret = -ENOSPC;
-		goto out;
-	}
-
-	if (!xs->not_found) {
-		/* For existing extended attribute */
-		size_t size = namevalue_size_xe(xs->here);
-		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
-		void *val = xs->base + offs;
-
-		if (ocfs2_xattr_is_local(xs->here) && size == size_l) {
-			/* Replace existing local xattr with tree root */
-			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
-							    ctxt, &vb, offs);
-			if (ret < 0)
-				mlog_errno(ret);
-			goto out;
-		} else if (!ocfs2_xattr_is_local(xs->here)) {
-			/* For existing xattr which has value outside */
-			vb.vb_xv = (struct ocfs2_xattr_value_root *)
-				(val + OCFS2_XATTR_SIZE(xi->xi_name_len));
-
-			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
-				/*
-				 * If new value need set outside also,
-				 * first truncate old value to new value,
-				 * then set new value with set_value_outside().
-				 */
-				ret = ocfs2_xattr_value_truncate(inode,
-							&vb,
-							xi->xi_value_len,
-							ctxt);
-				if (ret < 0) {
-					mlog_errno(ret);
-					goto out;
-				}
-
-				ret = ocfs2_xattr_update_entry(inode,
-							       handle,
-							       xi,
-							       xs,
-							       &vb,
-							       offs);
-				if (ret < 0) {
-					mlog_errno(ret);
-					goto out;
-				}
-
-				ret = __ocfs2_xattr_set_value_outside(inode,
-							handle,
-							&vb,
-							xi->xi_value,
-							xi->xi_value_len);
-				if (ret < 0)
-					mlog_errno(ret);
-				goto out;
-			} else {
-				/*
-				 * If new value need set in local,
-				 * just trucate old value to zero.
-				 */
-				 ret = ocfs2_xattr_value_truncate(inode,
-								  &vb,
-								  0,
-								  ctxt);
-				if (ret < 0)
-					mlog_errno(ret);
-			}
-		}
-	}
-
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), xs->inode_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -2289,22 +2150,20 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		goto out;
 	}
 
-	/*
-	 * Prepare our entry and insert the inline value.  This will
-	 * be a value tree root for values that are larger than
-	 * OCFS2_XATTR_INLINE_SIZE.
-	 */
-	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash);
+	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash, ctxt);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
 		goto out;
 	}
-	/* XXX For now, until we make ocfs2_xa_prepare_entry() primary */
-	BUG_ON(ret == -ENOSPC);
-	ocfs2_xa_store_inline_value(&loc, xi);
 	xs->here = loc.xl_entry;
 
+	ret = ocfs2_xa_store_value(&loc, xi, ctxt);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	ocfs2_xa_journal_dirty(handle, &loc);
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) &&
@@ -2336,28 +2195,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (!ret && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
-		/*
-		 * Set value outside in B tree.
-		 * This is the second step for value size > INLINE_SIZE.
-		 */
-		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
-		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt,
-						    &vb, offs);
-		if (ret < 0) {
-			int ret2;
-
-			mlog_errno(ret);
-			/*
-			 * If set value outside failed, we have to clean
-			 * the junk tree root we have already set in local.
-			 */
-			ret2 = ocfs2_xattr_cleanup(inode, ctxt->handle,
-						   xi, xs, &vb, offs);
-			if (ret2 < 0)
-				mlog_errno(ret2);
-		}
-	}
 out:
 	return ret;
 }
@@ -5338,61 +5175,6 @@ static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
 }
 
 /*
- * Set the xattr entry in the specified bucket.
- * The bucket is indicated by xs->bucket and it should have the enough
- * space for the xattr insertion.
- */
-static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
-					   handle_t *handle,
-					   struct ocfs2_xattr_info *xi,
-					   struct ocfs2_xattr_search *xs,
-					   u32 name_hash)
-{
-	int ret;
-	u64 blkno;
-	struct ocfs2_xa_loc loc;
-
-	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
-	     (unsigned long)xi->xi_value_len, xi->xi_name_index,
-	     (unsigned long long)bucket_blkno(xs->bucket));
-
-	if (!xs->bucket->bu_bhs[1]) {
-		blkno = bucket_blkno(xs->bucket);
-		ocfs2_xattr_bucket_relse(xs->bucket);
-		ret = ocfs2_read_xattr_bucket(xs->bucket, blkno);
-		if (ret) {
-			mlog_errno(ret);
-			goto out;
-		}
-	}
-
-	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
-				       xs->not_found ? NULL : xs->here);
-	ret = ocfs2_xa_journal_access(handle, &loc,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash);
-	if (ret) {
-		if (ret != -ENOSPC)
-			mlog_errno(ret);
-		goto out;
-	}
-	/* XXX For now, until we make ocfs2_xa_prepare_entry() primary */
-	BUG_ON(ret == -ENOSPC);
-	ocfs2_xa_store_inline_value(&loc, xi);
-	xs->here = loc.xl_entry;
-
-	ocfs2_xa_journal_dirty(handle, &loc);
-
-out:
-	return ret;
-}
-
-/*
  * Truncate the specified xe_off entry in xattr bucket.
  * bucket is indicated by header_bh and len is the new length.
  * Both the ocfs2_xattr_value_root and the entry will be updated here.
@@ -5462,66 +5244,6 @@ out:
 	return ret;
 }
 
-static int ocfs2_xattr_bucket_value_truncate_xs(struct inode *inode,
-					struct ocfs2_xattr_search *xs,
-					int len,
-					struct ocfs2_xattr_set_ctxt *ctxt)
-{
-	int ret, offset;
-	struct ocfs2_xattr_entry *xe = xs->here;
-	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)xs->base;
-
-	BUG_ON(!xs->bucket->bu_bhs[0] || !xe || ocfs2_xattr_is_local(xe));
-
-	offset = xe - xh->xh_entries;
-	ret = ocfs2_xattr_bucket_value_truncate(inode, xs->bucket,
-						offset, len, ctxt);
-	if (ret)
-		mlog_errno(ret);
-
-	return ret;
-}
-
-static int ocfs2_xattr_bucket_set_value_outside(struct inode *inode,
-						handle_t *handle,
-						struct ocfs2_xattr_search *xs,
-						char *val,
-						int value_len)
-{
-	int ret, offset, block_off;
-	struct ocfs2_xattr_value_root *xv;
-	struct ocfs2_xattr_entry *xe = xs->here;
-	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
-	void *base;
-	struct ocfs2_xattr_value_buf vb = {
-		.vb_access = ocfs2_journal_access,
-	};
-
-	BUG_ON(!xs->base || !xe || ocfs2_xattr_is_local(xe));
-
-	ret = ocfs2_xattr_bucket_get_name_value(inode->i_sb, xh,
-						xe - xh->xh_entries,
-						&block_off,
-						&offset);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	base = bucket_block(xs->bucket, block_off);
-	xv = (struct ocfs2_xattr_value_root *)(base + offset +
-		 OCFS2_XATTR_SIZE(xe->xe_name_len));
-
-	vb.vb_xv = xv;
-	vb.vb_bh = xs->bucket->bu_bhs[block_off];
-	ret = __ocfs2_xattr_set_value_outside(inode, handle,
-					      &vb, val, value_len);
-	if (ret)
-		mlog_errno(ret);
-out:
-	return ret;
-}
-
 static int ocfs2_rm_xattr_cluster(struct inode *inode,
 				  struct buffer_head *root_bh,
 				  u64 blkno,
@@ -5620,41 +5342,8 @@ out:
 	return ret;
 }
 
-static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
-					 handle_t *handle,
-					 struct ocfs2_xattr_search *xs)
-{
-	struct ocfs2_xattr_header *xh = bucket_xh(xs->bucket);
-	struct ocfs2_xattr_entry *last = &xh->xh_entries[
-						le16_to_cpu(xh->xh_count) - 1];
-	int ret = 0;
-
-	ret = ocfs2_xattr_bucket_journal_access(handle, xs->bucket,
-						OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		return;
-	}
-
-	/* Remove the old entry. */
-	memmove(xs->here, xs->here + 1,
-		(void *)last - (void *)xs->here);
-	memset(last, 0, sizeof(struct ocfs2_xattr_entry));
-	le16_add_cpu(&xh->xh_count, -1);
-
-	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
-}
-
 /*
  * Set the xattr name/value in the bucket specified in xs.
- *
- * As the new value in xi may be stored in the bucket or in an outside cluster,
- * we divide the whole process into 3 steps:
- * 1. insert name/value in the bucket(ocfs2_xattr_set_entry_in_bucket)
- * 2. truncate of the outside cluster(ocfs2_xattr_bucket_value_truncate_xs)
- * 3. Set the value to the outside cluster(ocfs2_xattr_bucket_set_value_outside)
- * 4. If the clusters for the new outside value can't be allocated, we need
- *    to free the xattr we allocated in set.
  */
 static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 				     struct ocfs2_xattr_info *xi,
@@ -5662,70 +5351,46 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 				     struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int ret;
-	size_t value_len;
-	char *val = (char *)xi->xi_value;
-	struct ocfs2_xattr_entry *xe = xs->here;
+	u64 blkno;
+	struct ocfs2_xa_loc loc;
 	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
 					      xi->xi_name_len);
 
-	value_len = xi->xi_value_len;
-	if (!xs->not_found && !ocfs2_xattr_is_local(xe)) {
-		/*
-		 * We need to truncate the xattr storage first.
-		 *
-		 * If both the old and new value are stored to
-		 * outside block, we only need to truncate
-		 * the storage and then set the value outside.
-		 *
-		 * If the new value should be stored within block,
-		 * we should free all the outside block first and
-		 * the modification to the xattr block will be done
-		 * by following steps.
-		 */
-		if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
-			value_len = 0;
-
-		ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-							   value_len,
-							   ctxt);
-		if (ret)
+	if (!xs->bucket->bu_bhs[1]) {
+		blkno = bucket_blkno(xs->bucket);
+		ocfs2_xattr_bucket_relse(xs->bucket);
+		ret = ocfs2_read_xattr_bucket(xs->bucket, blkno);
+		if (ret) {
+			mlog_errno(ret);
 			goto out;
-
-		if (value_len)
-			goto set_value_outside;
+		}
 	}
 
-	/* So we have to handle the inside block change now. */
-	ret = ocfs2_xattr_set_entry_in_bucket(inode, ctxt->handle, xi, xs,
-					      name_hash);
-	if (ret) {
+	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
+				       xs->not_found ? NULL : xs->here);
+	ret = ocfs2_xa_journal_access(ctxt->handle, &loc,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
 
-	if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
+	ret = ocfs2_xa_prepare_entry(&loc, xi, name_hash, ctxt);
+	if (ret) {
+		if (ret != -ENOSPC)
+			mlog_errno(ret);
 		goto out;
+	}
+	xs->here = loc.xl_entry;
 
-	/* allocate the space now for the outside block storage. */
-	ret = ocfs2_xattr_bucket_value_truncate_xs(inode, xs,
-						   value_len, ctxt);
+	ret = ocfs2_xa_store_value(&loc, xi, ctxt);
 	if (ret) {
 		mlog_errno(ret);
-
-		if (xs->not_found) {
-			/*
-			 * We can't allocate enough clusters for outside
-			 * storage and we have allocated xattr already,
-			 * so need to remove it.
-			 */
-			ocfs2_xattr_bucket_remove_xs(inode, ctxt->handle, xs);
-		}
 		goto out;
 	}
 
-set_value_outside:
-	ret = ocfs2_xattr_bucket_set_value_outside(inode, ctxt->handle,
-						   xs, val, value_len);
+	ocfs2_xa_journal_dirty(ctxt->handle, &loc);
+
 out:
 	return ret;
 }
-- 
1.6.3.3
