Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F4E49A3D2;
	Fri,  9 Oct 2026 09:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538604; cv=none; b=fGcd3yjMq3/MZXaGjNVb63lKLT28iY/zm6AJETvZRQSeLcFLc4hVGEDhTLSooCLst0C3CJY8ggngAbprPH5NkE5cWqEOYa/TdcpsHcgzZDa1VDkrx0/dfA9psAhiXSrqKJITna9jBRm17Nk0YeVhYZBHqDiIYjiu0AvH8jtYLBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538604; c=relaxed/simple;
	bh=gaYw7HD64UCVgK2Uf8zpRsyaO2b6rlyzLYLoAr0mBBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCm9VOBW2eWtlsDNU5NAHiUoEZkWHuSd4S0w641Xm77J7j9MAt5GDWSfX2FpNz8gsuIW1wuhQ1Nu3RmdHNWdR/NAFuMpjRAC2aXj+oNn3i15OZU+KQIkWJ3lbaz3m9V0W2OGpNIA/5whYWs7EVhgI0vKSJcJZPMgxY982vSOZvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H9rX8kmw; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H9rX8kmw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791538582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kJu+lMYfoxcAxZS5wytHdkJUvnFLwOSD6ZOJqDIxfSU=;
	b=H9rX8kmw8s7104StlAvXGgYTFmi4fvePAHKHoPatchG3pZyV4Sng78jaAWVCt1M+LazTnKMHU1opNrY5wYnghejaYwQaPS/J/BtJA0Yj5/As4F6/p7Ufm9GHi21vx17mBepMe/voj9HHn8xPJaPnnkbt7jfoAOy6CUeFIeOuonU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSxcQl_1791538580;
Received: from 30.221.148.47(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSxcQl_1791538580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 17:36:21 +0800
Message-ID: <eb07fec3-58d5-4822-91c1-50675a8fabfa@linux.alibaba.com>
Date: Fri, 9 Oct 2026 17:36:20 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ocfs2: use the stored hash when checking xattr
 bucket collision
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
 <20261009083002.2621201-3-joseph.qi@linux.alibaba.com>
 <sashiko-outbox-165102@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-165102@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 4:44 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] fs/ocfs2: xattr data corruption due to stale loc.xl_entry after bucket defrag
> --
> 
> commit 6247b6061c7a43f1fbd44574fe532663a6b670bc
> Author: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>     ocfs2: use the stored hash when checking xattr bucket collision
> 
> This patch changes ocfs2_check_xattr_bucket_collision() to use the stored hash
> for existing entries when checking for bucket collisions during splits. It
> fixes an issue where unsigned hashes compared against legacy buckets reported
> no collision, leading to duplicate entries.
> 
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index a428fe908116e..c5a39a7d43d07 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
> 
> [ ... ]
> 
>> @@ -5993,10 +5992,18 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
>>  	 * the maximum number of collisions we will allow for then is
>>  	 * one bucket's worth, so check it here whether we need to
>>  	 * add a new bucket for the insert.
>> +	 *
>> +	 * An existing entry keeps the hash it was stored under, and that is
>> +	 * the hash a split has to work with.  A new entry is stored under the
>> +	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
>>  	 */
>> -	ret = ocfs2_check_xattr_bucket_collision(inode,
>> -						 xs->bucket,
>> -						 xi->xi_name);
>> +	if (xs->not_found)
>> +		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
>> +						  xi->xi_name_len);
>> +	else
>> +		name_hash = le32_to_cpu(xs->here->xe_name_hash);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> If ocfs2_xattr_set_entry_bucket() fails with -ENOSPC after defragmentation,
> can this access a stale xs->here pointer?
> 
> In ocfs2_xattr_set_entry_bucket(), loc.xl_entry is initialized to point
> directly to the target array element (xs->here):
> 
> 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
> 				       xs->not_found ? NULL : xs->here);
> 
> If ocfs2_xa_set() fails with -ENOSPC, it calls ocfs2_defrag_xattr_bucket(),
> which sorts the entries array by xe_name_hash:
> 
> 	/* sort the entries by their name_hash. */
> 	sort(entries, le16_to_cpu(xh->xh_count),
> 	     sizeof(struct ocfs2_xattr_entry),
> 	     cmp_xe, NULL);
> 
> Since sort() is unstable and hashes only cover the name suffix, identical-hash
> entries can be swapped. If they are swapped, loc.xl_entry and xs->here now
> point to the wrong xattr entry.
> 
> The second ocfs2_xa_set() call then reuses the stale loc.xl_entry pointer
> without re-evaluating its position in the sorted array:
> 
> 	ret = ocfs2_xa_set(&loc, xi, ctxt);
> 
> Can this overwrite the wrong xattr's data on disk, causing data corruption?
> 
> If the second ocfs2_xa_set() also fails with -ENOSPC, it returns to
> ocfs2_xattr_set_entry_index_block() where the patch now relies on the stale
> xs->here pointer to read the name_hash.
> 

It seems unrelated to my patch.

Since the array is already sorted on xe_name_hash when defrag runs,
re-sorting on the same key can only permute within a run of equal
hashes. The pointer may denote a different entry, but not a different
hash.

The underlying bug is real and independent of my series: after defrag
permutes an equal-hash run, that second ocfs2_xa_set(&loc, ...) operates
on a different entry. I'd like this to be addressed in a separate
thread.

Thanks,
Joseph
