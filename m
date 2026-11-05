Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863197;
	b=npqWDiQ9BaVBqTZmm45D6XOLI/zGi2z09dT2ngURq/08ENrj5jcdKZgivRaqPjWFguEm
	 hr3QWNvZIxY/GTUC1nN24L3PqR97ZYjwpArxLNYHz0F5/mhkoz0FXXLfsCdQ+c68tX8vW
	 q3/xUaVKspCtdYfff/0wdgYVPbchMhnHdtjXRCCmIz+Naxdk5gmrdgaN/HMtn5Tm1bnSm
	 pZrUVTOeB1W95PSchjnen+wAOniFPrhXatM1j8sk23IhveoiN+3MOcNRdBIQBiPutP91E
	 CXDCIgZup/69eXWj/StAVxZThruTj4rKL8/1T6x1bdHSDP4XPgWoNV24E5hDH2M4Aug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0+TsRuLTi5B5q+QjcNoQnJZ1NbXIYbMbWvn6J0IrHwc=;
	b=m9v5Zs1g5FtSEwoK4lv1gEqGbiDqR7NShLYQnN8F5oE/o9ft4d+POyP5OXiv628WrQZc
	 ndDIg7bdw1oBFs8N77iukq9EUf1XcIPDEh5mqwxwK0OK2RjWuCaomhL8TuyY2Q6jMsOwy
	 As0qmVbkNZxZLoq/jAAr8ZZ5XqWaB8w7b75x+t1HucVzapH+bFWFcD2k9/jrfwcbBXVbp
	 muVdTEP5q0i5wF0fb5YsXQx9OU4+UTp25YLHwS5/h2WjAJoPKBTQBlJKneyaGojRyro3u
	 AT5wx4EkZUMTrC7f1G/CImA7mVw7MHt9qq7vZvsiMwLM3lyrpncapeMbhT67WBVmtFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fQbLhgUv;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19171606A326
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 07:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19171606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=fQbLhgUv
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a59ffacb51so1998065e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Nov 2026 23:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793863194; x=1794467994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+TsRuLTi5B5q+QjcNoQnJZ1NbXIYbMbWvn6J0IrHwc=;
        b=fQbLhgUvwC0hs3DwGglNqeBmKEMtYqCkjqEZgINpZKneUsZYZxXtUlJuRGZxU8Pt38
         2VZCL9oo/zQeeSoTRTbGD8sOqL57OfnB9l17KxphxE1BHsswIszbnr24VX+Nze8eJDyw
         Z2L5IStmNkraHWVuqbEgJ/KjedOkfjo62+vEpUBuZIfhZX4GPmI65M6izN4HwQYw7IUo
         Amwh0qZu6R5/REUBgn8ccxBSz+My5AHHUSAVinekd5TXfuV4aMFe5hiMCTIds8+hu9G2
         ns4SRrAjctSKX9euAAfqR8YZIOswSl7bWsmRqxTCvGjk4+RJoFHu1UvFziyeqAuISNG9
         R5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793863194; x=1794467994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+TsRuLTi5B5q+QjcNoQnJZ1NbXIYbMbWvn6J0IrHwc=;
        b=yYDcVfv3D5clMTzpm2gf6D415PA4plZ1tJ0jd5zX72jnRyBJwKfMEaL4FTgOvlhrvJ
         6kaPe36jxN/MDpShKZGef5I4d3HDkqXQ6bLpPpsiT3AcWAG9c0XSK83bXZhAz4zX21K5
         mEzQTZLr8m9viO0ThIf8jb35tqHOW5coVcaXyy77+xXLQ2GdmsyehnI8hCRuypC6SSLN
         wqeqPFUJcVbKv2MOVyZqJQvl6K42eTNgkx/WbhNg2e4/HSZv7LniWy7j3hSWXKB0mf7C
         tCy6VKydWHtXetfTxxYDEzxxUM+ChRYIhSqqwqtCRoJyYSuT2LmuC0B5mwwd9AlOOouV
         J0Ew==
