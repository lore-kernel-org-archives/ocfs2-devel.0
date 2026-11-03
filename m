Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714201;
	b=HIxCldJToB95wKmts3R/6W/MioVte+jR3tQM5VKmPOWnICPo3JuncLN0tHfFsWVqSmbS
	 GLHxddZX+OtVEQK5b3g/ia9jpEzZd4x2PPBJahq9D1+mdaHIN2cFeJgSjmkCp6Gtt2CWp
	 mfKNy1riENS1BB8EdY3VJ/OzjXPbXLlt+2ZgxnZH/EQw6z8bH7WfkPcaL4pELjzumgZnO
	 pDf4aC76CwNtHTmKHgMcF+F0iokYf1HWIooCwsTKDqBOdLntAdRLs3T7PMbxTyWVVKKdc
	 wlSg+TrCVkLIfsPCarAChtckVWBYQzCMBz6B7PUyB+E6NikDrVFDrDXcuhnEGxsxT6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGzkI5LQV2cveyibHy3iay7MlNr3ZOauBOYiZpySomg=;
	b=ohJCC0LCUx91j4IWN385aArzb8/y4s8krjZfdvMoFSFpSK9tn+EmJOqPhwYEF56rdi0E
	 6i6nBiQQJs4PNxm4EH3CdxpLez1Pst6gviO3omTXWGX7ZNm9KW7mURmPJZn7AqL31kyhv
	 M13sjw1i1cxIN5ZHsD8jszDTME665OmTdNECsEIri9XkNapIoxnI9DeIH6ESKYxvkt7T2
	 AFrhmkwSDpdX+UkrnWs6iiv6/9e3zYxfbNjLT6uL4DxzPEs43GtFezmOfQlrWPs8bUXk/
	 np1pQEitPOadLMZJS3wT+v5Zo4ADMeYyxGzlLcihmCxFEqp7gy/Iox8nQU16zXVT9uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CJcvbdg4;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86676606EE8B
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 13:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86676606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CJcvbdg4
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a599e9110eso21767835e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 05:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793714199; x=1794318999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WGzkI5LQV2cveyibHy3iay7MlNr3ZOauBOYiZpySomg=;
        b=CJcvbdg4wYb+/Y9xeWV5p3OLCt0rPF7DZQlS1nMcqJxAfHEXvvmsiSkLyUSKw9IdaB
         tUbZvOg/6QSiJNrI8wRVabkHqElXEQja+WV4plXeo8c4QvUMWaN06pdFgJhN8iummOSU
         IOCRHUQduQq9CjREBZehorZiXbpnI707W2GEzm+DI8WjUkHBqswQoPKdRoz89mp6M2CQ
         1Mg9/UcIDdSHNrMeVHkJtMobUUFcUephob7DHmXt8L5h8W2a+i7DtB5QhCvkIRxOKAwm
         jIkTnZuCK9mPgopvDLlKpz2ubj4YI1oGxUPO4tURnToTOAmbsJmm9fjfqh7f3dVR8g+a
         oIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714199; x=1794318999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WGzkI5LQV2cveyibHy3iay7MlNr3ZOauBOYiZpySomg=;
        b=x+FvED+UjhTs2K2m5GBPjQjPmwTc9jxMpmiPYL6fhB5JaDxZgYoaXrRXB86hIkzPVo
         LDlN1v7ZfNd53jnhO90acqlUmzPH/KLGyLw+m80MLiohScvgqHA34yGRFmrOrNsnuRy/
         IKY2uH5Q0YuGl9jTY23tcKuhM1+aD36RM/GzVUlXvjmhIgKLKVrrS2e9DvlcZuMkywfQ
         BLtR8OsvlWqFedUe8IV8Rk7YlbedHqs+DmzwB3KWqJs0XrBvCzLdQaNW3Tmmji/GN5IU
         8mZpd2X3kw3nLcarujVVvV4IjsFOjXk8Y9qlcrFWF0jLwMfbBr8iWhP9o7rzj1bsMUTN
         y+zA==
