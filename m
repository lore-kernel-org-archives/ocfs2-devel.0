Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705682;
	b=r/duizkIEJfD8qVuRJA72fzl3kyymrJdU/AYkThm5wtBTsbSRsUKhEjh5Aaw/sRVKHog
	 mUFIik6Y7I6lR97EOVjnD5xI15j+7Vt5tLH17iaj1emUgaPr6VBeQt2o2ar4mauOe80Al
	 0w1Ley1tH2mxQYTQwRUk7CqSa1pMaO7zv/5Pcx99l/qM4/qO/IcBXofnWab5CGgxm4vTO
	 gd5GK26oJQaWTCZsd4Ddd+Ym96JsuKHKbY6PB5KTrhGwq5Rjz+4r0qSoq1VHccl/v+7D1
	 7lSwWbUf4+ZlyJks7LICOYxwNpnC6rlhoFC5KE+Nl5MviOzRxPFenqhyrLlJw9oFF5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705682;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6BboaAeCMsWLZ469+QOBZY6aS0uzM78QrSmwXu9WVRk=;
	b=LjRgevYtqt3zuwK5N+UYGWHMfivljKtrMDisM9I+2LRZqXSODI1IGFH8xDwnIfQlsEkh
	 dpfBxAPjTpstVsMvSlHnjaCZNB5DptwagMlj9p/f/bUaQ9vBb/6aIFWhFxN7//zUeL3O1
	 QZNPW2Uehv3U9ZvDKUssIg91uptkoYAWlgDRMgXwArrsK7I0PYDelz+G97UyFhSn8FDlD
	 xImjoKfhX/BvjoY+SOoHqZ9VE08DTeR7HhNJDKcaXEhQzL29SPvXik0No7bLc6hDuyJD0
	 ybShkHKWGzaKU6Sj2QyLohmhrx5fSv8KwR3/zwoEn0zJH4CQRKQdG2W/5ixZ+vcwlGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FvrVWkGS;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2D4606A332
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Nov 2026 15:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D2D4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FvrVWkGS
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6bae06f2b8aso575687a12.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Nov 2026 07:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795705680; x=1796310480; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6BboaAeCMsWLZ469+QOBZY6aS0uzM78QrSmwXu9WVRk=;
        b=FvrVWkGSAmDD3sDEtfU28Aht38auXoVYDkTbWOCxwvyOhEKP07bEa2knb/wCAGPNs/
         ovaNdMFdXPuOvAY5OhlhBIj1XDQmr5bEGmADu9pp/2hYQcToGdTn4NVZ+2JivP7ZjP4k
         NluX7gdvGBggoJbsFqlhUGZ8bDtkTVRjeUal9NwN9sIBcTe+Pk16vJ+jscHqeQLasUlw
         x5r7Y5JkejEc9Xlh2zWKmKeKt9rxGg5WKLa5pwqNT+R7CXiYuY0hmNw4ebpG6o7ZVYYn
         DF2xCfxQeqa3oBrfKIkMZPsmWwbDv+7aRgduh45xhsEjxPKSQevjjWxFWpqs+wP7ohUG
         mMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705680; x=1796310480;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6BboaAeCMsWLZ469+QOBZY6aS0uzM78QrSmwXu9WVRk=;
        b=q0V2Xa/a3pG9MPyFf83mzDcGGexGDKPDrpAduMIZavINyHXzJskWfTb8U8E04jUxcj
         y8eicN9nEF09KT8Gql4C9kfJnnoOka6YdpWH8SLPpiUpEapIQeZLbDAXD30lbHzm90sU
         Kou0ZCUbhhKE09ofKPrlzspsDb9Xo83kiA+SZE0rq+aqGrmwMx38KPzMY9fLWZzZlNCj
         zb6nBRn/BuyGHx4EyYUBw7XzB9o64otUyu2s1CRwFlinkAJ7XeQLr9ZRo26eGb0l5uWk
         tYUO40sVy4f6/ZlsKevnyfZ7eNm3izTEUgTGM14Z9GUeV9VHWcQcNq78Q/MRh1s3c8Rw
         LpuQ==
