Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795412608;
	b=JpUBy0mVTeXcQjerYh062wD3g6avkfaFzcX5cT/XpPd4JMvdho5m2ihOd+T6nP/dV/yd
	 0aBP3DRDWzqVdBThx0fDwTm9Piyl2H9fE9j/AfEg0QboU6pnGuD17Z9j3LerRvmYnVhc7
	 Uz+NHXx+G6dOV7fs+D5Scp57b7Eev+79cIbO5KkVnXQkvkUmk34+dVmrFPJ9P4AQVX4l/
	 5gQgS8qasie3kvEUuECBAMTFD4MLURwoSsgeS3DmLc9lyp4U+xdLwE7yB81paI9kxKPoy
	 YedipEu9WCponjDJXHOJHo4+7EwwZQqELAATrG4NRB/k9wUFTX1dXBY2cAW0hvJ9U/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795412608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9ldF5W7iWndLRJ3if+mEoSRjvBnqW0Qf1G0p6VNLPFw=;
	b=arGIJN/Db4WRLhJ7yXy9+GCmGSzC0dejf5reEKB0CCFER3ez/lOLHLcB68/yGAgyH+q4
	 +8GdbOVWnR0v4JGrimSovSbbJ03oGc6fl25CTZE6fiowIWE4BHRAmBK9j7m9hN0G6uswd
	 V5PvWsIeTT/YM0Vm44YaFxeF4dlacUyPT8KjIkSgnLqfo1NP5HypvKCrXNtfq6uYX460H
	 oBlOhMi8VXrj+uZ0iUFq2PMrfmnfG1p6cpdfppp7Ee1R28MoZSoi4QWpVdtx9hezUKgZN
	 neR490lRnbRd5a5HmfD3gcNUpKWqcnZ50e5STm46A57AZr3Id4DYC3HwrVY5CidkCpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YZXzIGF2;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32A606A31F
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 05:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB32A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=YZXzIGF2
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b54c019db4so406207a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Nov 2026 21:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795412605; x=1796017405; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ldF5W7iWndLRJ3if+mEoSRjvBnqW0Qf1G0p6VNLPFw=;
        b=YZXzIGF2FKvfq2CUouW4xKtN5uju3hlMYajMWWJHW+sImk/uQXFY7G2O8NEDbBYz4m
         e4IB1mWEjDMkMKM4DhiyiztIfBdnkohLbgaHXgEF9j0AB4/j3NVc4oW7NpQAc2Mr9Dni
         iULyivDYMKX2ONnXEhpLj4EWWfv5hh8wXOEJADpSWqqboAHEDUtB9KpUYfucd+/vEUYn
         7caSL1JKZ3cvfutD1GZ/D305xmFcIPC+DOMwWQ9JvKL7zuJVOW1EUSV6kqDF4K4QiEhM
         wLJEY+2uqj6hdaWWwt7Xyl9+VxEE9AkoRcGpb+GvI++IGFdOSs81V/3W32xXy7EwFAup
         nRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412605; x=1796017405;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ldF5W7iWndLRJ3if+mEoSRjvBnqW0Qf1G0p6VNLPFw=;
        b=mSU59blcMOa9x+kiY+eVG73a4MPo5Qr7QzqgmxeRuVQsHeYSNoqu6z1PBF6wKIN6ff
         jg9D2HKtzguoy6mbjMVURMhgQsHYySM8YQqy7291CeABZb+IV4PzKSlO5LQQpI5deZ9p
         JpB1nPjm+tZDZTtOoybCWd8aMEf8Ydxky8bdJN0Yq1dK6RvinAvIJuqxnyo1VKvn1jPw
         Nt55teSYuqvovtFHJwT+XnrtDRjKujC3nuL9HMK54sAD2zCaXQkiGULfqqNu3t8UgQkW
         3ncatcE9DOjKrMe3Rn928jxXVk1w+emcoaYEavJVXqTfPOuJ/gPnLVAxHim5I5Rh6n8A
         Y2PA==
X-Forwarded-Encrypted: i=1; AL+hErG5JcgwESzGqyBMh4Pxq+dn+j6yH7EYxuks8pjkKFbgiqMT/9G13g5tQzXCOyFbP5Tf1ttx5FREOs7dDg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8+qgK39WSsdgLFz5jIivLAyUkdzrmsN5sm6exWnaq1ed13APeI
	ZLN9QN1pX2/fkfbSRNhxA4nQZcQGeXlvoTitNWWGKOYzFJrk5N9xG9kknrtvYPTNjQI=
X-Gm-Gg: AZFdTZex9B0EOlTX9NZWB93yj36UBT6y+je9jMr+JGNBPBTmd1FEGertcQG7SMj6LXW
	o7MI4y6yNrqrO1PkE9nQrPUL5+d4tj4xb7KljHZCtTTEx9K5AJiniCjlGc5msFob56A4c8vFIoU
	a40KW+AaJ8PR9TM9wLYK5jLv+PahMxIzcGeHSH405A8/PSgiYXqlV4bMMGgUEZLdCp4O/kOH99R
	J+RfXT4+MaVmqYCpFlD6U7gKnkpGJwpjfMp0NWwsDICfH3ZhI+TDKT/F5SLBH5YLUbplIG0tH9g
	wRHrgOF1UIw0IIiG4FNnjqDaAySXdhgAuY3R8+VdFMxDa91tC8I5aNDcZdw0aur9macq56LPtLf
	wSwbkrsmA58+RO2nZ1UoivthzbbKw4k2K9OxfdYtqfa2Xk43VhKNRMFpAPk5S5SPnZ3WvbMMvzF
	gJQXJ2zAYA/WJ8Sy5FI9H1vWB1JhZuudNad3lSWJocUjeD/chiXVkuQaFOUgG0aoex9RkNI1Slu
	AwYG7ZgJ8yK4Hd/jWqNu82oTSXKCc/HVoxfdYvJ1rBXbLMOziQ/7VMEm/SJYuV1/rvmAYlkYOVG
	MSt80ua0cdvQpKmIbBN7u67rZx50sk2eCFc=
X-Received: by 2002:a17:906:3e41:b0:c46:ae89:cd3c with SMTP id a640c23a62f3a-c513a3971a7mr739977566b.1.1795412604518;
        Sun, 22 Nov 2026 21:43:24 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b0f482bdsm331942a91.14.2026.11.22.21.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 21:43:23 -0800 (PST)
Message-ID: <40eb0271-b7a3-4f67-a907-6827e4de0cba@suse.com>
Date: Mon, 23 Nov 2026 13:43:18 +0800
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v9 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, hch@lst.de,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261120060014.12087-1-heming.zhao@suse.com>
 <20261120060014.12087-4-heming.zhao@suse.com>
 <acec7763-5ce1-4480-8687-36ead15d8024@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <acec7763-5ce1-4480-8687-36ead15d8024@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/26 22:48, Joseph Qi wrote:
