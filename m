Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0673191B0
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Nov 2025 07:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763710846; cv=none; b=Otnwu6dSvAEVmOB+8uW/cbbn2M+KNwiRa/ORKVc8m/3FQRflBHsQThrhCJ3uy/zNLdU5gruOUk+HgNoZv9T4TFp1NfWP0QmQzXbZKvt08BeoXdkBmU2SU+bvkbmiOTvhni8p//v40oONwpfXyFtSTC8YPVYjUkk66x8su0RMnY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763710846; c=relaxed/simple;
	bh=jzpdVgcWhI1BiaFeT26VJqC0oJV3Mbha8IXXpw9WnAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkTYcir8rLiKNfGpdEb+pOn07/UMqElozVxpwPMon8JDJyViS/CZ8yy4T8YieZZ4U4utqvYd/uZEKsG3ykiDgr0roMX1U6F0BDtQLHdnELZWDmI8qy/iSncLly8vciGIPw5UxW/6buDB5pkdNC1qsawvCq7aGazwHPwRJZsmCGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZNvc3brc; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZNvc3brc"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-429c5e0f94eso258264f8f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 20 Nov 2025 23:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763710842; x=1764315642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8k/aHSJ5y3EQVvgtWu6J+LK331e28G7eJ5wJTbMn3Fw=;
        b=ZNvc3brcoIkVp7d8u6Qe/cMb/Z/vgvGueT4SuJbVKWHbx4PmYAq2wbtzwZneLcWjvy
         LETcYez2rsykRlSY06FM1ade6HniZfrl8UGerNFhs7cotN7WAwQKED6P/IWwxgc1Un9C
         GQzP07E4C/0VJMMBlyrrXVTXLBaEWmkVpHJFQj5W/maLAPEkqYJyaFMuqK/1dx3Pb3zc
         ipn8Sz7MTgdzGreGi9H5SxqLSzzWkvTzUzO59YW1rl47MKN6QjLXIMAG4Puad5+wuZtt
         0tVgzUkaP/zR9yI3NN+OGZoGbyc0xUV01TzjObtUixc9ZshJ6PTd6h3sGZmX3sUq+0F4
         Msig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763710842; x=1764315642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8k/aHSJ5y3EQVvgtWu6J+LK331e28G7eJ5wJTbMn3Fw=;
        b=AvWnJMEkwhoGpQoCVSneEFC8soC4QywBkdddsohRhfdVJjgLH0/F4kKCkjoh/h1rlX
         HipC3uWceIBAjZA/rMT4ayh3rRnGIMCYyao3dqechB2f+xJi+Y/IElczYy37DAo9/TxJ
         nNv7xmmrd9GJNkVK+J9G7sLw+HjecwnyItQ60WC3RrrcYQYY9L4luTko5DuhUkRf0JBy
         HOd2UjeGudg+dHgi5icCZLfbs7dizN/3QYyA7sdbzjGXkqwnySbLKiwDEUxX/oXqrO2f
         D8in+xg5lb+RaQA1LrWGtjYbTuDM/50hj8qchwmVn6oQ+Y4IeEMKA9Xb2sBYBatCxg3v
         pfcA==
X-Forwarded-Encrypted: i=1; AJvYcCVkJBAIbGeZnAZf1JvVdhEnwCmNdITu92KK7oGLDRdz0RaWQCOj7FBOddKqbbRcLt26fOP/TWHXgwxQ8A==@lists.linux.dev
X-Gm-Message-State: AOJu0YztL0PbRiFbhZgyKpnKBCCq8ffQCSZ6DXaCo9CgLUZTHN+ScU2B
	vynTUii99lRfACzaagSd0SKl8h1R0q8fLLxAtUruTaBFlgDuQl1QELQINJ0lwZ0WWMk=
X-Gm-Gg: ASbGncsX/pifkAgAdye0knHx3V13WjY1Ffi7UX72YOeXyqahBN6tXnsPjmDwWwLffL7
	Gp5O0QAXZkFwVwyd+fMOwLKddsJwT422uH2tuIHcUUZuN/FfH5MhdKMHwiUOB+7jZ6q5xTrA1Et
	t07Li47WvW7iDaaIa7bvQEWRD5HE3PbnmEOsQ7l8rISxSA6y7GzHyfM9LEo130UJ5RBK3WH4Ywg
	NTIH4Cv0qFww3CQ9tYQnP5Qp1E2vUsbxkD47QpRPPO1MNq9jSBDcG7ffLwXxa9ybn//FEl9THlc
	ZygQ6dhc3WxoKnNV10dQ3XvCwWUtZYZ7GuOfVsB36wuQiEhyAKStqtWxA0raqDPC8WoVu7gPkj7
	fcW55r5RX86ah77Rb6bfLeFM0W0h3HHQCrnFx1e78xuApW4fq3EbazzoQyARiDQ2kZzxet0o8nh
	bnFQEaKdE40Ut7hVHmO0ANbXxA