X-Forwarded-Encrypted: i=1; AKwUvBxcdSXtGIU/SGnODVx4V/3Nk9T/P4bJxjnmdUFXMeZXwrSaz52MfsRQsS1aohjXNQpE6yjo5eHTeA5QTg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9na1moD8EifvbOsbU1xDNA/GRt0w/g5kAa4tVsKMi0hzqNTVMH
	Uk/hEONsYdpq18WCWkEZJTRhXLKYfrNAgh8WIc+F+LNd/VWMwKKD+91lKHL+4hAUjNc=
X-Gm-Gg: AYBFou3LYvF476XWMhGxq4awIxcyVaWctrcG7DtjCfXakri3UGrQg73l7D9kzdeBrAK
	mvfh7bTeCwbO2sgLSoXzAyd1nveuzO2l/1G9N0JA0Ol3fpCpp9/n+Bph6FajCC4Qw9Ct7zD2q1A
	zfFwNnENW+BbiE+560nBNugTopkvPC1nI7vnlZMSvDIJynDSVnRPMgITyoaeuPynxF65OX8KP/O
	kKSTLfb/qNQeTEMS8tBXirIDM3WPEfMatozcqBg8qFqI42yHG5WgZp/mXh8oTQo+0cTKn4L474B
	8d1BUzwiHec9aZQslJabvXrVNXr1NYvGlQYD5PowtcfDKGcmlhSaPmryRi5clXMFUUmeXplWzRB
	FPvtMfbfsVLREw6IhUZPDj6u4KM65OorkuSal3JJgQnZzt83xnVXQhe+19iF0Osl5gdUBc9H2mB
	6J6u9yiUvjCQlMwH6WrwtN3glp8MYPtMBSPN7hX7ICDKW+cnqEI1WPdfWHmbAoE9+irVlRn1RqW
	f4MnGdz/9836y4ToK4I/4oBzI8VaYnH4toT7iJX/9ydeCNDUhLMpszJiOsvy72TSMfohgPjPY54
	KWkfEbhP5NONoUrg32ECsTe1k/dVguutsn+AyRjBUrw=
X-Received: by 2002:a7b:ce0d:0:b0:4a1:715d:1913 with SMTP id 5b1f17b1804b1-4ac177538c5mr304358505e9.1.1793863194273;
        Wed, 04 Nov 2026 23:19:54 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm14687084c88.1.2026.11.04.23.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:19:53 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v5 3/4] ocfs2: switch dio write path from buffer_head to iomap
Date: Thu,  5 Nov 2026 15:19:27 +0800
Message-ID: <20261105071930.16399-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261105071930.16399-1-heming.zhao@suse.com>
References: <20261105071930.16399-1-heming.zhao@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Converts OCFS2's DIO write path from the legacy buffer_head
infrastructure to the modern iomap framework.

Key modifications and designs are as follows:

Introduce ocfs2_dio_wr_map_blocks() to allocate and map direct write
blocks. This function is similar to the buffer_head path
ocfs2_dio_wr_get_block(), which still allocates one cluster per call.

Implement ocfs2_dio_write_end_io() and ocfs2_iomap_dio_end_io_write()
to handle IO completion. They convert UNWRITTEN extents, updates inode
size (EOF).

In the buffer_head path, ocfs2_dio_wr_get_block() stores dwc in
bh->b_private, enabling it to detect the first call for an IO chunk and
invoke ocfs2_add_inode_to_orphan() to protect the extent allocation.
However, iomap doesn't provide a similar private field. Therefore, moves
ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks(the buffer_head
counterpart to ocfs2_dio_wr_get_block()) to ocfs2_file_write_iter().

