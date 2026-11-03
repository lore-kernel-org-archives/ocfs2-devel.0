Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709825;
	b=W46UPkAmcAeJtfRCR7JEessVVfR0EPgmevfxYQjxjgSBDfUKO5YoBSmu8leZIpLQvMhF
	 apME028yLz/9ZcHRfRLFuY/Q/jHqr3R0JYYMbY0IWw5oNJaekXMlsleZegF1cmiLd8hrg
	 2SFaIX71+jdjb9dVNVSlKXsOgsSeas9qphMeNCx7FP642XWASVhJNGas8PfBks1exc4sx
	 vlvC61vhozEqMm8EuTyXGTQ0Ec1jcKgCt2TDchaNI9LUTRJKPHFfiMT4uFCfJqXl7fs6N
	 EuAfSEnUg8JdgwgF9nX1Ic/DZCx8A+w8KvyTtuFhuefBRrhM22JiSgacl7FSLAwcqlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SWnX1igkMTS7GU1K3Sy0dRFiPhq8aDmKMhsp2kLzPjo=;
	b=DOSqmBuFeER+n9GMxDKTbCsFbW9ciKTVHjNc0AxS4irjhSUczzKDLw7wZv85LuVSVzmv
	 YB/d5+1z/XD4FZDM5VZQdauAQYyYV6t7Gds+pT94W/VOFXkV+XlUto5wb2X8HNhkvpCIy
	 344wUKRvwgXTa4TYUwY9Z/tQy4hknWg3icbToaTFm7TmhO8FTql5ymmIhKIzOT/LkyxrO
	 +PLDpqgmqhZpu36gvl7ALHJdRG5Jc5h+NB2+994sAIp91SEmATFTeaItAl8/+cn/bBnB4
	 ThKQ5ix3VFxYWHErWE3SoLRFvDaFdSUtFpTi7cFetxFL3SrQO/pBJNQcBj6EOlDelRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LZjce+kZ;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C82606D801
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 12:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5C82606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LZjce+kZ
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1f80b7bf6so7170095e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 04:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793709822; x=1794314622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SWnX1igkMTS7GU1K3Sy0dRFiPhq8aDmKMhsp2kLzPjo=;
        b=LZjce+kZ4tw58KhpZuxbR5aCSA86YKU4ujhdqJ6hdYzFFR79nd2NCR6zH24Ler2dyl
         jLXCaL6SNKgVtw3IlO1l7OiiAVHEx/a5O/XZtgNtwyQc51KmFX0225fxEJ7IIDe4c5F9
         9DTKnxUIWgHTK1oneVf2OeD2uNxzCZesIL7RTqZjwnnLh5tenuZH3sCRQdOd5x48GO4J
         leym+lq9BTOusCpcWffDZNDxncldT8H6DxNyvPcqBcMqmtloJbgfm18GEujfxEa5v6Ai
         yOzAVXy+2ZHVJgNZQM3d9fBliriQcb9LM8SAIsygXn35p9soXnw79Kgkf1nmcjzGV8Ze
         S2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709822; x=1794314622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SWnX1igkMTS7GU1K3Sy0dRFiPhq8aDmKMhsp2kLzPjo=;
        b=QqEFDexaQ01YKVkYdCta7JBPxOHZQeYCL4kxKxRnLFralqIHH4Nz1FnciEpqtq4Bpl
         lVUNtzAobxjooRZ/mZcdqEGO1mT5OE4mFzbA2AOQ6BhKIRTRD9uICcQP3P1sl5j1GoMR
         jvNCLyBT5bHdavB6ORJwLz4oCOqgMi4tbZRCjFexR4DPyzYcq7PiaAkE4KaDwgFsvUfV
         bbtNN8nwceTjPazCyrMFanwAHvJrYwvexM2idMGIOyOycxHrVvDbiX2Guh9LI8lq5Hhd
         q0LjhcxikXeDgniGdO8j4JD2nETbDjOa8PUHrkgNurKF+j+6uQ5ctpqmBwimWV8RcIZj
         OXZw==
X-Forwarded-Encrypted: i=1; AKwUvByE/D/7zGPBTa+c51tubm6RY0aGW+6ilR4Y0FMnojQ6T4zHW0bLBekeYlf3OeWV7pXGPK06XFNBVgnF9Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z/CXSZJzuXMliKIf/z0q/s6jAR1krbosTjDMKK9hKp9bPQb3uuK
	/wih1k8vJ+6VWk5J6Gh3g6r8YOGOnBARlgaavrqjqeqoQUokeGWwQLXAD1N5INkTTEQ=