X-Forwarded-Encrypted: i=1; AKwUvBwfeHt6gaHVXU+mwfqsIBjm+ODvWAX9ufEtLazGEZYjBZItNB9TN9mAWZUewvLD4Ss6FsAEDgcl+YDf9Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z9YIIPGs2SpUKoLfk9lAYgK38zt7P4iqZubAAORKXpea3/8YS7H
	VNycrJe9f+ELxC0WJEiYNXsYMNNNBRQ3qzTTVflMygvLJVqCjpBqvH7dcmp4C/80eRg=
X-Gm-Gg: AYBFou3t+vaMjnIHGFSULlWa6yQLG2bSUWbTzb8SrDsAXFFy9d/sTbbaGqz1cJytAR/
	WhoLLgFCaZqnA2Lu13TbDCGEQ11iH4DfV0cZjTOmq6dp6WBaM63AhdBcVV8akRdNR9SI7DAylg5
	eeIQOUDURm9Zt67rmZni8HORvldTDPTQX+swI2qAldZflVgm86P4LbQ959BC46DBdY7SFLOTzQQ
	NdDdZiOYdY8UdW5+Tem+wzXpxn/zpFsGUkQtBE+xxE9ymO2O9bHAf4Liimu3Bjs6p8sfAtLSY0D
	frzOKXNVVowKL5VVazMT8Cdbjm91I4nUtW+WMI72mUuskz1JB3qYx/RMSIIYGBSGwcx+DCBltfJ
	ehHO2C3U3fK4pD7drERdJI2uQxOGDdbdNmfn8wp2PQmHyvLq6H0BDN1enN88eLeHXl4sMwRelul
	KicQiI7AazBvQZUj9eJ2tqWxYQH6yQSTIICu/3n2XqMpTWsrIN6jQ27JsEl5eRjOQAIaH/eBOZi
	sL7I3LqbLLu3QY2zPhvKRaoilCrdfsiwvCCXnq5go7gpNaPzs3l5wCxwch7t5QDmBHuuRrS8Qc7
	QiRTb28KOyNa+AqjeGneAIuELHLKd6bkBdtoCIVEicHnZZiAu4W1K0EXuGRlN7MA
X-Received: by 2002:a05:600c:34c5:b0:4a0:13d8:cd0c with SMTP id 5b1f17b1804b1-4ac16acdfe0mr295195175e9.2.1793714198772;
        Tue, 03 Nov 2026 05:56:38 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1a16sm39629747c88.1.2026.11.03.05.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:56:37 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 4/4] ocfs2: remove legacy blockdev direct-IO path APIs
Date: Tue,  3 Nov 2026 21:56:03 +0800
Message-ID: <20261103135605.22943-5-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103135605.22943-1-heming.zhao@suse.com>
References: <20261103135605.22943-1-heming.zhao@suse.com>
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

Since the DIO path already migrated from buffer_head mode (by
using a_ops->direct_IO method) to iomap mode, the VFS no longer
sets FMODE_CAN_ODIRECT automatically, so ocfs2_file_open() sets
it explicitly.

The now-unused blockdev get_block/end_io machinery
(ocfs2_lock_get_block(), ocfs2_dio_wr_get_block(), ocfs2_dio_end_io(),
ocfs2_dio_end_io_write(), and the ocfs2_dio_write_ctxt helpers)
is removed, and OCFS2_FS Kconfig removes LEGACY_DIRECT_IO.

Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/Kconfig |   1 -
 fs/ocfs2/aops.c  | 416 +----------------------------------------------
 fs/ocfs2/aops.h  |  35 +---
 fs/ocfs2/file.c  |  14 +-
 fs/ocfs2/ocfs2.h |   5 -
 5 files changed, 19 insertions(+), 452 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index bf1678a5eb01..74bc2008ef0b 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -9,7 +9,6 @@ config OCFS2_FS
 	select QUOTA_TREE
 	select FS_IOMAP
 	select FS_POSIX_ACL
