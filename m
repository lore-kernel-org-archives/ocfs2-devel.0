Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D74F13774A
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722240307; cv=none; b=QFoyFEhs2IzoAywg66aR4OxOsdqom82QzuvBgbGyAmXvnVJBzS0j0EUNsmSwEK+Z6QBpy/2RTbzcYBWisoO8g6dK8OK7IHGgv7Phhk7xCABzojri+VFzrWDQuqS2iX4a+FaUE4qFxzcX5QW6orduwuDNoqusfS5a2l84jzx5a/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722240307; c=relaxed/simple;
	bh=2eGxTHw0jP/ubsMXdn71H+QW2PiPIEZCcR0B77OlbFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BRXIBwclbaxFJ+SxaajH03+iAL3xncuBDOQdteFDPIj7VyFiSZppkLCMDUS5mEGXxyr9jdOGVS2sQUWLZIhk7jkQRUkpbtVJzzafeHCJXvd7VXkvkVUEwqdsPMQvf3NEW1zGAtEGBepXYiSrvEriMsVMnbcgDvH+SjYFE0Xig38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HCVqy+Vd; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HCVqy+Vd"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52f025bc147so4392968e87.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 01:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722240303; x=1722845103; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKcXzhisYHPgxtNmQWfAdWQ1Sw5COucUi7V39nJlfO8=;
        b=HCVqy+VdFrZstJG5GDDmwGgaljSTwkNQ4eS0QoKijwCU73CadUkXJ2JGDUWl+AWHUh
         Zc7BOJQDs7Y4SGv955CpRoZ79NioeyV8RIjRCiFjLHxhLI4ciWsqSNmDBtAJAnhbhJvo
         pwQlGBzyrI8sP/JeJVaX7ITX1YipCZsHk0tKnbRhTCiNRVf0u8uzdiGX78vwHhiIRoan
         k+bUi2yZavxjUR3vyiH2Pjm0Jsbnn46Ctj5TA/OCIf1Uj0KZZsS6j+JvoX3vNgRsJgZm
         adEqjy2huaXGu1yqaoBHGI+B2wl/RX2uAABES3KQV5tm6BElRzP+0yTIWyjU8bUD5sT8
         ekeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722240303; x=1722845103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKcXzhisYHPgxtNmQWfAdWQ1Sw5COucUi7V39nJlfO8=;
        b=uD192+Ti7kwB/UVi+cO1FOaI8HDTTHSioo3ffyAQSLs0D4ZfIGHKOMQjMcVC0H/s30
         FOgaFEYFrgat1HW9k71JLN/FPS/b/Oqi8CLlj3vApqRPvGHvnxlpHpXszf9OBAu/Usnx
         ztXTByq7Cz6dmVm9gmHz5Xy3LBiCoXkzQApxnnlvUdOXD0JS3LtALk90wPRmltIRN6BU
         BvjpbBFbFnIksMJ4NIxj4q/+g78bm6n8M3LmHtxRJhEdDiQimcr0ARLr8pj41uHA++s4
         RBOHvslcbd/cOCYwc2pijKsnW0kJEL5zIBQmdVF13hGpttCf8XidIL11e+VQ2THoMAev
         qYFw==
X-Forwarded-Encrypted: i=1; AJvYcCVb8asm6JH87CL+bewl1xABqSy2uYcqlp1lUoB3+Ah82/nnaoLhVQDg5oO0sR+Oa/TdzJLg7LpaPkOlCJBSM9Z8+TS5zJi/jnzDb8c=
X-Gm-Message-State: AOJu0YxRrkLAOH1wnSle85WcIK0xUKoPqfMmwB7jE0E/nIm/o7C5Ouqk
	cHXJYf2qgMmMN/BDs9kqL7GaW0dIe/KKIRVqZBhVwOiwX0uVTl+BMVah+ZSeavQ=
X-Google-Smtp-Source: AGHT+IHEND3aPqThkJT3LbImiLehDYvu7qhDHooRQ25JvSjOwtTEkO7+0T7MZEWAoLg5R+7mojgNVA==
X-Received: by 2002:a2e:95cd:0:b0:2ef:2d80:b8ff with SMTP id 38308e7fff4ca-2f12edf00camr42607271fa.6.1722240302973;
        Mon, 29 Jul 2024 01:05:02 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7edd813sm76560305ad.170.2024.07.29.01.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 01:05:02 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 1/3] ocfs2: give ocfs2 the ability to reclaim suballoc free bg
