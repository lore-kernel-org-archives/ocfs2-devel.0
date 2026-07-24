Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E78C36B917
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Jul 2026 05:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870789; cv=none; b=oGp727kP7bdBmtCN8tMqM4dkle4jewg59QS/RJmJOMz95z74YoTYdtvdC6ojrVoz2PT8cslIXogbuE3mmD0YHCTgJ8ElLXBj8/MZBIjWVXykZxlVwJkV4BLeYavnvf58nIs9UbfAIXnvvtPg8XEA5dsOzPkRSri4tvwzmcXC0pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870789; c=relaxed/simple;
	bh=sBrxqrJYeuSHZ1ErJI1ESVtstnVy/ymu4rVj7A6nUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwDyUCWYCUBgCK/1Ovvc4AzHXY6mWXtrvKr356iyJ/dbd45BkIqW2xCFgfMFEWm6ThBKfrd3h85lgNnZff9csoj/dBiDDC9g29OaoMjncoZjZNF/myf2e0A6xJD5C93uqQCmxxz0e3AvFc6yw6eGcv7Z0dijEAR8WlwOBV6XGfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WL9FUfyk; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WL9FUfyk"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6983ed43ca1so1340a12.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 22:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784870785; x=1785475585; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmVoEl+v/L9t9C2QA0vFF2m+wfjKfR2N+EOEcn5k2S8=;
        b=WL9FUfykGtQQyMOs8556WxGO8sx08Tu2GsRq5bdfcUtSYGtKv1GDDj5A64TvApNGcC
         zuOg6fWbiVKEnM76rTI7fwgrmNBC9URD1bZOnJzNHYJHfIWl4LDMuHrwjIacwoHGTp96
         V4Nua9PYuQHKuJAk4jSZRWdw31/r5p/jSnvxfWgKQuRTyU8jqc/Veq3cNjUwabknpRyq
         JvLSi7150OwjbMKYqQfR0LV6qdPtzkTlRH9KXDctLYz5bkkT6z8dbcanawlz449JQuaq
         YajSJSayfKKr71nny285CvWldNWYbz2zAA5eqx46Epj5+E/2cCeaqsjCi0jWll5yEhg3
         /LUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784870785; x=1785475585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qmVoEl+v/L9t9C2QA0vFF2m+wfjKfR2N+EOEcn5k2S8=;
        b=hHXsV//DAXyZS0nwk6d8NkjIUI10SL8SNOscAirIcPslm8xB7RO3Vp/XhbzQ5iKbKg
         Lc6stwzbQ2DdJCpw8hBjzewqFcYI4ivYvVhBpOHsN9xS0XiIzDzJ4+HW43IVbCsd9iDP
         0fT+YbR+jaUCq6MQ1l2GEn3/3vBTN41GmE+IO0k95pE8Q7CH3X3Wt1dvG1uCxeA7rrlm
         xC0Ik8e4QhlpTWLALmr1gnnFe20XTbqyApqulNSBVmtkchzQpdZnuqH7hCGPz27J18cE
         H1EGbYRNDZnHeiXSDevvP7m8R0v42EkzHJVRlbw83csz4DDo0+CNfjU0SrDmllrEyK8J
         XHqg==
X-Forwarded-Encrypted: i=1; AHgh+RqFQlXSa1JFQ3AkThv0kSc8Rz5JROBp0pvZyhuSXTTKGW0AVewaFUJoi3AqA+8wTLyF3oV3jOTDIb+ybg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc4wemnPpiDutkwhSln1hAGLMM6WCf8iiDXJxHPQ6GiE7EMdci
	IustaT3h1pm+N9lXqEwnmN2Fo57FtTo6kmkaa5chpNchsLET4AgxBav7fKl8cLE9NxQ=
