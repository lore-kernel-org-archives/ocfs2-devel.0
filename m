Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0068E342532
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792334030; cv=none; b=lmb1mZtIbM3ovzeiQW/04NcsVtxl+BIeiIreQeWu3TbfartV/r17dwXwmDRygruqLee9kpXgRB8qkETctb9HV82K84OJ3rAGXvH/uaOi8gpC4C91dXv+GNfFj/U0U+MfD5BjN82ED8gxWFSPdpcBsTyVjezRuXciQU4rSiBS38U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792334030; c=relaxed/simple;
	bh=tsAYQd4TENTQWsvrNVru6QcJ/ZwITZxgoShYZaDpr+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPQqy5irKYB3B8LxZW39wN9AZ7Tqy7RnBZc2v/F1ZnKXugmbBZcnuVDxtkET+xDWj9wSrJue0njxI1cbW6jBi/G9GV79j+chYwSNuRg8huJnsq810MlYCvyyPRiTo69lclOB0Nh6cjoucTOrR7moRs27Zzl+h/JQ7hSKk31Mo18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WKGfce3x; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WKGfce3x"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4887dbe4f2dso162878f8f.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 07:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792334026; x=1792938826; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=okixQ2e46852sKS48RnDwRsV78EOa5szqwRC2jyrBiw=;
        b=WKGfce3xJA96crVvrKgHlLI+RuWT/oS0GenD5zQnlNbu0FJGic3VIbsW9w7PBAmBWA
         qv2n5SVeBVpZ/VcRQm+TQmXoXCAiIdwXqGptccBIAvjDepRMnWxqsym3jdC+NSSuVNwn
         LmG2Sjw3KFZBMQmpffGsISBnxWxWkSiVZwUb3it27W/Aw0Wasiz4ZMmEr6yLUZWV865X
         qlHOFDqMIj5J33H9pDDD/APR0fc/MuCHI1w5EZEA7D9Kzfb8NDczx6PvQEsLnLsMzbRV
         QdoC+tvXHdRM6B8MqgLT+AJWPDTkZt9qHG5dg51miZ7c2NRxDIUJyjiyMtxf0jHo7u75
         OvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334026; x=1792938826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=okixQ2e46852sKS48RnDwRsV78EOa5szqwRC2jyrBiw=;
        b=fmEmO9LnR722zSKGPNeMqLUFOej5bQ36T0/QUkFIg0m+gkXGfrB30qeLHWGYsxVjF2
         oaYAUuvm4g3H5QNlktzmthAC6kOeTTPttbcU+YnapPzJ3G+xRe8/2tVandNcpVximC9C
         TCr0cm7C1B3KLikUjJd4gSs+2sqr3ak5upz0tcFWKZVKK9wDwwF0OIXCzekScWQ97hC3
         xG9gJFxodalmF5z8as4aFKvuiEUcDdmvQRolID/93TyUU4/uAY+6N2uWLSBzhS7v68sK
         wk4ovOfZvU3k0Of9ytjMC1cvUcO6DADyzl22SoaH+8Gh6eJjBdToDUqnIdzebExgRmLk
         0bbw==
X-Forwarded-Encrypted: i=1; AKwUvByFDNB4h1FuckAMo6Q/xI2jBr1AxVOC+MJIaAt2KSztp4CYv8BQu9IDS/FpcALxCFya7d4vh1XgkBriRQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJk+/tD96BBe4VfzPKj5qbZqO2WRxCuMKVkBOGFqybh88YU23JH
	dh1DXSplCExRiXwPXloDgU/Kaz++oxd6kd4RuvqWKHFnjh1hFARtE2yGKgg0V6pCShY=