Date: Mon, 29 Jul 2024 16:04:52 +0800
Message-Id: <20240729080454.12771-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240729080454.12771-1-heming.zhao@suse.com>
References: <20240729080454.12771-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current ocfs2 code can't reclaim suballocator block group space.
This cause ocfs2 to hold onto a lot of space in some cases. for example,
when creating lots of small files, the space is held/managed by
'//inode_alloc'. After the user deletes all the small files, the space
never returns to '//global_bitmap'. This issue prevents ocfs2 from
providing the needed space even when there is enough free space in a
small ocfs2 volume.
This patch gives ocfs2 the ability to reclaim suballoc free space when
the block group is free. For performance reasons, ocfs2 doesn't release
the first suballocator block group.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/suballoc.c | 211 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 206 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..1b64f4c87607 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -294,6 +294,60 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
 	return ocfs2_validate_gd_self(sb, bh, 0);
 }
 
+/*
+ * hint gd may already be released in _ocfs2_free_suballoc_bits(),
+ * we first check gd descriptor signature, then do the
+ * ocfs2_read_group_descriptor() jobs.
+ */
+static int ocfs2_read_hint_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
+				u64 gd_blkno, struct buffer_head **bh)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+	struct ocfs2_group_desc *gd;
+
+	rc = ocfs2_read_block(INODE_CACHE(inode), gd_blkno, &tmp, NULL);
+	if (rc)
+		goto out;
+
+	gd = (struct ocfs2_group_desc *) tmp->b_data;
+	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
+		/*
+		 * Invalid gd cache was set in ocfs2_read_block(),
+		 * which will affect block_group allocation.
+		 * Path:
+		 * ocfs2_reserve_suballoc_bits
+		 *  ocfs2_block_group_alloc
+		 *   ocfs2_block_group_alloc_contig
+		 *    ocfs2_set_new_buffer_uptodate
+		 */
+		ocfs2_remove_from_cache(INODE_CACHE(inode), tmp);
+		rc = -EIDRM;
+		goto free_bh;
+	}
+
+	if (!buffer_jbd(tmp)) {
+		rc = ocfs2_validate_group_descriptor(inode->i_sb, tmp);
+		if (rc)
+			goto free_bh;
+	}
+
+	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
+	if (rc)
+		goto free_bh;
+
+	/* If ocfs2_read_block() got us a new bh, pass it up. */
+	if (!*bh)
+		*bh = tmp;
+
+	return rc;
+
+free_bh:
+	brelse(tmp);
+out:
+	return rc;
+}
+
 int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
 				u64 gd_blkno, struct buffer_head **bh)
 {
@@ -1730,10 +1784,11 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_group_descriptor(alloc_inode, di,
+	ret = ocfs2_read_hint_group_descriptor(alloc_inode, di,
 					  res->sr_bg_blkno, &group_bh);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EIDRM)
+			mlog_errno(ret);
 		return ret;
 	}
 
@@ -1961,6 +2016,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
+	/* the hint bg may already be released, we quiet search this group. */
 	res->sr_bg_blkno = hint;
 	if (res->sr_bg_blkno) {
 		/* Attempt to short-circuit the usual search mechanism
@@ -1971,12 +2027,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 						min_bits, res, &bits_left);
 		if (!status)
 			goto set_hint;
+		if (status == -EIDRM) {
+			res->sr_bg_blkno = 0;
+			goto chain_search;
+		}
 		if (status < 0 && status != -ENOSPC) {
 			mlog_errno(status);
 			goto bail;
 		}
 	}
-
+chain_search:
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 
 	victim = ocfs2_find_victim_chain(cl);
@@ -2077,6 +2137,12 @@ int ocfs2_claim_metadata(handle_t *handle,
 	return status;
 }
 
+/*
+ * after ocfs2 has the ability to release block group unused space,
+ * the ->ip_last_used_group may be invalid. so this function returns
+ * ac->ac_last_group need to verify.
+ * refer the 'hint' in ocfs2_claim_suballoc_bits() for more details.
+ */
 static void ocfs2_init_inode_ac_group(struct inode *dir,
 				      struct buffer_head *parent_di_bh,
 				      struct ocfs2_alloc_context *ac)
@@ -2534,6 +2600,16 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	struct ocfs2_group_desc *group;
 	__le16 old_bg_contig_free_bits = 0;
 
+	struct buffer_head *main_bm_bh = NULL;
+	struct inode *main_bm_inode = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
+	struct ocfs2_chain_rec *rec;
+	u64 start_blk;
+	int idx, i, next_free_rec, len = 0;
+	int free_main_bm_inode = 0, free_main_bm_bh = 0;
+	u16 bg_start_bit;
+
+reclaim:
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
 	 * allocator and gotten alloc_bh from the lock call.  This
@@ -2577,13 +2653,138 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 		goto bail;
 	}
 
