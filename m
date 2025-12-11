Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F129313DDAA
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 01:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765415564; cv=none; b=DTyyMSMw1u1VfHtwWvD4v2+408qxM1rhDyoFl/jJ14jqyB8zfvOLk5aUTysi34DRdZgw1Zo0Bn3CtVVlxEMfyq2P2livamKsyElS12jPecIT+WDPbtevuw8RDsJ7xHAUdt5gNd0UPe5EA/WF+oO3mhkwec/LuMH79nHb/K2dB00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765415564; c=relaxed/simple;
	bh=KZvnJORJKHGvbZ3rH0cRy7xADt+ZlOCpdFFwQLVNfiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZ8YFTHXzw8IdvKjmYIgFoBFkioEn7Eksbps8rAvC6NRY3Txs7k4jZdPKexCLgRgs3YZDImbE6W4057WX/KOrARzq4o6oYI20f7IMaH1qhTCJuOJ7DAjeME64DhA01YXmwKFL4gejT+bdzrAXhupzFgVfZ+Uo0mGGWQ5s4RcrA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ipLKDsKi; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ipLKDsKi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765415557; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wUe2G6vfrTi7D2RtFvEJd29jK1RVyTvQLfW3GMhkYMg=;
	b=ipLKDsKibGZEe3wVXTnJ845CODdwsrHIWuZDMRvsWuymLx83OuEJw3DoHmkHdZMvMT4KHzaSYy86sWItSuKPFxh++h8cuqeZWCgoSI+9pmt8KHocOEJCywlLarFajux8aKr8oRG6uDLzE+AoTwVP+TKTv6bgqGccBfLW/BzTUgE=
Received: from 30.221.145.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WuYFuuQ_1765415556 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 09:12:36 +0800
Message-ID: <349ce103-8cab-4df4-9768-bfb9c805badd@linux.alibaba.com>
Date: Thu, 11 Dec 2025 09:12:34 +0800
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
 <99870b4d-8fdf-4690-93a2-a206fbb223fe@linux.alibaba.com>
 <totiw3xkf67vewj3o4bittuk3lhec6sfehmyl7vhd44dhndgkl@76s5s2lcesiw>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <totiw3xkf67vewj3o4bittuk3lhec6sfehmyl7vhd44dhndgkl@76s5s2lcesiw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/10 22:07, Heming Zhao wrote:
> On Wed, Dec 10, 2025 at 05:00:09PM +0800, Joseph Qi wrote:
>>
>>
>> On 2025/12/10 12:14, Heming Zhao wrote:
>>> On Wed, Dec 10, 2025 at 09:55:03AM +0800, Joseph Qi wrote:
>>>>
>>>>
>>>> On 2025/12/2 14:39, Heming Zhao wrote:
>>>>> After ocfs2 gained the ability to reclaim suballocator free block
>>>>> group (BGs), a suballocator block group may be released. This change
>>>>> causes the xfstest case generic/426 to fail.
>>>>>
>>>>> generic/426 expects return value -ENOENT or -ESTALE, but the current
>>>>> code triggers -EROFS.
>>>>>
>>>>> Call stack before ocfs2 gained the ability to reclaim bg:
>>>>>
>>>>> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>>>>>  ocfs2_get_dentry
>>>>>   + ocfs2_test_inode_bit
>>>>>   |  ocfs2_test_suballoc_bit
>>>>>   |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
>>>>>   |   |                             //the bg block was always found.
>>>>>   |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
>>>>>   |
>>>>>   + if (!set) //because the above *res is 0
>>>>>      status = -ESTALE //the generic/426 expected return value
>>>>>
>>>>> Current call stack that triggers -EROFS:
>>>>>
>>>>> ocfs2_get_dentry
>>>>>  ocfs2_test_inode_bit
>>>>>   ocfs2_test_suballoc_bit
>>>>>    ocfs2_read_group_descriptor
>>>>>     + if reading a released bg, validation fails and triggers -EROFS
>>>>>
>>>>> How to fix:
>>>>> Since the read BG is already released, we must avoid triggering -EROFS.
>>>>> With this commit, we use ocfs2_read_hint_group_descriptor() to detect
>>>>> the released BG block. This approach quietly handles this type of error
>>>>> and returns -EINVAL, which triggers the caller's existing conversion
>>>>> path to -ESTALE.
>>>>>
>>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>>>> ---
>>>>>  fs/ocfs2/suballoc.c | 28 ++++++++++++++++++----------
>>>>>  1 file changed, 18 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>>>> index de2f09217142..a126d83ddb1c 100644
>>>>> --- a/fs/ocfs2/suballoc.c
>>>>> +++ b/fs/ocfs2/suballoc.c
>>>>> @@ -3152,7 +3152,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>>>  	struct ocfs2_group_desc *group;
>>>>>  	struct buffer_head *group_bh = NULL;
>>>>>  	u64 bg_blkno;
>>>>> -	int status;
>>>>> +	int status, quiet = 0, released;
>>>>>  
>>>>>  	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>>>>>  				      (unsigned int)bit);
>>>>> @@ -3168,11 +3168,15 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>>>  
>>>>>  	bg_blkno = group_blkno ? group_blkno :
>>>>>  		   ocfs2_which_suballoc_group(blkno, bit);
>>>>> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
>>>>> -					     &group_bh);
>>>>> -	if (status < 0) {
>>>>> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
>>>>> +					     &group_bh, &released);
>>>>> +	if (released) {
>>>>> +		quiet = 1;
>>>>> +		status = -EINVAL;
>>>>> +		goto bail;
>>>>> +	} else if (status < 0) {
>>>>>  		mlog(ML_ERROR, "read group %llu failed %d\n",
>>>>> -		     (unsigned long long)bg_blkno, status);
>>>>> +				(unsigned long long)bg_blkno, status);
>>>>>  		goto bail;
>>>>>  	}
>>>>>  
>>>>> @@ -3182,7 +3186,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>>>  bail:
>>>>>  	brelse(group_bh);
>>>>>  
>>>>> -	if (status)
>>>>> +	if (status && (!quiet))
>>>>>  		mlog_errno(status);
>>>>>  	return status;
>>>>>  }
>>>>> @@ -3202,7 +3206,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>>>   */
>>>>>  int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>>>>  {
>>>>> -	int status;
>>>>> +	int status, quiet = 0;
>>>>>  	u64 group_blkno = 0;
>>>>>  	u16 suballoc_bit = 0, suballoc_slot = 0;
>>>>>  	struct inode *inode_alloc_inode;
>>>>> @@ -3244,8 +3248,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>>>>  
>>>>>  	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>>>>>  					 group_blkno, blkno, suballoc_bit, res);
>>>>> -	if (status < 0)
>>>>> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
>>>>> +	if (status < 0) {
>>>>> +		if (status == -EINVAL)
>>>>
>>>> This seems not right, since there is other case which will also return -EINVAL.
>>>> So how about return -ESTALE in this case?
>>>>
>>>> Thanks,
>>>> Joseph
>>>
>>> I agree with your idea that we can get a more specific errno, but we might
>>> introduce some slightly unnecessary work here.
>>>
>>> The ocfs2_test_inode_bit() and ocfs2_test_suballoc_bit() only serve for NFS
>>> export paths:
>>>
>>> ```
>>> ocfs2_fh_to_[dentry|parent]
>>>  ocfs2_get_dentry //converts -EINVAL to -ESTALE
>>>   ocfs2_test_inode_bit //<== here, current returns -EINVAL
>>>    ocfs2_test_suballoc_bit //test the released gd
>>>
>>> ocfs2_get_parent //converts -EINVAL to -ESTALE
>>>  ocfs2_test_inode_bit //<== here, current returns -EINVAL
>>>   ocfs2_test_suballoc_bit
>>> ```
>>>
>>> the current code design treats -EINVAL as a speical case, converting it to -ESTALE.
>>>
>>> If we change the ocfs2_test_inode_bit() return value from -EINVAL to -ESTALE.
>>> This will add another special errno in the error handling path.
>>>
>>> The code changes are show below:
>>>
>>> ```
>>> diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
>>> index b95724b767e1..8992989b85a5 100644
>>> --- a/fs/ocfs2/export.c
>>> +++ b/fs/ocfs2/export.c
>>> @@ -74,7 +74,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
>>>               * nice
>>>               */
>>>              status = -ESTALE;
>>> -        } else
>>> +        } else if (status != -ESTALE)
>>>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
>>>          goto unlock_nfs_sync;
>>>      }
>>> @@ -162,7 +162,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
>>>      if (status < 0) {
>>>          if (status == -EINVAL) {
>>>              status = -ESTALE;
>>> -        } else
>>> +        } else if (status != -ESTALE)
>>>              mlog(ML_ERROR, "test inode bit failed %d\n", status);
>>>          parent = ERR_PTR(status);
>>>          goto bail_unlock;
>>>
>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>> index c274b649b022..ddcfa6e001e8 100644
>>> --- a/fs/ocfs2/suballoc.c
>>> +++ b/fs/ocfs2/suballoc.c
>>> @@ -3172,7 +3172,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>>>                           &group_bh, &released);
>>>      if (released) {
>>>          quiet = 1;
>>> -        status = -EINVAL;
>>> +        status = -ESTALE;
>>>          goto bail;
>>>      } else if (status < 0) {
>>>          mlog(ML_ERROR, "read group %llu failed %d\n",
>>> @@ -3249,7 +3249,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>>      status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>>>                       group_blkno, blkno, suballoc_bit, res);
>>>      if (status < 0) {
>>> -        if (status == -EINVAL)
>>> +        if (status == -ESTALE)
>>>              quiet = 1;
>>>          else
>>>              mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
>>> ```
>>>
>>> However, I am ok with your approach. If you think it is better to return -ESTALE,
>>> I will fix it in the next version.
>>>
>>
>> Okay, it seems -EINVAL is also fine. But why you silent the error log
>> for -EINVAL? This will also silent another case, which is different from
>> before.
> 
> You are right, the patch code silents all -EINVAL cases, which is
> incorrect logic.
> 
>> BTW, why can't we just return 0 in case of release?
>>
>> Joseph
>>
> 
> There are two reasons why we should return an errno:
> 1> This is still an abnormal case where user is searching for an inode that
>    is already deleted.
> 
> 2> I am not familiar with NFS. However, the meaning from the xfstests
>    generic/426 source code, which calls "open_by_handle -d", and the comment
>    at the beginning of the src/open_by_handle.c [1]:
> 
>    ```
>    6. Get file handles for existing test set, unlink all test files,
>       remove test_dir, drop caches, try to open all files by handle
>       and expect ESTALE:
>    
>       open_by_handle -dp <test_dir> [N]
>    ```
> 
>    The expected return value is '-ESTALE', not '0' (success).
> 
> Returning to my patch, I think your previous idea (to return specific
> -ESTALE) makes sense. Although we are adding another special error case,
> this change keeps the existing error path working as before.
> 
> May I sent the v5 patch which includes the change for -ESTALE (using code
> similar to my previous email in this thread)?
> 
Or reuse the existing -EINVAL logic but without silent error log?
It seems log this case also make sense.

Joseph
