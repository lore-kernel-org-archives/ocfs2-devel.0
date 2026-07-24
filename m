Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B86188596
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Jul 2026 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784856742; cv=none; b=Sk3LwvEJqgUckviKeWjNUXVHybi3xNlcj5S7ZazN2pUFERCkWJXthw+c99ZUdegjUqFnNaqOzl0EmE0TS9PyVPG5rI2r8/nnJUxruHyifmB5HZOL1xl0eoOBM0BhzlyjTZGexFV7ErSQ1qqVDretBovA1uey7jIwVVEa9rmpCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784856742; c=relaxed/simple;
	bh=HHHZiTcrTjFb+UWVphjXbdfBcFvlyyfL+qME1N5d29M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=sOVVs7OJFoLcsLVlQZhcCtI7B04EvNfNK84jZfwlMv47qgutnTT/AqpEdTEplrtzHiDKTDgRVGVzVRPbJe5yygIsirUIXGeBjvAFlFxrSREl2EGYd2i8Jaz9grAJfMrjy7+j9w5wWQKQOa0i+YKPzVcKRTvsvQC94kRmB0kh71A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ID714WtT; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ID714WtT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784856736; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kKKYdn2hGDdCn/1y1KFi9p9D69T092R6LhPTdJFFHFg=;
	b=ID714WtTneC9KCDXS8ijDiumtkPCUrQbzh0Z3qVeknaM1S/SH4NEG1EevuZ8bveZ/NB0vZiwdF0LAWaeW/eRbi/Jj1bb1fUEJnvc0Ca/fWviquwZ0jIHuRC/w/+r9U8kjOmuY4pftGA2WQFI4spuYERrepDzL+aquxt61o1dbDw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X7hRwxX_1784856734;
