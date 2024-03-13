Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBBE1B273
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Mar 2024 09:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710321006; cv=none; b=Avl1FseL+14O84/CW2pHlOTRt2/e0/mscrBLTyQC0CgGCNqq8xUWs9zdXi7U9rN69CrQLlcGsuL6/XTThncOUhC2EVg2sD1t4mPu6IhOfTpOXv8Sf2RIoJ+JmlhjxMTLodOvhDf9utB9AIQxAx+KxaDXUHdjA2i3AwdTXadDAzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710321006; c=relaxed/simple;
	bh=HScPN1EUe+EWBmLFeT7Y7uO0g9Lrwc+mvECF5ryisaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpSI+tfq58zaP8dOnoM8/Zc9YNNTipOc4WIwKJm5+l6Wj9mUSxvIkIu2pZfpS4QGjVdZ3uGll+Bvhfhk0oY25pXWPlF4G2qWXsNYNNJG0U+9EtEbD6J4Qxy6NCFe2cKP/OneKXs7OjhAlATVJsFYMMG1H+s+4qdJq7qv/c0wCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Npb75lF/; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Npb75lF/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710320994; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vuqz/5dkvYQOhocFGx3xmGNI5iWoTHfd3MWfzqbY2a4=;
	b=Npb75lF/mKeZHf9pG6Sr4aH+ZZPp3CrFBtJi7z/P8PlgKT/bO5PQE/x0eYq9/Uig8wYdyNmLNj7Zb0TgbzF5P7fLVPfzJTCLnY+wz7hZ30WV8OATC834qxvXmIpH6qAZA9CeZwH1/PsS9nLwUiI1+4TfKHwbMzWqjxUZjDhko3Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W2OY8Rm_1710320993;
Received: from 30.221.128.134(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2OY8Rm_1710320993)
          by smtp.aliyun-inc.com;
          Wed, 13 Mar 2024 17:09:54 +0800
Message-ID: <70d119b5-53c0-4a92-84ec-9b5053184959@linux.alibaba.com>
Date: Wed, 13 Mar 2024 17:09:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: improve write IO performance when fragmentation is
 high
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240308015251.32041-1-heming.zhao@suse.com>
 <3de83d2c-729b-453f-b874-3d553b8274a7@linux.alibaba.com>
 <ccbfc231-cb82-4455-a137-7d9c9dab44d5@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ccbfc231-cb82-4455-a137-7d9c9dab44d5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/13/24 9:34 AM, Heming Zhao wrote:
> Hi Joseph,
> 
> Before sending v2 patch, I need to explain ocfs2_find_max_contig_free_bits()
> for you. See the comment in below.
> 
> On 3/11/24 19:04, Joseph Qi wrote:
>>
>> Hi,
>>
>> Please see my comments inline.
>>
>> On 3/8/24 9:52 AM, Heming Zhao wrote:
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
>>> under this patch, the timing is '7*242*49 = 83006', reduce by three
>>> orders of magnitude.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>   fs/ocfs2/move_extents.c |   6 +-
>>>   fs/ocfs2/ocfs2_fs.h     |   4 +-
>>>   fs/ocfs2/resize.c       |   7 +++
>>>   fs/ocfs2/suballoc.c     | 120 ++++++++++++++++++++++++++++------------
>>>   fs/ocfs2/suballoc.h     |  28 +++++++++-
>>>   5 files changed, 122 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>>> index 1f9ed117e78b..6b9753b8c6fb 100644
>>> --- a/fs/ocfs2/move_extents.c
>>> +++ b/fs/ocfs2/move_extents.c
>>> @@ -576,6 +576,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>>       u32 move_max_hop = ocfs2_blocks_to_clusters(inode->i_sb,
>>>                               context->range->me_threshold);
>>>       u64 phys_blkno, new_phys_blkno;
>>> +    struct ocfs2_suballoc_result res = {0};
>>>         phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>>>   @@ -684,8 +685,9 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>>           goto out_commit;
>>>       }
>>>   -    ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>>> -                     goal_bit, len);
>>> +    res.sr_bit_offset = goal_bit;
>>> +    res.sr_bits = len;
>>> +    ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh, &res, 0);
>>>       if (ret) {
>>>           ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
>>>                              le16_to_cpu(gd->bg_chain));
>>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>>> index 7aebdbf5cc0a..eae18d772e93 100644
>>> --- a/fs/ocfs2/ocfs2_fs.h
>>> +++ b/fs/ocfs2/ocfs2_fs.h
>>> @@ -883,14 +883,14 @@ struct ocfs2_group_desc
>>>       __le16    bg_free_bits_count;     /* Free bits count */
>>>       __le16   bg_chain;               /* What chain I am in. */
>>>   /*10*/    __le32   bg_generation;
>>> -    __le32    bg_reserved1;
>>> +    __le32   bg_contig_free_bits;  /* max contig free bits length */
>>>       __le64   bg_next_group;          /* Next group in my list, in
>>>                          blocks */
>>>   /*20*/    __le64   bg_parent_dinode;       /* dinode which owns me, in
>>>                          blocks */
>>>       __le64   bg_blkno;               /* Offset on disk, in blocks */
>>>   /*30*/    struct ocfs2_block_check bg_check;    /* Error checking */
>>> -    __le64   bg_reserved2;
>>> +    __le64   bg_reserved1;
>>>   /*40*/    union {
>>>           DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
>>>           struct {
>>> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
>>> index d65d43c61857..ab30518d5f04 100644
>>> --- a/fs/ocfs2/resize.c
>>> +++ b/fs/ocfs2/resize.c
>>> @@ -91,6 +91,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>       u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
>>>       u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
>>>       u16 old_bg_clusters;
>>> +    u32 contig_bits = 0, old_bg_contig_free_bits;
>>>         trace_ocfs2_update_last_group_and_inode(new_clusters,
>>>                           first_new_cluster);
>>> @@ -122,6 +123,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>           le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
>>>       }
>>>   +    ocfs2_find_max_contig_free_bits(group->bg_bitmap,
>>> +                    group->bg_bits, 0, &contig_bits);
>>> +    old_bg_contig_free_bits = group->bg_contig_free_bits;
>>> +    group->bg_contig_free_bits = cpu_to_le32(contig_bits);
>>> +
>>>       ocfs2_journal_dirty(handle, group_bh);
>>>         /* update the inode accordingly. */
>>> @@ -160,6 +166,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>>           le16_add_cpu(&group->bg_free_bits_count, backups);
>>>           le16_add_cpu(&group->bg_bits, -1 * num_bits);
>>>           le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
>>> +        group->bg_contig_free_bits = old_bg_contig_free_bits;
>>>       }
>>>   out:
>>>       if (ret)
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index 166c8918c825..df149c3b0eed 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -37,21 +37,6 @@
>>>     #define OCFS2_MAX_TO_STEAL        1024
>>>   -struct ocfs2_suballoc_result {
>>> -    u64        sr_bg_blkno;    /* The bg we allocated from.  Set
>>> -                       to 0 when a block group is
>>> -                       contiguous. */
>>> -    u64        sr_bg_stable_blkno; /*
>>> -                         * Doesn't change, always
>>> -                         * set to target block
>>> -                         * group descriptor
>>> -                         * block.
>>> -                         */
>>> -    u64        sr_blkno;    /* The first allocated block */
>>> -    unsigned int    sr_bit_offset;    /* The bit in the bg */
>>> -    unsigned int    sr_bits;    /* How many bits we claimed */
>>> -};
>>> -
>>>   static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
>>>   {
>>>       if (res->sr_blkno == 0)
>>> @@ -1272,6 +1257,25 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>>>       return ret;
>>>   }
>>>   +/* caller should initialize contig_bits */
>>> +void ocfs2_find_max_contig_free_bits(void *bitmap,
>>> +             unsigned int total_bits, int start,
>>> +             unsigned int *contig_bits)
>>> +{
>>> +    int offset, free_bits;
>>> +
>>> +    while (start < total_bits) {
>>> +        offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
>>> +        if (offset == total_bits)
>>> +            break;
>>> +
>>> +        start = ocfs2_find_next_bit(bitmap, total_bits, offset);
>>> +        free_bits = start - offset;
>>> +        if (*contig_bits < free_bits)
>>> +            *contig_bits = free_bits;
>>> +    }
>>
>> Or we can just return the contig_bits. Something like:
>> unsigned int ocfs2_find_max_contig_free_bits(void *bitmap,
>>         unsigned int total_bits, int start)
>> {
>>     int offset, start;
>>     unsigned int contig_bits = 0;
>>
>>     while () {
>>         ...
>>     }
>>
>>     return contig_bits;
>> }
> 
> the input *contig_bits has two jobs:
> - return the max contigous free bits of bitmap
> - if *contig_bits is not ZERO, it keeps the max-contig-bits
>   from last search. When the input 'start' not zero
>   (means start from middle of bitmap), the max-contig-bits
>   from latter part of bitmap may smaller than first part.
>   at this case, function should keep & return the input
>   *contig_bits.
> 

IC, I don't think it's a good idea to mix up the 2 responsibilities.
You've hidden the logic that it may change the input contig_bits (not
the case of first search).
You can also implement it something like:

contig_bits = ocfs2_find_max_contig_free_bits();
if (config_bits > sr_max_contig_bits)
	sr_max_contig_bits = contig_bits;

This will be more explicit for an optimized search.

Thanks,
Joseph

> the view of ocfs2_find_max_contig_free_bits():
> 
>   front part  |  latter part
> [-------------+------------------] bitmap
>  0            'start'           total_bits
> 
> the call stack:
> 
> ocfs2_search_one_group
> + ac->ac_group_search
> |  ocfs2_cluster_group_search
> |   ocfs2_block_group_find_clear_bits
> |    + scan area [0, res->sr_bit_offset + res->sr_bits - 1]
> |    | /* zhm: save the second max-contig-bits.
> |    |  * if it doesn't exist, the value is 0. */
> |    + res->sr_max_contig_bits = prev_best_size;
> |
> + ocfs2_block_group_set_bits
>    ocfs2_find_max_contig_free_bits(...,
>             start, /* zhm: may not ZERO, help to speed up the search */
>             res->sr_max_contig_bits) /* zhm: the optimal value may have been reached */
> 
> So we should keep ocfs2_find_max_contig_free_bits() with a return type of 'void'.
>
