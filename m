Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624432C9D
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 04:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773377619; cv=none; b=GUWFAlhhpacm8eXZCCkmOykWN9MPLrc5xFLXEIlYvFX99aRldCFGD2tXoMgrE1pixkv1qwxn+hHb/yShcbX8yGGpKCbk3IRHdtXBnxdifB8Q6PkKWfs7eZI99tKVclSiCWF7ICxRLWOeNBQ3s3PQNboVZWeExj20UV3UJxgKAJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773377619; c=relaxed/simple;
	bh=6XeXD+RhgTV9V7sBumkRFf3EqTisoM8lihu9ChvVmG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ETAOIhlCfrCPzgd/cy1srtUkPNFflb0jb//eYggnI6+8EXh8JJIz8CjupGziz15fPfrdfeFUSdIkgVvheihLz1v9cZXCPQYh7pF8bhxGBoDPcpYIN1Ny+SJhNkrHoCY8erHtIGNk1/WTJXsMTtdjSw59uoij49s9/+nWVBuL684=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gfTTHJvB; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gfTTHJvB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773377614; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Mu427i48vl+bXTMeJv1FaKW6evZNat+ldY8A5kb3/Xc=;
	b=gfTTHJvBzmoT06Iopsj7tqt2Ia21AhxBIaXfUs8zrMcQhWKFE/eBAIX1C6rYqSPHDw4F6L/9ro/K07hzgjp1TJrUFRp2Wrwh7lkO0Z9DEEFqVjtyXqCQfkpZ9fPpgxGSa0vcmT1ZyH6KxF7Fz0HgUmQar6TiGxEIJO1c4tIoud8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-r0yhF_1773377612;
Received: from 30.221.129.56(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-r0yhF_1773377612 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 12:53:33 +0800
Message-ID: <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
Date: Fri, 13 Mar 2026 12:53:32 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 11:17 AM, Heming Zhao wrote:
> On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
>> Almost looks fine, minor updates below.
>>
>> On 3/13/26 12:27 AM, Heming Zhao wrote:
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
>>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
>>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index 09146b43d1f0..91997b330d39 100644
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
>>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
>>>  			mlog_errno(ret);
>>>  			break;
>>
>> I'd rather goto unlock directly without update i_size in case error.
> 
> agree
>>
>>>  		}
>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
>>> +		if (ret) {
>>> +			mlog_errno(ret);
>>> +			ocfs2_commit_trans(osb, handle);
>>> +			break;
>>
>> Ditto.
> 
> agree
>>
>>> +		}
>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>>>  						ue->ue_cpos, 1,
>>>  						ue->ue_phys,
>>>  						meta_ac, &dealloc);
>>>  		if (ret < 0) {
>>>  			mlog_errno(ret);
>>> +			ocfs2_commit_trans(osb, handle);
>>>  			break;
>>
>> Ditto.
> 
> The existing code still updates i_size even if ocfs2_mark_extent_written()
> returns an error. I am not certain whether updating i_size in this case is
> correct, but I prefer to maintain the original logic for now.
> Does that seem reasonable to you?
> 

Since it returns 0 for unwritten extents, it looks fine.

>> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
>> to save the extra call in case error.
> 
> agree
> 
> I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
> is about 12107 ~ 12457.
> Regarding the transaction splitting in the unwritten handling loop: this patch
> introduces a minor performance regression. I would like to merge some of the
> transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
> What do you think of this approach?
> 

Seems we can limit max credit for a single transaction here?
If exceeds, restart a new one.

Joseph,
Thanks
