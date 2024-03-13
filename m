Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787FC122
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Mar 2024 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710293651; cv=none; b=T3tRpP70P69VZxESPzCvc7bZqoWiTityoUSpT5GJQwfhXzO5BBqDsmtEF3GU8bfv3pusIC/hi9b1KjRT+paLd4F7umCwpNRpnSRuH8/WmGZejfDxDnwln3Iisu0HO6LGS/DwUY97OWLHsaVRgbb1mdd44H+AKEY1MokDJWJVY3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710293651; c=relaxed/simple;
	bh=0dMjroestdQBVCh+2zRnt5Xg7a8uoGDJPPXXGPJWEeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WX08wm8tBXchclSyBJgrS6CesI6JyM9qYUCxabP99CXYI1CE/F6G428iB/W2oF02nKJABUsxQ3nMfLS1ZNGN+NL2mazJN6j/etPj24t6ezx+TcUNNTTrc3jWHuxZehWKZH+3W+QADOXV5NjSw1qur/AqGrlAj379+txQdWBkToE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U1BrQuRj; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U1BrQuRj"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d27fef509eso100248281fa.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 18:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710293646; x=1710898446; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j6LLFNznZ8lfp5XnmEGca4zMWFhvlGP70n1/jWQb0Xs=;
        b=U1BrQuRjhTFgZFtenLMdE+c+F7tqs6zQxGYR6crBOd2Av2SDZx1ylnDvnGO/aNZWjt
         xM7FZ5fsjVCmB6R+4K6yH652lwLFeADC8Uk+LhwCJP9rPTWqNQBV/vefIdq56YxC/Qy0
         kaki8w4NtF3+P5HrL96MHOz5sDyyA8nBBVhUgpxEdLdtHP2UZQ+S4Th3d84COvKafoYK
         w9IvHkDu4bHtkQyFxH5wts1krNtyeXgq2ED2KyG9Zn8oy9s7ofQYB0vCtiqPxKfCiFWc
         188xG89lB8guHZnm2chQVO4EDAMaJtuu/TXRnCT0kuVjTaQrJluVhS1Pmn3AFf9N4tph
         eZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710293646; x=1710898446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j6LLFNznZ8lfp5XnmEGca4zMWFhvlGP70n1/jWQb0Xs=;
        b=t7VG8+ujNl9EIRoJbRH9uIIqkfJVNzABRZl+I2HndHKqs7C16jhQpLJIkwEo6ajUyV
         k/CqTP3OPNsDoeOcxMYH0Zs0bQEEBdFuJCv5lEAx1sc94eGwV8i8ZmrJP9BeUUKIiMhy
         wAnX+9kScwuKbaR2cRW9irpTjG/UkkcWAUnelMQhQGIU7VbVEfcyi4VvjWiAqZHXemey
         5CqLazkL4DW/cuaMhDQ8J0y6+SM5t/64dsiER6P5HRtDyJJbKWaeNGlfjKUPkVJ3EOrU
         zIUxPZ1YmtfQT19ytgtz7PEva1IrxV7DBoqPEtvfB48lFpdXjvfi3gQlkh/FmdqR3aI3
         FBhg==
X-Gm-Message-State: AOJu0YweKbji6STSWb6+2D/B1k9ToUDFmpJuQOn7ZEyG1HmWJeqmk2pb
	r4tQqhvWAF/k7c0hhnNNajbe1V3mz8NdBkXPXPglrY8moyUAFX0I8NYwuABoWFQ=
X-Google-Smtp-Source: AGHT+IF9l6qjOAoVxKKTeyBEeqkOTqE1q8zT5vlbZeRDyL3DG6GqQLK2nehph+eNAb8AdeFrFiNvKg==
X-Received: by 2002:a2e:a16e:0:b0:2d4:68ef:c711 with SMTP id u14-20020a2ea16e000000b002d468efc711mr865160ljl.25.1710293646229;
        Tue, 12 Mar 2024 18:34:06 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id k21-20020a635615000000b005dcc075d5edsm6712086pgb.60.2024.03.12.18.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 18:34:05 -0700 (PDT)
Message-ID: <ccbfc231-cb82-4455-a137-7d9c9dab44d5@suse.com>
Date: Wed, 13 Mar 2024 09:34:02 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: improve write IO performance when fragmentation is
 high
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240308015251.32041-1-heming.zhao@suse.com>
 <3de83d2c-729b-453f-b874-3d553b8274a7@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <3de83d2c-729b-453f-b874-3d553b8274a7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph,

Before sending v2 patch, I need to explain ocfs2_find_max_contig_free_bits()
for you. See the comment in below.

