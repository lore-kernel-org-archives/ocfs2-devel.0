From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 28 Aug 2009 01:35:52 -0700
Subject: [Ocfs2-devel] [PATCH 03/14] ocfs2: Prefix the member fields of
	struct ocfs2_xattr_info.
In-Reply-To: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1251448563-12508-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

struct ocfs2_xattr_info is a useful structure describing an xattr
you'd like to set.  Let's put prefixes on the member fields so it's
easier to read and use.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  212 +++++++++++++++++++++++++++--------------------------
 1 files changed, 108 insertions(+), 104 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 333d384..2fdf809 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -120,10 +120,10 @@ static struct xattr_handler *ocfs2_xattr_handler_map[OCFS2_XATTR_MAX] = {
 };
 
 struct ocfs2_xattr_info {
-	int name_index;
-	const char *name;
-	const void *value;
-	size_t value_len;
+	int		xi_name_index;
+	const char	*xi_name;
+	const void	*xi_value;
+	size_t		xi_value_len;
 };
 
 struct ocfs2_xattr_search {
@@ -1367,7 +1367,7 @@ static int ocfs2_xattr_cleanup(struct inode *inode,
 			       size_t offs)
 {
 	int ret = 0;
-	size_t name_len = strlen(xi->name);
+	size_t name_len = strlen(xi->xi_name);
 	void *val = xs->base + offs;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 
@@ -1407,8 +1407,8 @@ static int ocfs2_xattr_update_entry(struct inode *inode,
 	}
 
 	xs->here->xe_name_offset = cpu_to_le16(offs);
-	xs->here->xe_value_size = cpu_to_le64(xi->value_len);
-	if (xi->value_len <= OCFS2_XATTR_INLINE_SIZE)
+	xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
+	if (xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE)
 		ocfs2_xattr_set_local(xs->here, 1);
 	else
 		ocfs2_xattr_set_local(xs->here, 0);
@@ -1433,14 +1433,14 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 					 struct ocfs2_xattr_value_buf *vb,
 					 size_t offs)
 {
-	size_t name_len = strlen(xi->name);
+	size_t name_len = strlen(xi->xi_name);
 	void *val = xs->base + offs;
 	struct ocfs2_xattr_value_root *xv = NULL;
 	size_t size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
 	int ret = 0;
 
 	memset(val, 0, size);
-	memcpy(val, xi->name, name_len);
+	memcpy(val, xi->xi_name, name_len);
 	xv = (struct ocfs2_xattr_value_root *)
 		(val + OCFS2_XATTR_SIZE(name_len));
 	xv->xr_clusters = 0;
@@ -1450,7 +1450,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 	xv->xr_list.l_next_free_rec = 0;
 	vb->vb_xv = xv;
 
-	ret = ocfs2_xattr_value_truncate(inode, vb, xi->value_len, ctxt);
+	ret = ocfs2_xattr_value_truncate(inode, vb, xi->xi_value_len, ctxt);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -1461,7 +1461,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
 		return ret;
 	}
 	ret = __ocfs2_xattr_set_value_outside(inode, ctxt->handle, vb,
-					      xi->value, xi->value_len);
+					      xi->xi_value, xi->xi_value_len);
 	if (ret < 0)
 		mlog_errno(ret);
 
@@ -1665,7 +1665,7 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 					struct ocfs2_xattr_entry *last,
 					size_t min_offs)
 {
-	size_t name_len = strlen(xi->name);
+	size_t name_len = strlen(xi->xi_name);
 	struct ocfs2_xa_loc loc;
 
 	if (xs->xattr_bh == xs->inode_bh)
@@ -1674,10 +1674,10 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 	else
 		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
 					      xs->not_found ? NULL : xs->here);
