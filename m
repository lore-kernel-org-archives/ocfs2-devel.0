Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3DD35E948
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Mar 2026 03:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774581143; cv=none; b=dUlK6wOmVmI35tOiqpmNPLQANeywxlH7ALg1t9nE5kVl0nX1ZVWRhZG/xgGwCBn4wCucIeLx+15VSRtSxUScmDrfClF91bXjdEqwI46z4Agmyzn9OIpx9HEI57CLpilr8TanvTmtnCkCrhuqWu12MqMaF2GPMsAGNsNsQ7N1LY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774581143; c=relaxed/simple;
	bh=fY1H1mhVbiv3v+6X5YM0di8lhmYkTEc7JIWCXTOyQBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XswlBVieIHeQyjudl/ElnzILMuslaSIsRxUKC5B91FfB8kl32kVspJIXXWknZG4woi6vsukhmGwYSTXWZ1Cn10PAV4mBEIXe52GT+R3BjROsaoHaeqxjmhhPp19fcBFLlWfEreWjeY6SiGOLJDj18BYFMhoh9Csg373nFBvI6zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Pqugg2zs; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Pqugg2zs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774581137; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z3ER4uZfQFN8UsxUbmx5OlL1opWvl7soPiJH7TZQ/J8=;
	b=Pqugg2zsynmSqLyXxEwZ4o6ldKuyEhwWFJMnon89rlo4X8voYRfMOUlr+/TcdU2RaON5PtEKB0vr02OdmIaoggxJdP3PG8ooXhY4BnVsSMGaiGdgAHpPw6wJV50s/F4S/kTO7xU+obn8Qx+40IMFjc1B75c291yQHAXbjzqLf5w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.mlyR0_1774581135;
Received: from 30.221.145.61(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.mlyR0_1774581135 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 11:12:16 +0800
Message-ID: <b1c0f287-1d7f-4302-9ce5-f3582757432a@linux.alibaba.com>
Date: Fri, 27 Mar 2026 11:12:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com, Jan Kara <jack@suse.cz>
References: <20260326142640.20077-1-heming.zhao@suse.com>
 <20260326142640.20077-2-heming.zhao@suse.com>
 <b0ba52bb-ab01-48a2-ab40-b2dfe4cdc236@linux.alibaba.com>
 <ohp7ryqyx67edlqxtw6z77omxtdsjwtfqlfultpemfkur4y4iv@ptnborr5awav>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ohp7ryqyx67edlqxtw6z77omxtdsjwtfqlfultpemfkur4y4iv@ptnborr5awav>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/27/26 11:02 AM, Heming Zhao wrote:
> On Fri, Mar 27, 2026 at 09:42:55AM +0800, Joseph Qi wrote:
>> Hi,
>>
>> On 3/26/26 10:26 PM, Heming Zhao wrote:
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
>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write()
>>> to handle extent in a batch of transaction.
>>>
>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
>>> only be removed from the orphan list after the extent tree update is complete.
>>> this ensures that if a crash occurs in the middle of extent tree updates, we
>>> won't leave stale blocks beyond EOF.
>>>
>>> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
>>> suggestions.
>>>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>  fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
>>>  1 file changed, 44 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>>> index 09146b43d1f0..60f1b607022f 100644
>>> --- a/fs/ocfs2/aops.c
>>> +++ b/fs/ocfs2/aops.c
>>> @@ -37,6 +37,8 @@
>>>  #include "namei.h"
>>> ... ... <--- snip --->
>>> +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
>>> +			ocfs2_commit_trans(osb, handle);
>>> +			handle = NULL;
>>> +			batch = 0;
>>> +		}
>>>  	}
>>>  
>>>  	if (end > i_size_read(inode)) {
>>
>> I still don't think it is a good idea to update inode size in case error.
>> The original logic behaves inconsistent, if ocfs2_start_trans() and
>> ocfs2_journal_access_di() fails, it won't update inode size, but if
>> ocfs2_assure_trans_credits() and ocfs2_mark_extent_written(), it will do.
>> So let's make it behave consistent by both checking 'ret' here.
>>
>> Other looks fine.
>>
>> Joseph
> 
> After sending the v4 patch, I did some tests and identified the key of the
> performance degradation in the dynamic credit adjustment patch.
> I found that by using half of the jbd2_max value, the time consumption returned
> to the same level as the "direct loop" style. 
> 
> key code change:
> (base on patch[1]: 0001-ocfs2-dynamic-extending-jbd2-credits-during-dio-end-.patch)
>         int jbd2_max = (journal->j_max_transaction_buffers -
>                         journal->j_transaction_overhead_buffers) >> 2;
> 
> my test env:
> - 10G ocfs2 volume
> - DIO 2G file, write with 64MB block (--bs=64M).
> 
> observations:
> - ocfs2_assure_trans_credits calls "commit & start trans" times on every 64MB block:
>   - using jbd2_max (5449):  ~9 times.
>   - using half value (2724): ~20 times.
> - v4 patch ("batch" style), call "commit & start trans" on every 64MB block: ~62 times
> 
> time consumption:
> 
> jbd2_max:5449 case
> real    2m9.346s
> user    0m0.277s
> sys     0m22.748s
> 
> half jbd2_max:2724 case
> real    1m49.400s                                                                              
> user    0m0.343s                                                                               
> sys     0m22.734s
> 
> v4 patch:
> real    1m49.650s
> user    0m0.337s
> sys     0m22.780s
> 
> 
> the reason (I guess):
> The original patch only performed a "commit and start new trans" when jbd2
> credits were nearly exhausted. I suspect contention between the commit flush
> operation and the jbd2 operations in the dio end path, leading to high latency.
> By using half the jbd2_max value, trigger commits more frequently, which appears
> to reduce jbd2 contention and racing.
> 
> Finally, I suggest we use the dynamic credit extension patch for v5. This
> version only adds logic to ocfs2_assure_trans_credits() and does not affect
> i_size changes during error cases.
> 
Ummm... I think v4 looks simpler and direct.
For i_size update logic, I think the existing logic looks wried. Take a
look at ext4, it also doesn't do this if converting unwritten extents
fails.

Joseph
 