X-Gm-Gg: AYBFou2/JChpxCTv/mZAFnWhdEZLNZQZTlZRfI5MzSDNpvLWqRVwplOtIClsJVt/ZO1
	Vu5czRb9H6r/sUIFmKAt0DldhYqKgc+lePpjsfa6p9iCbNW5riyKRsG3VnmDqLqDTyhGTy80+EV
	pvhdYfw4BuWHnHmqRUaBQUwVLFsYePfngC4bLJJneMkX4mVB3DQ0HXL/RwSa7hsqwZXhWJk4GhE
	X0RbSkb3/WzUpfKbVJMHDVHEFoMzcGEHQsXtvFvB0otJiMK2M8hWRFbqwdDYj3DbyS5qwc2njK7
	8GJq0j+zSeZWBwnGhvEPyG50+PHtW9iceXNpY0iDYD5YmmMcT/Tf5bOjQVcjLdxkepn8cSzhNu0
	enkqoKQboGXrRvibt5lLp3T65mkISfEPJ8I0Vkf6+lpaSBk11wI8xnW1ib5P3JeOQ5V6Kx5TB9r
	4cZNOUxjb/HbAwANwiK0e8kaSzg4UpQ6JjV7n6KMAX9RQOdkp2xXc+IYzb2OwY/mLCtkFcYk7fw
	sM5U/h9wJnZaZVn0+j6dw2/Gmcg/biAKeGCC6fIOKrjcYYsIvYwiSHPetaswlJ1OL2Fl1JmJD9e
	Ya1rYD4uW4PhyWILEksA7ehnntBx7kowYtTg2H5MZy5tS4S1ZIlw2v59HnVYmwhx
X-Received: by 2002:a05:600c:1c06:b0:4a1:e015:6441 with SMTP id 5b1f17b1804b1-4ac12194311mr360009115e9.0.1793709822036;
        Tue, 03 Nov 2026 04:43:42 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c8460acsm4365014a91.7.2026.11.03.04.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:43:40 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 3/4] ocfs2: switch dio write path from buffer_head to iomap
Date: Tue,  3 Nov 2026 20:43:07 +0800
Message-ID: <20261103124310.21143-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103124310.21143-1-heming.zhao@suse.com>
References: <20261103124310.21143-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.c  | 442 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/aops.h  |   1 +
 fs/ocfs2/file.c  | 137 +++++++++++++--
 fs/ocfs2/ocfs2.h |   2 +
 4 files changed, 545 insertions(+), 37 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index da53abe59ea0..6f8890873b86 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -206,6 +206,19 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
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
@@ -2343,6 +2356,160 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
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
+	map->flags |= OCFS2_MAP_DEFER_COMPLETION;
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
@@ -2549,6 +2716,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ocfs2_map_block map;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	u8 blkbits = inode->i_blkbits;
+	unsigned int orig_mlen;
 
 	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
@@ -2560,9 +2728,32 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
+				if ((!(flags & IOMAP_ATOMIC) && map.len > 0) ||
+				   ((flags & IOMAP_ATOMIC) && map.len >= orig_mlen)) {
+					goto out;
+				}
+			}
+			map.len = orig_mlen;
+		}
+		ret = ocfs2_dio_wr_map_blocks(inode, &map, 1);
 	} else {
 		down_read(&oi->ip_alloc_sem);
 		ret = ocfs2_map_blocks(inode, &map, 0);
@@ -2572,6 +2763,7 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 
+out:
 	/*
 	 * Before returning to iomap, let's ensure the allocated mapping
 	 * covers the entire requested length for atomic writes.
@@ -2612,6 +2804,216 @@ const struct iomap_ops ocfs2_iomap_ops = {
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
+	if (size && ((flags & IOMAP_DIO_UNWRITTEN) ||
+		    (offset + size > i_size_read(inode)))) {
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
@@ -2619,38 +3021,40 @@ const struct iomap_ops ocfs2_iomap_ops = {
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
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0ad4f08eb3e4..83ad96e21fd0 100644
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
@@ -2385,9 +2388,43 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -2405,6 +2442,8 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 			i_size_read(inode) ? 1 : 0);
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
+	int dio_flags = 0;
+	int orphaned = 0;
 
 	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2424,8 +2463,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	} else
 		inode_lock(inode);
 
-	ocfs2_iocb_init_rw_locked(iocb);
-
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2474,6 +2511,10 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	}
 	count = ret;
 
+	ret = kiocb_modified(iocb);
+	if (ret < 0)
+		goto out;
+
 	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count, !nowait);
 	if (ret < 0) {
 		if (ret != -EAGAIN)
@@ -2489,26 +2530,79 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
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
+			iocb->ki_flags &= ~IOCB_DIRECT;
+			written = __generic_file_write_iter(iocb, from);
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
 
@@ -2533,6 +2627,13 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
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
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 58ad6f570536..e36130de2dd8 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -552,6 +552,8 @@ struct ocfs2_map_block {
 
 extern const struct iomap_ops ocfs2_iomap_ops;
 extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
 
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
-- 
2.55.0

