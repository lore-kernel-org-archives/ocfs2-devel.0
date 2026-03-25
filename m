Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F05335A95A
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Mar 2026 06:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420414; cv=none; b=JvkTVAyE4QBgPwzBaETJYHh7oxED3yHQsoIKwke9uvfpkeM+DjyEpzkh1eNb2ql9to6Y55/q6Jy+gcwWQuui/a+Sxha5fxNV54EoPad4MIsqLuGbe2Z+4LqJbvXyDL41xg38O/Fu+WEwRNvI0XT2GOIGe0V7RsYv8m/IpJ29EDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420414; c=relaxed/simple;
	bh=XK0DsBwXfZmyx+AJmo+AdpkRWa1wp9rXgopSnbUM7NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ei6RxZrke1K7dwlZ39lQEFdzutY0P5aL+M31SsAB3bmlGs2FxSHoX5WVZ1IPztDm70JkGe3kZNi7pm0Vs8EadYiGZNZiIgdfVdHT9/aUeV2Lvo+Y65JeRaigUS2uj6AiS9exurmnydDmSzntKwRIzOwW1vsu5wHYqOyD4TXF1TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c/px3Kds; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c/px3Kds"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774420400; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7P6MqgmBcf3wWJaNyl7ybEnuTDQYXkmG2lAeQrvjOKs=;
	b=c/px3Kdssz4v/OXxCpPAQ/BDCcgnN0rIVKmxwW4wqOMP/jz2GQiUTu44SwO3OAiUCqkkZs2uIomMHHHpM8YJ90LDOX8ViO0Ln93WGGkxWbCgkNsAFHIFa13b2/L4PsJiAvPjiBnOAzfmHDjo5XyRfi+bnD3Rh5Ppl88w+/qYJoI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.gdSzi_1774420399;
