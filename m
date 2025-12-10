Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142FE1A9B46
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 09:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765357222; cv=none; b=a2EdyTY2E3MGpJurtvihBZavNcPy/RUPHMGa5UBM98XpeD6Wor6Ue83FjEBl46N2F1z4VVcp7Mkb5I9KoDsUSMVgjgyatRNxBN8VIHth3Zlr8Hr8RSFzYS1B/X6w5J1NPfBOJ2hX3ByEDokekE/KQtNkF45KZVsH/rZ6AJM1eZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765357222; c=relaxed/simple;
	bh=jHxm6W4y5ONoEvR5mwomdUCTxi5+XOHMo03z9WuuTik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgXmHIb40DHgFxszWMHSTx6wQ0QyUJrxG6O3z8vZRPszlHzk3OYrlVg88R+RY4ShPk2SstCAGe3YF8aNdDGygilaaXfZnALypp2/NJJc4Xrkzz8jtXsbAkvX54eGBTcYKRwAbNRuyd2LehyXD8t41apNb7jOkWRsh3ntE7OXKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WyCy9ja8; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WyCy9ja8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765357210; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/rOCVcOt6jVFdkZX/WQTFS/fuDZkiWQiVoo1WyUNXCQ=;
	b=WyCy9ja8vb0O/ktUuZo/RzKYFYRcNcuIpCVAkJBDmvDpdi5s2MzuSu2cJE4ehSOCMGE5UKQQb//XPjhTaY7guFwp+x8ANodsAsQERvplhZhBxZxNo5c5mCydDglsZbiQlP3SAfFhBJ7nyRdnlMcQdHFTdxCYEaq8+EdsJAbOMn0=
Received: from 30.221.145.92(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuW.HoW_1765357209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Dec 2025 17:00:09 +0800
Message-ID: <99870b4d-8fdf-4690-93a2-a206fbb223fe@linux.alibaba.com>
Date: Wed, 10 Dec 2025 17:00:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v4 2/2] ocfs2: detect released suballocator BG for
 fh_to_[dentry|parent]
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, glass.su@suse.com
References: <20251202063938.9046-1-heming.zhao@suse.com>
 <20251202063938.9046-3-heming.zhao@suse.com>
 <86fe3ab7-943d-415f-822d-ffa2e7c18640@linux.alibaba.com>
 <jegkzhlqfygaxwthju5pijim44gurqxkpjvgxak7geacv35tdx@33lfq6jjv2dj>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <jegkzhlqfygaxwthju5pijim44gurqxkpjvgxak7geacv35tdx@33lfq6jjv2dj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/10 12:14, Heming Zhao wrote:
