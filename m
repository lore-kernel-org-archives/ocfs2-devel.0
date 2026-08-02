Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F82D3998BE
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Aug 2026 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785667093; cv=none; b=dtvVoEJ8soxXuyRCCVuG0+oPZ1RbHP2mDGc3w+k6WAXQ3nFBKAH0WxJj+SHPdHvjxmzAvOJb6g/5wNzKHvHFGZHvctRwFF9zPNuCDAyMvy/HU/PSvGsKsRHqb6NjLmUwHWWFYr7Iucjr7JisdAc/KB+jE/XH8WJNofUCE9/Ecx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785667093; c=relaxed/simple;
	bh=OmarSLLLzz+Griltnoejz7lQt9tQ0KBXBgbwCZNzOjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZF60Rfq5Mx8+N+rsJ1YpAHRBFk4dGBvXyGkgu9ST6Q22ghK2IMyzZUrdgOdMQ7tJIRMFeCfs3WO8Umbj2pI/aOS7VK+Cb3GCQ21NLnhxmNnUYbfaeKpEPtGXbF/G7IKD5mMGJXtwcDmJqOrqdO4zBbe9O+dxC49RMmH6AWgrboA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DnHldIFU; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DnHldIFU"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-698ae9da373so373725a12.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 03:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785667086; x=1786271886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2KU83/Eja/mJ1pbh3up2jl+P50P3KVRjygzt1nTwLgA=;
        b=DnHldIFUvbXKuDkpQrX7oTBDSpvRYd4PPUGh36NDQiWfIGtH+3lSO3KKINyqgvLxg8
         kIr9h8KR8os/Xzz7eiZIUERJ3APE8TvjHAgVBdsYCvXuUif0n5BvkHh18eoLRxdsKJSg
         2b7hSKWhJLBgrfK1/r2dee9+AeQ1pGTe7T1WrS2RK6nuxpdBzs0OeEgd8y1MDzWpXYi6
         zCMBh0IXaS4yxm6BZdYVPPxuFlCuk3p2bZigzMwVIl7G7xNuaL0dJaHbMqfevVy0rXXW
         A0ZhnNZiGHrCKJCyopxPYp6jzObRCjho6x1jxbunk7CCFSqjinJfW0FUoGm7KmGxVMyU
         VG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785667086; x=1786271886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2KU83/Eja/mJ1pbh3up2jl+P50P3KVRjygzt1nTwLgA=;
        b=oCnsjhE5O9p+4GHNdbJvtn3NfnyU8m5Wog41/WW3xRGVfkI09lUE/WrmblCwGAOJJK
         WxTLb0aTaUcdjfceCMmfFc0hxZUzwywZ0rABq5TP39s4lohDvJQqjiZ4BgBV6YLAkP8x
         jlWcbYu19Hl5Aeh57evDwWAGODUU0BO2P1fPvKZEM8cgD/2FEYohJwymtBc6eM7bTheb
         EjVzduAI4ySh2e9sjLr2jlxjoXloUEBI7xu6OWuFXXrU96ptziQzZcObwoOODot4dvx9
         N9s3SQi9r7f4cCNZnDRzWb8ijJxmERgJRAvTUrwt2M7d5rdS0rRVvmkRi7tA0U+qm89A
         OspQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGPjXa4V9M8pnf60/O6K0VlhuI5NSn+Nfmd5yfB5Hy03ULCD52vCGvH2bQEsNA6q0yrf3dBOlcKCe2ow==@lists.linux.dev
X-Gm-Message-State: AOJu0YwjU74F/Nh4pe4agUmKXEcz8sluZ80x4h98K0/pouFLAr2HbDVb
	OWpQ0BjkjYtRMPza5Sda/Abb+HwFy/hrXPyjbgtjaIfLDZde8DXSMIh1GatDSUVEQOI=