X-Forwarded-Encrypted: i=1; AL+hErEOq18S8s9sHHVRS2gI3tqup8M+EkS4QsZ9KndHrfNqrZzlH5mX4SpxcIB+OrNskKQKPxpJ4Ulq0QS7Jg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8d3Z6I7/4EOlGowDVJ2Cx8lyvbxsUG6/wpOjTquQ7JD3nbD8Ny
	yshB38Jli7ROv7kx/uiL5XihCPN3Bs6tyHxdPeU6OwIqUo+1c2CWrCDK+xQfW9YiQbE=
X-Gm-Gg: AZFdTZcfOX0tBlvuz+kIp5nXMjgH234ghJMHZiYa7Jbl3H5Fjgd1rgE0OL3DxFvu+cV
	9wvgH7oowVOx9in7WX40In6iZmEE7kzpDo8TCArftdj+gfs714IvVTSSgUT1rkJIR4+ZtaEM6MY
	TSdXwaOOjDUmsJ2Al8W5Ny6qlhr9OP4pnq6chM9xgMZ3IfZabYL3M0WhwigtYvgNUy5zHaotvlw
	UhuW7rYWn/tCY9U1ERtkg0w8CJHxx8HgPPFiat8azvlcfOGyJGKrDnamNFRvryF2amKbj1UKy0A
	Rm9QOwQbYfUqBrwziVXV3NBR8i6xcfydLqPxA0HkVYWIEsFhEZoCqYeA/kvxaQWKj9AZ8ho9z2M
	fZSLq68gTiNQyWFtogGKJS9MLWY2DWXCTMBXLvSgArgeG7mMiUrqKZTkyrdS9LAtqxWFOIcAGUx
	jls/l3QT0cyVU2gQ+cftWs4Rz/QBOt/74SoJltv6aXUaWAFEM/FfAbxZuLw9pEuy1A5wrmpYWm+
	GcCGux8AoJgLWnyg3V2V60Tq3V87coqDWtcItykNJoivzvh7fY6+J8bWb0CkrWDxap9P5Bx8fF9
	xdbAPhRgUnD/whPJmtYuYMFhV6TXLrRJS/4=
X-Received: by 2002:a05:6402:90d:b0:6b7:dace:635d with SMTP id 4fb4d7f45d1cf-6ba37ac9214mr18662767a12.0.1795705679696;
        Thu, 26 Nov 2026 07:07:59 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee848c1sm104667515ad.10.2026.11.26.07.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 07:07:58 -0800 (PST)