X-Google-Smtp-Source: AGHT+IEOCNSLp4USQ3IbILIF9/CRDBl64jBdeElEJETGIULBrLRo8uj6TLcwaX6NYIFZt20NYemJIA==
X-Received: by 2002:a05:600c:1396:b0:477:a478:3f94 with SMTP id 5b1f17b1804b1-477c316e614mr2619735e9.5.1763710842408;
        Thu, 20 Nov 2025 23:40:42 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023fba8sm5081295b3a.41.2025.11.20.23.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:40:41 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v4 1/2] ocfs2: give ocfs2 the ability to reclaim suballocator free bg
Date: Fri, 21 Nov 2025 15:40:24 +0800
Message-ID: <20251121074030.12014-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121074030.12014-1-heming.zhao@suse.com>
References: <20251121074030.12014-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current ocfs2 code can't reclaim suballocator block group space.
In some cases, this causes ocfs2 to hold onto a lot of space.
For example, when creating lots of small files, the space is held/managed
by the '//inode_alloc'. After the user deletes all the small files,
the space never returns to the '//global_bitmap'. This issue prevents
ocfs2 from providing the needed space even when there is enough free
space in a small ocfs2 volume.

This patch gives ocfs2 the ability to reclaim suballocator free space
when the block group is freed. For performance reasons, this patch keeps
the first suballocator block group active.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/suballoc.c | 308 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 299 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..de2f09217142 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -294,6 +294,74 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
 	return ocfs2_validate_gd_self(sb, bh, 0);
 }
 
+/*
+ * The hint group descriptor (gd) may already have been released
+ * in _ocfs2_free_suballoc_bits(). We first check the gd signature,
+ * then perform the standard ocfs2_read_group_descriptor() jobs.
+ *
+ * If the gd signature is invalid, we return 'rc=0' and set
+ * '*released=1'. The caller is expected to handle this specific case.
+ * Otherwise, we return the actual error code.
+ *
+ * We treat gd signature corruption case as a release case. The
+ * caller ocfs2_claim_suballoc_bits() will use ocfs2_search_chain()
+ * to search each gd block. The code will eventually find this
+ * corrupted gd block - Late, but not missed.
+ *
+ * Note:
+ * The caller is responsible for initializing the '*released' status.
+ */
+static int ocfs2_read_hint_group_descriptor(struct inode *inode,
+			struct ocfs2_dinode *di, u64 gd_blkno,
+			struct buffer_head **bh, int *released)
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
+		*released = 1; /* we return 'rc=0' for this case */
+		goto free_bh;
+	}
+
+	/* below jobs same with ocfs2_read_group_descriptor() */
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
@@ -1724,7 +1792,7 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 				  u32 bits_wanted,
 				  u32 min_bits,
 				  struct ocfs2_suballoc_result *res,
-				  u16 *bits_left)
+				  u16 *bits_left, int *released)
 {
 	int ret;
 	struct buffer_head *group_bh = NULL;
@@ -1732,9 +1800,11 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)ac->ac_bh->b_data;
 	struct inode *alloc_inode = ac->ac_inode;
 
-	ret = ocfs2_read_group_descriptor(alloc_inode, di,
-					  res->sr_bg_blkno, &group_bh);
-	if (ret < 0) {
+	ret = ocfs2_read_hint_group_descriptor(alloc_inode, di,
+				res->sr_bg_blkno, &group_bh, released);
+	if (*released) {
+		return 0;
+	} else if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
 	}
@@ -1949,6 +2019,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 				     struct ocfs2_suballoc_result *res)
 {
 	int status;
+	int released = 0;
 	u16 victim, i;
 	u16 bits_left = 0;
 	u64 hint = ac->ac_last_group;
@@ -1975,6 +2046,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		goto bail;
 	}
 
+	/* the hint bg may already be released, we quiet search this group. */
 	res->sr_bg_blkno = hint;
 	if (res->sr_bg_blkno) {
 		/* Attempt to short-circuit the usual search mechanism
@@ -1982,7 +2054,12 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		 * allocation group. This helps us maintain some
 		 * contiguousness across allocations. */
 		status = ocfs2_search_one_group(ac, handle, bits_wanted,
-						min_bits, res, &bits_left);
+						min_bits, res, &bits_left,
+						&released);
+		if (released) {
+			res->sr_bg_blkno = 0;
+			goto chain_search;
+		}
 		if (!status)
 			goto set_hint;
 		if (status < 0 && status != -ENOSPC) {
@@ -1990,7 +2067,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 			goto bail;
 		}
 	}
-
+chain_search:
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 
 	victim = ocfs2_find_victim_chain(cl);
@@ -2102,6 +2179,12 @@ int ocfs2_claim_metadata(handle_t *handle,
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
@@ -2540,6 +2623,198 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 	return status;
 }
 