-	select LEGACY_DIRECT_IO
 	help
 	  OCFS2 is a general purpose extent based shared disk cluster file
 	  system with many similarities to ext3. It supports 64 bit inode
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6f8890873b86..834fd401a883 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -114,19 +114,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 	return err;
 }
 
-static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
-		    struct buffer_head *bh_result, int create)
-{
-	int ret = 0;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-
-	down_read(&oi->ip_alloc_sem);
-	ret = ocfs2_get_block(inode, iblock, bh_result, create);
-	up_read(&oi->ip_alloc_sem);
-
-	return ret;
-}
-
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags)
 {
@@ -2159,203 +2146,6 @@ static int ocfs2_write_end(const struct kiocb *iocb,
 	return ret;
 }
 
-struct ocfs2_dio_write_ctxt {
-	struct list_head	dw_zero_list;
-	unsigned		dw_zero_count;
-	int			dw_orphaned;
-	pid_t			dw_writer_pid;
-};
-
-static struct ocfs2_dio_write_ctxt *
-ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
-{
-	struct ocfs2_dio_write_ctxt *dwc = NULL;
-
-	if (bh->b_private)
-		return bh->b_private;
-
-	dwc = kmalloc_obj(struct ocfs2_dio_write_ctxt, GFP_NOFS);
-	if (dwc == NULL)
-		return NULL;
-	INIT_LIST_HEAD(&dwc->dw_zero_list);
-	dwc->dw_zero_count = 0;
-	dwc->dw_orphaned = 0;
-	dwc->dw_writer_pid = task_pid_nr(current);
-	bh->b_private = dwc;
-	*alloc = 1;
-
-	return dwc;
-}
-
-static void ocfs2_dio_free_write_ctx(struct inode *inode,
-				     struct ocfs2_dio_write_ctxt *dwc)
-{
-	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
-	kfree(dwc);
-}
-
-/*
- * TODO: Make this into a generic get_blocks function.
- *
- * From do_direct_io in direct-io.c:
- *  "So what we do is to permit the ->get_blocks function to populate
- *   bh.b_size with the size of IO which is permitted at this offset and
- *   this i_blkbits."
- *
- * This function is called directly from get_more_blocks in direct-io.c.
- *
- * called like this: dio->get_blocks(dio->inode, fs_startblk,
- * 					fs_count, map_bh, dio->rw == WRITE);
- */
-static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
-			       struct buffer_head *bh_result, int create)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_write_ctxt *wc;
-	struct ocfs2_write_cluster_desc *desc = NULL;
-	struct ocfs2_dio_write_ctxt *dwc = NULL;
-	struct buffer_head *di_bh = NULL;
-	u64 p_blkno;
-	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
-	loff_t pos = iblock << i_blkbits;
-	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
-	unsigned len, total_len = bh_result->b_size;
-	int ret = 0, first_get_block = 0;
-
-	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
-	len = min(total_len, len);
-
-	/*
-	 * bh_result->b_size is count in get_more_blocks according to write
-	 * "pos" and "end", we need map twice to return different buffer state:
-	 * 1. area in file size, not set NEW;
-	 * 2. area out file size, set  NEW.
-	 *
-	 *		   iblock    endblk
-	 * |--------|---------|---------|---------
-	 * |<-------area in file------->|
-	 */
-
-	if ((iblock <= endblk) &&
-	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
-		len = (endblk - iblock + 1) << i_blkbits;
-
-	mlog(0, "get block of %llu at %llu:%u req %u\n",
-			inode->i_ino, pos, len, total_len);
-
-	/*
-	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
-	 * we may need to add it to orphan dir. So can not fall to fast path
-	 * while file size will be changed.
-	 */
-	if (pos + total_len <= i_size_read(inode)) {
-
-		/* This is the fast path for re-write. */
-		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
-		if (buffer_mapped(bh_result) &&
-		    !buffer_new(bh_result) &&
-		    ret == 0)
-			goto out;
-
-		/* Clear state set by ocfs2_get_block. */
-		bh_result->b_state = 0;
-	}
-
-	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
-	if (unlikely(dwc == NULL)) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
-	}
-
-	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
-	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
-	    !dwc->dw_orphaned) {
-		/*
-		 * when we are going to alloc extents beyond file size, add the
-		 * inode to orphan dir, so we can recall those spaces when
-		 * system crashed during write.
-		 */
-		ret = ocfs2_add_inode_to_orphan(osb, inode);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto out;
-		}
-		dwc->dw_orphaned = 1;
-	}
-
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	down_write(&oi->ip_alloc_sem);
-
-	if (first_get_block) {
-		if (ocfs2_sparse_alloc(osb))
-			ret = ocfs2_zero_tail(inode, di_bh, pos);
-		else
-			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
-							   total_len, NULL);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto unlock;
-		}
-	}
-
-	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
-				       OCFS2_WRITE_DIRECT, NULL,
-				       (void **)&wc, di_bh, NULL);
-	if (ret) {
-		mlog_errno(ret);
-		goto unlock;
-	}
-
-	desc = &wc->w_desc[0];
-
-	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
-	BUG_ON(p_blkno == 0);
-	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
-
-	map_bh(bh_result, inode->i_sb, p_blkno);
-	bh_result->b_size = len;
-	if (desc->c_needs_zero)
-		set_buffer_new(bh_result);
-
-	if (iblock > endblk)
-		set_buffer_new(bh_result);
-
-	/* May sleep in end_io. It should not happen in a irq context. So defer
-	 * it to dio work queue. */
-	set_buffer_defer_completion(bh_result);
-
-	if (!list_empty(&wc->w_unwritten_list)) {
-		struct ocfs2_unwritten_extent *ue = NULL;
-
-		ue = list_first_entry(&wc->w_unwritten_list,
-				      struct ocfs2_unwritten_extent,
-				      ue_node);
-		BUG_ON(ue->ue_cpos != desc->c_cpos);
-		/* The physical address may be 0, fill it. */
-		ue->ue_phys = desc->c_phys;
-
-		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count += wc->w_unwritten_count;
-	}
-
-	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
-	BUG_ON(ret != len);
-	ret = 0;
-unlock:
-	up_write(&oi->ip_alloc_sem);
-	ocfs2_inode_unlock(inode, 1);
-	brelse(di_bh);
-out:
-	return ret;
-}
-
 /*
  * Prepare the area between i_size and a direct write that starts or ends
  * beyond it.  Must be called once per dio, before any io is issued, with
@@ -2391,7 +2181,6 @@ int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count)
 	return ret;
 }
 
-/* copy from ocfs2_dio_wr_get_block */
 static int ocfs2_dio_wr_map_blocks(struct inode *inode,
 				   struct ocfs2_map_block *map, int create)
 {
@@ -2510,205 +2299,6 @@ static int ocfs2_dio_wr_map_blocks(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_dio_end_io_write(struct inode *inode,
-				  struct ocfs2_dio_write_ctxt *dwc,
-				  loff_t offset,
-				  ssize_t bytes)
-{
-	struct ocfs2_cached_dealloc_ctxt dealloc;
-	struct ocfs2_extent_tree et;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	struct ocfs2_unwritten_extent *ue = NULL;
-	struct buffer_head *di_bh = NULL;
-	struct ocfs2_dinode *di;
-	struct ocfs2_alloc_context *data_ac = NULL;
-	struct ocfs2_alloc_context *meta_ac = NULL;
-	handle_t *handle = NULL;
-	loff_t end = offset + bytes;
-	int ret = 0, credits = 0, batch = 0;
-
-	ocfs2_init_dealloc_ctxt(&dealloc);
-
-	/* We do clear unwritten, delete orphan, change i_size here. If neither
-	 * of these happen, we can skip all this. */
-	if (list_empty(&dwc->dw_zero_list) &&
-	    end <= i_size_read(inode) &&
-	    !dwc->dw_orphaned)
-		goto out;
-
-	ret = ocfs2_inode_lock(inode, &di_bh, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
-
-	down_write(&oi->ip_alloc_sem);
-	di = (struct ocfs2_dinode *)di_bh->b_data;
-
-	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
-
-	/* Attach dealloc with extent tree in case that we may reuse extents
-	 * which are already unlinked from current extent tree due to extent
-	 * rotation and merging.
-	 */
-	et.et_dealloc = &dealloc;
-
-	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
-				    &data_ac, &meta_ac);
-	if (ret) {
-		mlog_errno(ret);
-		goto unlock;
-	}
-
-	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
-
-	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
-		if (!handle) {
-			handle = ocfs2_start_trans(osb, credits);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
-				mlog_errno(ret);
-				goto unlock;
-			}
-			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-					OCFS2_JOURNAL_ACCESS_WRITE);
-			if (ret) {
-				mlog_errno(ret);
-				goto commit;
-			}
-		}
-		ret = ocfs2_assure_trans_credits(handle, credits);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto commit;
-		}
-		ret = ocfs2_mark_extent_written(inode, &et, handle,
-						ue->ue_cpos, 1,
-						ue->ue_phys,
-						meta_ac, &dealloc);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto commit;
-		}
-
-		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
-			ocfs2_commit_trans(osb, handle);
-			handle = NULL;
-			batch = 0;
-		}
-	}
-
-	if (end > i_size_read(inode)) {
-		if (!handle) {
-			handle = ocfs2_start_trans(osb, credits);
-			if (IS_ERR(handle)) {
-				ret = PTR_ERR(handle);
-				mlog_errno(ret);
-				goto unlock;
-			}
-		}
-		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-
-commit:
-	if (handle)
-		ocfs2_commit_trans(osb, handle);
-unlock:
-	up_write(&oi->ip_alloc_sem);
-
-	if (data_ac) {
-		ocfs2_free_alloc_context(data_ac);
-		data_ac = NULL;
-	}
-	if (meta_ac) {
-		ocfs2_free_alloc_context(meta_ac);
-		meta_ac = NULL;
-	}
-
-	/* everything looks good, let's start the cleanup */
-	if (!ret && dwc->dw_orphaned) {
-		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
-
-		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-	ocfs2_inode_unlock(inode, 1);
-	brelse(di_bh);
-out:
-	ocfs2_run_deallocs(osb, &dealloc);
-	ocfs2_dio_free_write_ctx(inode, dwc);
-
-	return ret;
-}
-
-/*
- * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
- * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
- * to protect io on one node from truncation on another.
- */
-static int ocfs2_dio_end_io(struct kiocb *iocb,
-			    loff_t offset,
-			    ssize_t bytes,
-			    void *private)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	int level;
-	int ret = 0;
-
-	/* this io's submitter should not have unlocked this before we could */
-	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
-
-	if (bytes <= 0)
-		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
-				 (long long)bytes);
-	if (private) {
-		if (bytes > 0)
-			ret = ocfs2_dio_end_io_write(inode, private, offset,
-						     bytes);
-		else
-			ocfs2_dio_free_write_ctx(inode, private);
-	}
-
-	ocfs2_iocb_clear_rw_locked(iocb);
-
-	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
-	return ret;
-}
-
-static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	get_block_t *get_block;
-
-	/*
-	 * Fallback to buffered I/O if we see an inode without
-	 * extents.
-	 */
-	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
-		return 0;
-
-	/* Fallback to buffered I/O if we do not support append dio. */
-	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
-	    !ocfs2_supports_append_dio(osb))
-		return 0;
-
-	if (iov_iter_rw(iter) == READ)
-		get_block = ocfs2_lock_get_block;
-	else
-		get_block = ocfs2_dio_wr_get_block;
-
-	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-				    iter, get_block,
-				    ocfs2_dio_end_io, 0);
-}
-
 static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
