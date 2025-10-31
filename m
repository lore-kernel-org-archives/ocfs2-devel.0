Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD267239E76
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761926319; cv=none; b=adu1sWW6sg93KJCdGaAEOzKabFZVmtearyCryMaJTLRztorW5i8z7hcNPVBiK2mHWe3ur5PjueDYwsfI2Bs0v6E0uA3gE0CrV5paNCw4u54rxECiLJO69g/aWaY4PBFtJNHHh2WPkd8YyQrvOOOTJGppQwJTgQfYbb/u5MBoSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761926319; c=relaxed/simple;
	bh=5g3WkrxQDlFuuYL38cUTanHgQvLq5j98hmEAgDL/cyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h8bWCoGnegiw5C1LwapAk2AeW2drR5fDVnDVq1IIi4MBREVmpUugj8DJHTLPXlHIvO9m/tZ32UNdJVCU3ekOJ5K/rSsCTyt83d5qf+snr3VAz+wyZsY0rBJs32cVSVbuIte7/yJsh5E5orybonilanXim1S0z0DOM9ElSS74/nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Y4Fk4JOX; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Y4Fk4JOX"
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c21:289d:0:640:fedd:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 7D1C6C0012;
	Fri, 31 Oct 2025 18:58:27 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id Qwiju04LNa60-T0OtXpEs;
	Fri, 31 Oct 2025 18:58:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761926307; bh=FlHuOcA17vQOhWBu5SUbcE/PRhxW+GxPXdl88auM9UI=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Y4Fk4JOXxjxomB2rnE1DxX83IVs0l0c3zc/KAtHMWrp8ICRvthU5rZJ/9z0X1UIeH
	 tPNvNuPaiPeaNWOGiP0LgyM8q+G7wqjk03+afrrSC4Jxk+sKlW4LQbs7H3xr/dstJM
	 whEuOz62AVXh6XifWqCi4/fS+ORIb0zmhUmc7RaE=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: avoid deprecated strcpy() and introduce initialization helper
Date: Fri, 31 Oct 2025 18:57:51 +0300
Message-ID: <20251031155751.87491-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the whohe OCFS2 code base, avoid deprecated 'strcpy()' and introduce
'ocfs2_init_with_signature()' initialization helper with 'strscpy()' for
the signature and 'memset()' for the rest. No functional changes assumed.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/alloc.c               | 10 ++++++----
 fs/ocfs2/cluster/nodemanager.c |  2 +-
 fs/ocfs2/dir.c                 | 17 +++++++++--------
 fs/ocfs2/namei.c               |  5 +++--
 fs/ocfs2/ocfs2.h               |  7 +++++++
 fs/ocfs2/refcounttree.c        | 10 ++++++----
 fs/ocfs2/stackglue.c           |  2 +-
 fs/ocfs2/suballoc.c            |  5 +++--
 fs/ocfs2/xattr.c               |  5 +++--
 9 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..21fd5947979e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1034,10 +1034,11 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 				goto bail;
 			}
 
-			memset(bhs[i]->b_data, 0, osb->sb->s_blocksize);
 			eb = (struct ocfs2_extent_block *) bhs[i]->b_data;
+			ocfs2_init_with_signature(eb, h_signature,
+						  OCFS2_EXTENT_BLOCK_SIGNATURE,
+						  osb->sb->s_blocksize);
 			/* Ok, setup the minimal stuff here. */
-			strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 			eb->h_blkno = cpu_to_le64(first_blkno);
 			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 			eb->h_suballoc_slot =
@@ -6738,13 +6739,14 @@ static int ocfs2_reuse_blk_from_dealloc(handle_t *handle,
 			goto bail;
 		}
 
-		memset(new_eb_bh[i]->b_data, 0, osb->sb->s_blocksize);
 		eb = (struct ocfs2_extent_block *) new_eb_bh[i]->b_data;
+		ocfs2_init_with_signature(eb, h_signature,
+					  OCFS2_EXTENT_BLOCK_SIGNATURE,
+					  osb->sb->s_blocksize);
 
 		/* We can't guarantee that buffer head is still cached, so
 		 * polutlate the extent block again.
 		 */