X-Gm-Gg: AYBFou2+KMvn4PlCK+NYJ2XQn3zoZyOdBUV18GqN80xRXPfSKakSZFcbrTTt9cq4Wj6
	sSHzFndZEE8Y3Cdn7Ai10HLj+6uYS7jAKnEgGMkCO1F03ZP9e43w80hVOND6hcrxX0P0LZP1zNy
	vZ1v3dAW54pAaLcc0IpM3hAMIa4oueoa2YNJsSMugEREXwq1o0g//AhJmJb12RzRdnIlHFIGcwG
	hDBooaxRahtoK9FCiYcafeF4fwYHveFxKKavVSObnrPMiKBb0ufTMD9a93YM/aIIxc/miU6+y4p
	/bePikbimat+Wh0KPjS8YEn2KT4nX6iQTNZxphybKyxtMoC6HyFFlRLdFMi2IhCggd4HInRKT6v
	o89m10CVjY/mN/6T9ozpIwaepXWKrztytUZ3Uqwp7VKne17OjWYnGJeN/+j8p/QPmjzd05t5evf
	imHcS0QIGTRT+At5Md9J8LK2OkcexJh7QyjTS7FIRBFUp6XU/XN61EA4rbB7h4/i6bgHYkzEf8D
	v2kgH4oPBM26Lcet8UGwKY=
X-Received: by 2002:a05:600c:3e85:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4a1d74667d5mr107269755e9.0.1792334026042;
        Sun, 18 Oct 2026 07:33:46 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm16339501a91.11.2026.10.18.07.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:33:45 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 3/4] ocfs2: switch dio write path from buffer_head to iomap
Date: Sun, 18 Oct 2026 22:33:15 +0800
Message-ID: <20261018143319.22329-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261018143319.22329-1-heming.zhao@suse.com>
References: <20261018143319.22329-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Converts OCFS2's DIO write path from the legacy buffer_head
infrastructure to the modern iomap framework.

Key modifications and designs are as follows:

Iomap can handle more than one cluster per call. Refactor
'struct ocfs2_write_ctxt' to use a flexible array 'w_desc[]' instead
of a fixed-size array (which was 1 for 4K page on x86_64). Dynamically
allocate the context based on the write length ('w_clen') in
'ocfs2_alloc_write_ctxt()'.

Introduce 'ocfs2_dio_wr_map_blocks()' to allocate and map direct write
blocks. Define OCFS2_DIO_WR_MAX_MAP_BYTES to limit mappings to 1 MiB
chunk per call, restricting allocation granularity to prevent resource
exhaustion during huge asynchronous sequential writes.

Implement ocfs2_dio_write_end_io() and ocfs2_iomap_dio_end_io_write()
to handle IO completion. They convert UNWRITTEN extents, updates inode
size (EOF), and deletes the inode from the orphan directory if it was
appended.

In the buffer_head path, ocfs2_dio_wr_get_block() stores dwc in
bh->b_private, enabling it to detect the first call for an IO chunk and
invoke ocfs2_add_inode_to_orphan() to protect the extent allocation.
However, iomap doesn't provide a similar private field. Therefore, moves
ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks(the buffer_head
counterpart to ocfs2_dio_wr_get_block()) to ocfs2_file_write_iter().

Doesn't like ocfs2_dio_wr_get_block(), move the zero operations from
ocfs2_dio_wr_map_blocks() to ocfs2_file_write_iter(). If do the zeroing
in ocfs2_dio_wr_map_blocks() would zero blocks that earlier mappings of
this same dio have already written, as i_size is only updated at dio
completion. this will makes xfstests generic/538 failure.

Assisted-by: LLM
Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c           | 426 ++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/aops.h           |   1 +
 fs/ocfs2/buffer_head_io.c |   7 +-
 fs/ocfs2/file.c           |  96 +++++++--
 fs/ocfs2/ocfs2.h          |   2 +
 5 files changed, 498 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 633d23dbbe09..6564b3251b28 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -753,6 +753,8 @@ int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 #define OCFS2_MAX_CTXT_PAGES	(OCFS2_MAX_CLUSTERSIZE / PAGE_SIZE)
 #endif
 