Received: from 30.221.145.63(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.gdSzi_1774420399 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 14:33:20 +0800
Message-ID: <0b5f43a9-4b54-4cf3-999a-7fa3f88b6105@linux.alibaba.com>
Date: Wed, 25 Mar 2026 14:33:19 +0800
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
 Jan Kara <jack@suse.cz>, glass.su@suse.com
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
 <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
 <x7tv6dzqhiwcvld2cct4olou5oioeis5k4nlpr6oglpch2skvr@duochardclqx>
 <a108b18a-e27e-424c-80f1-c19ea2c30685@linux.alibaba.com>
 <fxq56b3asrnttbxflhegeetn74kbo3xfjqipcelisbifbtuxku@g2zhgyuzq6je>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <fxq56b3asrnttbxflhegeetn74kbo3xfjqipcelisbifbtuxku@g2zhgyuzq6je>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/25/26 11:31 AM, Heming Zhao wrote:
> On Thu, Mar 19, 2026 at 09:53:16AM +0800, Joseph Qi wrote:
>>
>>
>> On 3/18/26 2:40 PM, Heming Zhao wrote:
>>> On Fri, Mar 13, 2026 at 12:53:32PM +0800, Joseph Qi wrote:
>>>>
>>>>
>>>> On 3/13/26 11:17 AM, Heming Zhao wrote:
>>>>> On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
>>>>>> Almost looks fine, minor updates below.
>>>>>>
>>>>>> On 3/13/26 12:27 AM, Heming Zhao wrote:
>>>>>>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
>>>>>>> ocfs2_dio_end_io_write
>>>>>>>  ocfs2_mark_extent_written
>>>>>>>   ocfs2_change_extent_flag
>>>>>>>    ocfs2_split_extent
>>>>>>>     ocfs2_try_to_merge_extent
>>>>>>>      ocfs2_extend_rotate_transaction
>>>>>>>       ocfs2_extend_trans
>>>>>>>        jbd2__journal_restart
>>>>>>>         start_this_handle
>>>>>>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
>>>>>>>
>>>>>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
>>>>>>> handle each extent in a separate transaction.
>>>>>>>
>>>>>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
>>>>>>> only be removed from the orphan list after the extent tree update is complete.
>>>>>>> this ensures that if a crash occurs in the middle of extent tree updates, we
>>>>>>> won't leave stale blocks beyond EOF.
>>>>>>>
>>>>>>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
>>>>>>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
>>>>>>> insufficient transaction credits").
>>>>>>>
>>>>>>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
>>>>>>>
>>>>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>>>>> ---
>>>>>>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
>>>>>>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>>>>>> index 09146b43d1f0..91997b330d39 100644
>>>>>>> --- a/fs/ocfs2/aops.c
>>>>>>> +++ b/fs/ocfs2/aops.c
>>>>>>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>>>>>  		goto out;
>>>>>>>  	}
>>>>>>>  
>>>>>>> -	/* Delete orphan before acquire i_rwsem. */
>>>>>>> -	if (dwc->dw_orphaned) {
>>>>>>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
>>>>>>> -
>>>>>>> -		end = end > i_size_read(inode) ? end : 0;
>>>>>>> -
>>>>>>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
>>>>>>> -				!!end, end);
>>>>>>> -		if (ret < 0)
>>>>>>> -			mlog_errno(ret);
>>>>>>> -	}
>>>>>>> -
>>>>>>>  	down_write(&oi->ip_alloc_sem);
>>>>>>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>>>>>>>  
>>>>>>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>>>>>>  
>>>>>>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
>>>>>>>  
>>>>>>> -	handle = ocfs2_start_trans(osb, credits);
>>>>>>> -	if (IS_ERR(handle)) {
>>>>>>> -		ret = PTR_ERR(handle);
>>>>>>> -		mlog_errno(ret);
>>>>>>> -		goto unlock;
>>>>>>> -	}
>>>>>>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>>>>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
>>>>>>> -	if (ret) {
>>>>>>> -		mlog_errno(ret);
>>>>>>> -		goto commit;
>>>>>>> -	}
>>>>>>> -
>>>>>>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
>>>>>>> -		ret = ocfs2_assure_trans_credits(handle, credits);
>>>>>>> -		if (ret < 0) {
>>>>>>> +		handle = ocfs2_start_trans(osb, credits);
>>>>>>> +		if (IS_ERR(handle)) {
>>>>>>> +			ret = PTR_ERR(handle);
>>>>>>>  			mlog_errno(ret);
>>>>>>>  			break;
>>>>>>
>>>>>> I'd rather goto unlock directly without update i_size in case error.
>>>>>
>>>>> agree
>>>>>>
>>>>>>>  		}
>>>>>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>>>>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
>>>>>>> +		if (ret) {
>>>>>>> +			mlog_errno(ret);
>>>>>>> +			ocfs2_commit_trans(osb, handle);
>>>>>>> +			break;
>>>>>>
>>>>>> Ditto.
>>>>>
>>>>> agree
>>>>>>
>>>>>>> +		}
>>>>>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>>>>>>>  						ue->ue_cpos, 1,
>>>>>>>  						ue->ue_phys,
>>>>>>>  						meta_ac, &dealloc);
>>>>>>>  		if (ret < 0) {
>>>>>>>  			mlog_errno(ret);
>>>>>>> +			ocfs2_commit_trans(osb, handle);
>>>>>>>  			break;
>>>>>>
>>>>>> Ditto.
>>>>>
>>>>> The existing code still updates i_size even if ocfs2_mark_extent_written()
>>>>> returns an error. I am not certain whether updating i_size in this case is
>>>>> correct, but I prefer to maintain the original logic for now.
>>>>> Does that seem reasonable to you?
>>>>>
>>>>
>>>> Since it returns 0 for unwritten extents, it looks fine.
>>>>
>>>>>> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
>>>>>> to save the extra call in case error.
>>>>>
>>>>> agree
>>>>>
>>>>> I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
>>>>> is about 12107 ~ 12457.
>>>>> Regarding the transaction splitting in the unwritten handling loop: this patch
>>>>> introduces a minor performance regression. I would like to merge some of the
>>>>> transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
>>>>> What do you think of this approach?
>>>>>
>>>>
>>>> Seems we can limit max credit for a single transaction here?
>>>> If exceeds, restart a new one.
>>>>
>>>> Joseph,
>>>> Thanks
>>>
>>> sorry for the late reply, I spend some time running the tests.
>>> I have created two different types of patches (see below) to address this issue.
>>>
>>> time consumption results:
>>>
>>> ocfs2-dynamic-... patch
>>> real    2m9.900s
>>> user    0m0.333s
>>> sys     0m22.687s
>>>
>>> %200 of ocfs2-split-trans-... patch
>>> real    1m48.901s
>>> user    0m0.306s
>>> sys     0m23.019s
>>>
>>> %500 of ocfs2-split-trans-... patch
>>> real    1m49.350s
>>> user    0m0.299s
>>> sys     0m22.718s
>>>
>>> As shown above, the fixed "500% mode" is faster than the dynamic style.
>>> Which approach do you prefer?
>>>
>> I'd prefer solution B, it looks simpler to directly set a commit batch.
>> Some comments for the formal patch：
>> 1. I don't think you have to use 'cnt + trans_start + mod' to control
>> the batch commit, just check 'batch + handle' seems enough.
>> 2. Define a macro for the batch, e.g. OCFS2_DIO_MARK_EXTENT_BATCH,
>> 3. Do not update i_size in case error.
>> 4. Correctly handle commit transaction in case error.
>>
>> Thanks,
>> Joseph
>>
> 
> I hope I understand your point correctly.
> creating and setting OCFS2_DIO_MARK_EXTENT_BATCH to 800, corresponding to the
> %200 used in my previous 'cnt+trans_start+mod' patch.
> 

Seems you've proposed a new solution?

In your previous mail, I think it is:

list_for_each_entry() {
	if (!handle)
		ocfs2_start_trans();
	ocfs2_journal_access_di()
	ocfs2_mark_extent_written()
	if (batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
		ocfs2_commit_trans();
		handle = NULL;
	}
}

Joseph

