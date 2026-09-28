Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA5495032
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589400; cv=none; b=iQSL2jC/dNY1pULaCSXBzwFv++Y9Miybmoo+f1uQQTRF3MmV+X6E0GvBLCoyEHD86mBq4jhC3GJHiLWsX0npFVgzqIC7Sfea4y46VOT1ZkoQYtbEzGQ/X8LMitN1zdiix+ypJSwgJk/byIKfvSEHhNlTw6h8ctDAeENabSKtLSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589400; c=relaxed/simple;
	bh=Mz0deYU1xOfYGQIBc4XUCNpGi4xiDI26J6pp/LNHrUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ro5IUhx0KfDdrD5x6NKD+4nox85/2S3um8hlZnOdRylU149KBK9MWx2d7IUbzpf7DSqggyDLnH7WqrLkNlxjdcVE3reJu6+BIA/rqJQfLJU55d4ybG3gp9j1KqaI/zhuyy3g4riZs7bhYiQs8Ex66ek8Lfw9VdEU9WSn5dUaMQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=QK3v+HLI; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="QK3v+HLI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790589389; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=a8lNDEEGHD6z4GRB1sYGlOYweE4F493J28rMhTRvBIM=;
	b=QK3v+HLI/ZzyXTYx5BIytoI5qjqIJ8UNfiLYiWZG5n5pKOeCE9m3AKJdgQehsS1A64FQNgvKyFT40/LqUPaWjZwtN+OqPMiyHNjqddNp4SKAYLqvQjxce1+XCBoeFt8WBAaP5OsZH+eRUBz1AiroOU/6ifxgiiXeyiQ+XD7xghs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XBlwpe0_1790589387;