+#define OCFS2_DIO_WR_MAX_MAP_BYTES	(1U << 20)	/* 1 MiB */
+
 #define OCFS2_MAX_CLUSTERS_PER_PAGE	(PAGE_SIZE / OCFS2_MIN_CLUSTERSIZE)
 
 struct ocfs2_unwritten_extent {
@@ -788,8 +790,6 @@ struct ocfs2_write_ctxt {
 	/* Type of caller. Must be one of buffer, mmap, direct.  */
 	ocfs2_write_type_t		w_type;
 
-	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
-
 	/*
 	 * This is true if page_size > cluster_size.
 	 *
@@ -839,6 +839,8 @@ struct ocfs2_write_ctxt {
 
 	struct list_head		w_unwritten_list;
 	unsigned int			w_unwritten_count;
+
+	struct ocfs2_write_cluster_desc	w_desc[];
 };
 
 void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
@@ -906,17 +908,24 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
 				  unsigned len, ocfs2_write_type_t type,
 				  struct buffer_head *di_bh)
 {
-	u32 cend;
+	u32 w_cpos, cend, w_clen;
 	struct ocfs2_write_ctxt *wc;
+	size_t alloc_size;
+
+	w_cpos = pos >> osb->s_clustersize_bits;
+	cend = (pos + len - 1) >> osb->s_clustersize_bits;
+	w_clen = cend - w_cpos + 1;
 
-	wc = kzalloc_obj(struct ocfs2_write_ctxt, GFP_NOFS);
+	alloc_size = sizeof(struct ocfs2_write_ctxt) +
+		w_clen * sizeof(struct ocfs2_write_cluster_desc);
+
+	wc = kzalloc(alloc_size, GFP_NOFS);
 	if (!wc)
 		return -ENOMEM;
 
-	wc->w_cpos = pos >> osb->s_clustersize_bits;
+	wc->w_cpos = w_cpos;
 	wc->w_first_new_cpos = UINT_MAX;
-	cend = (pos + len - 1) >> osb->s_clustersize_bits;
-	wc->w_clen = cend - wc->w_cpos + 1;
+	wc->w_clen = w_clen;
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
 	wc->w_type = type;
@@ -2207,7 +2216,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	struct ocfs2_write_cluster_desc *desc = NULL;
 	struct ocfs2_dio_write_ctxt *dwc = NULL;
 	struct buffer_head *di_bh = NULL;
-	u64 p_blkno;
+	u64 p_blkno = 0;
 	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
 	loff_t pos = iblock << i_blkbits;
 	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
@@ -2347,6 +2356,183 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+/*
+ * Prepare the area between i_size and a direct write that starts or ends
+ * beyond it.  Must be called once per dio, before any io is issued, with
+ * i_rwsem and the rw lock held.
+ */
+int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *di_bh = NULL;
+	int ret;
+
+	if (pos + count <= i_size_read(inode))
+		return 0;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		ret = ocfs2_zero_tail(inode, di_bh, pos);
+	else
+		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, count,
+						   NULL);
+	if (ret < 0)
+		mlog_errno(ret);
+	up_write(&oi->ip_alloc_sem);
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+	return ret;
+}
+
+/* copy from ocfs2_dio_wr_get_block */
+static int ocfs2_dio_wr_map_blocks(struct inode *inode,
+			       struct ocfs2_map_block *map, int create)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_write_ctxt *wc;
+	struct ocfs2_write_cluster_desc *desc = NULL;
+	struct buffer_head *di_bh = NULL;
+	u64 p_blkno, bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	sector_t iblock = map->lblk;
+	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
+	loff_t pos = iblock << i_blkbits;
+	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
+	unsigned int total_len = map->len << i_blkbits;
+	unsigned int map_len;
+	unsigned int cont_clusters = 1;
+	int ret = 0, idx;
+
+	/*
+	 * map->len is count in ocfs2_iomap_begin according to write
+	 * "pos" and "end", we need map twice to return different buffer state:
+	 * 1. area in file size, not set NEW;
+	 * 2. area out file size, set  NEW.
+	 *
+	 *		   iblock    endblk
+	 * |--------|---------|---------|---------
+	 * |<-------area in file------->|
+	 */
+	if ((iblock <= endblk) &&
+	    ((iblock + ((total_len - 1) >> i_blkbits)) > endblk))
+		total_len = (endblk - iblock + 1) << i_blkbits;
+
+	/*
+	 * Bound how much we allocate/prepare (and journal) per call. map->len
+	 * below still reports only the physically-contiguous prefix to iomap;
+	 * iomap calls us again for the remainder.
+	 */
+	map_len = min(total_len, OCFS2_DIO_WR_MAX_MAP_BYTES);
+
+	mlog(0, "get block of %llu at %llu:%u req %u\n",
+			inode->i_ino, pos, map_len, total_len);
+
+	/*
+	 * Because we need to change file size in ocfs2_iomap_dio_end_io_write(),
+	 * or we may need to add it to orphan dir. So can not fall to fast path
+	 * while file size will be changed.
+	 */
+	if (pos + total_len <= i_size_read(inode)) {
+		/* This is the fast path for re-write. */
+		ret = ocfs2_map_blocks(inode, map, OCFS2_GET_BLOCKS_CREATE);
+		if ((map->flags & OCFS2_MAP_MAPPED) &&
+		    !(map->flags & OCFS2_MAP_NEW) && ret == 0)
+			goto out;
+
+		/* Clear state set by ocfs2_map_blocks. */
+		map->flags = 0;
+	}
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+
+	/*
+	 * Note, Zeroing the gap between i_size and the write is done
+	 * once per dio by ocfs2_dio_zero_eof() before the io is issued.
+	 */
+	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, map_len,
+				       OCFS2_WRITE_DIRECT, NULL,
+				       (void **)&wc, di_bh, NULL);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+
+	desc = &wc->w_desc[0];
+
+	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
+	if (p_blkno == 0) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto unlock;
+	}
+	p_blkno += iblock & (bpc - 1);
+
+	/*
+	 * Calculate physically contiguous clusters by checking descriptor arrays.
+	 * This strictly prevents map->len from expanding past non-contiguous physical bounds.
+	 */
+	for (idx = 1; idx < wc->w_clen; idx++) {
+		if (wc->w_desc[idx].c_phys == wc->w_desc[idx - 1].c_phys + 1 &&
+		    wc->w_desc[idx].c_needs_zero == wc->w_desc[idx - 1].c_needs_zero) {
+			cont_clusters++;
+		} else {
+			break;
+		}
+	}
+	map->pblk = p_blkno;
+	/*
+	 * Only report the mapping as UNWRITTEN when the cluster is newly
+	 * allocated or was already unwritten (desc->c_needs_zero). Reporting
+	 * an already-written cluster as UNWRITTEN makes the iomap direct-io
+	 * core zero the sub-block head/tail padding, which destroys existing
+	 * data when a sub-block write lands inside a written cluster.
+	 */
+	map->flags |= OCFS2_MAP_MAPPED;
+	if (desc->c_needs_zero)
+		map->flags |= OCFS2_MAP_UNWRITTEN;
+	/* subtract the offset */
+	map->len = cont_clusters * bpc - (iblock & (bpc - 1));
+	map->len = min_t(u64, map->len, map_len >> i_blkbits);
+
+	if (desc->c_needs_zero)
+		map->flags |= OCFS2_MAP_NEW;
+
+	if (iblock > endblk)
+		map->flags |= OCFS2_MAP_NEW;
+
+	map->flags |= OCFS2_MAP_DEFER_COMPLETION;
+
+	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
+	/* Here returns only two types: map_len (success), errno (failure). */
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, map_len, map_len, wc);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+	WARN_ON_ONCE(ret != map_len);
+	ret = 0;
+
+unlock:
+	up_write(&oi->ip_alloc_sem);
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+out:
+	return ret;
+}
+
 static int ocfs2_dio_end_io_write(struct inode *inode,
 				  struct ocfs2_dio_write_ctxt *dwc,
 				  loff_t offset,
@@ -2546,6 +2732,12 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 				    ocfs2_dio_end_io, 0);
 }
 