X-Gm-Gg: AR+sD12QkU9OUS0yZrvqq+4yOTF5XetmyQDbkeaU0QYhkPTo1dT/uvPheRxdbmtEIGn
	9biZCkq9Y8jniWQuMDuhEmlCyUqi5ahppER5ZpagW4kHwusu97BPg6ERcLEZlrTvFi4+HHT6WTn
	fVcfClbsM7U/Ys9uelBZ0msycEhiqTg+RE7YcdXfe3mvf4hn2F6n2d4zDUSUNXSkSQKi80zmhWm
	EwmopYvhNBLiQUeqEXwVOPe909AC1/0dLprra5rw7xBe3NO6jqQM7G2fIn+59MzfQNy9uISvRJZ
	QKmwhiExbl6I0uKBwTKPUsTtvpBD1H9KWNEz2c6PG92nKeimklXKrgn4Xwus78oT1qDIPTgxVa9
	09wJCtAU3JNTgn3ebE3mUKLebFCQnYA42dqZF1V1SWAZ5DC/av+UsSr/7hIjk6yfc/k5QzehSwE
	pyhGVGLrSsOapapDZB4v0r8zj3+DibK8CLcOu8sTSjnbAxkRRumdqjSwmXiFw2owvLDExQQg==
X-Received: by 2002:a05:6402:548b:b0:68e:4c0:f59a with SMTP id 4fb4d7f45d1cf-6a0a7ce2288mr2535135a12.2.1785667086225;
        Sun, 02 Aug 2026 03:38:06 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5a91asm24971235ad.21.2026.08.02.03.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:38:05 -0700 (PDT)
Date: Sun, 2 Aug 2026 18:37:58 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/4] ocfs2: remove legacy blockdev direct-IO path
 APIs
Message-ID: <am8KRsslaFdwD_YC@p15>
References: <20260727061802.18485-1-heming.zhao@suse.com>
 <20260727061802.18485-5-heming.zhao@suse.com>
 <22d4f8e8-e179-45a9-99ae-f858960087c9@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d4f8e8-e179-45a9-99ae-f858960087c9@linux.alibaba.com>