Received: from 30.221.128.216(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBlwpe0_1790589387 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 17:56:28 +0800
Message-ID: <08d85624-7da8-4d6e-9899-765d1af2e9f4@linux.alibaba.com>
Date: Mon, 28 Sep 2026 17:56:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate extent list in filecheck repair
To: Heming Zhao <heming.zhao@suse.com>, yaojiale02@163.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260926131848.3379842-1-yaojiale02@163.com>
 <744a70bd-5455-421f-a37d-1c0a63f54b60@linux.alibaba.com>
 <arn2x2Y688K9Js4N@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <arn2x2Y688K9Js4N@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/28/26 1:18 PM, Heming Zhao wrote:
> On Mon, Sep 28, 2026 at 09:33:12AM +0800, Joseph Qi wrote:
>>
>>
>> On 9/26/26 9:18 PM, Jiale Yao wrote:
>>> ocfs2_filecheck_validate_inode_block() does not validate the embedded
>>> extent list, while ocfs2_filecheck_repair_inode_block() only clamps
>>> l_next_free_rec to l_count.  The normal inode read path requires l_count
>>> to be non-zero, limits it to the number of extent records that fit in the
>>> inode, and requires l_next_free_rec not to exceed l_count.
>>>
>>> Without the same checks, filecheck can report SUCCESS while leaving an
>>> invalid extent list on disk.  A later read through the normal inode
>>> validation path rejects the inode and makes the filesystem read-only.
>>>
>>> Add a shared helper for the filecheck paths to check these invariants.
>>> The filecheck validator now rejects all three cases.  The repair path
>>> still clamps l_next_free_rec, but refuses to repair zero or oversized
>>> l_count values.
>>>
>>> Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
>>
>> I'd like make this as a new ability rather than a bug fix.
>>
>>> Signed-off-by: Jiale Yao <yaojiale02@163.com>
>>> ---
>>>  fs/ocfs2/inode.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 71 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>>> index 180107a11046..57168ed02915 100644
>>> --- a/fs/ocfs2/inode.c
>>> +++ b/fs/ocfs2/inode.c
>>> @@ -249,6 +249,41 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
>>>  	return 1;
>>>  }
>>>  
>>> +enum ocfs2_extent_list_status {
>>> +	OCFS2_EXTENT_LIST_OK,
>>> +	OCFS2_EXTENT_LIST_ZERO_COUNT,
>>> +	OCFS2_EXTENT_LIST_OVERSIZED,
>>> +	OCFS2_EXTENT_LIST_BAD_NEXT_FREE,
>>> +};
>>> +
>>> +static enum ocfs2_extent_list_status
>>> +ocfs2_check_extent_list(struct super_block *sb, struct ocfs2_dinode *di)
>>> +{
>>> +	struct ocfs2_extent_list *el = &di->id2.i_list;
>>> +	u16 count;
>>> +	u16 next_free;
>>> +
>>> +	if (!ocfs2_dinode_has_extents(di))
>>> +		return OCFS2_EXTENT_LIST_OK;
>>> +
>>> +	count = le16_to_cpu(el->l_count);
>>> +	next_free = le16_to_cpu(el->l_next_free_rec);
>>> +	if (count == 0)
>>> +		return OCFS2_EXTENT_LIST_ZERO_COUNT;
>>> +	/*
>>> +	 * The exact capacity depends on i_xattr_inline_size, another
>>> +	 * unvalidated on-disk field. Inline xattrs only shrink the
>>> +	 * list, so the no-xattr maximum is a safe upper bound that a
>>> +	 * valid l_count never exceeds.
>>> +	 */
>>> +	if (count > ocfs2_extent_recs_per_inode(sb))
>>> +		return OCFS2_EXTENT_LIST_OVERSIZED;
>>> +	if (next_free > count)
>>> +		return OCFS2_EXTENT_LIST_BAD_NEXT_FREE;
>>> +
>>> +	return OCFS2_EXTENT_LIST_OK;
>>> +}
>>
>> This seems a duplicated check in ocfs2_validate_inode_block().
>> So I sugguest just extract the helper from it instead of duplicating
>> a new one.
>>
>> BTW, seems we don't have to introduce enum ocfs2_extent_list_status,
>> to make the checks simple.
>>
>> Thanks,
>> Joseph
> 
> Hi Joseph,
> 
> The code logic is identical for ocfs2_validate_inode_block() and
> ocfs2_filecheck_validate_inode_block(), except for their error handling style.
> It seems possible to merge them into ocfs2_validate_inode_block() by adding
> a bool check parameter to distinguish between the two behaviors, and then remove
> ocfs2_filecheck_validate_inode_block().
> 
> The new code logic: replace ocfs2_error() with mlog(), and then "goto bail".
> At the bail label, handle the two cases separately using "if (check)".
> 
> i.e.:
> //adding a new parameter "check"
> int ocfs2_validate_inode_block(struct super_block *sb,
> 			       struct buffer_head *bh, bool check)
> 
> 
> code change from:
> ```
> 	int rc;
> 
> 	... ...
> 
> 	if (!OCFS2_IS_VALID_DINODE(di))
>                 rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
> 		     (unsigned long long)bh->b_blocknr, 7,
>                      di->i_signature);
>                 goto bail;
>         }
> ```
> 
> to
> ```
> 	int rc = 0;
> 
> 	... ...
> 
> 	if (!OCFS2_IS_VALID_DINODE(di))
>                 mlog(sb, "Invalid dinode #%llu: signature = %.*s\n",
> 		     (unsigned long long)bh->b_blocknr, 7,
>                      di->i_signature);
>                 goto bail;
>         }
> 
> 	... ...
> 
> 	return rc;
> 
> bail:
> 	if (check) {
> 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> 	} else {
> 		rc = ocfs2_error(sb, "invalid dinode\n");
> 	}
> 
> 	return rc;
> }
> ```

Ummm... This may make the code messy.
I'd like only abtract the check condition, and let the return code and
log message as in its own validation function.
e.g. ocfs2_dinode_has_size_without_clusters().

Thanks,
Joseph