+static int ocfs2_iomap_alloc(struct inode *inode, struct ocfs2_map_block *map,
+			    unsigned int flags)
+{
+	return ocfs2_dio_wr_map_blocks(inode, map, 1);
+}
+
 static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
@@ -2553,6 +2745,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ocfs2_map_block map;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	u8 blkbits = inode->i_blkbits;
+	unsigned int orig_mlen;
 
 	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -2564,9 +2757,32 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
 	map.flags = 0;
+	orig_mlen = map.len;
 
 	if (flags & IOMAP_WRITE) {
-		return -EOPNOTSUPP;
+		/*
+		 * We check here if the blocks are already allocated, then we
+		 * don't need to start a journal txn and we can directly return
+		 * the mapping information. This could boost performance
+		 * especially in multi-threaded overwrite requests.
+		 */
+		if (offset + length <= i_size_read(inode)) {
+			down_read(&oi->ip_alloc_sem);
+			ret = ocfs2_map_blocks(inode, &map, 0);
+			up_read(&oi->ip_alloc_sem);
+			/*
+			 * For atomic writes the entire requested length should
+			 * be mapped.
+			 */
+			if (map.flags & OCFS2_MAP_MAPPED) {
+				if ((!(flags & IOMAP_ATOMIC) && ret > 0) ||
+				   (flags & IOMAP_ATOMIC && ret >= orig_mlen)) {
+					goto out;
+				}
+			}
+			map.len = orig_mlen;
+		}
+		ret = ocfs2_iomap_alloc(inode, &map, flags);
 	} else {
 		down_read(&oi->ip_alloc_sem);
 		ret = ocfs2_map_blocks(inode, &map, 0);
@@ -2576,6 +2792,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 
+out:
 	/*
 	 * Before returning to iomap, let's ensure the allocated mapping
 	 * covers the entire requested length for atomic writes.
@@ -2641,8 +2858,8 @@ static int ocfs2_iomap_dio_end_io(struct kiocb *iocb, ssize_t size, int error,
 	return error;
 }
 
-static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
-				int error, unsigned int flags)
+static int ocfs2_iomap_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
+					int error, unsigned int flags)
 {
 	if (error)
 		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
@@ -2654,8 +2871,193 @@ static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
 }
 
 const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
-	.end_io = ocfs2_dio_end_io_r_pr,
+	.end_io = ocfs2_iomap_dio_end_io_r_pr,
+};
+
+/* copy from ocfs2_dio_end_io_write */
+static int ocfs2_iomap_dio_end_io_write(struct inode *inode,
+				  loff_t offset,
+				  ssize_t bytes)
+{
+	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct ocfs2_extent_tree et;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	struct ocfs2_alloc_context *data_ac = NULL;
+	struct ocfs2_alloc_context *meta_ac = NULL;
+	handle_t *handle = NULL;
+	loff_t end = offset + bytes;
+	int ret = 0, credits = 0;
+	struct ocfs2_map_block map;
+	unsigned int blkbits = inode->i_blkbits;
+	unsigned int ue_cpos = 0, ue_phys = 0, ue_len = 0;
+	unsigned int curr_lblk, end_lblk;
+
+	map.lblk = offset >> blkbits;
+
+	ocfs2_init_dealloc_ctxt(&dealloc);
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	down_write(&oi->ip_alloc_sem);
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
+
+	/* Attach dealloc with extent tree in case that we may reuse extents
+	 * which are already unlinked from current extent tree due to extent
+	 * rotation and merging.
+	 */
+	et.et_dealloc = &dealloc;
+
+	ret = ocfs2_lock_allocators(inode, &et, 0, (bytes >> osb->s_clustersize_bits)*2,
+				    &data_ac, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+
+	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
+
+	handle = ocfs2_start_trans(osb, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		mlog_errno(ret);
+		goto unlock;
+	}
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		mlog_errno(ret);
+		goto commit;
+	}
+
+	curr_lblk = offset >> blkbits;
+	/*
+	 * Round the end up so the final partial block (sub-block direct I/O)
+	 * is included; otherwise the last, partially-written cluster is left
+	 * unwritten and reads back as zero.
+	 */
+	end_lblk = (offset + bytes + (1 << blkbits) - 1) >> blkbits;
+	while (ret >= 0 && curr_lblk < end_lblk) {
+		memset(&map, 0, sizeof(map));
+		map.lblk = curr_lblk;
+		map.len = end_lblk - curr_lblk;
+
+		ret = ocfs2_assure_trans_credits(handle, credits);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+
+		ret = ocfs2_map_blocks(inode, &map, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+		if (ret == 0)
+			break;
+
+		if (map.flags & OCFS2_MAP_UNWRITTEN) {
+			ue_cpos = ocfs2_blocks_to_clusters(inode->i_sb, map.lblk);
+			ue_phys = ocfs2_blocks_to_clusters(inode->i_sb, map.pblk);
+			ue_len = ocfs2_clusters_for_blocks(inode->i_sb,
+						map.lblk + map.len) - ue_cpos;
+
+			ret = ocfs2_mark_extent_written(inode, &et, handle,
+					ue_cpos, ue_len,
+					ue_phys,
+					meta_ac, &dealloc);
+			if (ret < 0) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+		curr_lblk += map.len;
+	}
+
+	if (end > i_size_read(inode)) {
+		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+commit:
+	ocfs2_commit_trans(osb, handle);
+
+unlock:
+	up_write(&oi->ip_alloc_sem);
+
+	if (data_ac)
+		ocfs2_free_alloc_context(data_ac);
+	if (meta_ac)
+		ocfs2_free_alloc_context(meta_ac);
+
+	down_write(&oi->ip_alloc_sem);
+	if (!ret && (di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+	up_write(&oi->ip_alloc_sem);
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+out:
+	ocfs2_run_deallocs(osb, &dealloc);
+	return ret;
+}
+
+static int ocfs2_dio_write_end_io(struct kiocb *iocb, ssize_t size,
+			int error, unsigned int flags, int level)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t offset = iocb->ki_pos;
+	int ret = 0;
+
+	if (error)
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+
+	if (size && ((flags & IOMAP_DIO_UNWRITTEN) ||
+		    (offset + size > i_size_read(inode)))) {
+		ret = ocfs2_iomap_dio_end_io_write(inode, offset, size);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	error = ocfs2_iomap_dio_end_io(iocb, size, error, level);
+
+	return error;
+}
+
+static int ocfs2_iomap_dio_end_io_w_pr(struct kiocb *iocb, ssize_t size,
+				     int error, unsigned int flags)
+{
+	return ocfs2_dio_write_end_io(iocb, size, error, flags, 0);
+}
+
+static int ocfs2_iomap_dio_end_io_w_ex(struct kiocb *iocb, ssize_t size,
+				     int error, unsigned int flags)
+{
+	return ocfs2_dio_write_end_io(iocb, size, error, flags, 1);
+}
+
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr = {
+	.end_io = ocfs2_iomap_dio_end_io_w_pr,
+};
+
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex = {
+	.end_io = ocfs2_iomap_dio_end_io_w_ex,
 };
+
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 8dd6edd7c1a1..b46ba4df1428 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -42,6 +42,7 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
+int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count);
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags);
 /* all ocfs2_dio_end_io()'s fault */
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 493f2209cca5..03906ab737ec 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -332,6 +332,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 						wait_on_buffer(bh);
 					put_bh(bh);
 					bhs[i] = NULL;
+				} else if (bh && buffer_uptodate(bh)) {
+					clear_buffer_uptodate(bh);
 				}
 				continue;
 			}
@@ -360,11 +362,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status = validate(sb, bh);
-				if (status) {
-					if (buffer_uptodate(bh))
-						clear_buffer_uptodate(bh);
+				if (status)
 					goto read_failure;
-				}
 			}
 		}
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a0b3883216bc..8ac15ea58cc6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -48,6 +48,7 @@
 #include "quota.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "namei.h"
 
 #include "buffer_head_io.h"
 