+/*
+ * Reclaim the suballocator managed space to main bitmap.
+ * This function first works on the suballocator to perform the
+ * cleanup rec/alloc_inode job, then switches to the main bitmap
+ * to reclaim released space.
+ *
+ * handle: The transaction handle
+ * alloc_inode: The suballoc inode
+ * alloc_bh: The buffer_head of suballoc inode
+ * group_bh: The group descriptor buffer_head of suballocator managed.
+ *           Caller should release the input group_bh.
+ */
+static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
+			struct inode *alloc_inode,
+			struct buffer_head *alloc_bh,
+			struct buffer_head *group_bh)
+{
+	int idx, status = 0;
+	int i, next_free_rec, len = 0;
+	__le16 old_bg_contig_free_bits = 0;
+	u16 start_bit;
+	u32 tmp_used;
+	u64 bg_blkno, start_blk;
+	unsigned int count;
+	struct ocfs2_chain_rec *rec;
+	struct buffer_head *main_bm_bh = NULL;
+	struct inode *main_bm_inode = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) alloc_bh->b_data;
+	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
+	struct ocfs2_group_desc *group = (struct ocfs2_group_desc *) group_bh->b_data;
+
+	idx = le16_to_cpu(group->bg_chain);
+	rec = &(cl->cl_recs[idx]);
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
+	 * Only clear the suballocator rec item in-place.
+	 *
+	 * If idx is not the last, we don't compress (remove the empty item)
+	 * the cl_recs[]. If not, we need to do lots jobs.
+	 *
+	 * Compress cl_recs[] code example:
+	 * if (idx != cl->cl_next_free_rec - 1)
+	 *     memmove(&cl->cl_recs[idx], &cl->cl_recs[idx + 1],
+	 *         sizeof(struct ocfs2_chain_rec) *
+	 *         (cl->cl_next_free_rec - idx - 1));
+	 * for(i = idx; i < cl->cl_next_free_rec-1; i++) {
+	 *     group->bg_chain = "later group->bg_chain";
+	 *     group->bg_blkno = xxx;
+	 *     ... ...
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
+		len++; /* the last item should be counted first */
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
+
+	status = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 1);
+	if (status < 0)
+		goto free_bm_inode; /* ignore the error in reclaim path */
+
+	ocfs2_block_to_cluster_group(main_bm_inode, start_blk, &bg_blkno,
+				     &start_bit);
+	fe = (struct ocfs2_dinode *) main_bm_bh->b_data;
+	cl = &fe->id2.i_chain;
+	/* reuse group_bh, caller will release the input group_bh */
+	group_bh = NULL;
+
+	/* reclaim clusters to global_bitmap */
+	status = ocfs2_read_group_descriptor(main_bm_inode, fe, bg_blkno,
+					     &group_bh);
+	if (status < 0) {
+		mlog_errno(status);
+		goto free_bm_bh;
+	}
+	group = (struct ocfs2_group_desc *) group_bh->b_data;
+
+	if ((count + start_bit) > le16_to_cpu(group->bg_bits)) {
+		ocfs2_error(alloc_inode->i_sb,
+			"reclaim length (%d) beyands block group length (%d)",
+			count + start_bit, le16_to_cpu(group->bg_bits));
+		goto free_group_bh;
+	}
+
+	old_bg_contig_free_bits = group->bg_contig_free_bits;
+	status = ocfs2_block_group_clear_bits(handle, main_bm_inode,
+					      group, group_bh,
+					      start_bit, count, 0,
+					      _ocfs2_clear_bit);
+	if (status < 0) {
+		mlog_errno(status);
+		goto free_group_bh;
+	}
+
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
+					 main_bm_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		ocfs2_block_group_set_bits(handle, main_bm_inode, group, group_bh,
+				start_bit, count,
+				le16_to_cpu(old_bg_contig_free_bits), 1);
+		goto free_group_bh;
+	}
+
+	idx = le16_to_cpu(group->bg_chain);
+	rec = &(cl->cl_recs[idx]);
+
+	le32_add_cpu(&rec->c_free, count);
+	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
+	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
+	ocfs2_journal_dirty(handle, main_bm_bh);
+
+free_group_bh:
+	brelse(group_bh);
+
+free_bm_bh:
+	ocfs2_inode_unlock(main_bm_inode, 1);
+	brelse(main_bm_bh);
+
+free_bm_inode:
+	inode_unlock(main_bm_inode);
+	iput(main_bm_inode);
+
+bail:
+	return status;
+}
+
 /*
  * expects the suballoc inode to already be locked.
  */
@@ -2552,12 +2827,13 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 				     void (*undo_fn)(unsigned int bit,
 						     unsigned long *bitmap))
 {
-	int status = 0;
+	int idx, status = 0;
 	u32 tmp_used;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) alloc_bh->b_data;
 	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *group;
+	struct ocfs2_chain_rec *rec;
 	__le16 old_bg_contig_free_bits = 0;
 
 	/* The alloc_bh comes from ocfs2_free_dinode() or
@@ -2603,12 +2879,26 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
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
 
+	/*
+	 * Reclaim suballocator free space.
+	 * Bypass: global_bitmap, non empty rec, first rec in cl_recs[]
+	 */
+	if (ocfs2_is_cluster_bitmap(alloc_inode) ||
+	    (le32_to_cpu(rec->c_free) != (le32_to_cpu(rec->c_total) - 1)) ||
+	    (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
+		goto bail;
+	}
+
+	_ocfs2_reclaim_suballoc_to_main(handle, alloc_inode, alloc_bh, group_bh);
+
 bail:
 	brelse(group_bh);
 	return status;
-- 
2.43.0

