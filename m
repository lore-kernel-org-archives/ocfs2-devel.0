Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621214;
	b=d3IeHc9KckQY//ek+/5+wwPRjpW3ZdmkBvLlSWlqr4QvXddQ5ro4KRq+sQvdEXvJOaBe
	 i1GmnQvRK4bvhRbSb6vTnQPjz+rdTeFq8DeX8l2JnBQXEDYeMOIksMYct9ihuuF8GCprq
	 EJb6J/AEK0DSxig0xhXnZG1083tJ1lTa3iwExE7nAvJ+kENsq1aqLLEBc2FxrAGxlXbm3
	 zf8ChjPUAIRlds7ip2g6CmDKEdmc68Zn14k2ec5MbN4ib1LJO+Cuy1eMCrH1fCVuXOyBr
	 5u2VXhUqR7sqQhk+vCrEMI/waTryxCdsjNTK5szq5AsLe0KgXUZyNkHnkG9WfFouZrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8tZOjDzIzRQ+YNPH/G14KBjcMmO9tjDHEX30WObku84=;
	b=RyMi5jero0SBc1rcIFdW3gZ9TloSd3Z3wtkqdyq0zwHrU7q0hISqksw732cOhq9ADv3P
	 IV6vwX+MP8+6pZz9fypUfdYz6Y98HHuYO3IsS5TdlCaz/xfxFb0P6mAKBcd34D/4OHcVa
	 Mtuih62bPqAiUY19VBaNydMYq1/uRlslXUvIktrNpLyikIbt9UVES7q3eGzbNrKMbcFSy
	 dhH0jQASiNQOFVDEj9wkpzrQdQMt80RAz367EGU1xFNMCefXvtIbdS/KV8BdlCmbA9Cnt
	 492tJP+wb+GaH4KDHCAsRwNoUWB7ovLneaqsgjoi5mLN494i4fxdBeMWxEe57wdG2Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Kt4ae4T7;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E960A5BE8
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 15:40:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 961E960A5BE8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Kt4ae4T7
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c407213696aso85305866b.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 07:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795621212; x=1796226012; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8tZOjDzIzRQ+YNPH/G14KBjcMmO9tjDHEX30WObku84=;
        b=Kt4ae4T7Pqjo+Z4CM0GB3t/lkgvBxayf6UbtOG/iPFInz752uToLFvYB0s1dwLnPrK
         L2Iw+vl5JsLSKos36Smxm+h8zyQEdFzGDGZXhoI31Wh6D3beubKxbEDJrKTUB78lBWL9
         OQcy2hPu6Kakklh+kVIOZcgZM7QsHw9vUnQeD3KwdDJJQMgMrmXrL4ZKZs9imLr59zG/
         Tkvyk0su/ORiD63wm9efy6WrVjLdvG+c7cL3sEYsf32q1814jT4nvDsgcHnG8QHHchiI
         ZBkRfIfO/9OVPAAGhmTePheUEy+chEjjtKIz0V+xbnREQEsNlWxibMfxfsbaEVypjkAd
         Gpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621212; x=1796226012;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8tZOjDzIzRQ+YNPH/G14KBjcMmO9tjDHEX30WObku84=;
        b=h0ky3IBH7PizMBDa2CkooqO0hs+BwmG9TzksbUHrpOT35o2SoUbXAOxyz1W9abDgjZ
         MwS9va7plxsg5X8/Lldu9iXLOzzX8htXdolvpSSJo4t2CIKbjVKCfLePsH1KflSI7eDS
         2c+zyYDpKurJH+M9CcFU4/Y46aovkQ59LqfcAk4zArHw1+uQ/Z99kXK4u0jRjdzQx584
         w4NgO5vMEMnEzWnIPBH3PQEqG52wlsp8EI4aUaooV9n2SUQ60tdNvZMaI20tM2QwGW05
         qh3+6mhR7fGgP6Y9wUrv7XvaDtL/xTeaCyM3FaeMzEn/Aii1holnezGb6jtMD2cpQe1V
         IknA==