@@ -2378,6 +2379,8 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 				struct inode *inode)
 {
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
 	/*
 	 * Fallback to buffered I/O if we see an inode without
 	 * extents.
@@ -2385,6 +2388,11 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return false;
 
+	/* Fallback to buffered I/O if we do not support append dio. */
+	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
+	    !ocfs2_supports_append_dio(osb))
+		return false;
+
 	return true;
 }
 
@@ -2405,6 +2413,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
+	int dio_flags = 0;
+	ssize_t buffered;
 
 	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2424,8 +2434,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
-	ocfs2_iocb_init_rw_locked(iocb);
-
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2489,26 +2497,78 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 		saved_ki_complete = xchg(&iocb->ki_complete, NULL);
 	}
 
-	/* communicate with ocfs2_dio_end_io */
-	ocfs2_iocb_set_rw_locked(iocb, rw_level);
+	if (direct_io && ocfs2_should_use_dio(iocb, from, inode)) {
+		if (ocfs2_clusters_for_bytes(inode->i_sb, iocb->ki_pos + count) >
+		    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode))) {
+			/*
+			 * when we are going to alloc extents beyond file size, add the
+			 * inode to orphan dir, so we can recall those spaces when
+			 * system crashed during write.
+			 */
+			ret = ocfs2_add_inode_to_orphan(osb, inode);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto out;
+			}
+			dio_flags = IOMAP_DIO_FORCE_WAIT;
+		}
+
+		ret = ocfs2_dio_zero_eof(inode, iocb->ki_pos, count);
+		if (ret < 0)
+			goto out;
 