On Tue, Jul 28, 2026 at 02:11:14PM +0800, Joseph Qi wrote:
> 
> 
> On 7/27/26 2:18 PM, Heming Zhao wrote:
> > Since the DIO path already migrated from buffer_head mode (by using
> > a_ops->direct_IO method) to iomap mode, the VFS no longer sets
> > FMODE_CAN_ODIRECT automatically, so ocfs2_file_open() sets it
> > explicitly.
> > 
> > The now-unused blockdev get_block/end_io machinery
> > (ocfs2_lock_get_block(), ocfs2_dio_wr_get_block(), ocfs2_dio_end_io(),
> > ocfs2_dio_end_io_write(), and the ocfs2_dio_write_ctxt helpers) is removed,
> > and OCFS2_FS Kconfig removes LEGACY_DIRECT_IO.
> > 
> > Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/Kconfig |   1 -
> >  fs/ocfs2/aops.c  | 411 -----------------------------------------------
> >  fs/ocfs2/aops.h  |  35 +---
> >  fs/ocfs2/file.c  |  13 +-
> >  fs/ocfs2/ocfs2.h |   5 -
> >  5 files changed, 16 insertions(+), 449 deletions(-)
> > 
> > diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> > index bf1678a5eb01..74bc2008ef0b 100644
> > --- a/fs/ocfs2/Kconfig
> > +++ b/fs/ocfs2/Kconfig
> > @@ -9,7 +9,6 @@ config OCFS2_FS
> >  	select QUOTA_TREE
> >  	select FS_IOMAP
> >  	select FS_POSIX_ACL
> > -	select LEGACY_DIRECT_IO
> >  	help
> >  	  OCFS2 is a general purpose extent based shared disk cluster file
> >  	  system with many similarities to ext3. It supports 64 bit inode
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 9a079436c9c0..3e4a7043074a 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -114,19 +114,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
> >  	return err;
> >  }
> >  
> > -static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
> > -		    struct buffer_head *bh_result, int create)
> > -{
> > -	int ret = 0;
> > -	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > -
> > -	down_read(&oi->ip_alloc_sem);
> > -	ret = ocfs2_get_block(inode, iblock, bh_result, create);
> > -	up_read(&oi->ip_alloc_sem);
> > -
> > -	return ret;
> > -}
> > -
> >  int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> >  		    int flags)
> >  {
> > @@ -2170,204 +2157,6 @@ static int ocfs2_write_end(const struct kiocb *iocb,
> >  	return ret;
> >  }
> >  
> > -struct ocfs2_dio_write_ctxt {
> > -	struct list_head	dw_zero_list;
> > -	unsigned		dw_zero_count;
> > -	int			dw_orphaned;
> > -	pid_t			dw_writer_pid;
> > -};
> > -
> > -static struct ocfs2_dio_write_ctxt *
> > -ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
> > -{
> > -	struct ocfs2_dio_write_ctxt *dwc = NULL;
> > -
> > -	if (bh->b_private)
> > -		return bh->b_private;
> > -
> > -	dwc = kmalloc_obj(struct ocfs2_dio_write_ctxt, GFP_NOFS);
> > -	if (dwc == NULL)
> > -		return NULL;
> > -	INIT_LIST_HEAD(&dwc->dw_zero_list);
> > -	dwc->dw_zero_count = 0;
> > -	dwc->dw_orphaned = 0;
> > -	dwc->dw_writer_pid = task_pid_nr(current);
> > -	bh->b_private = dwc;
> > -	*alloc = 1;
> > -
> > -	return dwc;
> > -}
> > -
> > -static void ocfs2_dio_free_write_ctx(struct inode *inode,
> > -				     struct ocfs2_dio_write_ctxt *dwc)
> > -{
> > -	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
> > -	kfree(dwc);
> > -}
> > -
> > -/*
> > - * TODO: Make this into a generic get_blocks function.
> > - *
> > - * From do_direct_io in direct-io.c:
> > - *  "So what we do is to permit the ->get_blocks function to populate
> > - *   bh.b_size with the size of IO which is permitted at this offset and
> > - *   this i_blkbits."
> > - *
> > - * This function is called directly from get_more_blocks in direct-io.c.
> > - *
> > - * called like this: dio->get_blocks(dio->inode, fs_startblk,
> > - * 					fs_count, map_bh, dio->rw == WRITE);
> > - */
> > -static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
> > -			       struct buffer_head *bh_result, int create)
> > -{
> > -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > -	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > -	struct ocfs2_write_ctxt *wc;
> > -	struct ocfs2_write_cluster_desc *desc = NULL;
> > -	struct ocfs2_dio_write_ctxt *dwc = NULL;
> > -	struct buffer_head *di_bh = NULL;
> > -	u64 p_blkno = 0;
> > -	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
> > -	loff_t pos = iblock << i_blkbits;
> > -	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
> > -	unsigned len, total_len = bh_result->b_size;
> > -	int ret = 0, first_get_block = 0;
> > -
> > -	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
> > -	len = min(total_len, len);
> > -
> > -	/*
> > -	 * bh_result->b_size is count in get_more_blocks according to write
> > -	 * "pos" and "end", we need map twice to return different buffer state:
> > -	 * 1. area in file size, not set NEW;
> > -	 * 2. area out file size, set  NEW.
> > -	 *
> > -	 *		   iblock    endblk
> > -	 * |--------|---------|---------|---------
> > -	 * |<-------area in file------->|
> > -	 */
> > -
> > -	if ((iblock <= endblk) &&
> > -	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
> > -		len = (endblk - iblock + 1) << i_blkbits;
> > -
> > -	mlog(0, "get block of %llu at %llu:%u req %u\n",
> > -			inode->i_ino, pos, len, total_len);
> > -
> > -	/*
> > -	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
> > -	 * we may need to add it to orphan dir. So can not fall to fast path
> > -	 * while file size will be changed.
> > -	 */
> > -	if (pos + total_len <= i_size_read(inode)) {
> > -
> > -		/* This is the fast path for re-write. */
> > -		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
> > -		if (buffer_mapped(bh_result) &&
> > -		    !buffer_new(bh_result) &&
> > -		    ret == 0)
> > -			goto out;
> > -
> > -		/* Clear state set by ocfs2_get_block. */
> > -		bh_result->b_state = 0;
> > -	}
> > -
> > -	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
> > -	if (unlikely(dwc == NULL)) {
> > -		ret = -ENOMEM;
> > -		mlog_errno(ret);
> > -		goto out;
> > -	}
> > -
> > -	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
> > -	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
> > -	    !dwc->dw_orphaned) {
> > -		/*
> > -		 * when we are going to alloc extents beyond file size, add the
> > -		 * inode to orphan dir, so we can recall those spaces when
> > -		 * system crashed during write.
> > -		 */
> > -		ret = ocfs2_add_inode_to_orphan(osb, inode);
> > -		if (ret < 0) {
> > -			mlog_errno(ret);
> > -			goto out;
> > -		}
> > -		dwc->dw_orphaned = 1;
> > -	}
> > -
> > -	ret = ocfs2_inode_lock(inode, &di_bh, 1);
> > -	if (ret) {
> > -		mlog_errno(ret);
> > -		goto out;
> > -	}
> > -
> > -	down_write(&oi->ip_alloc_sem);
> > -
> > -	if (first_get_block) {
> > -		if (ocfs2_sparse_alloc(osb))
> > -			ret = ocfs2_zero_tail(inode, di_bh, pos);
> > -		else
> > -			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
> > -							   total_len, NULL);
> > -		if (ret < 0) {
> > -			mlog_errno(ret);
> > -			goto unlock;
> > -		}
> > -	}
> > -
> > -	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
> > -				       OCFS2_WRITE_DIRECT, NULL,
> > -				       (void **)&wc, di_bh, NULL);
> > -	if (ret) {
> > -		mlog_errno(ret);
> > -		goto unlock;
> > -	}
> > -
> > -	desc = &wc->w_desc[0];
> > -
> > -	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
> > -	BUG_ON(p_blkno == 0);
> > -	p_blkno += iblock & (u64)(ocfs2_clusters_to_blocks(inode->i_sb, 1) - 1);
> > -
> > -	map_bh(bh_result, inode->i_sb, p_blkno);
> > -	bh_result->b_size = len;
> > -	if (desc->c_needs_zero)
> > -		set_buffer_new(bh_result);
> > -
> > -	if (iblock > endblk)
> > -		set_buffer_new(bh_result);
> > -
> > -	/* May sleep in end_io. It should not happen in a irq context. So defer
> > -	 * it to dio work queue. */
> > -	set_buffer_defer_completion(bh_result);
> > -
> > -	if (!list_empty(&wc->w_unwritten_list)) {
> > -		struct ocfs2_unwritten_extent *ue = NULL;
> > -
> > -		ue = list_first_entry(&wc->w_unwritten_list,
> > -				      struct ocfs2_unwritten_extent,
> > -				      ue_node);
> > -		BUG_ON(ue->ue_cpos != desc->c_cpos);
> > -		/* The physical address may be 0, fill it. */
> > -		ue->ue_phys = desc->c_phys;
> > -
> > -		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
> > -		dwc->dw_zero_count += wc->w_unwritten_count;
> > -	}
> > -
> > -	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
> > -	BUG_ON(ret != len);
> > -	ret = 0;
> > -unlock:
> > -	up_write(&oi->ip_alloc_sem);
> > -	ocfs2_inode_unlock(inode, 1);
> > -	brelse(di_bh);
> > -out:
> > -	return ret;
> > -}
> > -
> > -/* copy from ocfs2_dio_wr_get_block */
> >  static int ocfs2_dio_wr_map_blocks(struct inode *inode,
> >  			       struct ocfs2_map_block *map, int create)
> >  {
> > @@ -2509,205 +2298,6 @@ static int ocfs2_dio_wr_map_blocks(struct inode *inode,
> >  	return ret;
> >  }
> >  
> > -static int ocfs2_dio_end_io_write(struct inode *inode,
> > -				  struct ocfs2_dio_write_ctxt *dwc,
> > -				  loff_t offset,
> > -				  ssize_t bytes)
> > -{
> > -	struct ocfs2_cached_dealloc_ctxt dealloc;
> > -	struct ocfs2_extent_tree et;
> > -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > -	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> > -	struct ocfs2_unwritten_extent *ue = NULL;
> > -	struct buffer_head *di_bh = NULL;
> > -	struct ocfs2_dinode *di;
> > -	struct ocfs2_alloc_context *data_ac = NULL;
> > -	struct ocfs2_alloc_context *meta_ac = NULL;
> > -	handle_t *handle = NULL;
> > -	loff_t end = offset + bytes;
> > -	int ret = 0, credits = 0, batch = 0;
> > -
> > -	ocfs2_init_dealloc_ctxt(&dealloc);
> > -
> > -	/* We do clear unwritten, delete orphan, change i_size here. If neither
> > -	 * of these happen, we can skip all this. */
> > -	if (list_empty(&dwc->dw_zero_list) &&
> > -	    end <= i_size_read(inode) &&
> > -	    !dwc->dw_orphaned)
> > -		goto out;
> > -
> > -	ret = ocfs2_inode_lock(inode, &di_bh, 1);
> > -	if (ret < 0) {
> > -		mlog_errno(ret);
> > -		goto out;
> > -	}
> > -
> > -	down_write(&oi->ip_alloc_sem);
> > -	di = (struct ocfs2_dinode *)di_bh->b_data;
> > -
> > -	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> > -
> > -	/* Attach dealloc with extent tree in case that we may reuse extents
> > -	 * which are already unlinked from current extent tree due to extent
> > -	 * rotation and merging.
> > -	 */
> > -	et.et_dealloc = &dealloc;
> > -
> > -	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
> > -				    &data_ac, &meta_ac);
> > -	if (ret) {
> > -		mlog_errno(ret);
> > -		goto unlock;
> > -	}
> > -
> > -	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> > -
> > -	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> > -		if (!handle) {
> > -			handle = ocfs2_start_trans(osb, credits);
> > -			if (IS_ERR(handle)) {
> > -				ret = PTR_ERR(handle);
> > -				mlog_errno(ret);
> > -				goto unlock;
> > -			}
> > -			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> > -					OCFS2_JOURNAL_ACCESS_WRITE);
> > -			if (ret) {
> > -				mlog_errno(ret);
> > -				goto commit;
> > -			}
> > -		}
> > -		ret = ocfs2_assure_trans_credits(handle, credits);
> > -		if (ret < 0) {
> > -			mlog_errno(ret);
> > -			goto commit;
> > -		}
> > -		ret = ocfs2_mark_extent_written(inode, &et, handle,
> > -						ue->ue_cpos, 1,
> > -						ue->ue_phys,
> > -						meta_ac, &dealloc);
> > -		if (ret < 0) {
> > -			mlog_errno(ret);
> > -			goto commit;
> > -		}
> > -
> > -		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> > -			ocfs2_commit_trans(osb, handle);
> > -			handle = NULL;
> > -			batch = 0;
> > -		}
> > -	}
> > -
> > -	if (end > i_size_read(inode)) {
> > -		if (!handle) {
> > -			handle = ocfs2_start_trans(osb, credits);
> > -			if (IS_ERR(handle)) {
> > -				ret = PTR_ERR(handle);
> > -				mlog_errno(ret);
> > -				goto unlock;
> > -			}
> > -		}
> > -		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
> > -		if (ret < 0)
> > -			mlog_errno(ret);
> > -	}
> > -
> > -commit:
> > -	if (handle)
> > -		ocfs2_commit_trans(osb, handle);
> > -unlock:
> > -	up_write(&oi->ip_alloc_sem);
> > -
> > -	if (data_ac) {
> > -		ocfs2_free_alloc_context(data_ac);
> > -		data_ac = NULL;
> > -	}
> > -	if (meta_ac) {
> > -		ocfs2_free_alloc_context(meta_ac);
> > -		meta_ac = NULL;
> > -	}
> > -
> > -	/* everything looks good, let's start the cleanup */
> > -	if (!ret && dwc->dw_orphaned) {
> > -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> > -
> > -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
> > -		if (ret < 0)
> > -			mlog_errno(ret);
> > -	}
> > -	ocfs2_inode_unlock(inode, 1);
> > -	brelse(di_bh);
> > -out:
> > -	ocfs2_run_deallocs(osb, &dealloc);
> > -	ocfs2_dio_free_write_ctx(inode, dwc);
> > -
> > -	return ret;
> > -}
> > -
> > -/*
> > - * ocfs2_dio_end_io is called by the dio core when a dio is finished.  We're
> > - * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
> > - * to protect io on one node from truncation on another.
> > - */
> > -static int ocfs2_dio_end_io(struct kiocb *iocb,
> > -			    loff_t offset,
> > -			    ssize_t bytes,
> > -			    void *private)
> > -{
> > -	struct inode *inode = file_inode(iocb->ki_filp);
> > -	int level;
> > -	int ret = 0;
> > -
> > -	/* this io's submitter should not have unlocked this before we could */
> > -	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
> > -
> > -	if (bytes <= 0)
> > -		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
> > -				 (long long)bytes);
> > -	if (private) {
> > -		if (bytes > 0)
> > -			ret = ocfs2_dio_end_io_write(inode, private, offset,
> > -						     bytes);
> > -		else
> > -			ocfs2_dio_free_write_ctx(inode, private);
> > -	}
> > -
> > -	ocfs2_iocb_clear_rw_locked(iocb);
> > -
> > -	level = ocfs2_iocb_rw_locked_level(iocb);
> > -	ocfs2_rw_unlock(inode, level);
> > -	return ret;
> > -}
> > -
> > -static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> > -{
> > -	struct file *file = iocb->ki_filp;
> > -	struct inode *inode = file->f_mapping->host;
> > -	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > -	get_block_t *get_block;
> > -
> > -	/*
> > -	 * Fallback to buffered I/O if we see an inode without
> > -	 * extents.
> > -	 */
> > -	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> > -		return 0;
> > -
> > -	/* Fallback to buffered I/O if we do not support append dio. */
> > -	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
> > -	    !ocfs2_supports_append_dio(osb))
> > -		return 0;
> > -
> > -	if (iov_iter_rw(iter) == READ)
> > -		get_block = ocfs2_lock_get_block;
> > -	else
> > -		get_block = ocfs2_dio_wr_get_block;
> > -
> > -	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
> > -				    iter, get_block,
> > -				    ocfs2_dio_end_io, 0);
> > -}
> > -
> >  static int ocfs2_iomap_alloc(struct inode *inode, struct ocfs2_map_block *map,
> >  			    unsigned int flags)
> >  {
> > @@ -3045,7 +2635,6 @@ const struct address_space_operations ocfs2_aops = {
> >  	.write_begin		= ocfs2_write_begin,
> >  	.write_end		= ocfs2_write_end,
> >  	.bmap			= ocfs2_bmap,
> > -	.direct_IO		= ocfs2_direct_IO,
> >  	.invalidate_folio	= block_invalidate_folio,
> >  	.release_folio		= ocfs2_release_folio,
> >  	.migrate_folio		= buffer_migrate_folio,
> > diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
> > index 8dd6edd7c1a1..484b25d749d7 100644
> > --- a/fs/ocfs2/aops.h
> > +++ b/fs/ocfs2/aops.h
> > @@ -7,6 +7,12 @@
> >  #define OCFS2_AOPS_H
> >  
> >  #include <linux/fs.h>
> > +#include <linux/iomap.h>
> > +
> > +extern const struct iomap_ops ocfs2_iomap_ops;
> > +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
> > +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
> > +extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
> >  
> >  int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
> >  			  struct inode *inode, unsigned int from,
> > @@ -44,34 +50,5 @@ int ocfs2_get_block(struct inode *inode, sector_t iblock,
> >  		    struct buffer_head *bh_result, int create);
> >  int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
> >  		    int flags);
> > -/* all ocfs2_dio_end_io()'s fault */
> > -#define ocfs2_iocb_is_rw_locked(iocb) \
> > -	test_bit(0, (unsigned long *)&iocb->private)
> > -static inline void ocfs2_iocb_set_rw_locked(struct kiocb *iocb, int level)
> > -{
> > -	set_bit(0, (unsigned long *)&iocb->private);
> > -	if (level)
> > -		set_bit(1, (unsigned long *)&iocb->private);
> > -	else
> > -		clear_bit(1, (unsigned long *)&iocb->private);
> > -}
> > -
> > -/*
> > - * Using a named enum representing lock types in terms of #N bit stored in
> > - * iocb->private, which is going to be used for communication between
> > - * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
> > - */
> > -enum ocfs2_iocb_lock_bits {
> > -	OCFS2_IOCB_RW_LOCK = 0,
> > -	OCFS2_IOCB_RW_LOCK_LEVEL,
> > -	OCFS2_IOCB_NUM_LOCKS
> > -};
> > -
> > -#define ocfs2_iocb_init_rw_locked(iocb) \
> > -	(iocb->private = NULL)
> > -#define ocfs2_iocb_clear_rw_locked(iocb) \
> > -	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
> > -#define ocfs2_iocb_rw_locked_level(iocb) \
> > -	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
> >  
> >  #endif /* OCFS2_FILE_H */
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 2d78f2863acf..a54f92633582 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -92,6 +92,13 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
> >  			      file->f_path.dentry->d_name.len,
> >  			      file->f_path.dentry->d_name.name, mode);
> >  
> > +	/*
> > +	 * Direct I/O is served through iomap_dio_rw() from
> > +	 * ocfs2_file_{read,write}_iter() rather than an a_ops->direct_IO
> > +	 * method, so advertise O_DIRECT capability explicitly here.
> > +	 */
> > +	file->f_mode |= FMODE_CAN_ODIRECT;
> 
> This unconditionally set may include inodes with inline data.
> Though it will handle the fallback in ocfs2_should_use_dio(), it looks odd
> and slightly misleading to userspace. 

Good catch, will change it in the next version.

Thanks,
Heming
> 
> > +
> >  	if (file->f_mode & FMODE_WRITE) {
> >  		status = dquot_initialize(inode);
> >  		if (status)
> > @@ -1171,9 +1178,9 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> >  	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
> >  	if (size_change) {
> >  		/*
> > -		 * Here we should wait dio to finish before inode lock
> > -		 * to avoid a deadlock between ocfs2_setattr() and
> > -		 * ocfs2_dio_end_io_write()
> > +		 * Here we should wait for in-flight direct I/O to finish
> > +		 * before taking the inode lock, to avoid a deadlock between
> > +		 * ocfs2_setattr() and direct I/O completion.
> >  		 */
> >  		inode_dio_wait(inode);
> >  
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index b228b10b5e71..095f7ae5dded 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -549,11 +549,6 @@ struct ocfs2_map_block {
> >  	unsigned int flags;
> >  };
> >  
> > -extern const struct iomap_ops ocfs2_iomap_ops;
> > -extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
> > -extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_pr;
> > -extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_w_ex;
> > -
> >  /* Flags used by ocfs2_map_blocks() */
> >  #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
> >  
> 