Message-ID: <a9224bf6-9d1b-4fdd-9980-a70c39b11b57@suse.com>
Date: Thu, 26 Nov 2026 23:07:54 +0800
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
Subject: Re: [RFC PATCH v12 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: sashiko-reviews@lists.linux.dev
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20261125154626.22335-1-heming.zhao@suse.com>
 <20261125154626.22335-4-heming.zhao@suse.com>
 <sashiko-outbox-233793@kernel.org>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-233793@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 01:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 11 potential
> issues to consider:
> - [High] ocfs2: missing fsync tid and i_blocks update in
>    ocfs2_dio_end_io_write()
> - [High] ocfs2: buffered and mmap writes do not wait in
>    ocfs2_unwritten_check()
> - [High] ocfs2: ocfs2_dio_cleanup_range() fails on zeroed folios past
>    i_size
> - [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() for
>    uncommitted metadata
> - [High] ocfs2: orphan entry and block leak on failed or short DIO write
> - [Medium] ocfs2: overestimated metadata reservation in
>    ocfs2_write_begin_nolock() for DIO
> - [Medium] ocfs2: per-cluster multi-MB allocation thrashing on ENOSPC in
>    ocfs2_dio_wr_map_blocks()
> - [Medium] ocfs2: per-cluster w_desc kvcalloc, ip_lock scans, and
>    duplicate lookups in DIO
> - [Medium] ocfs2: preallocated extents truncated in
>    ocfs2_dio_clear_orphan_locked()
> - [Medium] ocfs2: stale inode state after lock drop in
>    ocfs2_dio_upgrade_rw_lock()
> - [Medium] ocfs2: ocfs2_should_use_dio() forces buffered I/O for
>    sub-page DIO overwrites
> --
>

It feels like the more code I modified, the more issues I introduced.
Furthermore, Sashko has started reporting performance issues.
  
> commit fa968d70c6dc4fa539dd85a04ae0aae1e4ffeefa
> Author: Heming Zhao <heming.zhao@suse.com>
> 
> ocfs2: switch dio write path from buffer_head to iomap
> 
> This commit converts the OCFS2 direct I/O write path from the buffer_head
> infrastructure to iomap, allowing multi-cluster mappings up to 16MB and
> handling unwritten extent conversion, EOF zeroing, and orphan management
> around __iomap_dio_rw().
> 
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 21cdc5c29331d..197347d14d27f 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
> [ ... ]
>> @@ -914,10 +967,46 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
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
> 
> [Severity: Medium]
> Does a direct write need a per-cluster w_desc[] entry when
> ocfs2_dio_wr_map_blocks() has already clamped map->len via
> ocfs2_map_blocks() to a single contiguous hole or extent?
> 
> With 4KB clusters and a 16MB mapping (OCFS2_DIO_MAX_MAP_BYTES), wc->w_clen
> is 4096, so every mapping call allocates and frees a 96KB (order-5) array
> under ocfs2_inode_lock() and ip_alloc_sem.  ocfs2_populate_write_desc()
> then calls ocfs2_unwritten_check() on all 4096 descriptors, acquiring and
> releasing oi->ip_lock to scan oi->ip_unwritten_list 4096 times (even on
> holes where desc->c_new is 1), and ocfs2_write_clusters_direct()
> redundantly loops over wc->w_clen calling ocfs2_get_clusters() again even
> when c_new is 0 and ocfs2_populate_write_desc() already populated c_phys.
> 

like my v11 writing, this is performance issue, fix it in another patch set.

> [ ... ]
> 
>> @@ -1376,74 +1723,210 @@ static void ocfs2_set_target_boundaries(struct ocfs2_super *osb,
> [ ... ]
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
> 
> [Severity: High]
> Can a buffered write or mmap page_mkwrite fault lose data or expose
> uninitialized disk blocks when it hits an in-flight entry on
> oi->ip_unwritten_list?
> 
> Unlike ocfs2_dio_wr_map_blocks(), buffered writes and
> __ocfs2_page_mkwrite() do not wait on oi->ip_unwritten_wq.  Instead,
> ocfs2_unwritten_check() clears c_needs_zero and c_clear_unwritten, relying
> on the in-flight direct write to zero the cluster and convert the extent.
> In the new iomap path, ocfs2_dio_wr_map_blocks() records up to 16MB of
> unwritten clusters and drops ip_alloc_sem and ocfs2_inode_lock() before
> user pages are pinned or bios are submitted (__ocfs2_page_mkwrite() never
> takes inode_lock() or rw_lock, and async non-extending direct writes drop
> inode_lock() while in flight):
> 
> CPU0 (async DIO write)            CPU1 (mmap fault or buffered write)
> ocfs2_dio_wr_map_blocks()
>    ocfs2_write_begin_nolock()
>      ocfs2_dio_add_unwritten()
>    up_write(&oi->ip_alloc_sem)
>    ocfs2_inode_unlock()
>                                    __ocfs2_page_mkwrite()
>                                      ocfs2_write_begin_nolock()
>                                        ocfs2_unwritten_check()
>                                          c_needs_zero = 0
>                                          c_clear_unwritten = 0
>                                      /* skips ocfs2_mark_extent_written() */
> ocfs2_dio_end_io() (error != 0)
>    ocfs2_dio_cleanup_pages()
>      filemap_write_and_wait_range()
>      invalidate_inode_pages2_range()
>      /* extent stays unwritten; CPU1's data is discarded */
> 
> Furthermore, when s_clustersize > PAGE_SIZE, ocfs2_grab_folios_direct()
> only zeroes folios up to max(user_pos + user_len, i_size) and skips
> [target_index, end_index], so a concurrent buffered write into the rest of
> that cluster with c_needs_zero = 0 skips zeroing and leaves uninitialized
> disk blocks exposed once the direct write converts the cluster.
> 

existing issue, won't fix it.

> [ ... ]
> 
>> @@ -1777,6 +2305,18 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
> [ ... ]
>>   	if (clusters_to_alloc || extents_to_split) {
>>   		/*
>>   		 * XXX: We are stretching the limits of
>>   		 * ocfs2_lock_allocators(). It greatly over-estimates
>>   		 * the work to be done.
>>   		 */
>>   		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
>>   					      wc->w_di_bh);
>>   		ret = ocfs2_lock_allocators(inode, &et,
>>   					    clusters_to_alloc, extents_to_split,
>>   					    &data_ac, &meta_ac);
> 
> [Severity: Medium]
> Does passing clusters_to_alloc to ocfs2_lock_allocators() over-reserve
> metadata blocks for multi-cluster direct writes?
> 
> ocfs2_dio_alloc_clusters() calls ocfs2_add_inode_data() only once for a
> single contiguous cluster range, so an OCFS2_WRITE_DIRECT call inserts at
> most one extent record.  However, ocfs2_lock_allocators() computes
> max_recs_needed = clusters_to_add + 2 * extents_to_split assuming each
> cluster needs its own extent record.  Because a dinode holds at most 243
> inline extent records (and an extent block 252), any allocating direct
> write of 253 or more clusters (about 1MB with 4KB clusters) exceeds
> num_free_extents and forces ocfs2_reserve_new_metadata() to lock
> EXTENT_ALLOC_SYSTEM_INODE and reserve metadata blocks even when the dinode
> has plenty of free inline extent records.
> 

the new iomap direct write code only has 1 extent per calling, so fix this by
passing 0 or 1 as the extents_to_split parameter to ocfs2_lock_allocators()
on the direct write path.

> [ ... ]
> 
>> @@ -2151,130 +2733,243 @@ static int ocfs2_write_end(const struct kiocb *iocb,
> [ ... ]
>> +static void ocfs2_dio_cleanup_range(struct inode *inode, loff_t start,
>> +				    loff_t end)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	loff_t csize = ocfs2_clusters_to_bytes(inode->i_sb, 1);
>> +	int ret;
>> +
>> +	if (start >= end)
>> +		return;
>> +
>> +	start &= ~(csize - 1);
>> +	end = (end + csize - 1) & ~(csize - 1);
>> +
>> +	ret = filemap_write_and_wait_range(mapping, start, end - 1);
>> +	if (ret < 0)
>> +		mlog_errno(ret);
>> +
>> +	ret = invalidate_inode_pages2_range(mapping, start >> PAGE_SHIFT,
>> +					    (end - 1) >> PAGE_SHIFT);
>> +	/*
>> +	 * -EBUSY only means a page was redirtied (by a faulting mmap) after
>> +	 * the writeback; it is not ours to drop anymore.
>> +	 */
>> +	if (ret < 0 && ret != -EBUSY)
>> +		mlog_errno(ret);
>> +}
> 
> [Severity: High]
> Does ocfs2_dio_cleanup_range() fail to write out and invalidate zeroed
> head folios that sit at or beyond i_size?
> 
> When s_clustersize > PAGE_SIZE and an extending direct write into a hole
> or unwritten cluster starts at a non-cluster-aligned page offset past
> i_size (for example, i_size = 0, s_clustersize = 16KB, user_pos = 4KB),
> ocfs2_grab_folios_direct() and ocfs2_write_end_nolock() dirty the head
> folio at offset 0 and its buffer_heads while leaving i_size at 0.  If the
> direct write then fails and runs ocfs2_dio_cleanup_range(),
> filemap_write_and_wait_range() clears the folio dirty flag, but
> __mpage_writepage() and block_write_full_folio() refuse to write folios at
> folio_pos(folio) >= i_size_read(inode) and leave BH_Dirty set on the
> buffer_heads.  invalidate_inode_pages2_range() -> drop_buffers() then sees
> buffer_busy(bh) and fails with -EBUSY (which is ignored here), leaving the
> unwritten zeroes off disk and a folio with dirty buffer_heads stuck in the
> page cache past i_size.
> 

This issue is only triggered in error-handling paths, so I believe the impact
is minor. Also, I'm not very familiar with folios and the page cache, and this
part code was written with AI assistance. I plan to try one more revision;
if that still doesn't work, I'll revert this whole part.

> [ ... ]
> 
>> @@ -2285,95 +2980,222 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
> [ ... ]
>> +	ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
>> +				       OCFS2_WRITE_DIRECT, NULL,
>> +				       (void **)&wc, di_bh, NULL, owner);
>> +	if (ret == -ENOSPC &&
>> +	    ocfs2_clusters_for_bytes(inode->i_sb, pos + len) >
>> +	    ocfs2_bytes_to_clusters(inode->i_sb, pos) + 1) {
>> +		/*
>> +		 * There is not room for all of it, but maybe there is for
>> +		 * some, take the first cluster.
>> +		 */
>> +		len = min_t(loff_t, len, osb->s_clustersize -
>> +				(pos & (osb->s_clustersize - 1)));
>> +		goto again;
>> +	}
> 
> [Severity: Medium]
> When the filesystem has fewer free clusters than the requested mapping
> size (up to 16MB), doesn't falling back to a single cluster only for the
> current mapping cause every subsequent cluster in the write to repeat the
> failed multi-megabyte allocation?
> 
> On the next ->iomap_begin() call, the remaining request and the free
> space have both shrunk by one cluster, so ocfs2_write_begin_nolock() hits
> -ENOSPC again after sliding the local alloc window, locking
> GLOBAL_BITMAP_SYSTEM_INODE, and flushing the truncate log twice on every
> single cluster.  Also, if the user's remaining quota is smaller than the
> multi-cluster mapping size, dquot_alloc_space_nodirty() returns -EDQUOT,
> which bypasses this fallback and fails the write immediately.
> 

next version: remove the "ret == -ENOSPC" then "goto again" code area.

> [ ... ]
> 
>> +static void ocfs2_dio_clear_orphan_locked(struct inode *inode,
>> +				   struct buffer_head *di_bh)
>> +{
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>> +	loff_t end = READ_ONCE(oi->ip_dio_orphan_end);
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * The write has not reached the end it asked for. Free whatever it
>> +	 * allocated beyond i_size before the orphan entry.
>> +	 */
>> +	if (i_size_read(inode) < end)
>> +		ret = ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
> 
> [Severity: Medium]
> As noted in the TODO comment above this function, if a file has unwritten
> extents preallocated beyond i_size via fallocate(FALLOC_FL_KEEP_SIZE),
> won't an extending direct write that ends short, bails out before I/O
> submission, or bounces to buffered I/O on -ENOTBLK and writes short
> truncate away all pre-existing preallocated clusters beyond i_size?
> 
> In addition, ocfs2_file_write_iter() adds the inode to the slot's global
> orphan directory whenever iocb->ki_pos + count extends past i_size's
> cluster, even when preallocated clusters already cover the range and no
> new clusters will be allocated, and calling ocfs2_truncate_file() on an
> early bailout updates i_mtime and i_ctime on disk even when no data was
> written.
> 

record this issue in TODO. won't fix it.

> [ ... ]
> 
>> @@ -2386,54 +3208,109 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> [ ... ]
>> +				ret = ocfs2_mark_extent_written(inode, &et,
>> +						handle, cpos, num, phys,
>> +						meta_ac, &dealloc);
>> +				if (ret < 0) {
>> +					mlog_errno(ret);
>> +					goto commit;
>> +				}
>> +				cpos += num;
>> +
>> +				if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
>> +					ocfs2_commit_trans(osb, handle);
>> +					handle = NULL;
>> +					batch = 0;
>> +				}
>> +			}
>> +		}
>> +
>> +		if (pass == 0) {
>> +			if (extents_to_split) {
>> +				ret = ocfs2_lock_allocators(inode, &et, 0,
>> +						extents_to_split * 2,
>> +						&data_ac, &meta_ac);
>> +				if (ret) {
>> +					mlog_errno(ret);
>> +					goto unlock;
>> +				}
>> +			}
>> +			credits = ocfs2_calc_extend_credits(inode->i_sb,
>> +							    &di->id2.i_list);
>> +		}
>> +	}
>>   
>>   	if (end > i_size_read(inode)) {
>>   		if (!handle) {
>>   			handle = ocfs2_start_trans(osb, credits);
>>   			if (IS_ERR(handle)) {
>>   				ret = PTR_ERR(handle);
>> +				handle = NULL;
>>   				mlog_errno(ret);
>>   				goto unlock;
>>   			}
>>   		}
>>   		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>>   		if (ret < 0)
>>   			mlog_errno(ret);
>>   	}
>>   
>>   commit:
>>   	if (handle)
>>   		ocfs2_commit_trans(osb, handle);
> 
> [Severity: High]
> When a direct write allocates clusters into a hole or converts unwritten
> extents within i_size (end <= i_size_read(inode)), does this miss updating
> oi->i_sync_tid, oi->i_datasync_tid, and inode->i_blocks?
> 
> ocfs2_write_end_nolock() skips updating i_blocks and calling
> ocfs2_update_inode_fsync_trans() for OCFS2_WRITE_DIRECT, and
> ocfs2_dio_end_io_write() only calls ocfs2_set_inode_size() (which updates
> i_blocks and calls ocfs2_mark_inode_dirty() ->
> ocfs2_update_inode_fsync_trans()) when end > i_size_read(inode) (and even
> then, earlier transactions committed by the OCFS2_DIO_MARK_EXTENT_BATCH
> loop are committed without updating the fsync tids).  Because
> ocfs2_file_write_iter() now delegates O_DSYNC on direct writes to
> iomap_dio_complete() -> generic_write_sync() -> ocfs2_sync_file(),
> ocfs2_sync_file() checks a stale i_datasync_tid / i_sync_tid and returns
> without committing the journal transaction that allocated or converted the
> extents, so a crash after O_DSYNC / fsync() can revert the written range
> to a hole or unwritten extent.
> 
> Also, when s_clustersize > PAGE_SIZE and a direct write only covers part
> of a newly allocated or unwritten cluster, the zeroed head and tail folios
> outside [offset, offset + size) are dirtied in the page cache, but
> generic_write_sync() only flushes [offset, offset + size - 1], leaving the
> zeroed head and tail pages of the converted cluster unflushed after
> O_DSYNC / O_SYNC.
> 

