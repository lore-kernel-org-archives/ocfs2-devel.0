Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AA0261B71
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 05:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773380123; cv=none; b=fA04n0VePsyxQi1ZWEFx2Ur9f+o/+bcVqKHFMbgVg98f0msVX8IVQ/7+zy2HxIjkIwj4T/xd3RDEysNT65TsHGwkdfmtiJ4oPagW/4lGTkQE0KVc7i1Q5enKVrBeW5vM7Z/N2TK2BsfJXESJ3U86lPM+KTCnLFLe0oT5ciVy9f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773380123; c=relaxed/simple;
	bh=yoAmtuV4Rt7JLmLPLdWSAOMKYN/b1quTaQRsyCtgxrs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PzrdkMjpO4G/wV/QxuRQAccI1FrJ4j/2+KfFHWIaFtA1OSE4iCKuV2bxlUtb079YQFt5MUZNlHc+aqwCMr89j3PNqgFtMedfb44tQKh/uB8NDETeoW6DonkyAXjkH5XnAbM/d1P6DIjolzuNZ/weZk/w/JIwROzOtPkrjqfRkXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Odj4Kplp; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Odj4Kplp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773380119; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=8xuSwu51JAUBAfIMOasB14qyu6X2mOAggsEKtDm+0Zo=;
	b=Odj4KplpFUL3D+JHvWQxsI7qMHDl548CyWgc0g9IZmVtcJtP7+ayHaucYlk5+VDIZv1YZAK4G/hNTQ+D8t/RHmBf9up8rMLeupkif/PYNhDuq/9EBcp2qUXJHyKmn1MQWUR86Or3sZtUn6zB8//shFEt/PPyCL/ncHS3jI+eS4M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-r1AHr_1773380117;
Received: from 30.221.129.56(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-r1AHr_1773380117 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 13:35:18 +0800
Message-ID: <f20e0032-79f2-4465-a74b-b689d1f46772@linux.alibaba.com>
Date: Fri, 13 Mar 2026 13:35:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
 <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
In-Reply-To: <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 12:53 PM, Joseph Qi wrote:
> 
> 
> On 3/13/26 11:17 AM, Heming Zhao wrote:
>> On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
>>> Almost looks fine, minor updates below.
>>>
>>> On 3/13/26 12:27 AM, Heming Zhao wrote:
>>>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
>>>> ocfs2_dio_end_io_write
>>>>  ocfs2_mark_extent_written
>>>>   ocfs2_change_extent_flag
>>>>    ocfs2_split_extent
>>>>     ocfs2_try_to_merge_extent
>>>>      ocfs2_extend_rotate_transaction
>>>>       ocfs2_extend_trans
>>>>        jbd2__journal_restart
>>>>         start_this_handle
>>>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
>>>>
>>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
>>>> handle each extent in a separate transaction.
>>>>
>>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
>>>> only be removed from the orphan list after the extent tree update is complete.
>>>> this ensures that if a crash occurs in the middle of extent tree updates, we
>>>> won't leave stale blocks beyond EOF.
>>>>
>>>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
>>>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
>>>> insufficient transaction credits").
>>>>
>>>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
>>>>
>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> ---
>>>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
>>>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>>> index 09146b43d1f0..91997b330d39 100644
>>>> --- a/fs/ocfs2/aops.c
>>>> +++ b/fs/ocfs2/aops.c
>>>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>>  		goto out;
>>>>  	}
>>>>  
>>>> -	/* Delete orphan before acquire i_rwsem. */
>>>> -	if (dwc->dw_orphaned) {
>>>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
>>>> -
>>>> -		end = end > i_size_read(inode) ? end : 0;
>>>> -
>>>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
>>>> -				!!end, end);
>>>> -		if (ret < 0)
>>>> -			mlog_errno(ret);
>>>> -	}
>>>> -
>>>>  	down_write(&oi->ip_alloc_sem);
>>>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>>>>  
>>>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>>  
>>>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
>>>>  
>>>> -	handle = ocfs2_start_trans(osb, credits);
>>>> -	if (IS_ERR(handle)) {
>>>> -		ret = PTR_ERR(handle);
>>>> -		mlog_errno(ret);
>>>> -		goto unlock;
>>>> -	}
>>>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
>>>> -	if (ret) {
>>>> -		mlog_errno(ret);
>>>> -		goto commit;
>>>> -	}
>>>> -
>>>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
>>>> -		ret = ocfs2_assure_trans_credits(handle, credits);
>>>> -		if (ret < 0) {
>>>> +		handle = ocfs2_start_trans(osb, credits);
>>>> +		if (IS_ERR(handle)) {
>>>> +			ret = PTR_ERR(handle);
>>>>  			mlog_errno(ret);
>>>>  			break;
>>>
>>> I'd rather goto unlock directly without update i_size in case error.
>>
>> agree
>>>
>>>>  		}
>>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
>>>> +		if (ret) {
>>>> +			mlog_errno(ret);
>>>> +			ocfs2_commit_trans(osb, handle);
>>>> +			break;
>>>
>>> Ditto.
>>
>> agree
>>>
>>>> +		}
>>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>>>>  						ue->ue_cpos, 1,
>>>>  						ue->ue_phys,
>>>>  						meta_ac, &dealloc);
>>>>  		if (ret < 0) {
>>>>  			mlog_errno(ret);
>>>> +			ocfs2_commit_trans(osb, handle);
>>>>  			break;
>>>
>>> Ditto.
>>
>> The existing code still updates i_size even if ocfs2_mark_extent_written()
>> returns an error. I am not certain whether updating i_size in this case is
>> correct, but I prefer to maintain the original logic for now.
>> Does that seem reasonable to you?
>>
> 
> Since it returns 0 for unwritten extents, it looks fine.
> 
Think it a bit more, I think it would be more acceptable to behave
consistent here.
e.g. succeeds in the first round and fails to start transaction in the
second, now it won't update i_size.

Joseph