-		strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 		eb->h_blkno = cpu_to_le64(bf->free_blk);
 		eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 		eb->h_suballoc_slot = cpu_to_le16(real_slot);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 2f61d39e4e50..a7f03b641d10 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -590,7 +590,7 @@ static struct config_item *o2nm_node_group_make_item(struct config_group *group,
 	if (node == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
+	strscpy(node->nd_name, name); /* use item.ci_namebuf instead? */
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..d08bf5d09cde 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -136,7 +136,7 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 	struct ocfs2_dir_block_trailer *trailer;
 
 	trailer = ocfs2_trailer_from_bh(bh, inode->i_sb);
-	strcpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
+	strscpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
 	trailer->db_compat_rec_len =
 			cpu_to_le16(sizeof(struct ocfs2_dir_block_trailer));
 	trailer->db_parent_dinode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
@@ -2192,14 +2192,14 @@ static struct ocfs2_dir_entry *ocfs2_fill_initial_dirents(struct inode *inode,
 	de->name_len = 1;
 	de->rec_len =
 		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
-	strcpy(de->name, ".");
+	strscpy(de->name, ".");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
 	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
 	de->rec_len = cpu_to_le16(size - OCFS2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	strcpy(de->name, "..");
+	strscpy(de->name, "..");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	return de;
@@ -2356,8 +2356,9 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 	}
 
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
-	memset(dx_root, 0, osb->sb->s_blocksize);
-	strcpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
+	ocfs2_init_with_signature(dx_root, dr_signature,
+				  OCFS2_DX_ROOT_SIGNATURE,
+				  osb->sb->s_blocksize);
 	dx_root->dr_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	dx_root->dr_suballoc_loc = cpu_to_le64(suballoc_loc);
 	dx_root->dr_suballoc_bit = cpu_to_le16(dr_suballoc_bit);
@@ -2431,9 +2432,9 @@ static int ocfs2_dx_dir_format_cluster(struct ocfs2_super *osb,
 		}
 
 		dx_leaf = (struct ocfs2_dx_leaf *) bh->b_data;
-
-		memset(dx_leaf, 0, osb->sb->s_blocksize);
-		strcpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
+		ocfs2_init_with_signature(dx_leaf, dl_signature,
+					  OCFS2_DX_LEAF_SIGNATURE,
+					  osb->sb->s_blocksize);
 		dx_leaf->dl_fs_generation = cpu_to_le32(osb->fs_generation);
 		dx_leaf->dl_blkno = cpu_to_le64(bh->b_blocknr);
 		dx_leaf->dl_list.de_count =
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c90b254da75e..b39dbcf0152e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -551,7 +551,9 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	}
 
 	fe = (struct ocfs2_dinode *) (*new_fe_bh)->b_data;
-	memset(fe, 0, osb->sb->s_blocksize);
+	ocfs2_init_with_signature(fe, i_signature,
+				  OCFS2_INODE_SIGNATURE,
+				  osb->sb->s_blocksize);
 
 	fe->i_generation = cpu_to_le32(inode->i_generation);
 	fe->i_fs_generation = cpu_to_le32(osb->fs_generation);
@@ -568,7 +570,6 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 
 	fe->i_last_eb_blk = 0;
-	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
 	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 6aaa94c554c1..0863057c9c7c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -971,5 +971,12 @@ static inline int ocfs2_find_next_zero_bit_unaligned(void *bitmap, int max,
 	return ret;
 }
 
+#define ocfs2_init_with_signature(ptr, sigmember, sigdata, size)	\
+	do {								\
+		strscpy((ptr)->sigmember, (sigdata));			\
+		memset((char *)ptr + sizeof((ptr)->sigmember), 0,	\
+		       (size) - sizeof((ptr)->sigmember));		\
+	} while (0)
+
 #endif  /* OCFS2_H */
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 267b50e8e42e..c0063ecc8a8b 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -620,8 +620,9 @@ static int ocfs2_create_refcount_tree(struct inode *inode,
 
 	/* Initialize ocfs2_refcount_block. */
 	rb = (struct ocfs2_refcount_block *)new_bh->b_data;
-	memset(rb, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	ocfs2_init_with_signature(rb, rf_signature,
+				  OCFS2_REFCOUNT_BLOCK_SIGNATURE,
+				  inode->i_sb->s_blocksize);
 	rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
@@ -1561,8 +1562,9 @@ static int ocfs2_new_leaf_refcount_block(handle_t *handle,
 
 	/* Initialize ocfs2_refcount_block. */
 	new_rb = (struct ocfs2_refcount_block *)new_bh->b_data;
-	memset(new_rb, 0, sb->s_blocksize);
-	strcpy((void *)new_rb, OCFS2_REFCOUNT_BLOCK_SIGNATURE);
+	ocfs2_init_with_signature(new_rb, rf_signature,
+				  OCFS2_REFCOUNT_BLOCK_SIGNATURE,
+				  sb->s_blocksize);
 	new_rb->rf_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	new_rb->rf_suballoc_loc = cpu_to_le64(suballoc_loc);
 	new_rb->rf_suballoc_bit = cpu_to_le16(suballoc_bit_start);
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index a28c127b9934..5f721611d8fe 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -670,7 +670,7 @@ static int __init ocfs2_stack_glue_init(void)
 {
 	int ret;
 
-	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
+	strscpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl("fs/ocfs2/nm", ocfs2_nm_table);
 	if (!ocfs2_table_header) {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..844a6ae363c3 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -371,8 +371,9 @@ static int ocfs2_block_group_fill(handle_t *handle,
 		goto bail;
 	}
 
-	memset(bg, 0, sb->s_blocksize);
-	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
+	ocfs2_init_with_signature(bg, bg_signature,
+				  OCFS2_GROUP_DESC_SIGNATURE,
+				  sb->s_blocksize);
 	bg->bg_generation = cpu_to_le32(osb->fs_generation);
 	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
 						osb->s_feature_incompat));
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..9ca8e51f8c5c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2907,8 +2907,9 @@ static int ocfs2_create_xattr_block(struct inode *inode,
 
 	/* Initialize ocfs2_xattr_block */
 	xblk = (struct ocfs2_xattr_block *)new_bh->b_data;
-	memset(xblk, 0, inode->i_sb->s_blocksize);
-	strcpy((void *)xblk, OCFS2_XATTR_BLOCK_SIGNATURE);
+	ocfs2_init_with_signature(xblk, xb_signature,
+				  OCFS2_XATTR_BLOCK_SIGNATURE,
+				  inode->i_sb->s_blocksize);
 	xblk->xb_suballoc_slot = cpu_to_le16(ctxt->meta_ac->ac_alloc_slot);
 	xblk->xb_suballoc_loc = cpu_to_le64(suballoc_loc);
 	xblk->xb_suballoc_bit = cpu_to_le16(suballoc_bit_start);
-- 
2.51.0