try to fix it in next version.

> [ ... ]
> 
>> @@ -2567,10 +3382,20 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>   	map.flags = 0;
>>   
>>   	if (flags & IOMAP_WRITE) {
>> -		return -EOPNOTSUPP;
>> +		/*
>> +		 * Writes that span EOF might trigger an IO size update on
>> +		 * completion, so consider them to be dirty for the purposes
>> +		 * of O_DSYNC even if there is no other metadata changes
>> +		 * pending or have been made here.
>> +		 */
>> +		if (offset + length > i_size_read(inode))
>> +			iomap->flags |= IOMAP_F_DIRTY;
>> +
>> +		ret = ocfs2_dio_wr_map_blocks(inode, &map, flags, owner);
> 
> [Severity: High]
> Should ocfs2_iomap_begin() also set IOMAP_F_DIRTY when the inode has
> uncommitted metadata changes in the journal?
> 
> For an O_DSYNC / RWF_DSYNC overwrite within i_size,
> ocfs2_prepare_inode_for_write() may have just broken sharing via
> ocfs2_refcount_cow() in a JBD2 transaction without committing the journal
> (or the inode may have an uncommitted transaction in oi->i_datasync_tid).
> ocfs2_dio_wr_map_blocks() then maps the CoW'd extent as OCFS2_MAP_MAPPED
> without OCFS2_MAP_NEW.  Without IOMAP_F_DIRTY, iomap uses
> IOMAP_DIO_WRITE_THROUGH (REQ_FUA) on capable devices, clears
> IOMAP_DIO_NEED_SYNC, and skips generic_write_sync(), while
> ocfs2_file_write_iter() skips jbd2_journal_force_commit() because use_dio
> is true, returning from an O_DSYNC write with the CoW extent tree changes
> uncommitted in JBD2.

ext4 uses ext4_inode_datasync_dirty() to check ->i_datasync_tid.
I will follow the ext4 style to fix it .

> 
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 3d717200d53a4..18aee5372eebe 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
> [ ... ]
>> @@ -2417,9 +2426,52 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
>>   	    !ocfs2_supports_append_dio(osb))
>>   		return false;
>>   
>> +	/*
>> +	 * A direct write which does not cover whole pages leaves the rest of
>> +	 * the page untouched. iomap only zeroes the padding up to the file
>> +	 * system block size, so on a file system with a block size smaller
>> +	 * than the page size the untouched blocks would expose stale data
>> +	 * once the cluster is marked written. Let buffered I/O handle it.
>> +	 *
>> +	 * TODO: Avoid unnecessarily demoting in-place sub-page overwrites
>> +	 * to buffered I/O when i_blocksize(inode) < PAGE_SIZE.
>> +	 */
>> +	if (iov_iter_rw(iter) == WRITE && i_blocksize(inode) < PAGE_SIZE &&
>> +	    (!IS_ALIGNED(iocb->ki_pos, PAGE_SIZE) ||
>> +	     !IS_ALIGNED(iocb->ki_pos + iter->count, PAGE_SIZE)))
>> +		return false;
> 
> [Severity: Medium]
> Doesn't rejecting all sub-page O_DIRECT writes in ocfs2_should_use_dio()
> before block mapping cause a regression for in-place overwrites when
> i_blocksize(inode) < PAGE_SIZE (including all 4KB-block filesystems on
> 16KB or 64KB PAGE_SIZE kernels)?
> 
> Overwriting already-written extents within i_size does not zero or convert
> clusters, yet returning false here forces an exclusive EX cluster rw_lock
> instead of PR under coherency=buffered, causes IOCB_NOWAIT sub-page
> overwrites to fail with -EAGAIN, and routes every sub-page overwrite
> through buffered I/O, JBD2 transactions, and synchronous page-cache
> writeback and invalidation.  Could ocfs2_dio_wr_map_blocks() return
> -ENOTBLK only when a sub-page write actually hits a hole or unwritten
> extent?
> 