It is also impossible t pass The dwc to iomap_dio_ops.end_io, the iomap
->end_io callback cannot effectively distinguish between I/Os initiated
by different threads concurrently. For example, when multiple DIO write
threads operate on the same inode concurrently, the end_io callback
without the dwc context may incorrectly delete an orphan inode created
by another thread, leading to a crash. The fix is to move the orphan
inode deletion from end_io into ocfs2_file_write_iter(). In
ocfs2_file_write_iter(), inode_lock() serializes the write threads,
and IOMAP_DIO_FORCE_WAIT ensures that the function only returns after
the bio completes. This guarantees that i_size has already been
updated when ocfs2_dio_del_orphan() is called.

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
 fs/ocfs2/aops.c | 418 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/aops.h |   3 +
 fs/ocfs2/file.c | 137 +++++++++++++---
 3 files changed, 521 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8e4d31cb85db..d5b471bdaec2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -199,6 +199,19 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 	return err;
 }
 
+static int ocfs2_lock_map_blocks(struct inode *inode,
+				 struct ocfs2_map_block *map, int flags)
+{
+	int ret = 0;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	down_read(&oi->ip_alloc_sem);
+	ret = ocfs2_map_blocks(inode, map, flags);
+	up_read(&oi->ip_alloc_sem);
+
+	return ret;
+}
+
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
@@ -2336,6 +2349,158 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
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
+				   struct ocfs2_map_block *map, int create)
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
+	unsigned int len, total_len = map->len << i_blkbits;
+	int ret = 0;
+
+	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
+	len = min(total_len, len);
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
+	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
+		len = (endblk - iblock + 1) << i_blkbits;
+
+	mlog(0, "get block of %llu at %llu:%u req %u\n",
+			inode->i_ino, pos, len, total_len);
+
+	/*
+	 * Because we need to change file size in ocfs2_iomap_dio_end_io_write(),
+	 * or we may need to add it to orphan dir. So can not fall to fast path
+	 * while file size will be changed.
+	 */
+	if (pos + total_len <= i_size_read(inode)) {
+		/* This is the fast path for re-write. */
+		ret = ocfs2_lock_map_blocks(inode, map, OCFS2_GET_BLOCKS_CREATE);
+		if ((map->flags & OCFS2_MAP_MAPPED) &&
+		    !(map->flags & OCFS2_MAP_NEW) &&
+		    ret == 0)
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
+	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
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
+	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
+
+	map->pblk = p_blkno;
+	/*
+	 * Only report the mapping as UNWRITTEN when the cluster is newly
+	 * allocated or was already unwritten (desc->c_needs_zero).
+	 */
+	map->flags |= desc->c_needs_zero ?
+			OCFS2_MAP_UNWRITTEN : OCFS2_MAP_MAPPED;
+	map->len = len >> i_blkbits;
+
+	if (desc->c_needs_zero)
+		map->flags |= OCFS2_MAP_NEW;
+
+	if (iblock > endblk)
+		map->flags |= OCFS2_MAP_NEW;
+
+	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
+	/* Here returns only two types: len (success), errno (failure). */
+	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+	WARN_ON_ONCE(ret != len);
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
@@ -2542,6 +2707,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ocfs2_map_block map;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	u8 blkbits = inode->i_blkbits;
+	unsigned int orig_mlen;
 
 	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -2553,9 +2719,10 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
 			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
 	map.flags = 0;
+	orig_mlen = map.len;
 
 	if (flags & IOMAP_WRITE) {
-		return -EOPNOTSUPP;
+		ret = ocfs2_dio_wr_map_blocks(inode, &map, 1);
 	} else {
 		down_read(&oi->ip_alloc_sem);
 		ret = ocfs2_map_blocks(inode, &map, 0);
@@ -2605,6 +2772,217 @@ const struct iomap_ops ocfs2_iomap_ops = {
 	.iomap_begin	= ocfs2_iomap_begin,
 };
 
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
+	int ret = 0, credits = 0, batch = 0;
+	struct ocfs2_map_block map;
+	unsigned int blkbits = inode->i_blkbits;
+	unsigned int ue_cpos = 0, ue_phys = 0, ue_len = 0;
+	unsigned int curr_lblk, end_lblk;
+	u32 extents_to_split;
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
+	/*
+	 * Currently, the slow path of ocfs2_dio_wr_map_blocks() only handles
+	 * single-cluster cases. Because kiocb->private is cleared before the
+	 * iomap_dio_ops end_io callback is invoked, this function cannot
+	 * obtain the exact number of unwritten extents via dwc, unlike the
+	 * buffered path function ocfs2_dio_end_io_write(). Consequently, the
+	 * algorithm here may overestimate the actual number of unwritten
+	 * extents; however, this only incurs additional allocator overhead and
+	 * does not compromise the correctness of the results.
+	 */
+	extents_to_split = DIV_ROUND_UP(bytes, 1 << osb->s_clustersize_bits);
+	ret = ocfs2_lock_allocators(inode, &et, 0, extents_to_split * 2,
+				    &data_ac, &meta_ac);
+	if (ret) {
+		mlog_errno(ret);
+		goto unlock;
+	}
+
+	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
+
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
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto commit;
+			}
+		}
+		ret = ocfs2_assure_trans_credits(handle, credits);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto commit;
+		}
+
+		ret = ocfs2_map_blocks(inode, &map, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto commit;
+		}
+		if (map.len == 0)
+			goto commit;
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
+				goto commit;
+			}
+		}
+		curr_lblk += map.len;
+		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+			batch = 0;
+		}
+	}
+
+	if (end > i_size_read(inode)) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
+		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+commit:
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
+
+unlock:
+	up_write(&oi->ip_alloc_sem);
+
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
+	/*
+	 * The orphan entry is removed by ocfs2_file_write_iter(), by the writer
+	 * that added it. Other dios on this inode may complete here while it
+	 * is still in flight, so they must not touch it.
+	 */
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+
+out:
+	ocfs2_run_deallocs(osb, &dealloc);
+	return ret;
+}
+
+/* See the comments from ocfs2_iomap_dio_end_io_r_pr(). */
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
+	/* bounced back to buffered I/O, leave the rw_lock held */
+	if (size == 0 && error == 0)
+		return 0;
+
+	if (size && error == 0 &&
+	    ((flags & IOMAP_DIO_UNWRITTEN) ||
+	     (offset + size > i_size_read(inode)))) {
+		ret = ocfs2_iomap_dio_end_io_write(inode, offset, size);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	ocfs2_rw_unlock(inode, level);
+
+	return ret ? ret : error;
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
 /*
  * Direct I/O completion. Like the old ocfs2_dio_end_io(), we use the rw_lock
  * DLM lock to protect io on one node from truncation on another, and drop it
@@ -2612,38 +2990,40 @@ const struct iomap_ops ocfs2_iomap_ops = {
  * including on the buffered-fallback (-ENOTBLK) path, so the rw_lock taken in
  * ocfs2_file_{read,write}_iter() is released exactly once.
  */
-static int ocfs2_iomap_dio_end_io(struct kiocb *iocb, ssize_t size, int error,
-				  int level)
+static int ocfs2_iomap_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
+					int error, unsigned int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 
+	if (error)
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+
 	/*
-	 * When iomap_dio_complete() calls us with size==0 and error==0, it
-	 * means the mapping bounced back to buffered I/O. In that case leave
-	 * the rw_lock ocfs2_file_{read,write}_iter() keeps it for the buffered
-	 * retry and releases it in its own cleanup path.
+	 * iomap_dio_complete() calls us even when no I/O was issued because the
+	 * mapping bounced us back to buffered I/O (reported as size == 0 and
+	 * error == 0). In that case leave the rw_lock held so
+	 * ocfs2_file_{read,write}_iter() keeps it for the buffered retry and
+	 * releases it in its own cleanup path.
 	 */
 	if (size == 0 && error == 0)
 		return 0;
 
-	ocfs2_rw_unlock(inode, level);
+	ocfs2_rw_unlock(inode, 0);
+
 	return error;
 }
 