X-Gm-Gg: AR+sD10a1+mvot4ipZu3nJQRO7CSfrBNsINUWh6ElR5Wjrqh7H8SAYrbDJgSUqIWX1/
	0qf3/dzNN1F2RKCDITWP0wInTefnWvdwquFk2Z/Jc7X8ocY3qkbpEudGOoZnOER8Qx41pIZvQtW
	3+C7RcOD2FAf3Z3lLYeWGV+9BWR2mSENBSRHkpoX01kHciUN7dr7xhN3UHOuGQGSrG3inYPB5r+
	oxPavriwmcjVFQTrtJe2AsUUJUZd44uZxYBUy1cBOf5QKQ7RKhcNgJaDylvaDvBooYMK/TRbuGF
	kxvzX8RW/UqWnm0qvF+Q/DUjljn9HJQtIlW0jExoyZ8wgdgw1hQHSEhFKSq+01mokoTzQtBHWOV
	7xqeVUQtpXyD6w1Ehe1BKp+6j4EXN9z7sfR5gIHQGwipNxBHg+TvgHKlPiM69a2jGI1Sgio5Nml
	Uwy/lFU9SMw1Dpiw==
X-Received: by 2002:a05:6402:26cf:b0:698:5889:9bfe with SMTP id 4fb4d7f45d1cf-69f8dc94d30mr601159a12.3.1784870784679;
        Thu, 23 Jul 2026 22:26:24 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f039b1ce3sm898577a91.4.2026.07.23.22.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 22:26:23 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] ocfs2: switch dio write path from buffer_head to iomap
Date: Fri, 24 Jul 2026 13:25:57 +0800
Message-ID: <20260724052559.15409-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724052559.15409-1-heming.zhao@suse.com>
References: <20260724052559.15409-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch converts OCFS2's DIO write path from the legacy
buffer_head infrastructure to the modern iomap framework.

Key modifications and designs are as follows:

1. Dynamic Context Allocation:
   Refactor 'struct ocfs2_write_ctxt' to use a flexible array 'w_desc[]'
   instead of a fixed-size array. Dynamically allocate the context based on
   the write length ('w_clen') in 'ocfs2_alloc_write_ctxt()'. This prevents
   static limits overflow and optimizes kernel heap memory utilization.

2. Robust Mapping and Limits:
   Introduce 'ocfs2_dio_wr_map_blocks()' to allocate and map direct write
   blocks. Implement a 1 MiB cap ('OCFS2_DIO_WR_MAX_MAX_BYTES') per mapping
   call to restrict allocation granularity, preventing JBD2 transaction
   credit exhaustion during huge asynchronous sequential writes.

3. Reliable Completion Work and Fallback:
   - Implement 'ocfs2_iomap_dio_end_io_write()' to handle metadata completion.
     It converts UNWRITTEN extents, updates inode size (EOF), and deletes the
     inode from the orphan directory if it was appended.
   - Implement 'ocfs2_dio_write_end_io()' to finalize the dio lifecycle and
     release cluster locks safely.
   - Intercept '-ENOTBLK' errors from 'iomap_dio_rw()' caused by page cache
     invalidation failures (due to mmap/buffered collisions). Gracefully clear
     the error, strip the IOCB_DIRECT flag, and fall back to buffered write

4. Moved ocfs2_add_inode_to_orphan():
   - moved ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks() to
     ocfs2_file_write_iter().

5. Uncertain logic in code
   For the following code block in ocfs2_dio_wr_map_blocks():
   ```
     if (extend) {
             if (ocfs2_sparse_alloc(osb))
                     ret = ocfs2_zero_tail(inode, di_bh, pos);
             else
                     ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
                                                         map_len, NULL);
             if (ret < 0) {
                     mlog_errno(ret);
                     goto unlock;
             }
     }
   ```
   I am not completely certain whether it is called only once per
   ocfs2_file_write_iter(), but I believe calling it multiple times will
   not introduce any side effects. Furthermore, testing across various
   scenarios showed no instances of multiple calls.

