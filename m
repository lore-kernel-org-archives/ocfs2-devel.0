Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905E3B27F2
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Mar 2026 07:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773215052; cv=none; b=qkyz4NVeKqjt08L7rGFEDW1YX7zZ36mHEZ2D8ONqKlTMYj3JWr8M7vc8c5FUOJwtQFvsrxZI1iCQDEPMdLxRjBrHuHg9UFAQwEuwfqtqGFyjcinNJSRI8SBJOhajrEo2ZDm9SYjDKO0Ykkdu7hC+13CLHSZ9NDvQHGKwj5Y8tpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773215052; c=relaxed/simple;
	bh=NIMb2Ha9z4OBZNZssGotnt54k13FZQC/Vh0imq6oW04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JanihBV//QYOGgmdhY7wwKJAc/9vbAfDerJPitfOiTWoFhywv6u89Jgl0cX8l7OZYpnJ07jJKZHscYE9caCwtCH0DC10WTYm9Ob3xQVM64A9h05pK7/M+y7+w8+iJr3Im4Ia+53so+kGeiOnXlJPlUSlj1Qeka5d6H17ZKCTexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Qkm4oEST; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Qkm4oEST"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773215039; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BHOuC1JBU7KnsI8dweOO0l0v+lOMWW+qGPhK43Wv/WM=;
	b=Qkm4oESTDnyeKP2P+pQ+84Jqte1PS01AAoiIv7AMoFp13wEBiYC3Iw4p30uneZqbzm/eXmcw8L4H9z1HP3eedzRlmzhksHX2X5IpcgDibatmVKXHkhe/lvVeqw5CvlDn9McJMZudt8VIpheepbScWaAfSgXPzjuksuL0Z1trt6Q=
Received: from 30.221.129.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-j4Nn3_1773215037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 15:43:58 +0800
Message-ID: <6a0a893b-10c4-4613-829d-c6ea00cc64a1@linux.alibaba.com>
Date: Wed, 11 Mar 2026 15:43:57 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] ocfs2: split transactions in dio completion to avoid
 credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: jack@suse.cz, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260310102413.12501-1-heming.zhao@suse.com>
 <20260310102413.12501-2-heming.zhao@suse.com>
 <5be5a109-477c-4c42-919b-1de0707e7af6@linux.alibaba.com>
 <2jftdgkyazhvzekghumby7ml72qsczwdqmvedb73i2rrprwvxd@rofsjquqnxqh>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2jftdgkyazhvzekghumby7ml72qsczwdqmvedb73i2rrprwvxd@rofsjquqnxqh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/11/26 1:43 PM, Heming Zhao wrote:
> On Wed, Mar 11, 2026 at 09:48:12AM +0800, Joseph Qi wrote:
>>
>>
>> On 3/10/26 6:24 PM, Heming Zhao wrote:
>>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
>>> ocfs2_dio_end_io_write
>>>  ocfs2_mark_extent_written
>>>   ocfs2_change_extent_flag
>>>    ocfs2_split_extent
>>>     ocfs2_try_to_merge_extent
>>>      ocfs2_extend_rotate_transaction
>>>       ocfs2_extend_trans
>>>        jbd2__journal_restart
>>>         start_this_handle
>>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
>>>
>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
>>> handle each extent in a separate transaction.
>>>
>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
>>> only be removed from the orphan list after the extent tree update is complete.
>>> this ensures that if a crash occurs in the middle of extent tree updates, we
>>> won't leave stale blocks beyond EOF.
>>>
>>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
>>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
>>> insufficient transaction credits").
>>>
>>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
>>>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>  fs/ocfs2/aops.c | 56 ++++++++++++++++++++-----------------------------
>>>  1 file changed, 23 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index 09146b43d1f0..50b4d474b88c 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>  		goto out;
>>>  	}
>>>  
>>> -	/* Delete orphan before acquire i_rwsem. */
>>> -	if (dwc->dw_orphaned) {
>>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
>>> -
>>> -		end = end > i_size_read(inode) ? end : 0;
>>> -
>>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
>>> -				!!end, end);
>>> -		if (ret < 0)
>>> -			mlog_errno(ret);
>>> -	}
>>> -
>>>  	down_write(&oi->ip_alloc_sem);
>>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>>>  
>>> @@ -2326,23 +2314,18 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>  
>>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
>>>  
>>> -	handle = ocfs2_start_trans(osb, credits);
>>> -	if (IS_ERR(handle)) {
>>> -		ret = PTR_ERR(handle);
>>> -		mlog_errno(ret);
>>> -		goto unlock;
>>> -	}
>>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
>>> -	if (ret) {
>>> -		mlog_errno(ret);
>>> -		goto commit;
>>> -	}
>>> -
>>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
>>> -		ret = ocfs2_assure_trans_credits(handle, credits);
>>> -		if (ret < 0) {
>>> +		handle = ocfs2_start_trans(osb, credits);
>>> +		if (IS_ERR(handle)) {
>>> +			ret = PTR_ERR(handle);
>>> +			mlog_errno(ret);
>>> +			break;
>>> +		}
>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
>>> +		if (ret) {
>>>  			mlog_errno(ret);
>>> +			ocfs2_commit_trans(osb, handle);
>>>  			break;
>>>  		}
>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>>> @@ -2351,19 +2334,26 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>  						meta_ac, &dealloc);
>>>  		if (ret < 0) {
>>>  			mlog_errno(ret);
>>> +			ocfs2_commit_trans(osb, handle);
>>>  			break;
>>>  		}
>>> +		ocfs2_commit_trans(osb, handle);
>>>  	}
>>>  
>>> -	if (end > i_size_read(inode)) {
>>> -		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>>
>> dw_orphaned is only set if it allocates new clusters, see
>> ocfs2_dio_get_block():
>>
>> 	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
>> 	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
>> 	    !dwc->dw_orphaned) {
>> 		...
>> 		dwc->dw_orphaned = 1;
>> 	}
>>
>> So in case extending a file within an existing cluster, it leaves
>> dwc->dw_orphaned = 0. Then i_size won't be updated here and the written
>> data is lost.
>>
>> Thanks,
>> Joseph
> 
> The cases corresponding to the logic above are:
> - 'if' (dw_orphaned:1): an extending write where (end > "inode old size")
> - 'else' (dw_orphaned:0): this should cover: overwrite, sparse/hole file write.
>   where the i_size doesn't need to be changed. 
> 
> Furthermore, code at the beginning of ocfs2_dio_end_io_write() checks
> if (end <= i_size).  if the condition is met, the code jumps directly to the
> 'out' label, no opportunity to update i_size.
> 
> ```ocfs2_dio_end_io_write()
> 
>         if (list_empty(&dwc->dw_zero_list) &&
>             end <= i_size_read(inode) &&
>             !dwc->dw_orphaned)
>                 goto out;
> ```

No, I am saying the case
end > i_size_read(inode) && !dwc->dw_orphaned

For example, cluster_size = 1M and i_size = 4k, then a DIO write at
offset 4k with len 4k, so end is 8k.
In this case ocfs2_clusters_for_bytes() is always 1 before and after.

Thanks,
Joseph

