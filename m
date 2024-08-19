Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB441DFED
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 02:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724035323; cv=none; b=qbbyQ5iIHvNGycH2tLuc9JoVt6IqO/BKT+Lfo39uWP71htoioz9a6vWdrcK8AOx+R4Pcj0TSU3Dygn9kMr/mnZZ6XqKq+cR9NP3dzXRQbcR8Zp+lmilNZkg5U4XyTVAshp9L4TpkgywktCU+/g9bXIZlBd4Wu2jAD142gcFJxu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724035323; c=relaxed/simple;
	bh=69BgL5Y3vpfGq66V6Tw0QpCEq8/qqPOBbTkGoRQ8e1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GOwvWzq8vqy1R1hXrZUDPbzU05sRKpqF4h3BJAtyuYMgkD1SgIKkIhaJkodx0uOlxAzKKSauFxWp1yWJHdobQ+j3xQTgJBw77VHnX1tmyNKiceOuDi46P7BfjNgSko1/acXLyrQWPrnylbCqr62FfFtfIBjK1Tj+/vCpWRGHJ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Y8Lp33aZ; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Y8Lp33aZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724035313; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zo6tB5cAYZ1gQ54vtXE5c4SoMVKkByEuctQv9OS1syc=;
	b=Y8Lp33aZy4LQasS1uWRncOEtrEDnuPwIdzVYTetIXq2PXXJegwO0UiE33h+qYQVzdul/fCAzbCFRJDxaiFzJwrNoTEH7eoODV2LRZex4mJuiIm5nt13pSb75oApzo2c5Z669Xgd6GjoKrEP97Lra+16L0sdC4Ox+pBCJfwTSRrY=
Received: from 30.221.129.125(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WD4uFA6_1724035311)
          by smtp.aliyun-inc.com;
          Mon, 19 Aug 2024 10:41:52 +0800
Message-ID: <27b7f0e6-b668-407b-abf8-30613fcf732c@linux.alibaba.com>
Date: Mon, 19 Aug 2024 10:41:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Remove custom swap functions in favor of built-in
 sort swap
To: Heming Zhao <heming.zhao@suse.com>, Kuan-Wei Chiu <visitorckw@gmail.com>,
 akpm <akpm@linux-foundation.org>
Cc: jserv@ccns.ncku.edu.tw, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References: <20240810195316.186504-1-visitorckw@gmail.com>
 <a4b3ab50-02af-42f2-b937-dcbb92b4f0d2@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <a4b3ab50-02af-42f2-b937-dcbb92b4f0d2@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/18/24 7:36 PM, Heming Zhao wrote:
> On 8/11/24 03:53, Kuan-Wei Chiu wrote:
>> The custom swap functions used in ocfs2 do not perform any special
>> operations and can be replaced with the built-in swap function of sort.
>> This change not only reduces code size but also improves efficiency,
>> especially in scenarios where CONFIG_RETPOLINE is enabled, as it makes
>> indirect function calls more expensive.
>>
>> By using the built-in swap, we avoid these costly indirect function
>> calls, leading to better performance.
>>
>> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Looks good to me
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

>> ---
>> Note: Build test only.
>>
>>   fs/ocfs2/dir.c          | 12 +-----------
>>   fs/ocfs2/refcounttree.c | 13 +++----------
>>   fs/ocfs2/xattr.c        | 15 +++------------
>>   3 files changed, 7 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index f0beb173dbba..fa5d0819a997 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -3511,16 +3511,6 @@ static int dx_leaf_sort_cmp(const void *a, const void *b)
>>       return 0;
>>   }
>>   -static void dx_leaf_sort_swap(void *a, void *b, int size)
>> -{
>> -    struct ocfs2_dx_entry *entry1 = a;
>> -    struct ocfs2_dx_entry *entry2 = b;
>> -
>> -    BUG_ON(size != sizeof(*entry1));
>> -
>> -    swap(*entry1, *entry2);
>> -}
>> -
>>   static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
>>   {
>>       struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
>> @@ -3781,7 +3771,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>>        */
>>       sort(dx_leaf->dl_list.de_entries, num_used,
>>            sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
>> -         dx_leaf_sort_swap);
>> +         NULL);
>>         ocfs2_journal_dirty(handle, dx_leaf_bh);
>>   diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 1f303b1adf1a..4f85508538fc 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -1392,13 +1392,6 @@ static int cmp_refcount_rec_by_cpos(const void *a, const void *b)
>>       return 0;
>>   }
>>   -static void swap_refcount_rec(void *a, void *b, int size)
>> -{
>> -    struct ocfs2_refcount_rec *l = a, *r = b;
>> -
>> -    swap(*l, *r);
>> -}
>> -
>>   /*
>>    * The refcount cpos are ordered by their 64bit cpos,
>>    * But we will use the low 32 bit to be the e_cpos in the b-tree.
>> @@ -1474,7 +1467,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
>>        */
>>       sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
>>            sizeof(struct ocfs2_refcount_rec),
>> -         cmp_refcount_rec_by_low_cpos, swap_refcount_rec);
>> +         cmp_refcount_rec_by_low_cpos, NULL);
>>         ret = ocfs2_find_refcount_split_pos(rl, &cpos, &split_index);
>>       if (ret) {
>> @@ -1499,11 +1492,11 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
>>         sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
>>            sizeof(struct ocfs2_refcount_rec),
>> -         cmp_refcount_rec_by_cpos, swap_refcount_rec);
>> +         cmp_refcount_rec_by_cpos, NULL);
>>         sort(&new_rl->rl_recs, le16_to_cpu(new_rl->rl_used),
>>            sizeof(struct ocfs2_refcount_rec),
>> -         cmp_refcount_rec_by_cpos, swap_refcount_rec);
>> +         cmp_refcount_rec_by_cpos, NULL);
>>         *split_cpos = cpos;
>>       return 0;
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 35c0cc2a51af..0e58a5ce539e 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -4167,15 +4167,6 @@ static int cmp_xe(const void *a, const void *b)
>>       return 0;
>>   }
>>   -static void swap_xe(void *a, void *b, int size)
>> -{
>> -    struct ocfs2_xattr_entry *l = a, *r = b, tmp;
>> -
>> -    tmp = *l;
>> -    memcpy(l, r, sizeof(struct ocfs2_xattr_entry));
>> -    memcpy(r, &tmp, sizeof(struct ocfs2_xattr_entry));
>> -}
>> -
>>   /*
>>    * When the ocfs2_xattr_block is filled up, new bucket will be created
>>    * and all the xattr entries will be moved to the new bucket.
>> @@ -4241,7 +4232,7 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
>>       trace_ocfs2_cp_xattr_block_to_bucket_end(offset, size, off_change);
>>         sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
>> -         cmp_xe, swap_xe);
>> +         cmp_xe, NULL);
>>   }
>>     /*
>> @@ -4436,7 +4427,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>>        */
>>       sort(entries, le16_to_cpu(xh->xh_count),
>>            sizeof(struct ocfs2_xattr_entry),
>> -         cmp_xe_offset, swap_xe);
>> +         cmp_xe_offset, NULL);
>>         /* Move all name/values to the end of the bucket. */
>>       xe = xh->xh_entries;
>> @@ -4478,7 +4469,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>>       /* sort the entries by their name_hash. */
>>       sort(entries, le16_to_cpu(xh->xh_count),
>>            sizeof(struct ocfs2_xattr_entry),
>> -         cmp_xe, swap_xe);
>> +         cmp_xe, NULL);
>>         buf = bucket_buf;
>>       for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)