-	if (xi->value && xs->not_found) {
+	if (xi->xi_value && xs->not_found) {
 		/* Insert the new xattr entry. */
 		le16_add_cpu(&xs->header->xh_count, 1);
-		ocfs2_xattr_set_type(last, xi->name_index);
+		ocfs2_xattr_set_type(last, xi->xi_name_index);
 		ocfs2_xattr_set_local(last, 1);
 		last->xe_name_len = name_len;
 	} else {
@@ -1697,42 +1697,42 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
 			size = OCFS2_XATTR_SIZE(name_len) +
 			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
 
-		if (xi->value && size == OCFS2_XATTR_SIZE(name_len) +
-				OCFS2_XATTR_SIZE(xi->value_len)) {
+		if (xi->xi_value && size == OCFS2_XATTR_SIZE(name_len) +
+				OCFS2_XATTR_SIZE(xi->xi_value_len)) {
 			/* The old and the new value have the
 			   same size. Just replace the value. */
 			ocfs2_xattr_set_local(xs->here, 1);
-			xs->here->xe_value_size = cpu_to_le64(xi->value_len);
+			xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
 			/* Clear value bytes. */
 			memset(val + OCFS2_XATTR_SIZE(name_len),
 			       0,
-			       OCFS2_XATTR_SIZE(xi->value_len));
+			       OCFS2_XATTR_SIZE(xi->xi_value_len));
 			memcpy(val + OCFS2_XATTR_SIZE(name_len),
-			       xi->value,
-			       xi->value_len);
+			       xi->xi_value,
+			       xi->xi_value_len);
 			return;
 		}
 
-		if (!xi->value)
+		if (!xi->xi_value)
 			ocfs2_xa_remove_entry(&loc);
 		else
 			ocfs2_xa_wipe_namevalue(&loc);
 
 		min_offs += size;
 	}
-	if (xi->value) {
+	if (xi->xi_value) {
 		/* Insert the new name+value. */
 		size_t size = OCFS2_XATTR_SIZE(name_len) +
-				OCFS2_XATTR_SIZE(xi->value_len);
+				OCFS2_XATTR_SIZE(xi->xi_value_len);
 		void *val = xs->base + min_offs - size;
 
 		xs->here->xe_name_offset = cpu_to_le16(min_offs - size);
 		memset(val, 0, size);
-		memcpy(val, xi->name, name_len);
+		memcpy(val, xi->xi_name, name_len);
 		memcpy(val + OCFS2_XATTR_SIZE(name_len),
-		       xi->value,
-		       xi->value_len);
-		xs->here->xe_value_size = cpu_to_le64(xi->value_len);
+		       xi->xi_value,
+		       xi->xi_value_len);
+		xs->here->xe_value_size = cpu_to_le64(xi->xi_value_len);
 		ocfs2_xattr_set_local(xs->here, 1);
 		ocfs2_xattr_hash_entry(inode, xs->header, xs->here);
 	}
@@ -1758,15 +1758,15 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	struct ocfs2_xattr_entry *last;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
-	size_t min_offs = xs->end - xs->base, name_len = strlen(xi->name);
+	size_t min_offs = xs->end - xs->base, name_len = strlen(xi->xi_name);
 	size_t size_l = 0;
 	handle_t *handle = ctxt->handle;
 	int free, i, ret;
 	struct ocfs2_xattr_info xi_l = {
-		.name_index = xi->name_index,
-		.name = xi->name,
-		.value = xi->value,
-		.value_len = xi->value_len,
+		.xi_name_index = xi->xi_name_index,
+		.xi_name = xi->xi_name,
+		.xi_value = xi->xi_value,
+		.xi_value_len = xi->xi_value_len,
 	};
 	struct ocfs2_xattr_value_buf vb = {
 		.vb_bh = xs->xattr_bh,
@@ -1804,7 +1804,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 		free += (size + sizeof(struct ocfs2_xattr_entry));
 	}
 	/* Check free space in inode or block */