Assisted-by: Gemini:gemini-3.5-flash
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c           | 387 +++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/buffer_head_io.c |   7 +-
 fs/ocfs2/file.c           |  55 +++++-
 fs/ocfs2/ocfs2.h          |   1 +
 4 files changed, 435 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 59d445dd61f6..60bf0973f38d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -764,6 +764,8 @@ int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 #define OCFS2_MAX_CTXT_PAGES	(OCFS2_MAX_CLUSTERSIZE / PAGE_SIZE)
 #endif
 
+#define OCFS2_DIO_WR_MAX_MAP_BYTES	(1U << 20)	/* 1 MiB */
+
 #define OCFS2_MAX_CLUSTERS_PER_PAGE	(PAGE_SIZE / OCFS2_MIN_CLUSTERSIZE)
 
 struct ocfs2_unwritten_extent {
@@ -799,8 +801,6 @@ struct ocfs2_write_ctxt {
 	/* Type of caller. Must be one of buffer, mmap, direct.  */
 	ocfs2_write_type_t		w_type;
 
-	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
-
 	/*
 	 * This is true if page_size > cluster_size.
 	 *
@@ -850,6 +850,8 @@ struct ocfs2_write_ctxt {
 
 	struct list_head		w_unwritten_list;
 	unsigned int			w_unwritten_count;
+
+	struct ocfs2_write_cluster_desc	w_desc[];
 };
 
 void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
@@ -917,17 +919,24 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
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
@@ -2218,7 +2227,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	struct ocfs2_write_cluster_desc *desc = NULL;
 	struct ocfs2_dio_write_ctxt *dwc = NULL;
 	struct buffer_head *di_bh = NULL;
-	u64 p_blkno;
+	u64 p_blkno = 0;
 	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
 	loff_t pos = iblock << i_blkbits;
 	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
@@ -2358,6 +2367,148 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+/* copy from ocfs2_dio_wr_get_block */
+static int ocfs2_dio_wr_map_blocks(struct inode *inode,
+			       struct ocfs2_map_block *map, int create)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_write_ctxt *wc;
+	struct ocfs2_write_cluster_desc *desc = NULL;
+	struct buffer_head *di_bh = NULL;
+	u64 p_blkno;
+	sector_t iblock = map->lblk;
+	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
+	loff_t pos = iblock << i_blkbits;
+	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
+	unsigned int total_len = map->len << i_blkbits;
+	unsigned int map_len;
+	unsigned int cont_clusters = 1;
+	int ret = 0, extend = 0, idx;
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
+	} else {
+		extend = 1;
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
+	if (extend) {
+		if (ocfs2_sparse_alloc(osb))
+			ret = ocfs2_zero_tail(inode, di_bh, pos);
+		else
+			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
+							   map_len, NULL);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto unlock;
+		}
+	}
+
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
+	BUG_ON(p_blkno == 0);
+	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
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
+	map->len = cont_clusters * ocfs2_clusters_to_blocks(inode->i_sb, 1);
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
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, map_len, map_len, wc);
+	BUG_ON(ret != map_len);
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
@@ -2525,6 +2676,8 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
+	/* match iomap rw lock action */
+	ocfs2_iomap_iocb_clear_rw_locked(iocb);
 	return ret;
 }
 
@@ -2557,6 +2710,12 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
@@ -2564,6 +2723,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ocfs2_map_block map;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	u8 blkbits = inode->i_blkbits;
+	unsigned int orig_mlen;
 
 	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -2575,9 +2735,32 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
 	map.flags = 0;
