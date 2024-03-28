Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFFC1BDEB
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711590635; cv=none; b=H3WDHY/RMWHAXqxhwRwNONRDwlw6EnZ5RpJFG8Zu9sF0xqR7qBgFrnHgxC4SvVmU8us5VZEb3NSA0+9XXNA1QMwt/3KGoCevhgrUL05+/2TVKnfbR5ytJDqu568Yt5wYDeHTjaXdTkNc8Imwzj8YLqqYdZtuntoZYULjWcE119g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711590635; c=relaxed/simple;
	bh=sTLrk10ROv21zus0l8Yy/+Extr4cNUPjUV8tvcdF1SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=faGcmWPvTMuYI3hew78Aq+2JxRYeMVIc42YsiD/ihfdGo5YgCNzU1V7VXvIEIaIuz0ra3XpvpW/s90OsRPwvDKUqGtTlqtUY1Jnv7nSOv9wz9g5v6yY6FgdjBr0ktqU/nh3XfLwMfEBLKuPSALgCCzvuCDtusWJbLpsTIgqlvps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QTZoXuZo; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QTZoXuZo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711590629; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hWGYvL6qOhu+Z2lFjRJ1UnkUkgLFu+Rqpq6JMSyPU38=;
	b=QTZoXuZoaIzjNeCp/ubTbwZGGFv36QkxG4eFbAD9fMAurFH2xu5pRWfzrVsIO80bmDvTUMyVFSApSZU+rHDhF9bn+IF/Qd2jWt2Ju+YPd6cxoDQ4nCM9dQlmB4tt0fVsvoiw8lbfSMz3Tu05hA7Wa1j8W6oaye60eSxJomZWmJk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W3QIHkU_1711590627;
Received: from 30.221.129.70(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W3QIHkU_1711590627)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 09:50:28 +0800
Message-ID: <8bbdaca3-cf86-40da-91a6-e3dd1405e495@linux.alibaba.com>
Date: Thu, 28 Mar 2024 09:50:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] ocfs2: improve write IO performance when
 fragmentation is high
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240327082146.6258-1-heming.zhao@suse.com>
 <20240327082146.6258-2-heming.zhao@suse.com>
 <b04e1f84-b170-467f-aa76-c8ea1133913d@linux.alibaba.com>
 <b03ba4fa-b751-41ed-b372-671edebeb96f@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <b03ba4fa-b751-41ed-b372-671edebeb96f@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/27/24 8:54 PM, Heming Zhao wrote:
> On 3/27/24 18:58, Joseph Qi wrote:
>>
>>
>> On 3/27/24 4:21 PM, Heming Zhao wrote:
>>> The group_search function ocfs2_cluster_group_search() should
>>> bypass groups with insufficient space to avoid unnecessary
>>> searches.
>>>
>>> This patch is particularly useful when ocfs2 is handling huge
>>> number small files, and volume fragmentation is very high.
>>> In this case, ocfs2 is busy with looking up available la window
>>> from //global_bitmap.
>>>
>>> This patch introduces a new member in the Group Description (gd)
>>> struct called 'bg_contig_free_bits', representing the max
>>> contigous free bits in this gd. When ocfs2 allocates a new
>>> la window from //global_bitmap, 'bg_contig_free_bits' helps
>>> expedite the search process.
>>>
>>> Let's image below path.
>>>
>>> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
>>>
>>> 2. when user delete a large file and trigger
>>>     ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
>>>     unconditionally.
>>>
>>> 3. a write IOs thread run and trigger the worst performance path
>>>
>>> ```
>>> ocfs2_reserve_clusters_with_limit
>>>   ocfs2_reserve_local_alloc_bits
>>>    ocfs2_local_alloc_slide_window //[1]
>>>     + ocfs2_local_alloc_reserve_for_window //[2]
>>>     + ocfs2_local_alloc_new_window //[3]
>>>        ocfs2_recalc_la_window
>>> ```
>>>
>>> [1]:
>>> will be called when la window bits used up.
>>>
>>> [2]:
>>> under la state is ENABLED, and this func only check global_bitmap
>>> free bits, it will succeed in general.
>>>
>>> [3]:
>>> will use the default la window size to search clusters then fail.
>>> ocfs2_recalc_la_window attempts other la window sizes.
>>> the timing complexity is O(n^4), resulting in a significant time
>>> cost for scanning global bitmap. This leads to a dramatic slowdown
>>> in write I/Os (e.g., user space 'dd').
>>>
>>> i.e.
>>> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
>>> la window default size: 106MB.
>>> The partition is fragmentation by creating & deleting huge mount of
>>> small files.
>>>
>>> before this patch, the timing of [3] should be
>>> (the number got from real world):
>>> - la window size change order (size: MB):
>>>    106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>>>    only 0.8MB succeed, 0.8MB also triggers la window to disable.
>>>    ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>>>    runs in worst case.
>>> - group chain number: 242
>>>    ocfs2_claim_suballoc_bits calls for-loop 242 times
>>> - each chain has 49 block group
>>>    ocfs2_search_chain calls while-loop 49 times
>>> - each bg has 32256 blocks
>>>    ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>>>    for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>>>    (32256/64) (this is not worst value) for timing calucation.
>>>
>>> the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
>>>
>>> In the worst case, user space writes 1MB data will trigger 42M scanning
>>> times.
>>>
>>> under this patch, the timing is '7*242*49 = 83006', reduced by three
>>> orders of magnitude.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>> v4:
>>> fix sparse warning:
>>> -  in ocfs2_update_last_group_and_inode(), change
>>>     'old_bg_contig_free_bits' type from 'u16' to '__le16'.
>>> -  in _ocfs2_free_suballoc_bits(), do le16_to_cpu convert
>>>     for assigning 'old_bg_contig_free_bits'.
>>>
>>> v3:
>>> 1. Fix wrong var length for 'struct ocfs2_group_desc'
>>>     .bg_contig_free_bits, change from '__le32' to '__le16'.
>>> 2. change all related code to use '__le16' instead of '__le32'.
>>>     Please note: change ocfs2_find_max_contig_free_bits() input
>>>     parameters and return type to 'u16'.
>>>
>>> v2:
>>> 1. fix wrong length converting from cpu_to_le16() to cpu_to_le32()
>>>     for setting bg->bg_contig_free_bits.
>>> 2. change ocfs2_find_max_contig_free_bits return type from 'void' to
>>>     'unsigned int'.
>>> 3. restore ocfs2_block_group_set_bits() input parameters style, change
>>>     parameter 'failure_path' to 'fastpath'.
>>> 4. after <3>, add new parameter 'unsigned int max_contig_bits'.
>>> 5. after <3>, restore define 'struct ocfs2_suballoc_result' from
>>>     'suballoc.h' to 'suballoc.c'.
>>> 6. modify some code indent error.
>>> ---
>>>   fs/ocfs2/move_extents.c |  2 +-
>>>   fs/ocfs2/ocfs2_fs.h     |  3 +-
>>>   fs/ocfs2/resize.c       |  8 ++++
>>>   fs/ocfs2/suballoc.c     | 99 +++++++++++++++++++++++++++++++++++++----
>>>   fs/ocfs2/suballoc.h     |  6 ++-
>>>   5 files changed, 107 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>>> index 1f9ed117e78b..f9d6a4f9ca92 100644
>>> --- a/fs/ocfs2/move_extents.c
>>> +++ b/fs/ocfs2/move_extents.c
>>> @@ -685,7 +685,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>>       }
>>>         ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>>> -                     goal_bit, len);
>>> +                     goal_bit, len, 0, 0);
>>>       if (ret) {
>>>           ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
>>>                              le16_to_cpu(gd->bg_chain));
>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>> index 7aebdbf5cc0a..c93689b568fe 100644
>>> --- a/fs/ocfs2/ocfs2_fs.h
>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>> @@ -883,7 +883,8 @@ struct ocfs2_group_desc
>>>       __le16    bg_free_bits_count;     /* Free bits count */
>>>       __le16   bg_chain;               /* What chain I am in. */
>>>   /*10*/    __le32   bg_generation;
>>> -    __le32    bg_reserved1;
>>> +    __le16   bg_contig_free_bits;   /* max contig free bits length */
>>> +    __le16   bg_reserved1;
>>>       __le64   bg_next_group;          /* Next group in my list, in
>>>                          blocks */
>>>   /*20*/    __le64   bg_parent_dinode;       /* dinode which owns me, in
>>> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
>>> index d65d43c61857..c4a4016d3866 100644
>>> --- a/fs/ocfs2/resize.c
>>> +++ b/fs/ocfs2/resize.c
>>> @@ -91,6 +91,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>       u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
>>>       u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
>>>       u16 old_bg_clusters;
>>> +    u16 contig_bits;
>>> +    __le16 old_bg_contig_free_bits;
>>>         trace_ocfs2_update_last_group_and_inode(new_clusters,
>>>                           first_new_cluster);
>>> @@ -122,6 +124,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>           le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
>>>       }
>>>   +    contig_bits = ocfs2_find_max_contig_free_bits(group->bg_bitmap,
>>> +                    le16_to_cpu(group->bg_bits), 0);
>>> +    old_bg_contig_free_bits = group->bg_contig_free_bits;
>>> +    group->bg_contig_free_bits = cpu_to_le16(contig_bits);
>>> +
>>>       ocfs2_journal_dirty(handle, group_bh);
>>>         /* update the inode accordingly. */
>>> @@ -160,6 +167,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>           le16_add_cpu(&group->bg_free_bits_count, backups);
>>>           le16_add_cpu(&group->bg_bits, -1 * num_bits);
>>>           le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
>>> +        group->bg_contig_free_bits = old_bg_contig_free_bits;
>>>       }
>>>   out:
>>>       if (ret)
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index 166c8918c825..6fd67c8da9fe 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -50,6 +50,10 @@ struct ocfs2_suballoc_result {
>>>       u64        sr_blkno;    /* The first allocated block */
>>>       unsigned int    sr_bit_offset;    /* The bit in the bg */
>>>       unsigned int    sr_bits;    /* How many bits we claimed */
>>> +    unsigned int    sr_max_contig_bits; /* The length for contiguous
>>> +                         * free bits, only available
>>> +                         * for cluster group
>>> +                         */
>>>   };
>>>     static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
>>> @@ -1272,6 +1276,26 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>>>       return ret;
>>>   }
>>>   +u16 ocfs2_find_max_contig_free_bits(void *bitmap,
>>> +             u16 total_bits, u16 start)
>>> +{
>>> +    u16 offset, free_bits;
>>> +    u16 contig_bits = 0;
>>> +
>>> +    while (start < total_bits) {
>>> +        offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
>>> +        if (offset == total_bits)
>>> +            break;
>>> +
>>> +        start = ocfs2_find_next_bit(bitmap, total_bits, offset);
>>> +        free_bits = start - offset;
>>> +        if (contig_bits < free_bits)
>>> +            contig_bits = free_bits;
>>> +    }
>>> +
>>> +    return contig_bits;
>>> +}
>>> +
>>>   static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
>>>                            struct buffer_head *bg_bh,
>>>                            unsigned int bits_wanted,
>>> @@ -1280,6 +1304,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
>>>   {
>>>       void *bitmap;
>>>       u16 best_offset, best_size;
>>> +    u16 prev_best_size = 0;
>>>       int offset, start, found, status = 0;
>>>       struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
>>>   @@ -1308,6 +1333,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
>>>               /* got a zero after some ones */
>>>               found = 1;
>>>               start = offset + 1;
>>> +            prev_best_size = best_size;
>>>           }
>>>           if (found > best_size) {
>>>               best_size = found;
>>> @@ -1320,6 +1346,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
>>>           }
>>>       }
>>>   +    /* best_size will be allocated, we save prev_best_size */
>>> +    res->sr_max_contig_bits = prev_best_size;
>>>       if (best_size) {
>>>           res->sr_bit_offset = best_offset;
>>>           res->sr_bits = best_size;
>>> @@ -1337,11 +1365,15 @@ int ocfs2_block_group_set_bits(handle_t *handle,
>>>                            struct ocfs2_group_desc *bg,
>>>                            struct buffer_head *group_bh,
>>>                            unsigned int bit_off,
>>> -                         unsigned int num_bits)
>>> +                         unsigned int num_bits,
>>> +                         unsigned int max_contig_bits,
>>> +                         int fastpath)
>>>   {
>>>       int status;
>>>       void *bitmap = bg->bg_bitmap;
>>>       int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
>>> +    unsigned int start = bit_off + num_bits;
>>> +    u16 contig_bits;
>>>         /* All callers get the descriptor via
>>>        * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
>>> @@ -1373,6 +1405,28 @@ int ocfs2_block_group_set_bits(handle_t *handle,
>>>       while(num_bits--)
>>>           ocfs2_set_bit(bit_off++, bitmap);
>>>   +    /*
>>> +     * this is optimize path, caller set old contig value
>>> +     * in max_contig_bits to bypass finding action.
>>> +     */
>>> +    if (fastpath) {
>>> +        bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
>>> +    } else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
>>> +        /*
>>> +         * Usually, the block group bitmap allocates only 1 bit
>>> +         * at a time, while the cluster group allocates n bits
>>> +         * each time. Therefore, we only save the contig bits for
>>> +         * the cluster group.
>>> +         */
>>> +        contig_bits = ocfs2_find_max_contig_free_bits(bitmap,
>>> +                    le16_to_cpu(bg->bg_bits), start);
>>> +        if (contig_bits > max_contig_bits)
>>> +            max_contig_bits = contig_bits;
>>> +        bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
>>> +    } else {
>>> +        bg->bg_contig_free_bits = 0;
>>> +    }
>>> +
>>>       ocfs2_journal_dirty(handle, group_bh);
>>>     bail:
>>> @@ -1486,7 +1540,12 @@ static int ocfs2_cluster_group_search(struct inode *inode,
>>>         BUG_ON(!ocfs2_is_cluster_bitmap(inode));
>>>   -    if (gd->bg_free_bits_count) {
>>> +    if (le16_to_cpu(gd->bg_contig_free_bits) &&
>>> +        le16_to_cpu(gd->bg_contig_free_bits) < bits_wanted)
>>> +        return -ENOSPC;
>>> +
>>> +    /* ->bg_contig_free_bits may un-initialized, so compare again */
>>> +    if (le16_to_cpu(gd->bg_free_bits_count) >= bits_wanted) {
>>>           max_bits = le16_to_cpu(gd->bg_bits);
>>>             /* Tail groups in cluster bitmaps which aren't cpg
>>> @@ -1555,7 +1614,7 @@ static int ocfs2_block_group_search(struct inode *inode,
>>>       BUG_ON(min_bits != 1);
>>>       BUG_ON(ocfs2_is_cluster_bitmap(inode));
>>>   -    if (bg->bg_free_bits_count) {
>>> +    if (le16_to_cpu(bg->bg_free_bits_count) >= bits_wanted) {
>>>           ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
>>>                               group_bh, bits_wanted,
>>>                               le16_to_cpu(bg->bg_bits),
>>> @@ -1715,7 +1774,8 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
>>>       }
>>>         ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
>>> -                     res->sr_bit_offset, res->sr_bits);
>>> +                     res->sr_bit_offset, res->sr_bits,
>>> +                     res->sr_max_contig_bits, 0);
>>>       if (ret < 0) {
>>>           ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
>>>                              res->sr_bits,
>>> @@ -1849,7 +1909,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
>>>                           bg,
>>>                           group_bh,
>>>                           res->sr_bit_offset,
>>> -                        res->sr_bits);
>>> +                        res->sr_bits,
>>> +                        res->sr_max_contig_bits,
>>> +                        0);
>>>       if (status < 0) {
>>>           ocfs2_rollback_alloc_dinode_counts(alloc_inode,
>>>                       ac->ac_bh, res->sr_bits, chain);
>>> @@ -2163,7 +2225,9 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
>>>                        bg,
>>>                        bg_bh,
>>>                        res->sr_bit_offset,
>>> -                     res->sr_bits);
>>> +                     res->sr_bits,
>>> +                     res->sr_max_contig_bits,
>>> +                     0);
>>>       if (ret < 0) {
>>>           ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
>>>                              ac->ac_bh, res->sr_bits, chain);
>>> @@ -2382,11 +2446,13 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
>>>                       struct buffer_head *group_bh,
>>>                       unsigned int bit_off,
>>>                       unsigned int num_bits,
>>> +                    unsigned int max_contig_bits,
>>>                       void (*undo_fn)(unsigned int bit,
>>>                               unsigned long *bmap))
>>>   {
>>>       int status;
>>>       unsigned int tmp;
>>> +    u16 contig_bits;
>>>       struct ocfs2_group_desc *undo_bg = NULL;
>>>       struct journal_head *jh;
>>>   @@ -2433,6 +2499,20 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
>>>                      num_bits);
>>>       }
>>>   +    /*
>>> +     * TODO: even 'num_bits == 1' (the worst case, release 1 cluster),
>>> +     * we still need to rescan whole bitmap.
>>> +     */
>>> +    if (ocfs2_is_cluster_bitmap(alloc_inode)) {
>>> +        contig_bits = ocfs2_find_max_contig_free_bits(bg->bg_bitmap,
>>> +                    le16_to_cpu(bg->bg_bits), 0);
>>> +        if (contig_bits > max_contig_bits)
>>> +            max_contig_bits = contig_bits;
>>> +        bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
>>> +    } else {
>>> +        bg->bg_contig_free_bits = 0;
>>> +    }
>>> +
>>>       if (undo_fn)
>>>           spin_unlock(&jh->b_state_lock);
>>>   @@ -2459,6 +2539,7 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
>>>       struct ocfs2_chain_list *cl = &fe->id2.i_chain;
>>>       struct buffer_head *group_bh = NULL;
>>>       struct ocfs2_group_desc *group;
>>> +    u16 old_bg_contig_free_bits = 0;
>>
>> Why not also define old_bg_contig_free_bits as __le16?
>> And do convert when calling ocfs2_block_group_set_bits().
>> This looks consistent with ocfs2_update_last_group_and_inode().
>>
>> Joseph
> 
> _ocfs2_free_suballoc_bits() is not similar to
> ocfs2_update_last_group_and_inode(). Here, 'old_bg_contig_free_bits'
> will be passed to ocfs2_block_group_set_bits() for error handling.
> In ocfs2_block_group_set_bits(), cpu_to_le16() is already used to
> perform the conversion.
> 

Don't understand what's your concern here.

__le16 old_bg_contig_free_bits = 0;
...
old_bg_contig_free_bits = group->bg_contig_free_bits;

if (error)
	ocfs2_block_group_set_bits(..., 
		le16_to_cpu(old_bg_contig_free_bits),
		...);

BTW, error case is an 'unlikely' branch, right?

Thanks,
Joseph