already record in TODO, won't fix it.

>> +
>>   	return true;
>>   }
>>   
>> +/*
>> + * A direct write holds the rw lock PR under coherency=buffered, but when it
>> + * ends up doing a buffered write, that write has to hold EX like any other
>> + * buffered write: with only PR another node's direct write can run at the
>> + * same time, and the read-modify-write this one does in the page cache races
>> + * with it.  The direct io is finished by now, nothing is in flight, so drop
>> + * the PR and take EX instead of upgrading in one request, which can deadlock
>> + * in the cluster lock manager when two nodes upgrade at once.
>> + */
>> +static int ocfs2_dio_upgrade_rw_lock(struct inode *inode, int *rw_level)
>> +{
>> +	int ret;
>> +
>> +	if (*rw_level != 0)
>> +		return 0;
>> +
>> +	ocfs2_rw_unlock(inode, 0);
>> +	*rw_level = -1;
>> +
>> +	ret = ocfs2_rw_lock(inode, 1);
>> +	if (ret < 0) {
>> +		mlog_errno(ret);
>> +		return ret;
>> +	}
>> +	*rw_level = 1;
>> +	return 0;
>> +}
> [ ... ]
>> @@ -2519,6 +2586,29 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>>   		goto out;
>>   	}
>>   
>> +	/*
>> +	 * generic_write_checks() has moved ki_pos to i_size for O_APPEND and
>> +	 * clamped the length, and ocfs2_prepare_inode_for_write() has
>> +	 * refreshed i_size and the inode flags under the cluster lock.  The
>> +	 * decisions taken before them can be stale, take them again with what
>> +	 * the I/O is actually going to use.
>> +	 */
>> +	if (direct_io) {
>> +		use_dio = ocfs2_should_use_dio(iocb, from, inode);
>> +
>> +		/* An extending write has to hold the rw lock EX */
>> +		if (use_dio && rw_level == 0 && !nowait &&
>> +		    iocb->ki_pos + count > i_size_read(inode)) {
>> +			ret = ocfs2_dio_upgrade_rw_lock(inode, &rw_level);
>> +			if (ret)
>> +				goto out;
>> +		}
>> +	}
> 
> [Severity: Medium]
> When ocfs2_dio_upgrade_rw_lock() drops the PR rw_lock and takes EX here,
> can another node modify the file while no cluster lock is held on this
> inode?
> 
> generic_write_checks() and ocfs2_prepare_inode_for_write() have already
> run and released ocfs2_inode_lock().  During the window where rw_lock is
> dropped, another node can truncate, extend, or reflink the file; taking
> ocfs2_rw_lock(inode, 1) does not refresh inode->i_size or invalidate
> ip_extent_map, and on an extending write within the last allocated cluster
> on a sparse volume, neither ocfs2_add_inode_to_orphan() nor
> ocfs2_dio_zero_eof() nor the rewrite fast path in
> ocfs2_dio_wr_map_blocks() takes ocfs2_inode_lock() again, so the write can
> proceed with stale cached extents or un-CoW'd reflinked blocks.
> 