-	le32_add_cpu(&cl->cl_recs[le16_to_cpu(group->bg_chain)].c_free,
-		     count);
+	idx = le16_to_cpu(group->bg_chain);
+	rec = &(cl->cl_recs[idx]);
+
+	le32_add_cpu(&rec->c_free, count);
 	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
 	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
 	ocfs2_journal_dirty(handle, alloc_bh);
 
+	/* bypass: global_bitmap, not empty rec, first item in cl_recs[] */
+	if (ocfs2_is_cluster_bitmap(alloc_inode) ||
+	    (le32_to_cpu(rec->c_free) != (le32_to_cpu(rec->c_total) - 1)) ||
+	    (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
+		goto bail;
+	}
+
+	status = ocfs2_extend_trans(handle,
+				ocfs2_calc_group_alloc_credits(osb->sb,
+						 le16_to_cpu(cl->cl_cpg)));
+	if (status) {
+		mlog_errno(status);
+		goto bail;
+	}
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(alloc_inode),
+					 alloc_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	/*
+	 * Only clear the rec item in-place.
+	 *
+	 * If idx is not the last, we don't compress (remove the empty item)
+	 * the cl_recs[]. If not, we need to do lots jobs.
+	 *
+	 * Compress cl_recs[] code example:
+	 * if (idx != cl->cl_next_free_rec - 1)
+	 * 	memmove(&cl->cl_recs[idx], &cl->cl_recs[idx + 1],
+	 * 		sizeof(struct ocfs2_chain_rec) *
+	 * 		(cl->cl_next_free_rec - idx - 1));
+	 * for(i = idx; i < cl->cl_next_free_rec-1; i++) {
+	 * 	group->bg_chain = "later group->bg_chain";
+	 * 	group->bg_blkno = xxx;
+	 * 	... ...
+	 * }
+	 */
+
+	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_total);
+	fe->id1.bitmap1.i_total = cpu_to_le32(tmp_used - le32_to_cpu(rec->c_total));
+
+	/* Substraction 1 for the block group itself */
+	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
+	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - 1);
+
+	tmp_used = le32_to_cpu(fe->i_clusters);
+	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
+
+	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
+	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
+	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
+					     le32_to_cpu(fe->i_clusters)));
+	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
+	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
+	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
+
+	ocfs2_journal_dirty(handle, alloc_bh);
+	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
+
+	start_blk = le64_to_cpu(rec->c_blkno);
+	count = le32_to_cpu(rec->c_total) / le16_to_cpu(cl->cl_bpc);
+
+	/*
+	 * If the rec is the last one, let's compress the chain list by
+	 * removing the empty cl_recs[] at the end.
+	 */
+	next_free_rec = le16_to_cpu(cl->cl_next_free_rec);
+	if (idx == (next_free_rec - 1)) {
+		len++; /* the last item */
+		for (i = (next_free_rec - 2); i > 0; i--) {
+			if (cl->cl_recs[i].c_free == cl->cl_recs[i].c_total)
+				len++;
+			else
+				break;
+		}
+	}
+	le16_add_cpu(&cl->cl_next_free_rec, -len);
+
+	rec->c_free = 0;
+	rec->c_total = 0;
+	rec->c_blkno = 0;
+	ocfs2_remove_from_cache(INODE_CACHE(alloc_inode), group_bh);
+	memset(group, 0, sizeof(struct ocfs2_group_desc));
+
+	/* prepare job for reclaim clusters */
+	main_bm_inode = ocfs2_get_system_file_inode(osb,
+						    GLOBAL_BITMAP_SYSTEM_INODE,
+						    OCFS2_INVALID_SLOT);
+	if (!main_bm_inode)
+		goto bail; /* ignore the error in reclaim path */
+
+	inode_lock(main_bm_inode);
+	free_main_bm_inode = 1;
+
+	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
+	if (status < 0)
+		goto bail; /* ignore the error in reclaim path */
+	free_main_bm_bh = 1;
+
+	ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
+				     &bg_start_bit);
+	alloc_inode = main_bm_inode;
+	alloc_bh = main_bm_bh;
+	fe = (struct ocfs2_dinode *) alloc_bh->b_data;
+	cl = &fe->id2.i_chain;
+	old_bg_contig_free_bits = 0;
+	brelse(group_bh);
+	group_bh = NULL;
+	start_bit = bg_start_bit;
+	undo_fn = _ocfs2_clear_bit;
+
+	/* reclaim clusters to global_bitmap */
+	goto reclaim;
+
 bail:
+	if (free_main_bm_bh) {
+		ocfs2_inode_unlock(main_bm_inode, 1);
+		brelse(main_bm_bh);
+	}
+	if (free_main_bm_inode) {
+		inode_unlock(main_bm_inode);
+		iput(main_bm_inode);
+	}
 	brelse(group_bh);
 	return status;
 }
-- 
2.35.3