@@ -2804,7 +2394,6 @@ const struct iomap_ops ocfs2_iomap_ops = {
 	.iomap_begin	= ocfs2_iomap_begin,
 };
 
-/* copy from ocfs2_dio_end_io_write */
 static int ocfs2_iomap_dio_end_io_write(struct inode *inode,
 				  loff_t offset,
 				  ssize_t bytes)
@@ -2852,8 +2441,8 @@ static int ocfs2_iomap_dio_end_io_write(struct inode *inode,
 	 * single-cluster cases. Because kiocb->private is cleared before the
 	 * iomap_dio_ops end_io callback is invoked, this function cannot
 	 * obtain the exact number of unwritten extents via dwc, unlike the
-	 * buffered path function ocfs2_dio_end_io_write(). Consequently, the
-	 * algorithm here may overestimate the actual number of unwritten
+	 * legacy buffered path function ocfs2_dio_end_io_write(). Consequently,
+	 * the algorithm here may overestimate the actual number of unwritten
 	 * extents; however, this only incurs additional allocator overhead and
 	 * does not compromise the correctness of the results.
 	 */
@@ -3064,7 +2653,6 @@ const struct address_space_operations ocfs2_aops = {
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
-	.direct_IO		= ocfs2_direct_IO,
 	.invalidate_folio	= block_invalidate_folio,
 	.release_folio		= ocfs2_release_folio,
 	.migrate_folio		= buffer_migrate_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index b46ba4df1428..11100421d924 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -7,6 +7,12 @@
 #define OCFS2_AOPS_H
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
+
+extern const struct iomap_ops ocfs2_iomap_ops;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
 
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
@@ -45,34 +51,5 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
 int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count);
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags);
-/* all ocfs2_dio_end_io()'s fault */
-#define ocfs2_iocb_is_rw_locked(iocb) \
-	test_bit(0, (unsigned long *)&iocb->private)
-static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
-{
-	set_bit(0, (unsigned long *)&iocb->private);
-	if (level)
-		set_bit(1, (unsigned long *)&iocb->private);
-	else
-		clear_bit(1, (unsigned long *)&iocb->private);
-}
-
-/*
- * Using a named enum representing lock types in terms of #N bit stored in
- * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
- */
-enum ocfs2_iocb_lock_bits {
-	OCFS2_IOCB_RW_LOCK = 0,
-	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_NUM_LOCKS
-};
-
-#define ocfs2_iocb_init_rw_locked(iocb) \
-	(iocb->private = NULL)
-#define ocfs2_iocb_clear_rw_locked(iocb) \
-	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
-#define ocfs2_iocb_rw_locked_level(iocb) \
-	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
 
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d5ad96bd010a..9b98def091d1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -136,6 +136,14 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 
 	file->f_mode |= FMODE_NOWAIT;
 
+	/*
+	 * Direct I/O is served through iomap_dio_rw() from
+	 * ocfs2_file_{read,write}_iter() rather than an a_ops->direct_IO
+	 * method, so advertise O_DIRECT capability explicitly here.
+	 */
+	file->f_mode |= FMODE_CAN_ODIRECT;
+
+
 leave:
 	return status;
 }
@@ -1196,9 +1204,9 @@ int ocfs2_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
 	if (size_change) {
 		/*
-		 * Here we should wait dio to finish before inode lock
-		 * to avoid a deadlock between ocfs2_setattr() and
-		 * ocfs2_dio_end_io_write()
+		 * Here we should wait for in-flight direct I/O to finish
+		 * before taking the inode lock, to avoid a deadlock between
+		 * ocfs2_setattr() and direct I/O completion.
 		 */
 		inode_dio_wait(inode);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ef494a758011..7c75def1ef4c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -555,11 +555,6 @@ struct ocfs2_map_block {
 	unsigned int flags;
 };
 
-extern const struct iomap_ops ocfs2_iomap_ops;
-extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
-extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
-extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
-
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
 
-- 
2.55.0