+	orig_mlen = map.len;
 
 	if (flags & IOMAP_WRITE) {
-		/* todo */
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
@@ -2587,6 +2770,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 
+out:
 	/*
 	 * Before returning to iomap, let's ensure the allocated mapping
 	 * covers the entire requested length for atomic writes.
@@ -2657,6 +2841,191 @@ static int ocfs2_dio_read_end_io(struct kiocb *iocb, ssize_t size, int error,
 const struct iomap_dio_ops ocfs2_dio_r_ops = {
 	.end_io = ocfs2_dio_read_end_io,
 };
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
+	unsigned int max_blocks;
+	unsigned int ue_cpos = 0, ue_phys = 0, ue_len = 0;
+	unsigned int curr_lblk, end_lblk;
+
+	map.lblk = offset >> blkbits;
+	max_blocks = (bytes + offset) >> osb->s_clustersize_bits;
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
+		map.lblk += curr_lblk;
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
+static int ocfs2_dio_write_end_io(struct kiocb *iocb, ssize_t size, int error,
+		unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	loff_t offset = iocb->ki_pos;
+	int level;
+	int ret = 0;
+
+	if (error) {
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+		goto bail;
+	}
+
+	BUG_ON(!ocfs2_iomap_iocb_is_rw_locked(iocb));
+
+
+	if (size && ((flags & IOMAP_DIO_UNWRITTEN) ||
+		    (offset + size > i_size_read(inode)))) {
+		ret = ocfs2_iomap_dio_end_io_write(inode, offset, size);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	level = ocfs2_iomap_iocb_rw_locked_level(iocb);
+
+	/* sync dio unlock job done in .read_iter or .write_iter */
+	if (ocfs2_iomap_iocb_is_rw_locked(iocb))
+		ocfs2_rw_unlock(inode, level);
+
+	ocfs2_iocb_clear_rw_locked(iocb);
+	ocfs2_iomap_iocb_clear_rw_locked(iocb);
+
+bail:
+	return error;
+}
+
+const struct iomap_dio_ops ocfs2_dio_w_ops = {
+	.end_io = ocfs2_dio_write_end_io,
+};
+
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
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
index e879312ff86b..f84e5e3ed391 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -48,6 +48,7 @@
 #include "quota.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "namei.h"
 
 #include "buffer_head_io.h"
 
@@ -2378,6 +2379,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 				struct inode *inode)
 {
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	unsigned int dio_align = bdev_logical_block_size(inode->i_sb->s_bdev);
 
 	/*
@@ -2387,6 +2389,11 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return false;
 
+	/* Fallback to buffered I/O if we do not support append dio. */
+	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
+	    !ocfs2_supports_append_dio(osb))
+		return false;
+
 	/*
 	 * Allow Direct I/O for any write requests aligned to the underlying
 	 * logical sector size (e.g., 512 bytes).
@@ -2415,6 +2422,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
+	int dio_flags = 0;
+	ssize_t buffered;
 
 	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2434,7 +2443,9 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
+	/* check the comments in ocfs2_file_read_iter() */
 	ocfs2_iocb_init_rw_locked(iocb);
+	ocfs2_iomap_iocb_init_rw_locked(iocb);
 
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
@@ -2501,8 +2512,46 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 
 	/* communicate with ocfs2_dio_end_io */
 	ocfs2_iocb_set_rw_locked(iocb, rw_level);
+	/* communicate with ocfs2_dio_write_end_io */
+	ocfs2_iomap_iocb_set_rw_locked(iocb, rw_level);
+
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
+		written = iomap_dio_rw(iocb, from, &ocfs2_iomap_ops, &ocfs2_dio_w_ops,
+					dio_flags, NULL, 0);
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
+	}
 
-	written = __generic_file_write_iter(iocb, from);
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(written == -EIOCBQUEUED && !direct_io);
 
@@ -2546,8 +2595,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	if (saved_ki_complete)
 		xchg(&iocb->ki_complete, saved_ki_complete);
 
-	if (rw_level != -1)
+	if (rw_level != -1) {
 		ocfs2_rw_unlock(inode, rw_level);
+		ocfs2_iomap_iocb_clear_rw_locked(iocb);
+	}
 
 out_mutex:
 	inode_unlock(inode);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 9397947583fb..7a7a2ecdaeaf 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -551,6 +551,7 @@ struct ocfs2_map_block {
 
 extern const struct iomap_ops ocfs2_iomap_ops;
 extern const struct iomap_dio_ops ocfs2_dio_r_ops;
+extern const struct iomap_dio_ops ocfs2_dio_w_ops;
 
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
-- 
2.54.0

