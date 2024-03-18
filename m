Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F3C1B966
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 04:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710737307; cv=none; b=r/DVlJQROZ9n2Qm5rWb+rxNfbGnU6L5TSJRMYibs07LqI1Qgxp0CVO091345550UaRsWz3zaRKWPy6WUOOyh96WVT8kZgGjC4wyHJUWLlWU0dc1WHiTygI3ltBloIQL4xZ+2AHwvkZp8cDwIN+YY+GHX8UxLKRRA52oQ/R7R+Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710737307; c=relaxed/simple;
	bh=dNg/72+BRhV/5sLvHFWc0xpW4pqB7pOO0cUx3gLmU14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5j5q4QgvgADJHCLQ6abojj+hNDRqnva7ZNdSvZqL3f0WUSTLPE1fkP7KhTw3xHZrrDkG6S+AOt/rl1hsH3nT9qdaaVrm0cSohIYZ1LmjXozprhE3949/KlBxI0Y/uCVaIhtBPYM/BOoC80z7WVm0yDPhBhzNuVgeIceRMkz/So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=v9tDR9s+; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="v9tDR9s+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710737301; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wsKHuyrqXU4unr3mJcgJ+pas6Vl63jsX1Rtwjle31mw=;
	b=v9tDR9s+0jY4Q1+xrGAYKpCIT0tnH4RFsCHPMnBrc8BYWVYxGmozwmDg13eiVfaaWq+AKpO+L4tkfdeuqsPs25JyhYxfltUEXbwKZ5sqtFwHF1YW8OjF6JMnaBlDSJrt7/y5Htv68UvhYRlSSj5V7fbXK+neKo/psJjCDg5KV2o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0W2eZoey_1710737299;
Received: from 30.221.64.205(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W2eZoey_1710737299)
          by smtp.aliyun-inc.com;
          Mon, 18 Mar 2024 12:48:20 +0800
Message-ID: <06f14a6d-b94d-482b-82b6-c1b618ff3253@linux.alibaba.com>
Date: Mon, 18 Mar 2024 12:48:19 +0800
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
 <0d4b501d-e835-4b55-baeb-c432ab5e029e@linux.alibaba.com>
 <c44d4535-3628-42a7-b25f-38c5371ca36c@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <c44d4535-3628-42a7-b25f-38c5371ca36c@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/18/24 11:16 AM, Heming Zhao wrote:
> On 3/18/24 09:26, Joseph Qi wrote:
>>
>>
>> On 3/15/24 8:26 PM, Heming Zhao wrote:
>>> On 3/15/24 15:22, Joseph Qi wrote:
>>>>
>>>>
>>>> On 3/15/24 10:25 AM, Heming Zhao wrote:
>>>>> On 3/15/24 09:09, Joseph Qi wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 3/14/24 3:33 PM, Heming Zhao wrote:
>>>>>>> This patch resolves 3 journal-related issues:
>>>>>>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>>>>>>       protection for modifying dinode.
>>>>>>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>>>>>>       journal protection for writing fe->i_size.
>>>>>>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>>>>>>       This adjustment ensures that only content requiring protection is
>>>>>>>       included in the journal.
>>>>>>>
>>>>>>
>>>>>> Any real issue you've found for above cases?
>>>>>
>>>>> No. I just found these issues when I was reading code.
>>>>>>
>>>>>> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
>>>>>> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
>>>>>> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
>>>>>> already dirtied before. Since they are in the same transaction, I don't
>>>>>> see any problem here.
>>>>>
>>>>> Yes, they share the same transaction.
>>>>> However:
>>>>> In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
>>>>> pair to protect metadata. In my view, jbd2_journal_access starts the
>>>>> protection stage, jbd2_journal_dirty closes the protection stage. the rollback
>>>>> function should start a new access/dirty pair to info jbd2 the di_bh had been
>>>>> modified again.
>>>>>
>>>> Refer jbd2_journal_dirty_metadata():
>>>>
>>>> /*
>>>>    * fastpath, to avoid expensive locking.  If this buffer is already
>>>>    * on the running transaction's metadata list there is nothing to do.
>>>>    * Nobody can take it off again because there is a handle open.
>>>>    * I _think_ we're OK here with SMP barriers - a mistaken decision will
>>>>    * result in this test being false, so we go in and take the locks.
>>>>    */
>>>>
>>>> So IMO, we don't have to access/dirty again since the buffer head is
>>>> already added before.
>>>>
>>>> Joseph
>>>
>>> Thanks for the detailed info. Regarding the jbd2 code, you are right.
>>>
>>> What is your opinion about other modifications of my patch?
>>> (the modifications about the jbd2 protection scope.)
>>> under above buffer protection rule of access/dirty, in function,
>>> the bh is same. It seems like the jbd2 dirty function could be
>>> called anywhere regardless of the end-use point of buffer_head.
>>> it's counterintuitive.
>>>
>> Which part do you refer?
>> It seems that all of them are changing the same buffer head which is
>> dirtied before, so it won't be a problem since the transaction has been
>> committed yet.
>> BTW, dinode size change should be protected under ip_lock, so we can't
>> move it out.
>>
>> Thanks,
>> Joseph
>>
> 
> Thank you for your explanation.
> For my patch, it's wrong to move out fe->i_size from spin_[un]lock()
> area.
> 
> But for above info, I have a different view:
> ->ip_lock is not used to protect dinode i_size.
> 
> From the comment in 'struct ocfs2_inode_info', 'spinlock_t ip_lock'
> is used to protect below items:
> ```
>     /* These fields are protected by ip_lock */
>     spinlock_t       ip_lock;
>     u32              ip_open_count;
>     struct list_head ip_io_markers;
>     u32              ip_clusters;
> 
>     u16              ip_dyn_features;
>     struct mutex     ip_io_mutex; //zhm: should not include this
>     u32              ip_flags; /* see below */
>     u32              ip_attr; /* inode attributes */
> ```
> 
> from the code of ocfs2_block_group_alloc():
> ```
> 737    spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
> 738    OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
> 739    fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
> 740                                         le32_to_cpu(fe->i_clusters)));
> 741    spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
> ```
> 
> we can see that ->ip_lock is protecting line 738, the assignment
> operation of "oi->ip_clusters". Because the cluster length is
> obtained from 'fe->i_clusters', if we move line 739 out of spin_[un]lock(),
> fe->clusters may change, resulting in a different value for fe->i_size.
> So author Mark put both 738 and 739 into spin_[un]lock(). From another
> viewpoint, it appears that Mark think fe->i_size should keep consistent
> with oi->ip_clusters.
> 
Make sense.

> we can also verify my analysis from ocfs2_mark_inode_dirty().
> In this function, ->ip_lock doesn't protect fe->i_size. because
> the assignment action reads data from 'inode', and not related
> with any 'ocfs2_inode_info' ip_xx items.
> 
> ------------------
> Let's discuss with jbd2 access/dirty.
> Because these code has already been running almost twenty years,
> I accept no changes for existing code. But it's better to unify
> the jbd2 access/dirty code style.
> 
> e.g:
> ocfs2_group_add() & ocfs2_block_group_alloc():
> - jbd2 dirty *before* spin_lock area.
> 
> ocfs2_update_last_group_and_inode():
> - jbd2 dirty *after* spin_lock area.
> 
> ocfs2_mark_inode_dirty():
> - jbd2 dirty *after* spin_lock area.
> 
> could we unify the code style? For example, placing jbd2 dirty
> *after* spin_lock area.
> 
> e.g:
> ```
> @@ -559,13 +559,12 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>               (input->clusters - input->frees) * cl_bpc);
>      le32_add_cpu(&fe->i_clusters, input->clusters);
>  
> -    ocfs2_journal_dirty(handle, main_bm_bh);
> -
>      spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
>      OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>      le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
>      spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
>      i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
> +    ocfs2_journal_dirty(handle, main_bm_bh);
>  
>      ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
> ```
> 
The above change looks sane.

Joseph