> On Wed, Dec 10, 2025 at 09:55:03AM +0800, Joseph Qi wrote:
>>
>>
>> On 2025/12/2 14:39, Heming Zhao wrote:
>>> After ocfs2 gained the ability to reclaim suballocator free block
>>> group (BGs), a suballocator block group may be released. This change
>>> causes the xfstest case generic/426 to fail.
>>>
>>> generic/426 expects return value -ENOENT or -ESTALE, but the current
>>> code triggers -EROFS.
>>>
>>> Call stack before ocfs2 gained the ability to reclaim bg:
>>>
>>> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>>>  ocfs2_get_dentry
>>>   + ocfs2_test_inode_bit
>>>   |  ocfs2_test_suballoc_bit
>>>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
>>>   |   |                             //the bg block was always found.
>>>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
>>>   |
>>>   + if (!set) //because the above *res is 0
>>>      status = -ESTALE //the generic/426 expected return value
>>>
>>> Current call stack that triggers -EROFS:
>>>
>>> ocfs2_get_dentry
>>>  ocfs2_test_inode_bit
>>>   ocfs2_test_suballoc_bit
>>>    ocfs2_read_group_descriptor
>>>     + if reading a released bg, validation fails and triggers -EROFS
>>>
>>> How to fix:
>>> Since the read BG is already released, we must avoid triggering -EROFS.
>>> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
>>> the released BG block. This approach quietly handles this type of error
>>> and returns -EINVAL, which triggers the caller's existing conversion
>>> path to -ESTALE.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>> ---
>>>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
>>>  1 file changed, 18 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index de2f09217142..a126d83ddb1c 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>  	struct ocfs2_group_desc *group;
>>>  	struct buffer_head *group_bh = NULL;
>>>  	u64 bg_blkno;
>>> -	int status;
>>> +	int status, quiet = 0, released;
>>>  
>>>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>>>  				      (unsigned int)bit);
>>> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>  
>>>  	bg_blkno = group_blkno ? group_blkno :
>>>  		   ocfs2_which_suballoc_group(blkno, bit);
>>> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
>>> -					     &group_bh);
>>> -	if (status < 0) {
>>> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
>>> +					     &group_bh, &released);
>>> +	if (released) {
>>> +		quiet = 1;
>>> +		status = -EINVAL;
>>> +		goto bail;
>>> +	} else if (status < 0) {
>>>  		mlog(ML_ERROR, "read group %llu failed %d\n",
>>> -		     (unsigned long long)bg_blkno, status);
>>> +				(unsigned long long)bg_blkno, status);
>>>  		goto bail;
>>>  	}
>>>  
>>> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>  bail:
>>>  	brelse(group_bh);
>>>  
>>> -	if (status)
>>> +	if (status && (!quiet))
>>>  		mlog_errno(status);
>>>  	return status;
>>>  }
>>> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>   */
>>>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>>  {
>>> -	int status;
>>> +	int status, quiet = 0;
>>>  	u64 group_blkno = 0;
>>>  	u16 suballoc_bit = 0, suballoc_slot = 0;
>>>  	struct inode *inode_alloc_inode;
>>> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>>  
>>>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>>>  					 group_blkno, blkno, suballoc_bit, res);
>>> -	if (status < 0)
>>> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
>>> +	if (status < 0) {
>>> +		if (status == -EINVAL)
>>
>> This seems not right, since there is other case which will also return -EINVAL.
>> So how about return -ESTALE in this case?
>>
>> Thanks,
>> Joseph
> 
> I agree with your idea that we can get a more specific errno, but we might
> introduce some slightly unnecessary work here.
> 
> The ocfs2_test_inode_bit() and ocfs2_test_suballoc_bit() only serve for NFS
> export paths:
> 
> ```
> ocfs2_fh_to_[dentry|parent]
>  ocfs2_get_dentry //converts -EINVAL to -ESTALE
>   ocfs2_test_inode_bit //<== here, current returns -EINVAL
>    ocfs2_test_suballoc_bit //test the released gd
> 
> ocfs2_get_parent //converts -EINVAL to -ESTALE
>  ocfs2_test_inode_bit //<== here, current returns -EINVAL
>   ocfs2_test_suballoc_bit
> ```
> 
> the current code design treats -EINVAL as a speical case, converting it to -ESTALE.
> 
> If we change the ocfs2_test_inode_bit() return value from -EINVAL to -ESTALE.
> This will add another special errno in the error handling path.
> 
> The code changes are show below:
> 
> ```
> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> index b95724b767e1..8992989b85a5 100644
> --- a/fs/ocfs2/export.c
> +++ b/fs/ocfs2/export.c
> @@ -74,7 +74,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
>               * nice
>               */
>              status = -ESTALE;
> -        } else
> +        } else if (status != -ESTALE)
>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
>          goto unlock_nfs_sync;
>      }
> @@ -162,7 +162,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
>      if (status < 0) {
>          if (status == -EINVAL) {
>              status = -ESTALE;
> -        } else
> +        } else if (status != -ESTALE)
>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
>          parent = ERR_PTR(status);
>          goto bail_unlock;
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index c274b649b022..ddcfa6e001e8 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -3172,7 +3172,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>                           &group_bh, &released);
>      if (released) {
>          quiet = 1;
> -        status = -EINVAL;
> +        status = -ESTALE;
>          goto bail;
>      } else if (status < 0) {
>          mlog(ML_ERROR, "read group %llu failed %d\n",
> @@ -3249,7 +3249,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>      status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>                       group_blkno, blkno, suballoc_bit, res);
>      if (status < 0) {
> -        if (status == -EINVAL)
> +        if (status == -ESTALE)
>              quiet = 1;
>          else
>              mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> ```
> 
> However, I am ok with your approach. If you think it is better to return -ESTALE,
> I will fix it in the next version.
> 

Okay, it seems -EINVAL is also fine. But why you silent the error log
for -EINVAL? This will also silent another case, which is different from
before.
BTW, why can't we just return 0 in case of release?

Joseph

