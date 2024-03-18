Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69151E864
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 Mar 2024 03:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710731781; cv=none; b=o/+kWpoSvm11dOlKoimm4k0Txk2SEna88un8QcVr9YzY2x4EcqJmyzcJSgnhMLUYJdM+jUnbdSQQPDveW2g41L88Q05WO+SaulhJ5ucWi0Vb5g3WvyF5qiVeATUpMY7wUeTwIchKlaIxfLJCCXi/30O2NP0Ii6NGQrrWRaIaDzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710731781; c=relaxed/simple;
	bh=uSalJK9weXyWcvNc0Ex2k8aNxKvtEz/HcN5qUWqzVJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNDKk3C7ZLypRn/1m16/fHYLG6O3FLyr8qAu0hznbBhFiQCTaSo/Dz+9Ex/FMWXIUT6PlZz/p2arHJkrS2CbALAQrMxS6AralsUjWnO/7KX68wJ1t7364ok62eVwLX3+Cr+vZg90JboaKVV2owMJ37GtoAj3/PcgzvmsabXCrII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XcHTfWj4; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XcHTfWj4"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d21cdbc85bso55034611fa.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Mar 2024 20:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710731777; x=1711336577; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auyI+9yuhngFjEx0avRO6VUhiHazKQiJ1M0M4TMrqSc=;
        b=XcHTfWj4stY3LpBSnqNC79mjR9v4LYOy3XER3HqAnLRW19l9dos6kokmiozWDKKk0E
         f73g2yTYJO7sBsrvoaNXAC2LFQ4zt6NnQMC73Q8GZIvn/aimbTYFsadQG3Mn5OmRbG0W
         /rt34pbSL4EtyXKvtFVzVf9MFU9JNdyi59iaxvKPh2NCl8dZUTSLSVm2Atap34+Fd69C
         U0u5z5m1EqzD9dmgxL+U868mK419fM2VaH4rMeD0TikpTzF666k5gaxe3PTxwMza0xpJ
         JM9iEyp5IzJuhyvAO0VroX2iJrznfjTM1jWetgVUxgf35/wC7t5rs89dJzJU1UTlYWIj
         g7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710731777; x=1711336577;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=auyI+9yuhngFjEx0avRO6VUhiHazKQiJ1M0M4TMrqSc=;
        b=E5FgItx79ujJ/12IQr5yk3OSgHevx6XwQZkOyGWJ+KxHm3I8Wtt78DVrwxHutr3/fR
         DuCb7yKw//2SuAJOZLCJdv2Qds1hDYnGhYUvqxdYZZd/liLzrCIPDEi7t79FnJbftzDu
         fpnyHZVyOQ/TROLIa/biobgmLOToJWNhPljo6c2KhTAbpMzZQpVXIqWvySrKQa0szV0q
         +PUCbx/kAuVnHcykjf5yiVMyohd/Z4jt/24LSTAzEoCeN7/pdm5tamaShU2/ix0r+Woc
         lzSs7Sy/PvRZCqTa8EMA8loAtwlIBOgTQVVCesjxf31D/vEYGJeoM+t/S33/Cw/djgqa
         0ZGQ==
X-Gm-Message-State: AOJu0Yy98v1+bkbhz6XxiZNoB+FJESw0tNPNrLEvzcWS8Q5qMIyjJOVc
	1I12jKyU/DH9rMY95aqxnK6oynNP53GNZgJ5pB8HbRYRZtBcxPE5id0rF+Z7LM8=
X-Google-Smtp-Source: AGHT+IG/3y9li0itkrKrRYE3ZM4IAUDaW4MIQBPJ0TbqwvaJaWN87VapQAon+XLeNphE/XMe1y9QqQ==
X-Received: by 2002:a2e:a4ce:0:b0:2d2:3c88:cd57 with SMTP id p14-20020a2ea4ce000000b002d23c88cd57mr5501217ljm.32.1710731776625;
        Sun, 17 Mar 2024 20:16:16 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id u3-20020a656703000000b005d3bae243bbsm5235329pgf.4.2024.03.17.20.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 20:16:16 -0700 (PDT)
Message-ID: <c44d4535-3628-42a7-b25f-38c5371ca36c@suse.com>
Date: Mon, 18 Mar 2024 11:16:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix journal protection issues
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
References: <20240314073353.11489-1-heming.zhao@suse.com>
 <1e0cd8fb-ca1e-4937-bdfe-333284569425@linux.alibaba.com>
 <306d79c8-f327-4c34-b103-a59d8ca87567@suse.com>
 <c535edcc-67da-4c40-bfd2-decd602bfded@linux.alibaba.com>
 <a23556e2-7b15-499f-ba60-0b93c5b796d0@suse.com>
 <0d4b501d-e835-4b55-baeb-c432ab5e029e@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <0d4b501d-e835-4b55-baeb-c432ab5e029e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/24 09:26, Joseph Qi wrote:
> 
> 
> On 3/15/24 8:26 PM, Heming Zhao wrote:
>> On 3/15/24 15:22, Joseph Qi wrote:
>>>
>>>
>>> On 3/15/24 10:25 AM, Heming Zhao wrote:
>>>> On 3/15/24 09:09, Joseph Qi wrote:
>>>>> Hi,
>>>>>
>>>>> On 3/14/24 3:33 PM, Heming Zhao wrote:
>>>>>> This patch resolves 3 journal-related issues:
>>>>>> 1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
>>>>>>       protection for modifying dinode.
>>>>>> 2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
>>>>>>       journal protection for writing fe->i_size.
>>>>>> 3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
>>>>>>       This adjustment ensures that only content requiring protection is
>>>>>>       included in the journal.
>>>>>>
>>>>>
>>>>> Any real issue you've found for above cases?
>>>>
>>>> No. I just found these issues when I was reading code.
>>>>>
>>>>> Take ocfs2_rollback_alloc_dinode_counts() for example, it will always be
>>>>> pair used with ocfs2_alloc_dinode_update_counts(), more precisely, in
>>>>> the error case of ocfs2_block_group_set_bits(). And the 'di_bh' is
>>>>> already dirtied before. Since they are in the same transaction, I don't
>>>>> see any problem here.
>>>>
>>>> Yes, they share the same transaction.
>>>> However:
>>>> In ocfs2_alloc_dinode_update_counts(), there already uses a jbd2 access/dirty
>>>> pair to protect metadata. In my view, jbd2_journal_access starts the
>>>> protection stage, jbd2_journal_dirty closes the protection stage. the rollback
>>>> function should start a new access/dirty pair to info jbd2 the di_bh had been
>>>> modified again.
>>>>
>>> Refer jbd2_journal_dirty_metadata():
>>>
>>> /*
>>>    * fastpath, to avoid expensive locking.  If this buffer is already
>>>    * on the running transaction's metadata list there is nothing to do.
>>>    * Nobody can take it off again because there is a handle open.
>>>    * I _think_ we're OK here with SMP barriers - a mistaken decision will
>>>    * result in this test being false, so we go in and take the locks.
>>>    */
>>>
>>> So IMO, we don't have to access/dirty again since the buffer head is
>>> already added before.
>>>
>>> Joseph
>>
>> Thanks for the detailed info. Regarding the jbd2 code, you are right.
>>
>> What is your opinion about other modifications of my patch?
>> (the modifications about the jbd2 protection scope.)
>> under above buffer protection rule of access/dirty, in function,
>> the bh is same. It seems like the jbd2 dirty function could be
>> called anywhere regardless of the end-use point of buffer_head.
>> it's counterintuitive.
>>
> Which part do you refer?
> It seems that all of them are changing the same buffer head which is
> dirtied before, so it won't be a problem since the transaction has been
> committed yet.
> BTW, dinode size change should be protected under ip_lock, so we can't
> move it out.
> 
> Thanks,
> Joseph
> 

Thank you for your explanation.
For my patch, it's wrong to move out fe->i_size from spin_[un]lock()
area.

But for above info, I have a different view:
->ip_lock is not used to protect dinode i_size.

 From the comment in 'struct ocfs2_inode_info', 'spinlock_t ip_lock'
is used to protect below items:
```
     /* These fields are protected by ip_lock */
     spinlock_t       ip_lock;
     u32              ip_open_count;
     struct list_head ip_io_markers;
     u32              ip_clusters;

     u16              ip_dyn_features;
     struct mutex     ip_io_mutex; //zhm: should not include this
     u32              ip_flags; /* see below */
     u32              ip_attr; /* inode attributes */
```

from the code of ocfs2_block_group_alloc():
```
737    spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
738    OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
739    fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
740                                         le32_to_cpu(fe->i_clusters)));
741    spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
```

we can see that ->ip_lock is protecting line 738, the assignment
operation of "oi->ip_clusters". Because the cluster length is
obtained from 'fe->i_clusters', if we move line 739 out of spin_[un]lock(),
fe->clusters may change, resulting in a different value for fe->i_size.
So author Mark put both 738 and 739 into spin_[un]lock(). From another
viewpoint, it appears that Mark think fe->i_size should keep consistent
with oi->ip_clusters.

we can also verify my analysis from ocfs2_mark_inode_dirty().
In this function, ->ip_lock doesn't protect fe->i_size. because
the assignment action reads data from 'inode', and not related
with any 'ocfs2_inode_info' ip_xx items.

------------------
Let's discuss with jbd2 access/dirty.
Because these code has already been running almost twenty years,
I accept no changes for existing code. But it's better to unify
the jbd2 access/dirty code style.

e.g:
ocfs2_group_add() & ocfs2_block_group_alloc():
- jbd2 dirty *before* spin_lock area.

ocfs2_update_last_group_and_inode():
- jbd2 dirty *after* spin_lock area.

ocfs2_mark_inode_dirty():
- jbd2 dirty *after* spin_lock area.

could we unify the code style? For example, placing jbd2 dirty
*after* spin_lock area.

e.g:
```
@@ -559,13 +559,12 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
               (input->clusters - input->frees) * cl_bpc);
      le32_add_cpu(&fe->i_clusters, input->clusters);
  
-    ocfs2_journal_dirty(handle, main_bm_bh);
-
      spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
      OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
      le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
      spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
      i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
+    ocfs2_journal_dirty(handle, main_bm_bh);
  
      ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
```

Thanks,
Heming