-	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+	if (xi->xi_value && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 		if (free < sizeof(struct ocfs2_xattr_entry) +
 			   OCFS2_XATTR_SIZE(name_len) +
 			   OCFS2_XATTR_ROOT_SIZE) {
@@ -1812,12 +1812,12 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 			goto out;
 		}
 		size_l = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
-		xi_l.value = (void *)&def_xv;
-		xi_l.value_len = OCFS2_XATTR_ROOT_SIZE;
-	} else if (xi->value) {
+		xi_l.xi_value = (void *)&def_xv;
+		xi_l.xi_value_len = OCFS2_XATTR_ROOT_SIZE;
+	} else if (xi->xi_value) {
 		if (free < sizeof(struct ocfs2_xattr_entry) +
 			   OCFS2_XATTR_SIZE(name_len) +
-			   OCFS2_XATTR_SIZE(xi->value_len)) {
+			   OCFS2_XATTR_SIZE(xi->xi_value_len)) {
 			ret = -ENOSPC;
 			goto out;
 		}
@@ -1842,16 +1842,16 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 			vb.vb_xv = (struct ocfs2_xattr_value_root *)
 				(val + OCFS2_XATTR_SIZE(name_len));
 
-			if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 				/*
 				 * If new value need set outside also,
 				 * first truncate old value to new value,
 				 * then set new value with set_value_outside().
 				 */
 				ret = ocfs2_xattr_value_truncate(inode,
-								 &vb,
-								 xi->value_len,
-								 ctxt);
+							&vb,
+							xi->xi_value_len,
+							ctxt);
 				if (ret < 0) {
 					mlog_errno(ret);
 					goto out;
@@ -1869,10 +1869,10 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 				}
 
 				ret = __ocfs2_xattr_set_value_outside(inode,
-								handle,
-								&vb,
-								xi->value,
-								xi->value_len);
+							handle,
+							&vb,
+							xi->xi_value,
+							xi->xi_value_len);
 				if (ret < 0)
 					mlog_errno(ret);
 				goto out;