I don't have a perfect solution. In my view, keeping the old buffer_head
path style (not doing cluster lock conversion in any case) is acceptable.
I will remove the new api ocfs2_dio_upgrade_rw_lock() and all the cluster
lock conversion code.

> [ ... ]
> 
>> @@ -2571,11 +2781,30 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
>>   	}
>>   
>>   out:
>> +	/*
>> +	 * IOMAP_DIO_FORCE_WAIT made an extending dio complete synchronously,
>> +	 * so its end_io has already updated i_size.
>> +	 */
>>   	if (saved_ki_complete)
>>   		xchg(&iocb->ki_complete, saved_ki_complete);
>>   
>> -	if (rw_level != -1)
>> +	if (rw_level != -1) {
>> +		/*
>> +		 * The orphan entry this write added is still there when no io
>> +		 * was issued at all, or when the write bailed out before
>> +		 * submitting it. The conversion in ocfs2_dio_end_io_write()
>> +		 * has removed it on the success path; a failed io is left to
>> +		 * the recovery. Remove it here for the former, while the
>> +		 * rw_lock is still held
>> +		 */
>> +		ocfs2_dio_clear_orphan(inode);
>>   		ocfs2_rw_unlock(inode, rw_level);
>> +	}
>> +
>> +	/* The marker must not outlive this write. */
>> +	if (READ_ONCE(OCFS2_I(inode)->ip_dio_orphan_pid) ==
>> +	    task_pid_nr(current))
>> +		WRITE_ONCE(OCFS2_I(inode)->ip_dio_orphan_pid, 0);
> 
> [Severity: High]
> Does an extending direct write that fails inside __iomap_dio_rw() (or
> completes short at or below i_size without unwritten records) leak its
> orphan directory entry and any clusters allocated beyond i_size?
> 
> Once __iomap_dio_rw() passes kiocb_invalidate_pages() and calls
> inode_dio_begin(), any failure in ocfs2_dio_wr_map_blocks() (-ENOSPC,
> -EDQUOT, -ENOMEM), bio_iov_iter_get_pages() (-EFAULT, which is also not
> caught by the pre-fault check at ki_pos > i_size when appending at
> ki_pos == i_size), or bio execution (-EIO) goes through
> iomap_dio_complete() -> ocfs2_dio_end_io().  Because error != 0 (or on a
> short write where offset + size <= i_size and unwritten is empty),
> ocfs2_dio_end_io() skips ocfs2_dio_end_io_write(), unlocks rw_lock, and
> returns a non-zero value, which sets rw_level = -1 in
> ocfs2_file_write_iter().  As a result, ocfs2_dio_clear_orphan() is skipped
> both in ocfs2_dio_end_io() and here at out:, leaving any newly allocated
> clusters attached beyond i_size and leaving OCFS2_DIO_ORPHANED_FL set on
> the dinode.
> 
> When that file is later unlinked, ocfs2_delete_inode() bails out on
> OCFS2_DIO_ORPHANED_FL without wiping the inode, and background orphan
> scans skip dio- orphan entries (ORPHAN_NO_NEED_TRUNCATE), leaking the
> inode and its blocks until unmount or crash recovery:
> 
> fs/ocfs2/inode.c:ocfs2_delete_inode() {
>      ...
> 	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
> 		ocfs2_cleanup_delete_inode(inode, 0);
> 		goto bail_unlock_inode;
> 	}
>      ...
> }
> 
> Since extending writes always set IOMAP_DIO_FORCE_WAIT and complete in
> process context, ocfs2_dio_end_io() can safely clean up the orphan entry
> before dropping rw_lock whenever ip_dio_orphan_pid matches.
> 

won't fix it.

Thanks,
Heming