> 
> 
> On 11/20/26 2:00 PM, Heming Zhao wrote:
>> Converts OCFS2's DIO write path from the legacy buffer_head
>> infrastructure to the modern iomap framework.
>>
>> The buffer_head based ocfs2_dio_wr_get_block() is replaced by
>> ocfs2_dio_wr_map_blocks(). Instead of one cluster per call, it now
>> hands iomap a mapping of as many clusters as can be described by a
>> single struct iomap: up to 16MB, stopped at the first cluster that is
>> not of the same kind as the first one (hole, unwritten, written).
>>
>> Implement ocfs2_dio_end_io() and ocfs2_dio_end_io_write() to handle IO
>> completion. They convert UNWRITTEN extents, updates inode size (EOF).
>>
>> In the buffer_head path, ocfs2_dio_wr_get_block() stores dwc in
>> bh->b_private, enabling it to detect the first call for an IO chunk and
>> invoke ocfs2_add_inode_to_orphan() to protect the extent allocation.
>> However, iomap doesn't provide a similar private field. Therefore, moves
>> ocfs2_add_inode_to_orphan() from ocfs2_dio_wr_map_blocks(the buffer_head
>> counterpart to ocfs2_dio_wr_get_block()) to ocfs2_file_write_iter().
>>
>> It is also impossible t pass The dwc to iomap_dio_ops.end_io, the iomap
>> ->end_io callback cannot effectively distinguish between I/Os initiated
>> by different threads concurrently. For example, when multiple DIO write
>> threads operate on the same inode concurrently, the end_io callback
>> without the dwc context may incorrectly delete an orphan inode created
>> by another thread, leading to a crash. The fix is to move the orphan
>> inode deletion from end_io into ocfs2_file_write_iter(). In
>> ocfs2_file_write_iter(), inode_lock() serializes the write threads,
>> and IOMAP_DIO_FORCE_WAIT ensures that the function only returns after
>> the bio completes. This guarantees that i_size has already been
>> updated when ocfs2_dio_del_orphan() is called.
>>
>> iomap calls ->iomap_begin() once per mapping but ->end_io() once per io,
>> and the latter only gets the kiocb, so the kiocb is used as the identity
>> of the io: ocfs2_file_write_iter() passes it in iomap_iter.private,
>> ocfs2_iomap_next() forwards it to ocfs2_dio_wr_map_blocks(), and each
>> unwritten record stores it in ue_owner with the cluster range it covers.
>>
>> Doesn't like ocfs2_dio_wr_get_block(), move the zero operations from
>> ocfs2_dio_wr_map_blocks() to ocfs2_file_write_iter(). If do the zeroing
>> in ocfs2_dio_wr_map_blocks() would zero blocks that earlier mappings of
>> this same dio have already written, as i_size is only updated at dio
>> completion. this will makes xfstests generic/538 failure.
>>
>> Assisted-by: LLM
>> Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/Kconfig      |    1 -
>>   fs/ocfs2/aops.c       | 1596 +++++++++++++++++++++++++++++++----------
>>   fs/ocfs2/aops.h       |   36 +-
>>   fs/ocfs2/extent_map.c |   34 +-
>>   fs/ocfs2/extent_map.h |    3 +
>>   fs/ocfs2/file.c       |  254 ++++++-
>>   fs/ocfs2/inode.h      |    9 +
>>   fs/ocfs2/mmap.c       |    2 +-
>>   fs/ocfs2/super.c      |    3 +
>>   9 files changed, 1477 insertions(+), 461 deletions(-)
>>
>> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
>> index bf1678a5eb01..74bc2008ef0b 100644
>> --- a/fs/ocfs2/Kconfig
>> +++ b/fs/ocfs2/Kconfig
>> @@ -9,7 +9,6 @@ config OCFS2_FS
>>   	select QUOTA_TREE
>>   	select FS_IOMAP
>>   	select FS_POSIX_ACL
>> -	select LEGACY_DIRECT_IO
>>   	help
>>   	  OCFS2 is a general purpose extent based shared disk cluster file
>>   	  system with many similarities to ext3. It supports 64 bit inode
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 21cdc5c29331..a6a2a1d11cd0 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -114,19 +114,6 @@ static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>>   	return err;
>>   }
>>   
>> -static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
>> -		    struct buffer_head *bh_result, int create)
>> -{
>> -	int ret = 0;
>> -	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> -
>> -	down_read(&oi->ip_alloc_sem);
>> -	ret = ocfs2_get_block(inode, iblock, bh_result, create);
>> -	up_read(&oi->ip_alloc_sem);
>> -
>> -	return ret;
>> -}
>> -
>>   static int ocfs2_lock_map_blocks(struct inode *inode,
>>   				 struct ocfs2_map_block *map, int flags)
>>   {
>> @@ -756,11 +743,26 @@ int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
>>   
>>   #define OCFS2_MAX_CLUSTERS_PER_PAGE	(PAGE_SIZE / OCFS2_MIN_CLUSTERSIZE)
>>   
>> +/*
>> + * Describe a range of clusters whose extents are (or were just allocated as)
>> + * unwritten, and which a direct write is going to convert once its io has
>> + * finished (see ocfs2_dio_end_io_write()).
>> + *
>> + * The entry is linked on oi->ip_unwritten_list for as long as the dio is in
>> + * flight, so that buffered writers see the clusters are already taken care of
>> + * and do not zero them under the dio.  iomap gives ->end_io() nothing but the
>> + * kiocb, so ue_owner is how the entries created by ->iomap_begin() are found
>> + * again at end_io time: it is the kiocb which __iomap_dio_rw() was called with.
>> + *
>> + * ue_node is used to chain the entries on a private list: the wc during
>> + * write_begin, a local list in end_io.
>> + */
>>   struct ocfs2_unwritten_extent {
>>   	struct list_head	ue_node;
>>   	struct list_head	ue_ip_node;
>>   	u32			ue_cpos;
>> -	u32			ue_phys;
>> +	u32			ue_clusters;
>> +	void			*ue_owner;
>>   };
>>   
>>   /*
>> @@ -773,9 +775,16 @@ struct ocfs2_write_cluster_desc {
>>   	 * Give this a unique field because c_phys eventually gets
>>   	 * filled.
>>   	 */
>> -	unsigned	c_new;
>> -	unsigned	c_clear_unwritten;
>> -	unsigned	c_needs_zero;
>> +	unsigned int	c_new;
>> +	unsigned int	c_clear_unwritten;
>> +	unsigned int	c_needs_zero;
>> +	/*
>> +	 * Direct write only: this cluster is unwritten and this very dio
>> +	 * (ue_owner) is going to convert it, either because it zeroed it in
>> +	 * this write_begin or because an earlier ->iomap_begin() of the same
>> +	 * dio did.  The mapping has to be reported as unwritten.
>> +	 */
>> +	unsigned int	c_dio_unwritten;
>>   };
>>   
>>   struct ocfs2_write_ctxt {
>> @@ -789,7 +798,13 @@ struct ocfs2_write_ctxt {
>>   	/* Type of caller. Must be one of buffer, mmap, direct.  */
>>   	ocfs2_write_type_t		w_type;
>>   
>> -	struct ocfs2_write_cluster_desc	w_desc[OCFS2_MAX_CLUSTERS_PER_PAGE];
>> +	/*
>> +	 * One descriptor per cluster of the write.  Buffered and mmap writes
>> +	 * never span more than a page, so the inline array is enough for them.
>> +	 * A direct write may span many clusters, w_desc is then allocated.
>> +	 */
>> +	struct ocfs2_write_cluster_desc	*w_desc;
>> +	struct ocfs2_write_cluster_desc	w_desc_inline[OCFS2_MAX_CLUSTERS_PER_PAGE];
>>   
>>   	/*
>>   	 * This is true if page_size > cluster_size.
>> @@ -812,7 +827,8 @@ struct ocfs2_write_ctxt {
>>   	 * zero's.
>>   	 */
>>   	unsigned int			w_num_folios;
>> -	struct folio			*w_folios[OCFS2_MAX_CTXT_PAGES];
>> +	struct folio			**w_folios;
>> +	struct folio			*w_folios_inline[OCFS2_MAX_CTXT_PAGES];
>>   	struct folio			*w_target_folio;
>>   
>>   	/*
>> @@ -839,7 +855,17 @@ struct ocfs2_write_ctxt {
>>   	struct ocfs2_cached_dealloc_ctxt w_dealloc;
>>   
>>   	struct list_head		w_unwritten_list;
>> -	unsigned int			w_unwritten_count;
>> +
>> +	/* Direct write only: the dio which owns the unwritten entries. */
>> +	void				*w_owner;
>> +
>> +	/*
>> +	 * Direct write only: clusters we reserved quota and allocator bits
>> +	 * for, but which could not be allocated in one go (the allocator
>> +	 * returned a shorter contiguous chunk).  The write was shortened, the
>> +	 * caller maps the remainder with its next ->iomap_begin().
>> +	 */
>> +	unsigned int			w_clusters_unused;
>>   };
>>   
>>   void ocfs2_unlock_and_free_folios(struct folio **folios, int num_folios)
>> @@ -883,6 +909,7 @@ static void ocfs2_free_unwritten_list(struct inode *inode,
>>   {
>>   	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>   	struct ocfs2_unwritten_extent *ue = NULL, *tmp = NULL;
>> +	bool freed = false;
>>   
>>   	list_for_each_entry_safe(ue, tmp, head, ue_node) {
>>   		list_del(&ue->ue_node);
>> @@ -890,7 +917,27 @@ static void ocfs2_free_unwritten_list(struct inode *inode,
>>   		list_del(&ue->ue_ip_node);
>>   		spin_unlock(&oi->ip_lock);
>>   		kfree(ue);
>> +		freed = true;
>>   	}
>> +
>> +	/* A direct write may be waiting for these, see ocfs2_dio_wr_map_blocks(). */
>> +	if (freed)
>> +		wake_up_all(&oi->ip_unwritten_wq);
>> +}
>> +
>> +static void ocfs2_release_write_ctxt(struct ocfs2_write_ctxt *wc)
>> +{
>> +	if (wc->w_desc != wc->w_desc_inline)
>> +		kvfree(wc->w_desc);
>> +
>> +	/*
>> +	 * The folios in w_folios array already unlocked and
>> +	 * put by ocfs2_unlock_folios()
>> +	 */
>> +	if (wc->w_folios != wc->w_folios_inline)
>> +		kfree(wc->w_folios);
>> +
>> +	kfree(wc);
>>   }
>>   
>>   static void ocfs2_free_write_ctxt(struct inode *inode,
>> @@ -899,13 +946,13 @@ static void ocfs2_free_write_ctxt(struct inode *inode,
>>   	ocfs2_free_unwritten_list(inode, &wc->w_unwritten_list);
>>   	ocfs2_unlock_folios(wc);
>>   	brelse(wc->w_di_bh);
>> -	kfree(wc);
>> +	ocfs2_release_write_ctxt(wc);
>>   }
>>   
>>   static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>>   				  struct ocfs2_super *osb, loff_t pos,
>>   				  unsigned len, ocfs2_write_type_t type,
>> -				  struct buffer_head *di_bh)
>> +				  struct buffer_head *di_bh, void *owner)
>>   {
>>   	u32 cend;
>>   	struct ocfs2_write_ctxt *wc;
>> @@ -914,10 +961,46 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>>   	if (!wc)
>>   		return -ENOMEM;
>>   
>> +	wc->w_desc = wc->w_desc_inline;
>> +	wc->w_folios = wc->w_folios_inline;
>> +	wc->w_owner = owner;
>>   	wc->w_cpos = pos >> osb->s_clustersize_bits;
>>   	wc->w_first_new_cpos = UINT_MAX;
>>   	cend = (pos + len - 1) >> osb->s_clustersize_bits;
>>   	wc->w_clen = cend - wc->w_cpos + 1;
>> +
>> +	/*
>> +	 * Only a direct write can span more clusters than fit in a page.
>> +	 * It needs the folios of the first and of the last cluster at most,
>> +	 * see ocfs2_grab_folios_for_write().
>> +	 */
>> +	if (wc->w_clen > ARRAY_SIZE(wc->w_desc_inline)) {
>> +		if (WARN_ON_ONCE(type != OCFS2_WRITE_DIRECT)) {
>> +			ocfs2_release_write_ctxt(wc);
>> +			return -EINVAL;
>> +		}
>> +		wc->w_desc = kvcalloc(wc->w_clen, sizeof(*wc->w_desc),
>> +				      GFP_NOFS);
>> +		if (!wc->w_desc) {
>> +			wc->w_desc = wc->w_desc_inline;
>> +			ocfs2_release_write_ctxt(wc);
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	/* ref ocfs2_grab_folios_direct() comments for the logic "2 *" */
>> +	if (type == OCFS2_WRITE_DIRECT &&
>> +	    2 * ocfs2_pages_per_cluster(osb->sb) >
>> +			ARRAY_SIZE(wc->w_folios_inline)) {
>> +		wc->w_folios = kcalloc(2 * ocfs2_pages_per_cluster(osb->sb),
>> +				       sizeof(*wc->w_folios), GFP_NOFS);
>> +		if (!wc->w_folios) {
>> +			wc->w_folios = wc->w_folios_inline;
>> +			ocfs2_release_write_ctxt(wc);
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>>   	get_bh(di_bh);
>>   	wc->w_di_bh = di_bh;
>>   	wc->w_type = type;
>> @@ -1084,7 +1167,85 @@ static int ocfs2_prepare_folio_for_write(struct inode *inode, u64 *p_blkno,
>>   }
>>   
>>   /*
>> - * This function will only grab one clusters worth of pages.
>> + * Grab the folios a direct write has to take care of, w_folios is laid out as
>> + * two windows of one cluster's worth of pages each:
>> + *
>> + *   [0, ppc)    the pages of the first cluster of the write
>> + *   [ppc, 2ppc) the pages of the last cluster of the write
>> + *
>> + * A direct write goes to the disk directly, so the pages inside of the user
>> + * range are not touched and stay NULL. The clusters in the middle of the
>> + * write are covered by the user range entirely and need nothing at all. Only
>> + * the head cluster before the user range and the tail cluster after it can have
>> + * pages which are not going to be overwritten, those must be zeroed through the
>> + * page cache if the cluster is new or unwritten (c_needs_zero).
>> + *
>> + * If the write is made of just one cluster, there is only the first window.
>> + *
>> + * Like for the buffered write, nothing past the end of the file is needed, the
>> + * tail is then cut at max(user range end, i_size).
>> + */
>> +static int ocfs2_grab_folios_direct(struct address_space *mapping,
>> +		struct ocfs2_write_ctxt *wc, loff_t user_pos, unsigned user_len)
>> +{
>> +	struct inode *inode = mapping->host;
>> +	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
>> +	unsigned long target_index = user_pos >> PAGE_SHIFT;
>> +	unsigned long end_index = (user_pos + user_len - 1) >> PAGE_SHIFT;
>> +	loff_t last_byte = max_t(loff_t, user_pos + user_len,
>> +				 i_size_read(inode));
>> +	unsigned long last_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
>> +	unsigned int nr_win = wc->w_clen > 1 ? 2 : 1;
>> +	int ret = 0, win, i;
>> +
>> +	wc->w_num_folios = 0;
>> +
>> +	for (win = 0; win < nr_win; win++) {
>> +		struct ocfs2_write_cluster_desc *desc =
>> +			win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
>> +		unsigned long start;
>> +
>> +		if (!desc->c_needs_zero)
>> +			continue;
>> +
>> +		start = ocfs2_align_clusters_to_page_index(inode->i_sb,
>> +							    desc->c_cpos);
>> +
>> +		for (i = 0; i < ppc; i++) {
>> +			unsigned long index = start + i;
>> +			struct folio *folio;
>> +
>> +			if (index >= last_index)
>> +				break;
>> +
>> +			/* Track the slots in use, for the unlock/commit loops. */
>> +			wc->w_num_folios = max_t(unsigned int, wc->w_num_folios,
>> +						 win * ppc + i + 1);
>> +
>> +			/* The direct io target has no page cache page here. */
>> +			if (index >= target_index && index <= end_index)
>> +				continue;
>> +
>> +			folio = __filemap_get_folio(mapping, index,
>> +					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
>> +					GFP_NOFS);
>> +			if (IS_ERR(folio)) {
>> +				ret = PTR_ERR(folio);
>> +				mlog_errno(ret);
>> +				goto out;
>> +			}
>> +			wc->w_folios[win * ppc + i] = folio;
>> +			folio_wait_stable(folio);
>> +		}
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>> +/*
>> + * This function will only grab one clusters worth of pages, except for a
>> + * direct write which gets the pages around the user range of up to two
>> + * clusters, see ocfs2_grab_folios_direct().
>>    */
>>   static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>>   		struct ocfs2_write_ctxt *wc, u32 cpos, loff_t user_pos,
>> @@ -1095,6 +1256,10 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>>   	struct inode *inode = mapping->host;
>>   	loff_t last_byte;
>>   
>> +	if (wc->w_type == OCFS2_WRITE_DIRECT)
>> +		return ocfs2_grab_folios_direct(mapping, wc, user_pos,
>> +						user_len);
>> +
>>   	target_index = user_pos >> PAGE_SHIFT;
>>   
>>   	/*
>> @@ -1146,11 +1311,6 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>>   			folio_get(mmap_folio);
>>   			wc->w_folios[i] = mmap_folio;
>>   			wc->w_target_locked = true;
>> -		} else if (index >= target_index && index <= end_index &&
>> -			   wc->w_type == OCFS2_WRITE_DIRECT) {
>> -			/* Direct write has no mapping page. */
>> -			wc->w_folios[i] = NULL;
>> -			continue;
>>   		} else {
>>   			wc->w_folios[i] = __filemap_get_folio(mapping, index,
>>   					FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
>> @@ -1173,6 +1333,61 @@ static int ocfs2_grab_folios_for_write(struct address_space *mapping,
>>   	return ret;
>>   }
>>   
>> +/*
>> + * Get the physical location of a cluster and prepare the folios [fstart, fend)
>> + * of w_folios, which belong to it, for the write.
>> + */
>> +static int ocfs2_prepare_cluster_folios(struct address_space *mapping,
>> +					u32 *phys, unsigned int should_zero,
>> +					struct ocfs2_write_ctxt *wc, u32 cpos,
>> +					loff_t user_pos, unsigned user_len,
>> +					unsigned int fstart, unsigned int fend)
>> +{
>> +	int ret, i;
>> +	u64 p_blkno;
>> +	struct inode *inode = mapping->host;
>> +	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
>> +
>> +	/*
>> +	 * The only reason this should fail is due to an inability to
>> +	 * find the extent added.
>> +	 */
>> +	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
>> +	if (ret < 0) {
>> +		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
>> +			    "at logical cluster %u",
>> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
>> +		return ret;
>> +	}
>> +
>> +	BUG_ON(*phys == 0);
>> +
>> +	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
>> +	if (!should_zero)
>> +		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
>> +
>> +	for (i = fstart; i < fend; i++) {
>> +		int tmpret;
>> +
>> +		/* This is the direct io target page. */
>> +		if (wc->w_folios[i] == NULL) {
>> +			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
>> +			continue;
>> +		}
>> +
>> +		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
>> +				wc->w_folios[i], cpos, user_pos, user_len,
>> +				should_zero);
>> +		if (tmpret) {
>> +			mlog_errno(tmpret);
>> +			if (ret == 0)
>> +				ret = tmpret;
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   /*
>>    * Prepare a single cluster for write one cluster into the file.
>>    */
>> @@ -1185,11 +1400,9 @@ static int ocfs2_write_cluster(struct address_space *mapping,
>>   			       struct ocfs2_write_ctxt *wc, u32 cpos,
>>   			       loff_t user_pos, unsigned user_len)
>>   {
>> -	int ret, i;
>> -	u64 p_blkno;
>> +	int ret;
>>   	struct inode *inode = mapping->host;
>>   	struct ocfs2_extent_tree et;
>> -	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
>>   
>>   	if (new) {
>>   		u32 tmp_pos;
>> @@ -1231,52 +1444,176 @@ static int ocfs2_write_cluster(struct address_space *mapping,
>>   		}
>>   	}
>>   
>> +	ret = ocfs2_prepare_cluster_folios(mapping, phys, should_zero, wc, cpos,
>> +					   user_pos, user_len, 0,
>> +					   wc->w_num_folios);
>> +
>>   	/*
>> -	 * The only reason this should fail is due to an inability to
>> -	 * find the extent added.
>> +	 * We only have cleanup to do in case of allocating write.
>>   	 */
>> -	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
>> +	if (ret && new)
>> +		ocfs2_write_failure(inode, wc, user_pos, user_len);
>> +
>> +out:
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * A direct write allocates all the clusters it needs in one go, the same way
>> + * ocfs2_extend_allocation() does.  The new extent is unwritten, it is converted
>> + * when the io is done, see ocfs2_dio_end_io_write().
>> + *
>> + * Only one call is made, which means one chunk of contiguous clusters.  The
>> + * allocator may return less than we asked for.  We don't try again, that would
>> + * need more credits and the chunks would not be contiguous on the disk, which
>> + * the caller needs as it hands out a single mapping.  The write is just made
>> + * shorter, the caller maps the rest with its next ->iomap_begin().
>> + */
>> +static int ocfs2_dio_alloc_clusters(struct inode *inode,
>> +				    struct ocfs2_write_ctxt *wc,
>> +				    struct ocfs2_alloc_context *data_ac,
>> +				    struct ocfs2_alloc_context *meta_ac)
>> +{
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
>> +	enum ocfs2_alloc_restarted why = RESTART_NONE;
>> +	u32 cpos = wc->w_cpos, got;
>> +	int ret, i;
>> +
>> +	ret = ocfs2_add_inode_data(osb, inode, &cpos, wc->w_clen, 1,
>> +				   wc->w_di_bh, wc->w_handle, data_ac, meta_ac,
>> +				   &why);
>> +	got = cpos - wc->w_cpos;
>> +	if (ret == -EAGAIN && why == RESTART_TRANS && got)
>> +		ret = 0;
>> +	if (ret == -EAGAIN) {
>> +		/*
>> +		 * We reserved the metadata for it up front, we do not
>> +		 * expect to be here.
>> +		 */
>> +		mlog(ML_ERROR, "Inode %llu: EAGAIN (%d) during dio allocation\n",
>> +		     (unsigned long long)OCFS2_I(inode)->ip_blkno, why);
>> +		ret = -ENOSPC;
>> +	}
>>   	if (ret < 0) {
>> -		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
>> -			    "at logical cluster %u",
>> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
>> -		goto out;
>> +		if (ret != -ENOSPC)
>> +			mlog_errno(ret);
>> +		return ret;
>>   	}
>>   
>> -	BUG_ON(*phys == 0);
>> -
>> -	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
>> -	if (!should_zero)
>> -		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
>> +	if (got < wc->w_clen) {
>> +		/*
>> +		 * Cut the write short.  What is left of it is not for us to
>> +		 * zero anymore, the last cluster we have now is covered by the
>> +		 * user range entirely.  Drop the folios of the old last
>> +		 * cluster.
>> +		 */
>> +		wc->w_clusters_unused = wc->w_clen - got;
>> +		wc->w_clen = got;
>>   
>> -	for (i = 0; i < wc->w_num_folios; i++) {
>> -		int tmpret;
>> +		for (i = ppc; i < 2 * ppc; i++) {
>> +			struct folio *folio = wc->w_folios[i];
>>   
>> -		/* This is the direct io target page. */
>> -		if (wc->w_folios[i] == NULL) {
>> -			p_blkno += (1 << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits));
>> -			continue;
>> +			if (!folio)
>> +				continue;
>> +			folio_unlock(folio);
>> +			folio_mark_accessed(folio);
>> +			folio_put(folio);
>> +			wc->w_folios[i] = NULL;
>>   		}
>> +		if (wc->w_num_folios > ppc)
>> +			wc->w_num_folios = ppc;
>> +	}
>>   
>> -		tmpret = ocfs2_prepare_folio_for_write(inode, &p_blkno, wc,
>> -				wc->w_folios[i], cpos, user_pos, user_len,
>> -				should_zero);
>> -		if (tmpret) {
>> -			mlog_errno(tmpret);
>> -			if (ret == 0)
>> -				ret = tmpret;
>> +	return 0;
>> +}
>> +
>> +/*
>> + * A direct write goes to the disk, it only needs the clusters allocated, the
>> + * folios around the user range zeroed and the physical location of each
>> + * cluster.  The latter is what the iomap mapping is made of.
>> + */
>> +static int ocfs2_write_clusters_direct(struct address_space *mapping,
>> +				       struct ocfs2_alloc_context *data_ac,
>> +				       struct ocfs2_alloc_context *meta_ac,
>> +				       struct ocfs2_write_ctxt *wc,
>> +				       loff_t pos, unsigned len)
>> +{
>> +	struct inode *inode = mapping->host;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
>> +	struct ocfs2_write_cluster_desc *desc;
>> +	loff_t end = pos + len;
>> +	int ret, i, win;
>> +	u32 phys, num;
>> +
>> +	if (wc->w_desc[0].c_new) {
>> +		ret = ocfs2_dio_alloc_clusters(inode, wc, data_ac, meta_ac);
>> +		if (ret)
>> +			return ret;
>> +		end = min_t(loff_t, end,
>> +			    ocfs2_clusters_to_bytes(inode->i_sb,
>> +						    wc->w_cpos + wc->w_clen));
>> +	}
>> +
>> +	/*
>> +	 * Fill in the physical location of the clusters, an extent covers as
>> +	 * many of them as it can.
>> +	 */
>> +	for (i = 0; i < wc->w_clen; ) {
>> +		desc = &wc->w_desc[i];
>> +
>> +		ret = ocfs2_get_clusters(inode, desc->c_cpos, &phys, &num,
>> +					 NULL);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			return ret;
>> +		}
>> +		if (!phys) {
>> +			mlog(ML_ERROR, "Inode %llu: no cluster at %u after dio allocation\n",
>> +			     (unsigned long long)OCFS2_I(inode)->ip_blkno,
>> +			     desc->c_cpos);
>> +			return -EIO;
>>   		}
>> +		for (; num && i < wc->w_clen; i++, num--, phys++)
>> +			wc->w_desc[i].c_phys = phys;
>>   	}
>>   
>>   	/*
>> -	 * We only have cleanup to do in case of allocating write.
>> +	 * The folios are only there for the first and the last cluster,
>> +	 * the ones in the middle are written by the dio as a whole.
>>   	 */
>> -	if (ret && new)
>> -		ocfs2_write_failure(inode, wc, user_pos, user_len);
>> +	for (win = 0; win < (wc->w_clen > 1 ? 2 : 1); win++) {
>> +		unsigned int fstart = win * ppc;
>> +		unsigned int fend = min(wc->w_num_folios, fstart + ppc);
>> +		loff_t cpos_byte;
>> +		unsigned int local_len;
>> +		loff_t user_pos;
>> +
>> +		desc = win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
>> +		if (!desc->c_needs_zero || fend <= fstart)
>> +			continue;
>>   
>> -out:
>> +		/* The part of the user range which is in this cluster. */
>> +		cpos_byte = ocfs2_clusters_to_bytes(inode->i_sb, desc->c_cpos);
>> +		user_pos = max_t(loff_t, pos, cpos_byte);
>> +		local_len = min_t(loff_t, end,
>> +				  cpos_byte + osb->s_clustersize) - user_pos;
>>   
>> -	return ret;
>> +		ret = ocfs2_prepare_cluster_folios(mapping, &desc->c_phys,
>> +						   desc->c_needs_zero, wc,
>> +						   desc->c_cpos, user_pos,
>> +						   local_len, fstart, fend);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			if (desc->c_new)
>> +				ocfs2_write_failure(inode, wc, pos, len);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return 0;
>>   }
>>   
>>   static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
>> @@ -1291,6 +1628,10 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
>>   	struct ocfs2_write_cluster_desc *desc;
>>   	struct ocfs2_super *osb = OCFS2_SB(mapping->host->i_sb);
>>   
>> +	if (wc->w_type == OCFS2_WRITE_DIRECT)
>> +		return ocfs2_write_clusters_direct(mapping, data_ac, meta_ac,
>> +						   wc, pos, len);
>> +
>>   	for (i = 0; i < wc->w_clen; i++) {
>>   		desc = &wc->w_desc[i];
>>   
>> @@ -1376,76 +1717,212 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
>>   }
>>   
>>   /*
>> - * Check if this extent is marked UNWRITTEN by direct io. If so, we need not to
>> - * do the zero work. And should not to clear UNWRITTEN since it will be cleared
>> - * by the direct io procedure.
>> - * If this is a new extent that allocated by direct io, we should mark it in
>> - * the ip_unwritten_list.
>> + * Find the entry which covers a cluster.  Must be called with ip_lock held.
>>    */
>> -static int ocfs2_unwritten_check(struct inode *inode,
>> -				 struct ocfs2_write_ctxt *wc,
>> -				 struct ocfs2_write_cluster_desc *desc)
>> +static struct ocfs2_unwritten_extent *
>> +ocfs2_find_unwritten(struct ocfs2_inode_info *oi, u32 cpos)
>>   {
>> -	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> -	struct ocfs2_unwritten_extent *ue = NULL, *new = NULL;
>> -	int ret = 0;
>> -
>> -	if (!desc->c_needs_zero)
>> -		return 0;
>> +	struct ocfs2_unwritten_extent *ue;
>>   
>> -retry:
>> -	spin_lock(&oi->ip_lock);
>> -	/* Needs not to zero no metter buffer or direct. The one who is zero
>> -	 * the cluster is doing zero. And he will clear unwritten after all
>> -	 * cluster io finished. */
>>   	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
>> -		if (desc->c_cpos == ue->ue_cpos) {
>> -			BUG_ON(desc->c_new);
>> -			desc->c_needs_zero = 0;
>> -			desc->c_clear_unwritten = 0;
>> -			goto unlock;
>> -		}
>> +		if (cpos >= ue->ue_cpos && cpos - ue->ue_cpos < ue->ue_clusters)
>> +			return ue;
>>   	}
>> +	return NULL;
>> +}
>>   
>> -	if (wc->w_type != OCFS2_WRITE_DIRECT)
>> -		goto unlock;
>> +/*
>> + * Is there an entry, which does not belong to @owner, on the clusters
>> + * [cpos, cend)?  That is, is another dio which is still in flight in charge of
>> + * some of them?
>> + */
>> +static bool ocfs2_dio_foreign_unwritten(struct ocfs2_inode_info *oi,
>> +					u32 cpos, u32 cend, void *owner)
>> +{
>> +	struct ocfs2_unwritten_extent *ue;
>> +	bool found = false;
>>   
>> -	if (new == NULL) {
>> -		spin_unlock(&oi->ip_lock);
>> -		new = kmalloc_obj(struct ocfs2_unwritten_extent, GFP_NOFS);
>> -		if (new == NULL) {
>> -			ret = -ENOMEM;
>> -			goto out;
>> +	spin_lock(&oi->ip_lock);
>> +	list_for_each_entry(ue, &oi->ip_unwritten_list, ue_ip_node) {
>> +		if (ue->ue_owner != owner && ue->ue_cpos < cend &&
>> +		    cpos < ue->ue_cpos + ue->ue_clusters) {
>> +			found = true;
>> +			break;
>>   		}
>> -		goto retry;
>>   	}
>> -	/* This direct write will doing zero. */
>> -	new->ue_cpos = desc->c_cpos;
>> -	new->ue_phys = desc->c_phys;
>> -	desc->c_clear_unwritten = 0;
>> -	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
>> -	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
>> -	wc->w_unwritten_count++;
>> -	new = NULL;
>> -unlock:
>>   	spin_unlock(&oi->ip_lock);
>> -out:
>> -	kfree(new);
>> -	return ret;
>> +
>> +	return found;
>>   }
>>   
>>   /*
>> - * Populate each single-cluster write descriptor in the write context
>> - * with information about the i/o to be done.
>> + * Check if this extent is marked UNWRITTEN by direct io. If so, we need not to
>> + * do the zero work. And should not to clear UNWRITTEN since it will be cleared
>> + * by the direct io procedure.
>>    *
>> - * Returns the number of clusters that will have to be allocated, as
>> - * well as a worst case estimate of the number of extent records that
>> - * would have to be created during a write to an unwritten region.
>> + * A direct write never clears UNWRITTEN here, that is done when its io is
>> + * finished. The clusters it is going to zero are not put to the
>> + * ip_unwritten_list by this function, see ocfs2_dio_add_unwritten(), as the
>> + * write might get shortened afterwards.
>>    */
>> -static int ocfs2_populate_write_desc(struct inode *inode,
>> -				     struct ocfs2_write_ctxt *wc,
>> -				     unsigned int *clusters_to_alloc,
>> -				     unsigned int *extents_to_split)
>> +static void ocfs2_unwritten_check(struct inode *inode,
>> +				  struct ocfs2_write_ctxt *wc,
>> +				  struct ocfs2_write_cluster_desc *desc)
>> +{
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	struct ocfs2_unwritten_extent *ue;
>> +
>> +	if (!desc->c_needs_zero)
>> +		return;
>> +
>> +	spin_lock(&oi->ip_lock);
>> +	ue = ocfs2_find_unwritten(oi, desc->c_cpos);
>> +	/* A hole (c_new is 1) can not be on the list, don't trust it if it is. */
>> +	if (ue && !WARN_ON_ONCE(desc->c_new)) {
>> +		/*
>> +		 * Needs not to zero no matter buffer or direct. The one who is
>> +		 * zero the cluster is doing zero. And he will clear unwritten
>> +		 * after all cluster io finished.
>> +		 */
>> +		desc->c_needs_zero = 0;
>> +		desc->c_clear_unwritten = 0;
>> +		/* match its own entry */
>> +		if (wc->w_type == OCFS2_WRITE_DIRECT && wc->w_owner &&
>> +		    ue->ue_owner == wc->w_owner)
>> +			desc->c_dio_unwritten = 1;
>> +		else
>> +			/*
>> +			 * Not ours. A direct write never gets here, it waits
>> +			 * for the entries of the other dios before it maps,
>> +			 * see ocfs2_dio_wr_map_blocks().
>> +			 */
>> +			WARN_ON_ONCE(wc->w_type == OCFS2_WRITE_DIRECT);
>> +	} else if (wc->w_type == OCFS2_WRITE_DIRECT) {
>> +		/* This direct write will doing zero. */
>> +		desc->c_clear_unwritten = 0;
>> +	}
>> +	spin_unlock(&oi->ip_lock);
>> +}
>> +
>> +/*
>> + * Is the cluster reported as unwritten to iomap?
>> + * Returns true for unwritten, false for mapped.
>> + */
>> +static inline bool ocfs2_desc_dio_unwritten(struct ocfs2_write_cluster_desc *d)
>> +{
>> +	/*
>> +	 * c_needs_zero: whether this mapping needs to be zeroed
>> +	 * c_dio_unwritten: whether the conversion is my job
>> +	 *
>> +	 * c_needs_zero | c_dio_unwritten | source place             | reports
>> +	 * ----------------------------------------------------------------
>> +	 *     0        |      0          | written extent           | MAPPED
>> +	 *              |                 | (a direct write never    |
>> +	 *              |                 | sees an unwritten one    |
>> +	 *              |                 | owned by another dio, it |
>> +	 *              |                 | waits for it first)      |
>> +	 * ------------------------------------------------------------------
>> +	 *     1        |      0          | buffered/mmap write;     | UNWRITTEN
>> +	 *              |                 | transitional state before|
>> +	 *              |                 | ocfs2_dio_add_unwritten  |
>> +	 * ------------------------------------------------------------------
>> +	 *     0        |      1          | ocfs2_unwritten_check    | UNWRITTEN
>> +	 *              |                 | found its own entry      |
>> +	 * ------------------------------------------------------------------
>> +	 *     1        |      1          | ocfs2_dio_add_unwritten  | UNWRITTEN
>> +	 */
>> +	return d->c_needs_zero || d->c_dio_unwritten;
>> +}
>> +
>> +/*
>> + * iomap takes one mapping which is of one type and contiguous on the disk.
>> + * Cut the clusters of a direct write at the first one which is not like the
>> + * first, they are mapped by the next ->iomap_begin().  Also, the clusters to
>> + * be allocated are all new or none of them is.
>> + *
>> + * Returns the number of clusters to be allocated.
>> + */
>> +static unsigned int ocfs2_dio_trim_write_ctxt(struct ocfs2_write_ctxt *wc)
>> +{
>> +	struct ocfs2_write_cluster_desc *first = &wc->w_desc[0];
>> +	u32 i;
>> +
>> +	for (i = 1; i < wc->w_clen; i++) {
>> +		struct ocfs2_write_cluster_desc *d = &wc->w_desc[i];
>> +
>> +		if (d->c_new != first->c_new ||
>> +		    ocfs2_desc_dio_unwritten(d) !=
>> +				ocfs2_desc_dio_unwritten(first))
>> +			break;
>> +		/* mapped clusters */
>> +		if (!d->c_new && d->c_phys != d[-1].c_phys + 1)
>> +			break;
>> +	}
>> +	wc->w_clen = i;
>> +
>> +	/*
>> +	 * c_new is 0 for mapped clusters, which means they are not
>> +	 * allocated by this write.
>> +	 */
>> +	return first->c_new ? wc->w_clen : 0;
>> +}
>> +
>> +/*
>> + * Record the clusters a direct write zeroed (or is going to convert) in
>> + * ip_unwritten_list, until ocfs2_dio_end_io_write() converts them.  The
>> + * entries are also on wc->w_unwritten_list, so that they are freed with the
>> + * write context if the write fails. Once the write has succeeded, the caller
>> + * detaches them from it, see ocfs2_dio_detach_unwritten().
>> + */
>> +static int ocfs2_dio_add_unwritten(struct inode *inode,
>> +				   struct ocfs2_write_ctxt *wc)
>> +{
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	struct ocfs2_unwritten_extent *ue;
>> +	u32 i, j;
>> +
>> +	for (i = 0; i < wc->w_clen; i = j) {
>> +		j = i + 1;
>> +		if (!wc->w_desc[i].c_needs_zero)
>> +			continue;
>> +		while (j < wc->w_clen && wc->w_desc[j].c_needs_zero)
>> +			j++;
>> +
>> +		ue = kmalloc_obj(struct ocfs2_unwritten_extent, GFP_NOFS);
>> +		if (!ue)
>> +			return -ENOMEM;
>> +		ue->ue_cpos = wc->w_desc[i].c_cpos;
>> +		ue->ue_clusters = j - i;
>> +		ue->ue_owner = wc->w_owner;
>> +		INIT_LIST_HEAD(&ue->ue_ip_node);
>> +		list_add_tail(&ue->ue_node, &wc->w_unwritten_list);
>> +	}
>> +
>> +	spin_lock(&oi->ip_lock);
>> +	list_for_each_entry(ue, &wc->w_unwritten_list, ue_node)
>> +		list_add_tail(&ue->ue_ip_node, &oi->ip_unwritten_list);
>> +	spin_unlock(&oi->ip_lock);
>> +
>> +	for (i = 0; i < wc->w_clen; i++) {
>> +		if (wc->w_desc[i].c_needs_zero)
>> +			wc->w_desc[i].c_dio_unwritten = 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Populate each single-cluster write descriptor in the write context
>> + * with information about the i/o to be done.
>> + *
>> + * Returns the number of clusters that will have to be allocated, as
>> + * well as a worst case estimate of the number of extent records that
>> + * would have to be created during a write to an unwritten region.
>> + */
>> +static int ocfs2_populate_write_desc(struct inode *inode,
>> +				     struct ocfs2_write_ctxt *wc,
>> +				     unsigned int *clusters_to_alloc,
>> +				     unsigned int *extents_to_split)
>>   {
>>   	int ret;
>>   	struct ocfs2_write_cluster_desc *desc;
>> @@ -1518,11 +1995,7 @@ static int ocfs2_populate_write_desc(struct inode *inode,
>>   			desc->c_needs_zero = 1;
>>   		}
>>   
>> -		ret = ocfs2_unwritten_check(inode, wc, desc);
>> -		if (ret) {
>> -			mlog_errno(ret);
>> -			goto out;
>> -		}
>> +		ocfs2_unwritten_check(inode, wc, desc);
>>   
>>   		num_clusters--;
>>   	}
>> @@ -1707,10 +2180,57 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
>>   	return ret;
>>   }
>>   
>> +/*
>> + * Does a direct write have folios to zero around its user range?
>> + * See ocfs2_grab_folios_direct(), this has to agree with it.
>> + */
>> +static bool ocfs2_dio_need_zero_folios(struct inode *inode,
>> +				       struct ocfs2_write_ctxt *wc,
>> +				       loff_t pos, unsigned len)
>> +{
>> +	unsigned int ppc = ocfs2_pages_per_cluster(inode->i_sb);
>> +	unsigned long target_index = pos >> PAGE_SHIFT;
>> +	unsigned long end_index = (pos + len - 1) >> PAGE_SHIFT;
>> +	loff_t last_byte = max_t(loff_t, pos + len, i_size_read(inode));
>> +	unsigned long last_index = ((last_byte - 1) >> PAGE_SHIFT) + 1;
>> +	unsigned int nr_win = wc->w_clen > 1 ? 2 : 1;
>> +	int win, i;
>> +
>> +	for (win = 0; win < nr_win; win++) {
>> +		struct ocfs2_write_cluster_desc *desc =
>> +			win ? &wc->w_desc[wc->w_clen - 1] : &wc->w_desc[0];
>> +		unsigned long start;
>> +
>> +		if (!desc->c_needs_zero)
>> +			continue;
>> +
>> +		start = ocfs2_align_clusters_to_page_index(inode->i_sb,
>> +							    desc->c_cpos);
>> +		for (i = 0; i < ppc && start + i < last_index; i++) {
>> +			if (start + i < target_index || start + i > end_index)
>> +				return true;
>> +		}
>> +	}
>> +	return false;
>> +}
>> +
>> +/*
>> + * A buffered write is cut by the caller into pieces of up to a page, and the
>> + * clusters it touches have to fit in a page.
>> + *
>> + * A direct write is not, it may span many clusters, which are all of the same
>> + * kind: all of them are to be allocated or none is, and either all of them are
>> + * unwritten or none is.  How many of the clusters asked for are used is up to
>> + * this function, see w_clen of the returned context.
>> + *
>> + * @owner is only used by a direct write, it is what ocfs2_dio_end_io_write()
>> + * finds the unwritten clusters recorded for this write by.
>> + */
>>   int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   		loff_t pos, unsigned len, ocfs2_write_type_t type,
>>   		struct folio **foliop, void **fsdata,
>> -		struct buffer_head *di_bh, struct folio *mmap_folio)
>> +		struct buffer_head *di_bh, struct folio *mmap_folio,
>> +		void *owner)
>>   {
>>   	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
>>   	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
>> @@ -1723,15 +2243,17 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   	handle_t *handle;
>>   	struct ocfs2_extent_tree et;
>>   	int try_free = 1, ret1;
>> +	u32 prev_clusters, added;
>>   
>>   try_again:
>> -	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh);
>> +	ret = ocfs2_alloc_write_ctxt(&wc, osb, pos, len, type, di_bh, owner);
>>   	if (ret) {
>>   		mlog_errno(ret);
>>   		return ret;
>>   	}
>>   
>> -	if (ocfs2_supports_inline_data(osb)) {
>> +	/* A direct write is never inline, it is not even allowed to start. */
>> +	if (type != OCFS2_WRITE_DIRECT && ocfs2_supports_inline_data(osb)) {
>>   		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
>>   						     mmap_folio, wc);
>>   		if (ret == 1) {
>> @@ -1744,7 +2266,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   		}
>>   	}
>>   
>> -	/* Direct io change i_size late, should not zero tail here. */
>> +	/* Direct io change i_size itself, should not zero tail here. */
>>   	if (type != OCFS2_WRITE_DIRECT) {
>>   		if (ocfs2_sparse_alloc(osb))
>>   			ret = ocfs2_zero_tail(inode, di_bh, pos);
>> @@ -1777,6 +2299,18 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   		mlog_errno(ret);
>>   		goto out;
>>   	}
>> +
>> +	if (type == OCFS2_WRITE_DIRECT) {
>> +		/*
>> +		 * Direct write never splits an extent here, they are converted
>> +		 * when the io is done. What it can do is to allocate.
>> +		 */
>> +		extents_to_split = 0;
>> +		clusters_to_alloc = ocfs2_dio_trim_write_ctxt(wc);
>> +		len = min_t(loff_t, len,
>> +			    ocfs2_clusters_to_bytes(inode->i_sb,
>> +						    wc->w_cpos + wc->w_clen) - pos);
>> +	}
>>   	clusters_need += clusters_to_alloc;
>>   
>>   	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
>> @@ -1815,13 +2349,24 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   
>>   		credits = ocfs2_calc_extend_credits(inode->i_sb,
>>   						    &di->id2.i_list);
>> -	} else if (type == OCFS2_WRITE_DIRECT)
>> -		/* direct write needs not to start trans if no extents alloc. */
>> -		goto success;
>> +	} else if (type == OCFS2_WRITE_DIRECT) {
>> +		/*
>> +		 * Direct write needs not to start trans if no extents alloc,
>> +		 * unless there are folios to zero.
>> +		 */
>> +		if (!ocfs2_dio_need_zero_folios(inode, wc, pos, len)) {
>> +			ret = ocfs2_dio_add_unwritten(inode, wc);
>> +			if (ret) {
>> +				mlog_errno(ret);
>> +				goto out;
>> +			}
>> +			goto success;
>> +		}
>> +	}
>>   
>>   	/*
>>   	 * We have to zero sparse allocated clusters, unwritten extent clusters,
>> -	 * and non-sparse clusters we just extended.  For non-sparse writes,
>> +	 * and non-sparse clusters we just extended. For non-sparse writes,
>>   	 * we know zeros will only be needed in the first and/or last cluster.
>>   	 */
>>   	if (wc->w_clen && (wc->w_desc[0].c_needs_zero ||
>> @@ -1841,6 +2386,14 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   
>>   	wc->w_handle = handle;
>>   
>> +	/*
>> +	 * Nobody else changes the clusters of the inode while we hold
>> +	 * ip_alloc_sem, what has been added since is ours.
>> +	 */
>> +	spin_lock(&OCFS2_I(inode)->ip_lock);
>> +	prev_clusters = OCFS2_I(inode)->ip_clusters;
>> +	spin_unlock(&OCFS2_I(inode)->ip_lock);
>> +
>>   	if (clusters_to_alloc) {
>>   		ret = dquot_alloc_space_nodirty(inode,
>>   			ocfs2_clusters_to_bytes(osb->sb, clusters_to_alloc));
>> @@ -1881,11 +2434,26 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   
>>   	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
>>   					  len);
>> +	if (wc->w_clusters_unused) {
>> +		/* A direct write got a shorter chunk than reserved. */
>> +		dquot_free_space(inode,
>> +			ocfs2_clusters_to_bytes(osb->sb, wc->w_clusters_unused));
>> +		clusters_to_alloc -= wc->w_clusters_unused;
>> +		wc->w_clusters_unused = 0;
>> +	}
>>   	if (ret) {
>>   		mlog_errno(ret);
>>   		goto out_quota;
>>   	}
>>   
>> +	if (type == OCFS2_WRITE_DIRECT) {
>> +		ret = ocfs2_dio_add_unwritten(inode, wc);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out_quota;
>> +		}
>> +	}
>> +
>>   	if (data_ac)
>>   		ocfs2_free_alloc_context(data_ac);
>>   	if (meta_ac)
>> @@ -1897,9 +2465,17 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   	*fsdata = wc;
>>   	return 0;
>>   out_quota:
>> -	if (clusters_to_alloc)
>> +	/*
>> +	 * Give back the quota of the clusters which were not allocated. Those
>> +	 * which already are in the extent tree stay, and so does their quota.
>> +	 */
>> +	spin_lock(&OCFS2_I(inode)->ip_lock);
>> +	added = OCFS2_I(inode)->ip_clusters - prev_clusters;
>> +	spin_unlock(&OCFS2_I(inode)->ip_lock);
>> +	if (clusters_to_alloc > added)
>>   		dquot_free_space(inode,
>> -			  ocfs2_clusters_to_bytes(osb->sb, clusters_to_alloc));
>> +			ocfs2_clusters_to_bytes(osb->sb,
>> +				clusters_to_alloc - added));
>>   out_commit:
>>   	ocfs2_commit_trans(osb, handle);
>>   
>> @@ -1968,7 +2544,7 @@ static int ocfs2_write_begin(const struct kiocb *iocb,
>>   	down_write(&OCFS2_I(inode)->ip_alloc_sem);
>>   
>>   	ret = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_BUFFER,
>> -				       foliop, fsdata, di_bh, NULL);
>> +				       foliop, fsdata, di_bh, NULL, NULL);
>>   	if (ret) {
>>   		mlog_errno(ret);
>>   		goto out_fail;
>> @@ -2130,7 +2706,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping, loff_t pos,
>>   	ocfs2_run_deallocs(osb, &wc->w_dealloc);
>>   
>>   	brelse(wc->w_di_bh);
>> -	kfree(wc);
>> +	ocfs2_release_write_ctxt(wc);
>>   
>>   	return copied;
>>   }
>> @@ -2151,130 +2727,180 @@ static int ocfs2_write_end(const struct kiocb *iocb,
>>   	return ret;
>>   }
>>   
>> -struct ocfs2_dio_write_ctxt {
>> -	struct list_head	dw_zero_list;
>> -	unsigned		dw_zero_count;
>> -	int			dw_orphaned;
>> -	pid_t			dw_writer_pid;
>> -};
>> -
>> -static struct ocfs2_dio_write_ctxt *
>> -ocfs2_dio_alloc_write_ctx(struct buffer_head *bh, int *alloc)
>> +/*
>> + * Prepare the area between i_size and a direct write that starts or ends
>> + * beyond it. Must be called once per dio, before any io is issued, with
>> + * i_rwsem and the rw lock held.
>> + */
>> +int ocfs2_dio_zero_eof(struct inode *inode, loff_t pos, size_t count)
>>   {
>> -	struct ocfs2_dio_write_ctxt *dwc = NULL;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	struct buffer_head *di_bh = NULL;
>> +	int ret;
>>   
>> -	if (bh->b_private)
>> -		return bh->b_private;
>> +	if (pos + count <= i_size_read(inode))
>> +		return 0;
>>   
>> -	dwc = kmalloc_obj(struct ocfs2_dio_write_ctxt, GFP_NOFS);
>> -	if (dwc == NULL)
>> -		return NULL;
>> -	INIT_LIST_HEAD(&dwc->dw_zero_list);
>> -	dwc->dw_zero_count = 0;
>> -	dwc->dw_orphaned = 0;
>> -	dwc->dw_writer_pid = task_pid_nr(current);
>> -	bh->b_private = dwc;
>> -	*alloc = 1;
>> +	ret = ocfs2_inode_lock(inode, &di_bh, 1);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		return ret;
>> +	}
>>   
>> -	return dwc;
>> +	down_write(&oi->ip_alloc_sem);
>> +	if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
>> +		ret = ocfs2_zero_tail(inode, di_bh, pos);
>> +	else
>> +		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, count,
>> +						   NULL);
>> +	if (ret < 0)
>> +		mlog_errno(ret);
>> +	up_write(&oi->ip_alloc_sem);
>> +
>> +	ocfs2_inode_unlock(inode, 1);
>> +	brelse(di_bh);
>> +	return ret;
>>   }
>>   
>> -static void ocfs2_dio_free_write_ctx(struct inode *inode,
>> -				     struct ocfs2_dio_write_ctxt *dwc)
>> +/*
>> + * The most a single mapping handed out for a direct write spans.
>> + * It bounds the memory of the write context, one descriptor per
>> + * cluster.
>> + */
>> +#define OCFS2_DIO_MAX_MAP_BYTES	(16U << 20)
>> +/* A mapping always leaves room for at least one whole cluster. */
>> +static_assert(OCFS2_DIO_MAX_MAP_BYTES > OCFS2_MAX_CLUSTERSIZE);
>> +
>> +/*
>> + * The entries of ip_unwritten_list which belong to a direct write
>> + * have been created while the write context was alive, they have to
>> + * survive it: they stay until ocfs2_dio_end_io() has converted the
>> + * clusters. Take them off the write context, so that it can be
>> + * released.
>> + */
>> +static void ocfs2_dio_detach_unwritten(struct ocfs2_write_ctxt *wc)
>>   {
>> -	ocfs2_free_unwritten_list(inode, &dwc->dw_zero_list);
>> -	kfree(dwc);
>> +	struct ocfs2_unwritten_extent *ue, *tmp;
>> +
>> +	list_for_each_entry_safe(ue, tmp, &wc->w_unwritten_list, ue_node)
>> +		list_del_init(&ue->ue_node);
>>   }
>>   
>>   /*
>> - * TODO: Make this into a generic get_blocks function.
>> + * Map a range of a direct write, allocate the clusters if needed.
>>    *
>> - * From do_direct_io in direct-io.c:
>> - *  "So what we do is to permit the ->get_blocks function to populate
>> - *   bh.b_size with the size of IO which is permitted at this offset and
>> - *   this i_blkbits."
>> + * Contrary to the single cluster it was before, a mapping spans as many
>> + * clusters as iomap asks for, up to the first thing that makes it unfit to
>> + * be handed out as one: the kind of the extent (hole, unwritten, written),
>> + * a discontiguous extent, or the end of the file. The latter is the one
>> + * place where the mapping is split on purpose:
>>    *
>> - * This function is called directly from get_more_blocks in direct-io.c.
>> + *		   eof_blk
>> + * |--------|---------|---------|---------
>> + * |<-in file range-->|<-past eof range-->
>>    *
>> - * called like this: dio->get_blocks(dio->inode, fs_startblk,
>> - * 					fs_count, map_bh, dio->rw == WRITE);
>> + * the part which is in the file is not NEW, it may have data which must
>> + * not be zeroed. The part which is beyond it is NEW. As the file size is
>> + * only changed when the io is done, both are told apart here.
>> + *
>> + * Whatever is unwritten and zeroed here is recorded in ip_unwritten_list
>> + * for ocfs2_dio_end_io() to convert, find them there by @owner.
>> + *
>> + * @map->lblk and @map->len go in, the mapping goes out.
>>    */
>> -static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>> -			       struct buffer_head *bh_result, int create)
>> +static int ocfs2_dio_wr_map_blocks(struct inode *inode,
>> +				   struct ocfs2_map_block *map,
>> +				   unsigned int flags, void *owner)
>>   {
>>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>   	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>   	struct ocfs2_write_ctxt *wc;
>> -	struct ocfs2_write_cluster_desc *desc = NULL;
>> -	struct ocfs2_dio_write_ctxt *dwc = NULL;
>> +	struct ocfs2_write_cluster_desc *desc;
>> +	struct ocfs2_map_block probe;
>>   	struct buffer_head *di_bh = NULL;
>> -	u64 p_blkno;
>> -	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
>> -	loff_t pos = iblock << i_blkbits;
>> -	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
>> -	unsigned len, total_len = bh_result->b_size;
>> -	int ret = 0, first_get_block = 0;
>> -
>> -	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
>> -	len = min(total_len, len);
>> +	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
>> +	u64 bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
>> +	u64 lblk = map->lblk;
>> +	u64 req_len = map->len;
>> +	u64 eof_blk, cap_end;
>> +	loff_t pos = lblk << blkbits;
>> +	loff_t len, end;
>> +	u32 cstart, cend;
>> +	int ret = 0, unwritten;
>>   
>> -	/*
>> -	 * bh_result->b_size is count in get_more_blocks according to write
>> -	 * "pos" and "end", we need map twice to return different buffer state:
>> -	 * 1. area in file size, not set NEW;
>> -	 * 2. area out file size, set  NEW.
>> -	 *
>> -	 *		   iblock    endblk
>> -	 * |--------|---------|---------|---------
>> -	 * |<-------area in file------->|
>> -	 */
>> +retry:
>> +	map->len = req_len;
>> +	map->flags = 0;
>> +	eof_blk = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>>   
>> -	if ((iblock <= endblk) &&
>> -	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
>> -		len = (endblk - iblock + 1) << i_blkbits;
>> +	/* Do not hand out a mapping which is over the end of the file. */
>> +	if (lblk < eof_blk && lblk + map->len > eof_blk)
>> +		map->len = eof_blk - lblk;
>>   
>> -	mlog(0, "get block of %llu at %llu:%u req %u\n",
>> -			inode->i_ino, pos, len, total_len);
>> +	map->len = min_t(u64, map->len, OCFS2_DIO_MAX_MAP_BYTES >> blkbits);
>>   
>>   	/*
>> -	 * Because we need to change file size in ocfs2_dio_end_io_write(), or
>> -	 * we may need to add it to orphan dir. So can not fall to fast path
>> -	 * while file size will be changed.
>> +	 * Compute the end of the cap in blocks directly. Near s_maxbytes the
>> +	 * cluster number of pos + OCFS2_DIO_MAX_MAP_BYTES does not fit in the
>> +	 * u32 argument of ocfs2_clusters_to_blocks(), and the truncated value
>> +	 * would make the subtraction below wrap around.
>>   	 */
>> -	if (pos + total_len <= i_size_read(inode)) {
>> +	cap_end = ((u64)pos + OCFS2_DIO_MAX_MAP_BYTES) >>
>> +			osb->s_clustersize_bits;
>> +	cap_end *= bpc;
>> +	map->len = min_t(u64, map->len, cap_end - lblk);
>>   
>> -		/* This is the fast path for re-write. */
>> -		ret = ocfs2_lock_get_block(inode, iblock, bh_result, create);
>> -		if (buffer_mapped(bh_result) &&
>> -		    !buffer_new(bh_result) &&
>> -		    ret == 0)
>> -			goto out;
>> -
>> -		/* Clear state set by ocfs2_get_block. */
>> -		bh_result->b_state = 0;
>> +	/*
>> +	 * This is the fast path for re-write.  The range which is in the file
>> +	 * has nothing to allocate nor to convert if it is mapped already. What
>> +	 * changes the file size is done at the end of io, no matter what the
>> +	 * mappings were.
>> +	 */
>> +	if (lblk < eof_blk) {
>> +		probe = *map;
>> +		probe.flags = 0;
>> +		ret = ocfs2_lock_map_blocks(inode, &probe,
>> +					    OCFS2_GET_BLOCKS_CREATE);
>> +		if (ret == 0 && (probe.flags & OCFS2_MAP_MAPPED) &&
>> +		    !(probe.flags & OCFS2_MAP_NEW)) {
>> +			*map = probe;
>> +			return 0;
>> +		}
>> +		ret = 0;
>>   	}
>>   
>> -	dwc = ocfs2_dio_alloc_write_ctx(bh_result, &first_get_block);
>> -	if (unlikely(dwc == NULL)) {
>> -		ret = -ENOMEM;
>> -		mlog_errno(ret);
>> -		goto out;
>> -	}
>> +	/* The allocation below sleeps on locks. */
>> +	if (flags & IOMAP_NOWAIT)
>> +		return -EAGAIN;
>>   
> 
> It seems the NOWAIT check should be before fast path.
> The above ocfs2_lock_map_blocks will call down_read(&oi->ip_alloc_sem),
> and may block DIO overwrite with RWF_NOWAIT, which conflicts the
> IOCB_NOWAIT semantics.
> 
> Thanks,
> Joseph
> 

I will move this condition check per the review comments.

Thanks,
Heming

>> -	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
>> -	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
>> -	    !dwc->dw_orphaned) {
>>  ... ...
>>   
> 