-static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
-				int error, unsigned int flags)
-{
-	if (error)
-		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
-				 (long long)size, error);
-
-	error = ocfs2_iomap_dio_end_io(iocb, size, error, 0);
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr = {
+	.end_io = ocfs2_iomap_dio_end_io_w_pr,
+};
 
-	return error;
-}
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex = {
+	.end_io = ocfs2_iomap_dio_end_io_w_ex,
+};
 
 const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
-	.end_io = ocfs2_dio_end_io_r_pr,
+	.end_io = ocfs2_iomap_dio_end_io_r_pr,
 };
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 2fe3b39e02f7..3bfce26ac3ab 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -11,6 +11,8 @@
 
 extern const struct iomap_ops ocfs2_iomap_ops;
 extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
 
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
@@ -46,6 +48,7 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
+int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count);
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags);
 /* all ocfs2_dio_end_io()'s fault */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a62cb68f246b..f92172673d87 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -48,6 +48,7 @@
 #include "quota.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "namei.h"
 
 #include "buffer_head_io.h"
 
@@ -2403,6 +2404,8 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 				struct inode *inode)
 {
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
 	/*
 	 * Fallback to buffered I/O if we see an inode without
 	 * extents.
@@ -2410,9 +2413,43 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return false;
 
+	/* Fallback to buffered I/O if we do not support append dio. */
+	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
+	    !ocfs2_supports_append_dio(osb))
+		return false;
+
 	return true;
 }
 
