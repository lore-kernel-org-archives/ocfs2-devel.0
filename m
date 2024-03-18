Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AD11EB21
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710725223; cv=none; b=JlxnXnbEYj4zJixkx/ZbEkL7IzJFXlUlvvVn0t1XXpBUpohWUGayKRflewegASTkGoItGrVoStKGvEkSziLZvgsgnPjovxvxBcELL4Mc8fVFKJNQJ4pnfxg5BhbQCnXFO3yziylCMO7Rezc7LfnZzNtIvCLwNnHVmq6rKhxCjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710725223; c=relaxed/simple;
	bh=V5fmPlf7jiIcak2LKDDCerr6BCMgOqqKNIg5L96s5sQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPiwmX0vCbFbHkYt5sjplDcE8BZ82tkVoRsbc8iF/2j2Y+WlgCocIqaSWBnPwGSFK99X8z4shE3XIUgkHklYIVFCJdx5FVLgsc33gSYDe6cHu2TUup5xw+3blXKa7lw14tXiwepPsDXqENW71pXyAWj3JqnEEO3MYKZMS/zfGfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k5N2o3q3; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k5N2o3q3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710725217; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b5vPZ0vL9Y4VZyVThKaCf6e/sA/zPs/iSMsRYngqnao=;
	b=k5N2o3q3KXv/s0ZaTDxl4OCfOiqSRyx+oVlBRUJRIvZrtSw7FcmS6rtHb+sJlSfOiTZiFkqCKHZMIOIuikQmzSKf2Y3QUpxSKbMEAxNBjfhcbPimTeXxFoZIFTmCgsHl0yY+u7YCoR/NwdASP0C0fcxGf656jyiFI3basGNizkM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W2dXcAL_1710725216;
Received: from 30.221.64.205(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2dXcAL_1710725216)
          by smtp.aliyun-inc.com;
          Mon, 18 Mar 2024 09:26:56 +0800
Message-ID: <0d4b501d-e835-4b55-baeb-c432ab5e029e@linux.alibaba.com>
Date: Mon, 18 Mar 2024 09:26:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
Content-Language: en-US
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
 <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
 <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
 <c535edcc-67da-4c40-bfd2-decd602bfded@linux.alibaba.com>
 <a23556e2-7b15-499f-ba60-0b93c5b796d0@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <a23556e2-7b15-499f-ba60-0b93c5b796d0@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/15/24 8:26 PM, Heming Zhao wrote:
> On 3/15/24 15:22, Joseph Qi wrote:
>>
>>
>> On 3/15/24 10:25 AM, Heming Zhao wrote:
>>> On 3/15/24 09:09, Joseph Qi wrote:
>>>> Hi,
>>>>
>>>> On 3/14/24 3:33 PM, Heming Zhao wrote:
>>>>> This patch resolves 3 journal-related issues:
>>>>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>>>>      protection for modifying dinode.
>>>>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>>>>      journal protection for writing fe->i_size.
>>>>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>>>>      This adjustment ensures that only content requiring protection is
>>>>>      included in the journal.
>>>>>
>>>>
>>>> Any real issue you've found for above cases?
>>>
>>> No. I just found these issues when I was reading code.
>>>>
>>>> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
>>>> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
>>>> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
>>>> already dirtied before. Since they are in the same transaction, I don't
>>>> see any problem here.
>>>
>>> Yes, they share the same transaction.
>>> However:
>>> In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
>>> pair to protect metadata. In my view, jbd2_journal_access starts the
>>> protection stage, jbd2_journal_dirty closes the protection stage. the rollback
>>> function should start a new access/dirty pair to info jbd2 the di_bh had been
>>> modified again.
>>>
>> Refer jbd2_journal_dirty_metadata():
>>
>> /*
>>   * fastpath, to avoid expensive locking.  If this buffer is already
>>   * on the running transaction's metadata list there is nothing to do.
>>   * Nobody can take it off again because there is a handle open.
>>   * I _think_ we're OK here with SMP barriers - a mistaken decision will
>>   * result in this test being false, so we go in and take the locks.
>>   */
>>
>> So IMO, we don't have to access/dirty again since the buffer head is
>> already added before.
>>
>> Joseph
> 
> Thanks for the detailed info. Regarding the jbd2 code, you are right.
> 
> What is your opinion about other modifications of my patch?
> (the modifications about the jbd2 protection scope.)
> under above buffer protection rule of access/dirty, in function,
> the bh is same. It seems like the jbd2 dirty function could be
> called anywhere regardless of the end-use point of buffer_head.
> it's counterintuitive.
> 
Which part do you refer?
It seems that all of them are changing the same buffer head which is
dirtied before, so it won't be a problem since the transaction has been
committed yet.
BTW, dinode size change should be protected under ip_lock, so we can't
move it out.

Thanks,
Joseph