-	written = __generic_file_write_iter(iocb, from);
-	/* buffered aio wouldn't have proper lock coverage today */
-	BUG_ON(written == -EIOCBQUEUED && !direct_io);
+		const struct iomap_dio_ops *dops = rw_level ?
+			&ocfs2_iomap_dio_ops_w_ex : &ocfs2_iomap_dio_ops_w_pr;
+		struct iomap_dio *dio;
 
-	/*
-	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
-	 * function pointer which is called when o_direct io completes so that
-	 * it can unlock our rw lock.
-	 * Unfortunately there are error cases which call end_io and others
-	 * that don't.  so we don't have to unlock the rw_lock if either an
-	 * async dio is going to do it in the future or an end_io after an
-	 * error has already done it.
-	 */
-	if ((written == -EIOCBQUEUED) || (!ocfs2_iocb_is_rw_locked(iocb))) {
-		rw_level = -1;
+		dio = __iomap_dio_rw(iocb, from, &ocfs2_iomap_ops,
+				     dops, dio_flags, NULL, 0);
+		if (dio == NULL) {
+			/* No I/O issued; rw_lock still held. */
+			written = 0;
+		} else if (IS_ERR(dio)) {
+			written = PTR_ERR(dio);
+			/*
+			 * -EIOCBQUEUED: async I/O; end_io will drop the lock on
+			 * completion. Any other error means no I/O started and
+			 * end_io was not called, so the cleanup path below drops
+			 * the lock.
+			 */
+			if (written == -EIOCBQUEUED)
+				rw_level = -1;
+		} else {
+			/*
+			 * Synchronous completion. iomap_dio_complete() runs
+			 * end_io, which drops the lock unless the mapping
+			 * bounced us back to buffered I/O (returns 0, lock
+			 * retained).
+			 */
+			written = iomap_dio_complete(dio);
+			if (written != 0)
+				rw_level = -1;
+		}
+		/*
+		 * iomap_dio_rw() returns -ENOTBLK when it could not invalidate
+		 * the page cache for the DIO range (e.g. racing buffered/mmap
+		 * I/O on the same file, as exercised by generic/095). Fall back
+		 * to a buffered write for the remaining data, the same way
+		 * ext4/xfs do, instead of leaking -ENOTBLK to userspace.
+		 */
+		if (written == -ENOTBLK)
+			written = 0;
+		if (written >= 0 && iov_iter_count(from)) {
+			iocb->ki_flags &= ~IOCB_DIRECT;
+			buffered = __generic_file_write_iter(iocb, from);
+			written = direct_write_fallback(iocb, from, written, buffered);
+		}
+	} else {
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		written = __generic_file_write_iter(iocb, from);
 	}
 
+	/* buffered aio wouldn't have proper lock coverage today */
+	BUG_ON(written == -EIOCBQUEUED && !direct_io);
+
 	if (unlikely(written <= 0))
 		goto out;
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index a775c1869293..b228b10b5e71 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -551,6 +551,8 @@ struct ocfs2_map_block {
 
 extern const struct iomap_ops ocfs2_iomap_ops;
 extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
 
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
-- 
2.55.0