On 3/11/24 19:04, Joseph Qi wrote:
> 
> Hi,
> 
> Please see my comments inline.
> 
> On 3/8/24 9:52 AM, Heming Zhao wrote:
>> The group_search function ocfs2_cluster_group_search() should
>> bypass groups with insufficient space to avoid unnecessary
>> searches.
>>
>> This patch is particularly useful when ocfs2 is handling huge
>> number small files, and volume fragmentation is very high.
>> In this case, ocfs2 is busy with looking up available la window
>> from //global_bitmap.
>>
>> This patch introduces a new member in the Group Description (gd)
>> struct called 'bg_contig_free_bits', representing the max
>> contigous free bits in this gd. When ocfs2 allocates a new
>> la window from //global_bitmap, 'bg_contig_free_bits' helps
>> expedite the search process.
>>
>> Let's image below path.
>>
>> 1. la state (->local_alloc_state) is set THROTTLED or DISABLED.
>>
>> 2. when user delete a large file and trigger
>>     ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
>>     unconditionally.
>>
>> 3. a write IOs thread run and trigger the worst performance path
>>
>> ```
>> ocfs2_reserve_clusters_with_limit
>>   ocfs2_reserve_local_alloc_bits
>>    ocfs2_local_alloc_slide_window //[1]
>>     + ocfs2_local_alloc_reserve_for_window //[2]
>>     + ocfs2_local_alloc_new_window //[3]
>>        ocfs2_recalc_la_window
>> ```
>>
>> [1]:
>> will be called when la window bits used up.
>>
>> [2]:
>> under la state is ENABLED, and this func only check global_bitmap
>> free bits, it will succeed in general.
>>
>> [3]:
>> will use the default la window size to search clusters then fail.
>> ocfs2_recalc_la_window attempts other la window sizes.
>> the timing complexity is O(n^4), resulting in a significant time
>> cost for scanning global bitmap. This leads to a dramatic slowdown
>> in write I/Os (e.g., user space 'dd').
>>
>> i.e.
>> an ocfs2 partition size: 1.45TB, cluster size: 4KB,
>> la window default size: 106MB.
>> The partition is fragmentation by creating & deleting huge mount of
>> small files.
>>
>> before this patch, the timing of [3] should be
>> (the number got from real world):
>> - la window size change order (size: MB):
>>    106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
>>    only 0.8MB succeed, 0.8MB also triggers la window to disable.
>>    ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
>>    runs in worst case.
>> - group chain number: 242
>>    ocfs2_claim_suballoc_bits calls for-loop 242 times
>> - each chain has 49 block group
>>    ocfs2_search_chain calls while-loop 49 times
>> - each bg has 32256 blocks
>>    ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
>>    for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
>>    (32256/64) (this is not worst value) for timing calucation.
>>
>> the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)
>>
>> In the worst case, user space writes 1MB data will trigger 42M scanning
>> times.
>>
>> under this patch, the timing is '7*242*49 = 83006', reduce by three
>> orders of magnitude.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/move_extents.c |   6 +-
>>   fs/ocfs2/ocfs2_fs.h     |   4 +-
>>   fs/ocfs2/resize.c       |   7 +++
>>   fs/ocfs2/suballoc.c     | 120 ++++++++++++++++++++++++++++------------
>>   fs/ocfs2/suballoc.h     |  28 +++++++++-
>>   5 files changed, 122 insertions(+), 43 deletions(-)
>>
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index 1f9ed117e78b..6b9753b8c6fb 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -576,6 +576,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>   	u32 move_max_hop = ocfs2_blocks_to_clusters(inode->i_sb,
>>   						    context->range->me_threshold);
>>   	u64 phys_blkno, new_phys_blkno;
>> +	struct ocfs2_suballoc_result res = {0};
>>   
>>   	phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
>>   
>> @@ -684,8 +685,9 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>   		goto out_commit;
>>   	}
>>   
>> -	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
>> -					 goal_bit, len);
>> +	res.sr_bit_offset = goal_bit;
>> +	res.sr_bits = len;
>> +	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh, &res, 0);
>>   	if (ret) {
>>   		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
>>   					       le16_to_cpu(gd->bg_chain));
>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>> index 7aebdbf5cc0a..eae18d772e93 100644
>> --- a/fs/ocfs2/ocfs2_fs.h
>> +++ b/fs/ocfs2/ocfs2_fs.h
>> @@ -883,14 +883,14 @@ struct ocfs2_group_desc
>>   	__le16	bg_free_bits_count;     /* Free bits count */
>>   	__le16   bg_chain;               /* What chain I am in. */
>>   /*10*/	__le32   bg_generation;
>> -	__le32	bg_reserved1;
>> +	__le32   bg_contig_free_bits;  /* max contig free bits length */
>>   	__le64   bg_next_group;          /* Next group in my list, in
>>   					   blocks */
>>   /*20*/	__le64   bg_parent_dinode;       /* dinode which owns me, in
>>   					   blocks */
>>   	__le64   bg_blkno;               /* Offset on disk, in blocks */
>>   /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
>> -	__le64   bg_reserved2;
>> +	__le64   bg_reserved1;
>>   /*40*/	union {
>>   		DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
>>   		struct {
>> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
>> index d65d43c61857..ab30518d5f04 100644
>> --- a/fs/ocfs2/resize.c
>> +++ b/fs/ocfs2/resize.c
>> @@ -91,6 +91,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>   	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
>>   	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
>>   	u16 old_bg_clusters;
>> +	u32 contig_bits = 0, old_bg_contig_free_bits;
>>   
>>   	trace_ocfs2_update_last_group_and_inode(new_clusters,
>>   						first_new_cluster);
>> @@ -122,6 +123,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>   		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
>>   	}
>>   
>> +	ocfs2_find_max_contig_free_bits(group->bg_bitmap,
>> +					group->bg_bits, 0, &contig_bits);
>> +	old_bg_contig_free_bits = group->bg_contig_free_bits;
>> +	group->bg_contig_free_bits = cpu_to_le32(contig_bits);
>> +
>>   	ocfs2_journal_dirty(handle, group_bh);
>>   
>>   	/* update the inode accordingly. */
>> @@ -160,6 +166,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
>>   		le16_add_cpu(&group->bg_free_bits_count, backups);
>>   		le16_add_cpu(&group->bg_bits, -1 * num_bits);
>>   		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
>> +		group->bg_contig_free_bits = old_bg_contig_free_bits;
>>   	}
>>   out:
>>   	if (ret)
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 166c8918c825..df149c3b0eed 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -37,21 +37,6 @@
>>   
>>   #define OCFS2_MAX_TO_STEAL		1024
>>   
>> -struct ocfs2_suballoc_result {
>> -	u64		sr_bg_blkno;	/* The bg we allocated from.  Set
>> -					   to 0 when a block group is
>> -					   contiguous. */
>> -	u64		sr_bg_stable_blkno; /*
>> -					     * Doesn't change, always
>> -					     * set to target block
>> -					     * group descriptor
>> -					     * block.
>> -					     */
>> -	u64		sr_blkno;	/* The first allocated block */
>> -	unsigned int	sr_bit_offset;	/* The bit in the bg */
>> -	unsigned int	sr_bits;	/* How many bits we claimed */
>> -};
>> -
>>   static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
>>   {
>>   	if (res->sr_blkno == 0)
>> @@ -1272,6 +1257,25 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
>>   	return ret;
>>   }
>>   
>> +/* caller should initialize contig_bits */
>> +void ocfs2_find_max_contig_free_bits(void *bitmap,
>> +			 unsigned int total_bits, int start,
>> +			 unsigned int *contig_bits)
>> +{
>> +	int offset, free_bits;
>> +
>> +	while (start < total_bits) {
>> +		offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
>> +		if (offset == total_bits)
>> +			break;
>> +
>> +		start = ocfs2_find_next_bit(bitmap, total_bits, offset);
>> +		free_bits = start - offset;
>> +		if (*contig_bits < free_bits)
>> +			*contig_bits = free_bits;
>> +	}
> 
> Or we can just return the contig_bits. Something like:
> unsigned int ocfs2_find_max_contig_free_bits(void *bitmap,
> 		unsigned int total_bits, int start)
> {
> 	int offset, start;
> 	unsigned int contig_bits = 0;
> 
> 	while () {
> 		...
> 	}
> 
> 	return contig_bits;
> }

the input *contig_bits has two jobs:
- return the max contigous free bits of bitmap
- if *contig_bits is not ZERO, it keeps the max-contig-bits
   from last search. When the input 'start' not zero
   (means start from middle of bitmap), the max-contig-bits
   from latter part of bitmap may smaller than first part.
   at this case, function should keep & return the input
   *contig_bits.

the view of ocfs2_find_max_contig_free_bits():

   front part  |  latter part
[-------------+------------------] bitmap
  0            'start'           total_bits

the call stack:

ocfs2_search_one_group
+ ac->ac_group_search
|  ocfs2_cluster_group_search
|   ocfs2_block_group_find_clear_bits
|    + scan area [0, res->sr_bit_offset + res->sr_bits - 1]
|    | /* zhm: save the second max-contig-bits.
|    |  * if it doesn't exist, the value is 0. */
|    + res->sr_max_contig_bits = prev_best_size;
|
+ ocfs2_block_group_set_bits
    ocfs2_find_max_contig_free_bits(...,
             start, /* zhm: may not ZERO, help to speed up the search */
             res->sr_max_contig_bits) /* zhm: the optimal value may have been reached */

So we should keep ocfs2_find_max_contig_free_bits() with a return type of 'void'.

-Heming