X-Forwarded-Encrypted: i=1; AL+hErFoBJcr2uvct0fmDoeDS6oMUJA6DAk7hWZg8yiusuDZ2DBxF5oD8WYhunV2IGNI5SLfKZUIK4HBqxeUVw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/GvOx0Dj4im8G4LZT7l3Oq2TAnNjT0Wq7Vl4kJx94H+EDmonY9
	b+Sx76BOJiIt6yZRi3SJ6/IMH4YgxZu7S58POflLnIe9Oz+AfT2W/OEEw2IzXN/AfFbnHtXqp3o
	q59ix+Yw=
X-Gm-Gg: AZFdTZeAIZsrF5Mm1TMBRfPkeJu9UOyBV5HXYOIhBXz71yZl/lpfL6lvdP3hpNaChQj
	j4nzvOrpqHlkQmqTJfwRVkf1JtlSjziqDO0rq+UYyync/yPObQRn1lm1Dn0hPAgn89AazpsokxD
	sPBfS/xtn1HcwavxVyVuxrwt0n8X9gOcu5tea7jgunxuwuYIh5yUwMUFJPM3EhAdx3KwdgnlwPA
	gEeYGTbtaPFJKRVKNETnoEGbUfwkj0NqUzLgqYTveCy5kuSIrY8BElpVwYpIeUgKfLm22RyWerE
	NkA0IYPL9VNvVjKj+e93zz66xry7gmuTsQZFOaC56zb4uYhHyFOeew/pHyT6LWfip7K2y8VW+xj
	1LVYsDjYtYCKqI1yv//8TgxCSXApJL3GvwmHZtX2fYCxhnPDoGlGPUb6LVgGAzYA2+MbHl0sSfa
	YlvcSvonuBRxKf1FKSlRXFpEbi3kMqehCYQku3RKoWiGR4FnvAW+2mmYnLrv9q7I4NAIjUl74bn
	wvOQ1IAa2FAv601OCVf5zulaMWvsYiZxtd0J0qBP6/qlGipVzeX5uRd1N3TqGuVB4ranbEuGgN/
	8bz7tStxPgkpKZtsvj8C98hKH4zlBqGpzCM=
X-Received: by 2002:a17:906:811:b0:c51:356c:2657 with SMTP id a640c23a62f3a-c513a567c14mr1470360766b.3.1795621211677;
        Wed, 25 Nov 2026 07:40:11 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d026d6fsm9107078a12.19.2026.11.25.07.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 07:40:10 -0800 (PST)
Message-ID: <68eb76a8-338e-4894-8695-437bfa09888f@suse.com>
Date: Wed, 25 Nov 2026 23:40:05 +0800
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
Subject: Re: [RFC PATCH v11 3/3] ocfs2: switch dio write path from buffer_head
 to iomap
To: Joseph Qi <joseph.qi@linux.alibaba.com>, sashiko-reviews@lists.linux.dev
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20261124152623.7838-1-heming.zhao@suse.com>
 <20261124152623.7838-4-heming.zhao@suse.com>
 <sashiko-outbox-231534@kernel.org>
 <7cf75ca9-ff9e-4cca-a043-8881706bee98@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <7cf75ca9-ff9e-4cca-a043-8881706bee98@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/25/26 19:01, Joseph Qi wrote:
> Hi,
> 
> On 11/25/26 12:11 AM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 7 potential
>> issues to consider:
>> - [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() skips
>>    O_DSYNC JBD2 commit
>> - [High] ocfs2: partial DIO failure in ocfs2_dio_end_io() skips
>>    unwritten conversion
>> - [High] ocfs2: buffered and mmap writes do not wait in
>>    ocfs2_unwritten_check()
>> - [High] ocfs2: orphan entry and block leak on failed or short DIO write
>> - [Medium] ocfs2: preallocated extents truncated in
>>    ocfs2_dio_clear_orphan_locked()
>> - [Medium] ocfs2: per-cluster kvcalloc and ip_lock scan in
>>    ocfs2_alloc_write_ctxt()
>> - [Medium] ocfs2: ocfs2_should_use_dio() forces buffered I/O for
>>    sub-page DIO overwrites
> 
> Seems the above Sashiko review comments are mostly new. > 
>> --
>>
>> commit b5b57d5ded817baa5742865c157d167ab85796b4
>> Author: Heming Zhao <heming.zhao@suse.com>
>>
>> ocfs2: switch dio write path from buffer_head to iomap
>>
>> This commit converts the OCFS2 direct I/O write path from the legacy
>> buffer_head infrastructure to the iomap framework, mapping multi-cluster
>> extents in ocfs2_dio_wr_map_blocks() and handling unwritten extent
>> conversion and i_size updates in ocfs2_dio_end_io().
>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index 21cdc5c29331d..7a0778914d69b 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>
>> [ ... ]
>>
>>> @@ -914,10 +967,46 @@ static int ocfs2_alloc_write_ctxt(struct ocfs2_write_ctxt **wcp,
>>>   	if (!wc)
>>>   		return -ENOMEM;
>>>   
>>> +	wc->w_desc = wc->w_desc_inline;
>>> +	wc->w_folios = wc->w_folios_inline;
>>> +	wc->w_owner = owner;
>>>   	wc->w_cpos = pos >> osb->s_clustersize_bits;
>>>   	wc->w_first_new_cpos = UINT_MAX;
>>>   	cend = (pos + len - 1) >> osb->s_clustersize_bits;
>>>   	wc->w_clen = cend - wc->w_cpos + 1;
>>> +
>>> +	/*
>>> +	 * Only a direct write can span more clusters than fit in a page.
>>> +	 * It needs the folios of the first and of the last cluster at most,
>>> +	 * see ocfs2_grab_folios_for_write().
>>> +	 */
>>> +	if (wc->w_clen > ARRAY_SIZE(wc->w_desc_inline)) {
>>> +		if (WARN_ON_ONCE(type != OCFS2_WRITE_DIRECT)) {
>>> +			ocfs2_release_write_ctxt(wc);
>>> +			return -EINVAL;
>>> +		}
>>> +		wc->w_desc = kvcalloc(wc->w_clen, sizeof(*wc->w_desc),
>>> +				      GFP_NOFS);
>>> +		if (!wc->w_desc) {
>>> +			wc->w_desc = wc->w_desc_inline;
>>> +			ocfs2_release_write_ctxt(wc);
>>> +			return -ENOMEM;
>>> +		}
>>> +	}
>>
>> [Severity: Medium]
>> Does a direct write need to allocate one ocfs2_write_cluster_desc per
>> cluster in wc->w_desc and call ocfs2_unwritten_check() on every cluster?
>>
>> Before calling ocfs2_write_begin_nolock(), ocfs2_dio_wr_map_blocks()
>> already clamps map->len with ocfs2_map_blocks() to a single contiguous
>> extent record or hole.  With 4KB clusters and a 16MB mapping
>> (OCFS2_DIO_MAX_MAP_BYTES), wc->w_clen is 4096, so every mapping call
>> allocates and frees a 96KB (order-5) array under ocfs2_inode_lock() and
>> ip_alloc_sem, and ocfs2_populate_write_desc() takes oi->ip_lock 4096 times
>> to scan oi->ip_unwritten_list (even for holes where c_new is 1).
>>

This is performance issue. The fio results show that the patched code achieves
the same speed/bandwidth as the original code.
Let's do it in another patch set.

>> [ ... ]
>>
>>> +static void ocfs2_unwritten_check(struct inode *inode,
>>> +				  struct ocfs2_write_ctxt *wc,
>>> +				  struct ocfs2_write_cluster_desc *desc)
>>>   {
>>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>> +	struct ocfs2_unwritten_extent *ue;
>>> +
>>> +	if (!desc->c_needs_zero)
>>> +		return;
>>> +
>>> +	spin_lock(&oi->ip_lock);
>>> +	ue = ocfs2_find_unwritten(oi, desc->c_cpos);
>>> +	/* A hole (c_new is 1) can not be on the list, don't trust it if it is. */
>>> +	if (ue && !WARN_ON_ONCE(desc->c_new)) {
>>>   		/*
>>> +		 * Needs not to zero no matter buffer or direct. The one who is
>>> +		 * zero the cluster is doing zero. And he will clear unwritten
>>> +		 * after all cluster io finished.
>>>   		 */
>>> +		desc->c_needs_zero = 0;
>>> +		desc->c_clear_unwritten = 0;
>>> +		/* match its own entry */
>>> +		if (wc->w_type == OCFS2_WRITE_DIRECT && wc->w_owner &&
>>> +		    ue->ue_owner == wc->w_owner)
>>> +			desc->c_dio_unwritten = 1;
>>> +		else
>>> +			/*
>>> +			 * Not ours. A direct write never gets here, it waits
>>> +			 * for the entries of the other dios before it maps,
>>> +			 * see ocfs2_dio_wr_map_blocks().
>>> +			 */
>>> +			WARN_ON_ONCE(wc->w_type == OCFS2_WRITE_DIRECT);
>>> +	} else if (wc->w_type == OCFS2_WRITE_DIRECT) {
>>> +		/* This direct write will doing zero. */
>>> +		desc->c_clear_unwritten = 0;
>>>   	}
>>>   	spin_unlock(&oi->ip_lock);
>>> +}
>>
>> [Severity: High]
>> What happens when a buffered write or mmap page_mkwrite fault hits a
>> cluster that an in-flight direct write has placed on
>> oi->ip_unwritten_list?
>>
>> Unlike ocfs2_dio_wr_map_blocks(), which waits on oi->ip_unwritten_wq for
>> foreign unwritten entries to finish, buffered and mmap writes clear
>> desc->c_needs_zero and desc->c_clear_unwritten here and proceed assuming
>> the direct write has zeroed the cluster and will convert it to written:
>>
>> 1. If the in-flight direct write later fails (for example with -EFAULT on
>>     a subsequent mapping) or ends short before this cluster,
>>     ocfs2_dio_end_io() skips conversion of that cluster, while
>>     ocfs2_write_cluster() also skipped ocfs2_mark_extent_written() because
>>     c_clear_unwritten was 0.  Once the dirty page cache folio is written
>>     back and evicted, the cluster remains marked OCFS2_EXT_UNWRITTEN on
>>     disk and subsequent reads return zeroes instead of the written data.
>>
>> 2. When cluster_size > PAGE_SIZE, ocfs2_grab_folios_direct() only zeroes
>>     folios outside the direct write's [target_index, end_index] up to
>>     max(user_pos + user_len, i_size).  If a concurrent buffered write
>>     extends i_size further within the same unwritten cluster, or does a
>>     partial-page write inside [target_index, end_index] where new = 0
>>     causes ocfs2_map_folio_blocks() to issue bh_read_nowait() on the
>>     unwritten block, unzeroed disk blocks are exposed once the direct write
>>     marks the cluster written.
>>

I will ignore above issue.
This issue predates this patch and is left unfixed. Additionally, triggering
it would require concurrent DIO and buffered I/O or mmap writes on the same
inode, which is not a realistic scenario in production env.

>> [ ... ]
>>
>>> +static void ocfs2_dio_clear_orphan_locked(struct inode *inode,
>>> +				   struct buffer_head *di_bh)
>>> +{
>>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>> +	loff_t end = READ_ONCE(oi->ip_dio_orphan_end);
>>> +	int ret = 0;
>>> +
>>> +	/*
>>> +	 * The write has not reached the end it asked for. Free whatever it
>>> +	 * allocated beyond i_size before the orphan entry.
>>> +	 */
>>> +	if (i_size_read(inode) < end)
>>> +		ret = ocfs2_truncate_file(inode, di_bh, i_size_read(inode));
>>
>> [Severity: Medium]
>> As noted in the TODO comment above this function, if a file has unwritten
>> extents preallocated beyond i_size via fallocate(FALLOC_FL_KEEP_SIZE),
>> won't any extending direct write that ends short, fails before submitting
>> I/O, or bounces to buffered I/O and writes short truncate away all
>> pre-existing preallocated clusters beyond i_size?
>>
>> In addition, because ocfs2_file_write_iter() checks
>> ocfs2_clusters_for_bytes(..., iocb->ki_pos + count) against i_size_read()
>> rather than against the inode's allocated clusters, every extending direct
>> write into space already preallocated with FALLOC_FL_KEEP_SIZE
>> unnecessarily adds and removes the inode in the slot's global orphan
>> directory.

I already added a "TODO" tag in the comments and will ignore this issue.
btw, this issue already existed before this patch set.

>>
>> [ ... ]
>>
>>> @@ -2567,10 +3311,11 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>>>   	map.flags = 0;
>>>   
>>>   	if (flags & IOMAP_WRITE) {
>>> -		return -EOPNOTSUPP;
>>> +		ret = ocfs2_dio_wr_map_blocks(inode, &map, flags, owner);
>>> +	} else {
>>> +		ret = ocfs2_lock_map_blocks(inode, &map, 0, flags & IOMAP_NOWAIT);
>>>   	}
>>
>> [ ... ]
>>
>>>   	if (map.flags & OCFS2_MAP_NEW)
>>>   		iomap->flags |= IOMAP_F_NEW;
>>>   
>>>   	return 0;
>>>   }
>>
>> [Severity: High]
>> Should ocfs2_iomap_begin() set IOMAP_F_DIRTY when the write extends i_size
>> or when the inode has uncommitted metadata transactions in JBD2?
>>
>> For O_DSYNC / RWF_DSYNC direct writes, ocfs2_file_write_iter() skips its
>> post-write jbd2_journal_force_commit() when use_dio is true and relies on
>> iomap.  When ocfs2_dio_wr_map_blocks() returns an already-allocated extent
>> (IOMAP_MAPPED without IOMAP_F_NEW)—for example when extending an unaligned
>> i_size within an already-allocated tail block (lblk < eof_blk), or after
>> ocfs2_prepare_inode_for_write() performed refcount CoW—and the block
>> device supports REQ_FUA, iomap sees neither IOMAP_F_NEW nor IOMAP_F_DIRTY,
>> issues a REQ_FUA bio, clears IOMAP_DIO_NEED_SYNC, and skips
>> generic_write_sync() (ocfs2_sync_file()).  The write then returns success
>> to userspace while the JBD2 transaction updating i_size or extent metadata
>> is still uncommitted.
>>
> 
> Seems we have to do it like:
> 
> 	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
> 	        iomap->flags |= IOMAP_F_DIRTY;
> 

My fix (copied from xfs and ext4):

@@ -3311,6 +3311,15 @@ static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
         map.flags = 0;
  
         if (flags & IOMAP_WRITE) {
+               /*
+                * Writes that span EOF might trigger an IO size update on
+                * completion, so consider them to be dirty for the purposes
+                * of O_DSYNC even if there is no other metadata changes
+                * pending or have been made here.
+                */
+               if (offset + length > i_size_read(inode))
+                       iomap->flags |= IOMAP_F_DIRTY;
+
                 ret = ocfs2_dio_wr_map_blocks(inode, &map, flags, owner);
         } else {
                 ret = ocfs2_lock_map_blocks(inode, &map, 0, flags & IOMAP_NOWAIT);


>> [ ... ]
>>
>>> +static int ocfs2_dio_end_io(struct kiocb *iocb, ssize_t size,
>>> +			int error, unsigned int flags, int level)
>>> +{
>>> +	struct inode *inode = file_inode(iocb->ki_filp);
>>> +	loff_t offset = iocb->ki_pos;
>>> +	bool recorded = error || (flags & IOMAP_DIO_UNWRITTEN);
>>> +	LIST_HEAD(unwritten);
>>> +	int ret = 0;
>>> +
>>> +	if (recorded)
>>> +		ocfs2_dio_collect_unwritten(inode, iocb, &unwritten);
>>> +
>>> +	if (error)
>>> +		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
>>> +				 (long long)size, error);
>>> +
>>> +	/* bounced back to buffered I/O, leave the rw_lock held */
>>> +	if (size == 0 && error == 0) {
>>> +		ocfs2_free_unwritten_list(inode, &unwritten);
>>> +		return 0;
>>> +	}
>>> +
>>> +	if (size && error == 0 &&
>>> +	    (!list_empty(&unwritten) ||
>>> +	     (offset + size > i_size_read(inode)))) {
>>> +		ret = ocfs2_dio_end_io_write(inode, offset, size, &unwritten);
>>> +		if (ret < 0)
>>> +			mlog_errno(ret);
>>> +	}
>>> +
>>> +	ocfs2_free_unwritten_list(inode, &unwritten);
>>
>> [Severity: High]
>> What happens if a multi-mapping direct write to unwritten or newly
>> allocated clusters completes some I/O (size > 0) and then fails on a later
>> mapping or bio (error != 0), for example with -ENOSPC in
>> ocfs2_dio_wr_map_blocks() or -EFAULT in bio_iov_iter_get_pages()?
>>
>> During ocfs2_dio_wr_map_blocks(), any unaligned head or tail folios in the
>> page cache for the first and last clusters of the earlier mapping were
>> already zeroed, mapped to the cluster's physical blocks, and marked dirty
>> and uptodate via block_commit_write().  Because error != 0,
>> ocfs2_dio_end_io() skips ocfs2_dio_end_io_write() and discards the
>> unwritten list, and iomap_dio_complete() skips
>> kiocb_invalidate_post_direct_write().  That leaves dirty, mapped page
>> cache buffers pointing at an extent that is still marked
>> OCFS2_EXT_UNWRITTEN on disk.

I will try to fix this issue in next version.
the idea is to first write back the dirty cache pages to disk, then
invalidate/drop the clean (written-back) pages.

btw, this issue is also existing in buffer_head path.
the old ocfs2_dio_end_io() just calls ocfs2_dio_free_write_ctx() when
"bytes <= 0", which also doesn't release the dirty pages.

>>
>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>> index 3d717200d53a4..18aee5372eebe 100644
>>> --- a/fs/ocfs2/file.c
>>> +++ b/fs/ocfs2/file.c
>>
>> [ ... ]
>>
>>> @@ -2417,9 +2426,52 @@ static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
>>>   	    !ocfs2_supports_append_dio(osb))
>>>   		return false;
>>>   
>>> +	/*
>>> +	 * A direct write which does not cover whole pages leaves the rest of
>>> +	 * the page untouched. iomap only zeroes the padding up to the file
>>> +	 * system block size, so on a file system with a block size smaller
>>> +	 * than the page size the untouched blocks would expose stale data
>>> +	 * once the cluster is marked written. Let buffered I/O handle it.
>>> +	 *
>>> +	 * TODO: Avoid unnecessarily demoting in-place sub-page overwrites
>>> +	 * to buffered I/O when i_blocksize(inode) < PAGE_SIZE.
>>> +	 */
>>> +	if (iov_iter_rw(iter) == WRITE && i_blocksize(inode) < PAGE_SIZE &&
>>> +	    (!IS_ALIGNED(iocb->ki_pos, PAGE_SIZE) ||
>>> +	     !IS_ALIGNED(iocb->ki_pos + iter->count, PAGE_SIZE)))
>>> +		return false;
>>> +
>>>   	return true;
>>>   }
>>
>> [Severity: Medium]
>> When i_blocksize(inode) < PAGE_SIZE (including all OCFS2 filesystems on
>> 16KB or 64KB PAGE_SIZE kernels), doesn't checking page alignment in
>> ocfs2_should_use_dio() demote all sub-page O_DIRECT overwrites of
>> already-written blocks to synchronous buffered I/O?
>>
>> Because use_dio becomes false before block mapping is checked, pure
>> in-place overwrites take an exclusive EX cluster rw_lock instead of a
>> shared PR lock under coherency=buffered, reject IOCB_NOWAIT writes with
>> -EAGAIN, and fall back to generic_perform_write() and page-cache
>> writeback/invalidation.  Returning -ENOTBLK from ocfs2_dio_wr_map_blocks()
>> only when the fast-path overwrite check misses would keep in-place
>> sub-page overwrites on the direct I/O path.
>>

I already added a "TODO" tag in the comments and will ignore this issue.

>> [ ... ]
>>
>>> +	if (use_dio) {
>>> +		if (!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(from),
>>> +				dio_align)) {
>>> +			ret = -EINVAL;
>>> +			goto out;
>>> +		}
>>>   
>>> +		/*
>>> +		 * Extending the file requires cluster locks and
>>> +		 * transactions, which IOCB_NOWAIT forbids.
>>> +		 */
>>> +		if (nowait &&
>>> +		    ((iocb->ki_pos + count) > i_size_read(inode))) {
>>> +			ret = -EAGAIN;
>>> +			goto out;
>>> +		}
>>> +
>>> +		if (iocb->ki_pos > i_size_read(inode) &&
>>> +		    fault_in_iov_iter_readable(from, count)) {
>>> +			ret = -EFAULT;
>>> +			goto out;
>>> +		}
>>> +
>>> +		if ((iocb->ki_pos + count) > i_size_read(inode)) {
>>> +			/*
>>> +			 * Complete before i_rwsem is dropped: i_size is only
>>> +			 * updated by ->end_io(), and the next writer would
>>> +			 * zero the gap between the size it still sees and its
>>> +			 * own write, over the data this one has just written.
>>> +			 */
>>> +			dio_flags |= IOMAP_DIO_FORCE_WAIT;
>>> +
>>> +			if (ocfs2_clusters_for_bytes(inode->i_sb,
>>> +						     iocb->ki_pos + count) >
>>> +			    ocfs2_clusters_for_bytes(inode->i_sb,
>>> +						     i_size_read(inode))) {
>>> +				/*
>>> +				 * when we are going to alloc extents beyond file
>>> +				 * size, add the inode to orphan dir, so we can
>>> +				 * recall those spaces when system crashed during
>>> +				 * write.
>>> +				 */
>>> +				ret = ocfs2_add_inode_to_orphan(osb, inode);
>>> +				if (ret < 0) {
>>> +					mlog_errno(ret);
>>> +					goto out;
>>> +				}
>>> +				WRITE_ONCE(OCFS2_I(inode)->ip_dio_orphan_pid,
>>> +					   task_pid_nr(current));
>>> +				WRITE_ONCE(OCFS2_I(inode)->ip_dio_orphan_end,
>>> +					   iocb->ki_pos + count);
>>> +			}
>>> +		}
>>> +
>>> +		ret = ocfs2_dio_zero_eof(inode, iocb->ki_pos, count);
>>> +		if (ret < 0)
>>> +			goto out;
>>> +
>>> +		const struct iomap_dio_ops *dops = rw_level ?
>>> +			&ocfs2_iomap_dio_ops_w_ex : &ocfs2_iomap_dio_ops_w_pr;
>>> +		struct iomap_dio *dio;
>>> +
>>> +		/*
>>> +		 * The kiocb is the owner of the unwritten clusters which
>>> +		 * ->iomap_begin() records for ->end_io() to convert, see
>>> +		 * ocfs2_iomap_next().
>>> +		 */
>>> +		dio = __iomap_dio_rw(iocb, from, ocfs2_iomap_next,
>>> +				     dops, dio_flags, iocb, 0);
>>> +		if (dio == NULL) {
>>> +			/* No I/O issued; rw_lock still held. */
>>> +			written = 0;
>>> +		} else if (IS_ERR(dio)) {
>>> +			written = PTR_ERR(dio);
>>> +			/*
>>> +			 * -EIOCBQUEUED: async I/O; end_io will drop the lock on
>>> +			 * completion. Any other error means no I/O started and
>>> +			 * end_io was not called, so the cleanup path below drops
>>> +			 * the lock.
>>> +			 */
>>> +			if (written == -EIOCBQUEUED)
>>> +				rw_level = -1;
>>> +		} else {
>>> +			/*
>>> +			 * Synchronous completion. iomap_dio_complete() runs
>>> +			 * end_io, which drops the lock unless the mapping
>>> +			 * bounced us back to buffered I/O (returns 0, lock
>>> +			 * retained).
>>> +			 */
>>> +			written = iomap_dio_complete(dio);
>>> +			if (written != 0)
>>> +				rw_level = -1;
>>> +		}
>>
>> [ ... ]
>>
>>>   out:
>>> +	/*
>>> +	 * IOMAP_DIO_FORCE_WAIT made an extending dio complete synchronously,
>>> +	 * so its end_io has already updated i_size.
>>> +	 */
>>>   	if (saved_ki_complete)
>>>   		xchg(&iocb->ki_complete, saved_ki_complete);
>>>   
>>> -	if (rw_level != -1)
>>> +	if (rw_level != -1) {
>>> +		/*
>>> +		 * The orphan entry this write added is still there when no io
>>> +		 * was issued at all, or when the write bailed out before
>>> +		 * submitting it. The conversion in ocfs2_dio_end_io_write()
>>> +		 * has removed it on the success path; a failed io is left to
>>> +		 * the recovery. Remove it here for the former, while the
>>> +		 * rw_lock is still held
>>> +		 */
>>> +		ocfs2_dio_clear_orphan(inode);
>>>   		ocfs2_rw_unlock(inode, rw_level);
>>> +	}
>>> +
>>> +	/* The marker must not outlive this write. */
>>> +	if (READ_ONCE(OCFS2_I(inode)->ip_dio_orphan_pid) ==
>>> +	    task_pid_nr(current))
>>> +		WRITE_ONCE(OCFS2_I(inode)->ip_dio_orphan_pid, 0);
>>
>> [Severity: High]
>> Does an extending direct write that fails inside __iomap_dio_rw() after
>> inode_dio_begin() (or ends short at or below i_size without unwritten
>> extents) leave the inode orphaned and any newly allocated clusters beyond
>> i_size leaked?
>>
>> For example, when appending at ki_pos == i_size with an unmapped user
>> buffer, fault_in_iov_iter_readable() is skipped because ki_pos > i_size is
>> false.  ocfs2_add_inode_to_orphan() adds the dio- orphan entry and sets
>> OCFS2_DIO_ORPHANED_FL on disk, and inside __iomap_dio_rw(),
>> ocfs2_dio_wr_map_blocks() allocates unwritten clusters before
>> bio_iov_iter_get_pages() fails with -EFAULT.  Because
>> IOMAP_DIO_FORCE_WAIT is set, __iomap_dio_rw() returns the dio pointer and
>> iomap_dio_complete() runs ocfs2_dio_end_io(), which skips
>> ocfs2_dio_end_io_write() on error, unlocks rw_lock, and returns -EFAULT.
>> ocfs2_file_write_iter() then sets rw_level = -1, so at out: it skips
>> ocfs2_dio_clear_orphan() and resets ip_dio_orphan_pid to 0.
>>
>> The same happens if an extending write starting below i_size on an
>> already-written prefix stops short at or before i_size (where
>> list_empty(&unwritten) and offset + size <= i_size_read(inode), so
>> ocfs2_dio_end_io() skips ocfs2_dio_end_io_write()).  With
>> OCFS2_DIO_ORPHANED_FL left set on the dinode, subsequent unlink cannot
>> wipe the inode in ocfs2_delete_inode():
>>
>> fs/ocfs2/inode.c:ocfs2_delete_inode() {
>>      ...
>> 	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
>> 		ocfs2_cleanup_delete_inode(inode, 0);
>> 		goto bail_unlock_inode;
>> 	}
>>      ...
>> }
>>
>> Because background and clean-mount orphan scans skip dio- entries
>> (ORPHAN_NO_NEED_TRUNCATE), the unlinked inode, its orphan entry, and the
>> clusters allocated beyond i_size remain on disk until an unclean recovery
>> or another extending direct write on the same inode triggers orphan
>> cleanup.
>>
> 

Don't agree. For above scenario, the patch keeps old logic.
There are two additional places where the orphaned inode is removed:
- On the next write to the inode, ocfs2_add_inode_to_orphan() will check
   OCFS2_DIO_ORPHANED_FL and remove the orphaned entry.
- The recovery path will call ocfs2_recover_orphans() to do the removal.


Thanks,
Heming
