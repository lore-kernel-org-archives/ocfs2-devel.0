From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Aug 2008 13:52:25 -0700
Subject: [Ocfs2-devel] [PATCH 13/15] Enable xattr set in index btree. v3
In-Reply-To: <48A0E2DD.2020607@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-11-git-send-email-tao.ma@oracle.com>
	<20080812001110.GF21187@wotan.suse.de>
	<48A0E2DD.2020607@oracle.com>
Message-ID: <20080812205225.GH21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 12, 2008 at 09:09:49AM +0800, Tao Ma wrote:
> 
> 
> Mark Fasheh wrote:
> >On Thu, Aug 07, 2008 at 06:31:33AM +0800, Tao Ma wrote:
> >>+/*
> >>+ * Add a new cluster for xattr storage.
> >>+ *
> >>+ * If the new cluster is contiguous with the previous one, it will be
> >>+ * appended to the same extent record, and num_clusters will be updated.
> >>+ * If not, we will insert a new extent for it and move some xattrs in
> >>+ * the last cluster into the new allocated one.
> >>+ * We also need to limit the maximum size of a btree leaf, otherwise 
> >>we'll
> >>+ * lose the benefits of hashing because we'll have to search large 
> >>leaves.
> >>+ * So now the maximum size is OCFS2_MAX_XATTR_TREE_LEAF_SIZE(or 
> >>clustersize,
> >>+ * if it's bigger).
> >>+ *
> >>+ * first_bh is the first block of the previous extent rec and header_bh
> >>+ * indicates the bucket we will insert the new xattrs. They will be 
> >>updated
> >>+ * when the header_bh is moved into the new cluster.
> >>+ */
> >>+static int ocfs2_add_new_xattr_cluster(struct inode *inode,
> >>+				       struct buffer_head *root_bh,
> >>+				       struct buffer_head **first_bh,
> >>+				       struct buffer_head **header_bh,
> >>+				       u32 *num_clusters,
> >>+				       u32 prev_cpos,
> >>+				       u64 prev_blkno,
> >>+				       int *extend)
> >>+{
> >>+	int ret, credits;
> >>+	u16 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
> >>+	u32 prev_clusters = *num_clusters;
> >>+	u32 clusters_to_add = 1, bit_off, num_bits, v_start = 0;
> >>+	u64 block;
> >>+	handle_t *handle = NULL;
> >>+	struct ocfs2_alloc_context *data_ac = NULL;
> >>+	struct ocfs2_alloc_context *meta_ac = NULL;
> >>+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >>+	struct ocfs2_xattr_block *xb =
> >>+			(struct ocfs2_xattr_block *)root_bh->b_data;
> >>+	struct ocfs2_xattr_tree_root *xb_root = &xb->xb_attrs.xb_root;
> >>+	struct ocfs2_extent_list *root_el = &xb_root->xt_list;
> >>+	enum ocfs2_extent_tree_type type = OCFS2_XATTR_TREE_EXTENT;
> >>+
> >>+	mlog(0, "Add new xattr cluster for %llu, previous xattr hash = %u, "
> >>+	     "previous xattr blkno = %llu\n",
> >>+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> >>+	     prev_cpos, prev_blkno);
> >>+
> >>+	ret = ocfs2_lock_allocators(inode, root_bh, root_el,
> >>+				    clusters_to_add, 0, &data_ac,
> >>+				    &meta_ac, type, NULL);
> >>+	if (ret) {
> >>+		mlog_errno(ret);
> >>+		goto leave;
> >>+	}
> >>+
> >>+	credits = ocfs2_calc_extend_credits(osb->sb, root_el, 
> >>clusters_to_add);
> >>+	handle = ocfs2_start_trans(osb, credits);
> >>+	if (IS_ERR(handle)) {
> >>+		ret = PTR_ERR(handle);
> >>+		handle = NULL;
> >>+		mlog_errno(ret);
> >>+		goto leave;
> >>+	}
> >>+
> >>+	ret = ocfs2_journal_access(handle, inode, root_bh,
> >>+				   OCFS2_JOURNAL_ACCESS_WRITE);
> >>+	if (ret < 0) {
> >>+		mlog_errno(ret);
> >>+		goto leave;
> >>+	}
> >>+
> >>+	ret = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
> >>+				     clusters_to_add, &bit_off, &num_bits);
> >>+	if (ret < 0) {
> >>+		if (ret != -ENOSPC)
> >>+			mlog_errno(ret);
> >>+		goto leave;
> >>+	}
> >>+
> >>+	BUG_ON(num_bits > clusters_to_add);
> >>+
> >>+	block = ocfs2_clusters_to_blocks(osb->sb, bit_off);
> >>+	mlog(0, "Allocating %u clusters at block %u for xattr in inode 
> >>%llu\n",
> >>+	     num_bits, bit_off, (unsigned long 
> >>long)OCFS2_I(inode)->ip_blkno);
> >>+
> >>+	if (prev_blkno + prev_clusters * bpc == block &&
> >>+	    (prev_clusters + num_bits) << osb->s_clustersize_bits <=
> >>+	     OCFS2_MAX_XATTR_TREE_LEAF_SIZE) {
> >>+		/*
> >>+		 * If this cluster is contiguous with the old one and
> >>+		 * adding this new cluster, we don't surpass the limit of
> >>+		 * OCFS2_MAX_XATTR_TREE_LEAF_SIZE, cool. We will let it be
> >>+		 * initialized and used like other buckets in the previous
> >>+		 * cluster.
> >>+		 * So add it as a contiguous one. The caller will handle
> >>+		 * its init process.
> >>+		 */
> >>+		v_start = prev_cpos + prev_clusters;
> >>+		*num_clusters = prev_clusters + num_bits;
> >>+		mlog(0, "Add contiguous %u clusters to previous extent 
> >>rec.\n",
> >>+		     num_bits);
> >>+	} else {
> >>+		ret = ocfs2_adjust_xattr_cross_cluster(inode,
> >>+						       handle,
> >>+						       first_bh,
> >>+						       header_bh,
> >>+						       block,
> >>+						       prev_blkno,
> >>+						       prev_clusters,
> >>+						       &v_start,
> >>+						       extend);
> >>+		if (ret) {
> >>+			mlog_errno(ret);
> >>+			goto leave;
> >>+		}
> >>+	}
> >>+
> >>+	mlog(0, "Insert %u clusters at block %llu for xattr at %u\n",
> >>+	     num_bits, block, v_start);
> >>+	ret = ocfs2_xattr_tree_insert_extent(osb, handle, inode, root_bh,
> >>+					     v_start, block, num_bits,
> >>+					     0, meta_ac);
> >
> >I think we need to do something down in the extent insertion code to 
> >prevent
> >merging in the OCFS2_MAX_XATTR_TREE_LEAF_SIZE cases - what's preventing it
> >from appending that allocation to the end of an extent (any extent) in the
> >btree?
> We don't need to do that. You see, in ocfs2_adjust_xattr_corss_cluster I 
> have adjusted v_start(v_start now indicates the first name hash of the 
> xattrs in the new cluster), so now they will not be contiguous now. ;)
> 
> We only allow xattr hashes to be the same in one bucket(4K) size, so 
> with 64K as our leaf size, even if the cluster is contiguous, we will 
> not have contiguous name hash. so it is safe to say here v_start can 
> never be old_v_start+1.

Hmm, ok, and there can never be anything in between v_start and old_v_start
to begin with, since v_start is determined from the values within the old
bucket. Clever  :)

One question though - what's your *guarantee* that v_start can never be
old_v_start + 1.... What if we *only* have hashes with the values
old_v_start and old_v_start+1 in the bucket?

Btw, it might really just have been easier for you to pass something to the
merge code which says "leave as seperate extents this time"  :)
	--Mark

--
Mark Fasheh