+/*
+ * Remove the inode from the orphan dir after an appending direct write.
+ * Only the writer that added the inode (under i_rwsem) may remove it;
+ */
+static int ocfs2_dio_del_orphan(struct inode *inode)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di;
+	int ret;
+
+	ret = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	if (di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)) {
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
+
+	ocfs2_inode_unlock(inode, 1);
+	brelse(di_bh);
+	return ret;
+}
+
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
@@ -2430,6 +2467,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
+	int dio_flags = 0;
+	int orphaned = 0;
 
 	if (trace_ocfs2_file_write_iter_enabled()) {
 		struct dentry *dentry = file->f_path.dentry;
@@ -2455,8 +2494,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
-	ocfs2_iocb_init_rw_locked(iocb);
-
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2512,6 +2549,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 		goto out;
 	}
 
+	ret = kiocb_modified(iocb);
+	if (ret < 0)
+		goto out;
+
 	if (direct_io && !is_sync_kiocb(iocb) &&
 	    ocfs2_is_io_unaligned(inode, count, iocb->ki_pos)) {
 		/*
@@ -2520,26 +2561,79 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
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
+			orphaned = 1;
+			dio_flags = IOMAP_DIO_FORCE_WAIT;
+		}
 
-	written = __generic_file_write_iter(iocb, from);
-	/* buffered aio wouldn't have proper lock coverage today */
-	BUG_ON(written == -EIOCBQUEUED && !direct_io);
+		ret = ocfs2_dio_zero_eof(inode, iocb->ki_pos, count);
+		if (ret < 0)
+			goto out;
 
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
+		const struct iomap_dio_ops *dops = rw_level ?
+			&ocfs2_iomap_dio_ops_w_ex : &ocfs2_iomap_dio_ops_w_pr;
+		struct iomap_dio *dio;
+
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
+
+		/*
+		 * __iomap_dio_rw() returns -ENOTBLK when it could not invalidate
+		 * the page cache for the DIO range (e.g. racing buffered/mmap
+		 * I/O on the same file, as exercised by generic/095). Fall back
+		 * to a buffered write for the remaining data, the same way
+		 * ext4/xfs do, instead of leaking -ENOTBLK to userspace.
+		 */
+		if (written == -ENOTBLK)
+			written = 0;
+		if (written == 0 && iov_iter_count(from)) {
+			direct_write_fallback(iocb, from, ret,
+					generic_perform_write(iocb, from));
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
 
@@ -2564,6 +2658,13 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	}
 
 out:
+	/*
+	 * IOMAP_DIO_FORCE_WAIT made the dio complete synchronously, so its
+	 * end_io has already updated i_size.
+	 */
+	if (orphaned)
+		ocfs2_dio_del_orphan(inode);
+
 	if (saved_ki_complete)
 		xchg(&iocb->ki_complete, saved_ki_complete);
 
-- 
2.55.0