Received: from 30.221.128.197(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7hRwxX_1784856734 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 09:32:15 +0800
Message-ID: <882d50db-d579-4794-ad2f-8bb88d2e1ace@linux.alibaba.com>
Date: Fri, 24 Jul 2026 09:32:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix missing metadata reservation for large xattrs
To: Ian Bridges <icb@fastmail.org>
References: <ahrxN7dbUaOqX9vT@dev> <amI3PMgVtPU_DVVT@dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <amI3PMgVtPU_DVVT@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/23/26 11:46 PM, Ian Bridges wrote:
> On Sat, May 30, 2026 at 09:16:28AM -0500, Ian Bridges wrote:
>> [BUG]
>> lsetxattr() panics the kernel when setting a large xattr value on a
>> fragmented filesystem where the file already has an external xattr
>> block.
>>
>> [CAUSE]
>> ocfs2_calc_xattr_set_need() never reserves metadata blocks for a new
>> xattr value's extent tree when the file already has an external xattr
>> block. The not_found path leaves meta_add at zero, so meta_ac is NULL
>> when ocfs2_xattr_extend_allocation() runs.
>>
>> A new value root has room for a single extent record. On a fragmented
>> filesystem, the allocator cannot satisfy the xattr value in one
>> contiguous run, so each non-contiguous run requires its own extent
>> record. When the value root's extent list is full and meta_ac is NULL,
>> ocfs2_add_clusters_in_btree() returns RESTART_META, and
>> ocfs2_xattr_extend_allocation() hits BUG_ON(why == RESTART_META).
>>
>> [FIX]
>> The case where no xattr block exists yet already calls
>> ocfs2_extend_meta_needed(&def_xv.xv.xr_list) to reserve value tree
>> metadata. Add the same reservation to the case where an xattr block
>> already exists, making the two cases consistent.
>>
>> Replace the BUG_ON with a -ENOSPC return so that if RESTART_META is
>> returned despite the reservation, the error propagates to userspace
>> instead of panicking the kernel.
>>
>> Fixes: a78f9f466894 ("ocfs2: make xattr extension work with new local alloc reservation.")
>> Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
>> Signed-off-by: Ian Bridges <icb@fastmail.org>
>> ---
>> This patch contains a proposed fix for a crash reported by syzbot
>> in ocfs2_xattr_value_truncate().
>>
>> This is my first attempt at submitting a patch to the Linux kernel,
>> so all feedback is appreciated.
>>
>> The file names and offsets in this description are from commit
>> 7cb1c5b32a2bfde961fff8d5204526b609bcb30a from this repo:
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>>
>> I also have a small test harness that reproduces the original panic,
>> which I can make available as well.
>>
>> The Bug
>>
>> When a user sets an extended attribute (xattr) that requires more
>> than 80 bytes of storage (OCFS2_XATTR_INLINE_SIZE,
>> fs/ocfs2/xattr.c:80) on a file, OCFS2 adds a name-root
>> (ocfs2_xattr_value_root) pair to the file's xattr storage area —
>> either the inline area at the tail of the inode block or the
>> external xattr block, depending on which has space. The xattr value
>> is then stored in separate clusters on disk. The value root is the
>> entry point for looking up which clusters hold the value.
>>
>> Each new root is cloned from def_xv (fs/ocfs2/xattr.c:90). The
>> def_xv template has its l_count member explicitly initialized to 1
>> (fs/ocfs2/xattr.c:91). l_count = 1 means the embedded
>> ocfs2_extent_list has room for exactly one extent record.
>> l_tree_depth is implicitly set to 0.
>>
>> OCFS2 will attempt to find a single run of contiguous free clusters
>> to store the xattr value. If it cannot find such a run because the
>> disk is fragmented, OCFS2 will store the xattr value across multiple
>> non-contiguous runs of clusters.
>>
>> The ocfs2_xattr_value_root embedded in the xattr entry is the root
>> of a B-tree that tracks extent records. Each non-contiguous run of
>> clusters requires its own extent record in this tree. Since l_count
>> is 1, the root can only hold a single extent record initially. If
>> the xattr value requires more than one extent record, the tree must
>> grow, which requires allocating a new metadata block.
>>
>> Before opening a transaction to allocate clusters for the xattr
>> value, ocfs2_xattr_set() calls ocfs2_init_xattr_set_ctxt()
>> (fs/ocfs2/xattr.c:3280), which calls ocfs2_calc_xattr_set_need()
>> (fs/ocfs2/xattr.c:3068) to pre-calculate the number of clusters
>> and metadata blocks the operation will need.
>>
>> The root cause of the bug is a missing reservation in
>> ocfs2_calc_xattr_set_need(). When adding a new large-value xattr to
>> a file that already has an external xattr block, the function never
>> adds anything to meta_add for the value tree, leaving it at 0. Here
>> is a breakdown:
>>
>>  0. ocfs2_calc_xattr_set_need() is called from
>>     ocfs2_init_xattr_set_ctxt() (fs/ocfs2/xattr.c:3296).
>>  1. The meta_add local is initialized to 0.
>>  2. Because we are adding a new xattr, xis->not_found and
>>     xbs->not_found are both -ENODATA. This means execution is
>>     transferred to the meta_guess label (fs/ocfs2/xattr.c:3212)
>>     with meta_add still set to 0.
>>  3. The reproducer code only sets a few xattrs. The xattrs fill the
>>     inode inline area and spill into the external xattr block, but
>>     not enough to cause the block to be indexed. Since the block is
>>     not indexed, we skip the incrementing of meta_add under the
>>     meta_guess label (fs/ocfs2/xattr.c:3235), and meta_add remains
>>     0.
>>  4. The value of meta_add (still 0) is returned to
>>     ocfs2_init_xattr_set_ctxt() through the meta_need parameter
>>     (fs/ocfs2/xattr.c:3296).
>>  5. extra_meta is 0 because the file is not a refcounted inode, so
>>     meta_add in ocfs2_init_xattr_set_ctxt() remains 0
>>     (fs/ocfs2/xattr.c:3303).
>>  6. Because meta_add is 0, ocfs2_init_xattr_set_ctxt() skips the
>>     metadata block reservation code
>>     (ocfs2_reserve_new_metadata_blocks()) and meta_ac remains 0
>>     (fs/ocfs2/xattr.c:3307).
>>  7. Eventually, we end up in ocfs2_xattr_extend_allocation()
>>     (fs/ocfs2/xattr.c:699) with the 0 meta_ac value having been
>>     propagated into ctxt->meta_ac.
>>  8. Due to disk fragmentation (which we purposefully cause in the
>>     reproducer code), the xattr value we set must be split into two
>>     non-contiguous clusters. This causes us to pass through the
>>     allocation loop in ocfs2_xattr_extend_allocation() twice.
>>  9. When ocfs2_add_clusters_in_btree() is called during the first
>>     pass through the loop (fs/ocfs2/xattr.c:723), the root has one
>>     free extent slot (l_count (1) - l_next_free_rec (0) = 1). The
>>     extent record for the first cluster is inserted into that slot,
>>     and l_next_free_rec is incremented to 1.
>>  10. Since the entire xattr value did not fit in the first cluster,
>>      why is set to RESTART_TRANS. This triggers another pass through
>>      the allocation loop.
>>  11. During the second pass through the loop, ctxt->meta_ac is
>>      still 0. Now that there are no more free slots in the root's
>>      ocfs2_extent_list (l_count (1) - l_next_free_rec (1) = 0),
>>      ocfs2_add_clusters_in_btree() returns RESTART_META in why
>>      (fs/ocfs2/alloc.c:4832).
>>  12. We then hit the BUG_ON assertion (fs/ocfs2/xattr.c:747) and
>>      panic.
>>
>> The Proposed Fix
>>
>> The proposed fix has two parts.
>>
>> The first part adds the missing reservation in
>> ocfs2_calc_xattr_set_need(). This change is derived from a similar
>> pattern (fs/ocfs2/xattr.c:3260), which handles the case where no
>> xattr block exists yet. This ensures meta_ac is not 0 when
>> ocfs2_xattr_extend_allocation() runs.
>>
>> The second part replaces the BUG_ON(why == RESTART_META) assertion
>> (fs/ocfs2/xattr.c:747) with a -ENOSPC return. If RESTART_META is
>> returned, the loop breaks and propagates -ENOSPC to userspace
>> instead of panicking the kernel.
>>
>>  fs/ocfs2/xattr.c | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index 86cfd4c2adf9..7eb8cce433de 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -740,12 +740,10 @@ static int ocfs2_xattr_extend_allocation(struct inode *inode,
>>  					 prev_clusters;
>>  
>>  		if (why != RESTART_NONE && clusters_to_add) {
>> -			/*
>> -			 * We can only fail in case the alloc file doesn't give
>> -			 * up enough clusters.
>> -			 */
>> -			BUG_ON(why == RESTART_META);
>> -
>> +			if (why == RESTART_META) {
>> +				status = -ENOSPC;
>> +				break;
>> +			}
>>  			credits = ocfs2_calc_extend_credits(inode->i_sb,
>>  							    &vb->vb_xv->xr_list);
>>  			status = ocfs2_extend_trans(handle, credits);
>> @@ -3241,6 +3239,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
>>  		} else
>>  			credits += OCFS2_SUBALLOC_ALLOC + 1;
>>  
>> +		/*
>> +		 * Reserve metadata for the new xattr's value extent tree.
>> +		 * The not_found path above adds credits for this tree but
>> +		 * omits meta_add, leaving meta_ac NULL for large values.
>> +		 */
>> +		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
>> +			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
>> +
>>  		/*
>>  		 * This cluster will be used either for new bucket or for
>>  		 * new xattr block.
>> -- 
>> 2.47.3
>>
> 
> Gentle ping. This fixes a syzbot reported kernel panic and has had no
> response since May. The patch still applies cleanly to current mainline
> and to mm-nonmm-unstable. Happy to resend if that is preferable.
> 

I can't find this patch in my local mailbox, that's why I've missed it.
Could you please resend it?

Thanks,
Joseph