@@ -1950,7 +1950,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (!ret && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+	if (!ret && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 		/*
 		 * Set value outside in B tree.
 		 * This is the second step for value size > INLINE_SIZE.
@@ -2616,13 +2616,13 @@ static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
 
 	BUG_ON(!xs->not_found);
 
-	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 		value_size = OCFS2_XATTR_ROOT_SIZE;
 	else
-		value_size = OCFS2_XATTR_SIZE(xi->value_len);
+		value_size = OCFS2_XATTR_SIZE(xi->xi_value_len);
 
 	if (free >= sizeof(struct ocfs2_xattr_entry) +
-		   OCFS2_XATTR_SIZE(strlen(xi->name)) + value_size)
+		   OCFS2_XATTR_SIZE(strlen(xi->xi_name)) + value_size)
 		return 1;
 
 	return 0;
@@ -2646,7 +2646,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 	char *base = NULL;
 	int name_offset, name_len = 0;
 	u32 new_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
-						    xi->value_len);
+						    xi->xi_value_len);
 	u64 value_size;
 
 	/*
@@ -2654,14 +2654,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 	 * No matter whether we replace an old one or add a new one,
 	 * we need this for writing.
 	 */
-	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 		credits += new_clusters *
 			   ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	if (xis->not_found && xbs->not_found) {
 		credits += ocfs2_blocks_per_xattr_bucket(inode->i_sb);
 
-		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			clusters_add += new_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							&def_xv.xv.xr_list,
@@ -2706,7 +2706,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 	 * The credits for removing the value tree will be extended
 	 * by ocfs2_remove_extent itself.
 	 */
-	if (!xi->value) {
+	if (!xi->xi_value) {
 		if (!ocfs2_xattr_is_local(xe))
 			credits += ocfs2_remove_extent_credits(inode->i_sb);
 
@@ -2736,7 +2736,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		}
 	}
 
-	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
+	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 		/* the new values will be stored outside. */
 		u32 old_clusters = 0;
 
@@ -2769,9 +2769,10 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 * value, we don't need any allocation, otherwise we have
 		 * to guess metadata allocation.
 		 */
-		if ((ocfs2_xattr_is_local(xe) && value_size >= xi->value_len) ||
+		if ((ocfs2_xattr_is_local(xe) &&
+		     (value_size >= xi->xi_value_len)) ||
 		    (!ocfs2_xattr_is_local(xe) &&
-		     OCFS2_XATTR_ROOT_SIZE >= xi->value_len))
+		     OCFS2_XATTR_ROOT_SIZE >= xi->xi_value_len))
 			goto out;
 	}
 
@@ -2861,7 +2862,7 @@ static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
 
 	meta_add += extra_meta;
 	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d, "
-	     "credits = %d\n", xi->name, meta_add, clusters_add, *credits);
+	     "credits = %d\n", xi->xi_name, meta_add, clusters_add, *credits);
 
 	if (meta_add) {
 		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
@@ -2901,7 +2902,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 {
 	int ret = 0, credits, old_found;
 
-	if (!xi->value) {
+	if (!xi->xi_value) {
 		/* Remove existing extended attribute */
 		if (!xis->not_found)
 			ret = ocfs2_xattr_ibody_set(inode, xi, xis, ctxt);
@@ -2915,8 +2916,8 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 			 * If succeed and that extended attribute existing in
 			 * external block, then we will remove it.
 			 */
-			xi->value = NULL;
-			xi->value_len = 0;
+			xi->xi_value = NULL;
+			xi->xi_value_len = 0;
 
 			old_found = xis->not_found;
 			xis->not_found = -ENODATA;
@@ -2944,8 +2945,8 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 		} else if (ret == -ENOSPC) {
 			if (di->i_xattr_loc && !xbs->xattr_bh) {
 				ret = ocfs2_xattr_block_find(inode,
-							     xi->name_index,
-							     xi->name, xbs);
+							     xi->xi_name_index,
+							     xi->xi_name, xbs);
 				if (ret)
 					goto out;
 
@@ -2984,8 +2985,8 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				 * If succeed and that extended attribute
 				 * existing in inode, we will remove it.
 				 */
-				xi->value = NULL;
-				xi->value_len = 0;
+				xi->xi_value = NULL;
+				xi->xi_value_len = 0;
 				xbs->not_found = -ENODATA;
 				ret = ocfs2_calc_xattr_set_need(inode,
 								di,
@@ -3051,10 +3052,10 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	int ret;
 
 	struct ocfs2_xattr_info xi = {
-		.name_index = name_index,
-		.name = name,
-		.value = value,
-		.value_len = value_len,
+		.xi_name_index = name_index,
+		.xi_name = name,
+		.xi_value = value,
+		.xi_value_len = value_len,
 	};
 
 	struct ocfs2_xattr_search xis = {
@@ -3134,10 +3135,10 @@ int ocfs2_xattr_set(struct inode *inode,
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	struct ocfs2_xattr_info xi = {
-		.name_index = name_index,
-		.name = name,
-		.value = value,
-		.value_len = value_len,
+		.xi_name_index = name_index,
+		.xi_name = name,
+		.xi_value = value,
+		.xi_value_len = value_len,
 	};
 
 	struct ocfs2_xattr_search xis = {
@@ -4985,7 +4986,7 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 					 int local)
 {
 	struct ocfs2_xattr_entry *last, *xe;
-	int name_len = strlen(xi->name);
+	int name_len = strlen(xi->xi_name);
 	struct ocfs2_xattr_header *xh = xs->header;
 	u16 count = le16_to_cpu(xh->xh_count), start;
 	size_t blocksize = inode->i_sb->s_blocksize;
@@ -5007,22 +5008,24 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 			OCFS2_XATTR_SIZE(OCFS2_XATTR_ROOT_SIZE);
 
 		/*
-		 * If the new value will be stored outside, xi->value has been
-		 * initalized as an empty ocfs2_xattr_value_root, and the same
-		 * goes with xi->value_len, so we can set new_size safely here.
+		 * If the new value will be stored outside, xi->xi_value has
+		 * been initalized as an empty ocfs2_xattr_value_root, and
+		 * the same goes with xi->xi_value_len, so we can set
+		 * new_size safely here.
 		 * See ocfs2_xattr_set_in_bucket.
 		 */
 		new_size = OCFS2_XATTR_SIZE(name_len) +
-			   OCFS2_XATTR_SIZE(xi->value_len);
+			   OCFS2_XATTR_SIZE(xi->xi_value_len);
 
-		if (xi->value) {
+		if (xi->xi_value) {
 			ocfs2_xa_wipe_namevalue(&loc);
 			if (new_size > size)
 				goto set_new_name_value;
 
 			/* Now replace the old value with new one. */
 			if (local)
-				xe->xe_value_size = cpu_to_le64(xi->value_len);
+				xe->xe_value_size =
+					cpu_to_le64(xi->xi_value_len);
 			else
 				xe->xe_value_size = 0;
 
@@ -5030,9 +5033,9 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 							 xs->bucket, offs);
 			memset(val + OCFS2_XATTR_SIZE(name_len), 0,
 			       size - OCFS2_XATTR_SIZE(name_len));
-			if (OCFS2_XATTR_SIZE(xi->value_len) > 0)
+			if (OCFS2_XATTR_SIZE(xi->xi_value_len) > 0)
 				memcpy(val + OCFS2_XATTR_SIZE(name_len),
-				       xi->value, xi->value_len);
+				       xi->xi_value, xi->xi_value_len);
 
 			le16_add_cpu(&xh->xh_name_value_len, new_size);
 			ocfs2_xattr_set_local(xe, local);
@@ -5073,12 +5076,12 @@ static void ocfs2_xattr_set_entry_normal(struct inode *inode,
 		memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
 		xe->xe_name_hash = cpu_to_le32(name_hash);
 		xe->xe_name_len = name_len;
-		ocfs2_xattr_set_type(xe, xi->name_index);
+		ocfs2_xattr_set_type(xe, xi->xi_name_index);
 	}
 
 set_new_name_value:
 	/* Insert the new name+value. */
-	size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(xi->value_len);
+	size = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_SIZE(xi->xi_value_len);
 
 	/*
 	 * We must make sure that the name/value pair
@@ -5097,10 +5100,11 @@ set_new_name_value:
 	xe->xe_name_offset = cpu_to_le16(offs - size);
 
 	memset(val, 0, size);
-	memcpy(val, xi->name, name_len);
-	memcpy(val + OCFS2_XATTR_SIZE(name_len), xi->value, xi->value_len);
+	memcpy(val, xi->xi_name, name_len);
+	memcpy(val + OCFS2_XATTR_SIZE(name_len), xi->xi_value,
+	       xi->xi_value_len);
 
-	xe->xe_value_size = cpu_to_le64(xi->value_len);
+	xe->xe_value_size = cpu_to_le64(xi->xi_value_len);
 	ocfs2_xattr_set_local(xe, local);
 	xs->here = xe;
 	le16_add_cpu(&xh->xh_free_start, -size);
@@ -5125,7 +5129,7 @@ static int ocfs2_xattr_set_entry_in_bucket(struct inode *inode,
 	u64 blkno;
 
 	mlog(0, "Set xattr entry len = %lu index = %d in bucket %llu\n",
-	     (unsigned long)xi->value_len, xi->name_index,
+	     (unsigned long)xi->xi_value_len, xi->xi_name_index,
 	     (unsigned long long)bucket_blkno(xs->bucket));
 
 	if (!xs->bucket->bu_bhs[1]) {
@@ -5423,10 +5427,10 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 {
 	int ret, local = 1;
 	size_t value_len;
-	char *val = (char *)xi->value;
+	char *val = (char *)xi->xi_value;
 	struct ocfs2_xattr_entry *xe = xs->here;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->name,
-					      strlen(xi->name));
+	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+					      strlen(xi->xi_name));
 
 	if (!xs->not_found && !ocfs2_xattr_is_local(xe)) {
 		/*
@@ -5441,8 +5445,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		 * the modification to the xattr block will be done
 		 * by following steps.
 		 */
-		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
-			value_len = xi->value_len;
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+			value_len = xi->xi_value_len;
 		else
 			value_len = 0;
 
@@ -5456,7 +5460,7 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 			goto set_value_outside;
 	}
 
-	value_len = xi->value_len;
+	value_len = xi->xi_value_len;
 	/* So we have to handle the inside block change now. */
 	if (value_len > OCFS2_XATTR_INLINE_SIZE) {
 		/*
@@ -5464,8 +5468,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 		 * initalize a new empty value root and insert it first.
 		 */
 		local = 0;
-		xi->value = &def_xv;
-		xi->value_len = OCFS2_XATTR_ROOT_SIZE;
+		xi->xi_value = &def_xv;
+		xi->xi_value_len = OCFS2_XATTR_ROOT_SIZE;
 	}
 
 	ret = ocfs2_xattr_set_entry_in_bucket(inode, ctxt->handle, xi, xs,
@@ -5539,11 +5543,11 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 	struct ocfs2_xattr_entry *xe;
 	u16 count, header_size, xh_free_start;
 	int free, max_free, need, old;
-	size_t value_size = 0, name_len = strlen(xi->name);
+	size_t value_size = 0, name_len = strlen(xi->xi_name);
 	size_t blocksize = inode->i_sb->s_blocksize;
 	int ret, allocation = 0;
 
-	mlog_entry("Set xattr %s in xattr index block\n", xi->name);
+	mlog_entry("Set xattr %s in xattr index block\n", xi->xi_name);
 
 try_again:
 	xh = xs->header;
@@ -5559,10 +5563,10 @@ try_again:
 			(unsigned long long)bucket_blkno(xs->bucket),
 			header_size);
 
-	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE)
+	if (xi->xi_value && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 		value_size = OCFS2_XATTR_ROOT_SIZE;
-	else if (xi->value)
-		value_size = OCFS2_XATTR_SIZE(xi->value_len);
+	else if (xi->xi_value)
+		value_size = OCFS2_XATTR_SIZE(xi->xi_value_len);
 
 	if (xs->not_found)
 		need = sizeof(struct ocfs2_xattr_entry) +
@@ -5645,7 +5649,7 @@ try_again:
 		 */
 		ret = ocfs2_check_xattr_bucket_collision(inode,
 							 xs->bucket,
-							 xi->name);
+							 xi->xi_name);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -5669,8 +5673,8 @@ try_again:
 		 */
 		ocfs2_xattr_bucket_relse(xs->bucket);
 		ret = ocfs2_xattr_index_block_find(inode, xs->xattr_bh,
-						   xi->name_index,
-						   xi->name, xs);
+						   xi->xi_name_index,
+						   xi->xi_name, xs);
 		if (ret && ret != -ENODATA)
 			goto out;
 		xs->not_found = ret;
@@ -5891,7 +5895,7 @@ static int ocfs2_prepare_refcount_xattr(struct inode *inode,
 	 * refcount tree, and make the original extent become 3. So we will need
 	 * 2 * cluster more extent recs at most.
 	 */
-	if (!xi->value || xi->value_len <= OCFS2_XATTR_INLINE_SIZE) {
+	if (!xi->xi_value || xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE) {
 
 		ret = ocfs2_refcounted_xattr_delete_need(inode,
 							 &(*ref_tree)->rf_ci,
-- 
1.6.3.3
