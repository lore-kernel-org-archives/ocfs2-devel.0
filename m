Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FF06F06A
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Aug 2025 01:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756259899; cv=none; b=OSg/8Nh0xoSg4GVo3fdndz1dJBo1hLrhl9LYb8BN4qzaLSXoNjGiznPKVuIjtiTUO0Otw8tWOGXDEiqvEgDjGZmmnOK4fhZlX2AZDY8LDozRThLDo7KBx+K0o/PFOkAq9c13ExVGEPDMkHvrgzCx49l4ry0nLRPUEiTpq4kXLtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756259899; c=relaxed/simple;
	bh=zEbxYfT4kxcceN0/zzFhozVbNeX+XbcrAH6NTr9I9c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ckYdd4Q8Gt2QnQFItDV13koOohUzN7avOCb6RLgXfhQ45YTktnyFeb54GbB/XYOJIvFr/OpCnGWut/1OrAluXGt/StlhOtiGxJl6iQ22s5pySeRfSD+k5pG/fwEw75xIMS2q+h/U0bxLJBPfw4oywQWl/EJKPwOLPjaFKG+JX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M+9myokW; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M+9myokW"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3cc211dde4fso107847f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Aug 2025 18:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756259895; x=1756864695; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CfqjUgAqjVwzZlQ7g5rqEfaJzCJp0ElhiyqxdgYpP1c=;
        b=M+9myokW5GMsBuA8HcBjBFy5kPHPrf4S7UdVil9mkQmj/NXN/Krxj9zTGJTQeWQqBn
         7Lw4bLD+7Efncb2A/E8gPohqCKYxvdF9Hsb1oLVNDrzEPZp0gpfz0TMCYuaT1bX38dRO
         ZLIvo4yb8d7nKn/aAPRF60KPsTPdQo7REhZ2nwJRns+/8rjw7PKky7Q07jyCbfFJgSlV
         4cep9Y+3yiJ5YDHxW54nphGdYVYj9ksM7OQX3myot9bd/D6x0AWO216aftzG6E2aD571
         2IA1ti4g78CEz8/FSzotzXyv0jgmWL3VhDRiCmEijPgTjCVG8Ava6G2/ZO8D2tSSlhVW
         jLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756259895; x=1756864695;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CfqjUgAqjVwzZlQ7g5rqEfaJzCJp0ElhiyqxdgYpP1c=;
        b=D5IVKviKnhV3F6UZ36m1E/7BYCUIYUSNv2MWDWwGC/whelHor5G3RVtIzHMNfogGJT
         Awly9OnFCG6XvB6rN9o5AUeWnDdn8GVu59a6Qv8dyyEpW7xv36wkz2f9s8zrQmkogJeh
         k2f266zJiBSF6y/kiNK4BASq8snb6RxAIptp3EEWKjcxW67190XJX6ZTQB8yKsXusaE4
         +YqDzF2rkWSqIjP7aDIR4iw9wiJLmzQFc9bBHgd2Amf5tzombrCleoShrRwNoO0bkltF
         swUxT0vH5WNR2joAMFnrtVIf6tNN+mfeE6ue5pnADkbRhnL7bXVeR19gNmU2G0wXAjYf
         4Htw==
X-Gm-Message-State: AOJu0YxjdleUdxCvP0C2qRs6yRNno1MU7OpphTcleTs0R9DzAZYjIlEx
	06Hejer2/jk6vxA5A2RxPKBam5dn4yiP8rcw/vrrBfnp5sCvip1jqs7NOcPz90IRP+0=
X-Gm-Gg: ASbGncu+wuAsf6l8lPfNCTBc4negkBmhuBxHgmiT0SESSgZ9yhO+lH870KxDpIMv+iU
	bu+eOUMCpIEG2F2tI99ENl0c3elgOUnbxTQF5DJ8uz1K33bQhYemD7HCGNjIqF5YW4CSR3MkMe3
	Dgf1B/LnPvrnCK7PxPq7SWliqEItty+IiEsjbp1L1RdrS7HdDyfwBMRL1sxqMeu/gw53YC+Btya
	pp9KgJCywhHsSY9i8VFWDVx2c8PbBWDBme/nObbtTlk6Qg9pvm115rYsn+WE4cHN/TKn6FtHzUA
	JbYvv/qDRJTsA9m6CMxoFDwwUQy8u9CFRmVaBcOTQe/VuZFbsoqem8FJtuAibBZAGhvzImbp064
	b1jRE/hdAkHaVEFGjEMhPfpAqWyQE
X-Google-Smtp-Source: AGHT+IGCFoEAWHp0O0ZxSghIhKJ6bqWzUVNZMvPU9+r3bWoucErvPggkAcIFKHKZBsqrlaHAk5kO7w==
X-Received: by 2002:a05:600c:138d:b0:459:d7c4:9e28 with SMTP id 5b1f17b1804b1-45b5eb1c567mr38424715e9.0.1756259895243;
        Tue, 26 Aug 2025 18:58:15 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24882c84b6esm17608355ad.6.2025.08.26.18.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 18:58:14 -0700 (PDT)
Message-ID: <ab82d1b0-8152-4573-9781-df8d689e9298@suse.com>
Date: Wed, 27 Aug 2025 09:58:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: PATCH] ocfs2: fix recursive semaphore deadlock
 in fiemap call
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Mark Fasheh <mark@fasheh.com>,
 "syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com"
 <syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20250825145825.3596-1-mark.tinguely@oracle.com>
 <d05b1d06-3b03-45b3-aa5f-97b5e8366c5e@oracle.com>
 <6641daab-022b-424f-9b06-068e21e1adb3@suse.com>
 <67993b6e-d162-4a56-8b2e-3a40cd1f9111@oracle.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <67993b6e-d162-4a56-8b2e-3a40cd1f9111@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/26/25 21:01, Mark Tinguely wrote:
> On 8/25/25 9:19 PM, Heming Zhao wrote:
>> On 8/25/25 23:13, Mark Tinguely wrote:
>>>
>>> syzbot detected a OCFS2 hang due to a recursive semaphore on a
>>> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
>>>
>>> context_switch kernel/sched/core.c:5357 [inline]
>>>   __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>>>   __schedule_loop kernel/sched/core.c:7043 [inline]
>>>   schedule+0x165/0x360 kernel/sched/core.c:7058
>>>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>>>   rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>>>   __down_write_common kernel/locking/rwsem.c:1317 [inline]
>>>   __down_write kernel/locking/rwsem.c:1326 [inline]
>>>   down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>>>   ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>>>   do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>>>   wp_page_shared mm/memory.c:3762 [inline]
>>>   do_wp_page+0x268d/0x5800 mm/memory.c:3981
>>>   handle_pte_fault mm/memory.c:6068 [inline]
>>>   __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>>>   handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>>>   do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>>>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>>   exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>>>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>>> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
>>> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
>>> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
>>> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
>>> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89 f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
>>> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
>>> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
>>> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
>>> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
>>> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
>>> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>>>   copy_to_user include/linux/uaccess.h:225 [inline]
>>>   fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>>>   ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>>>   ioctl_fiemap fs/ioctl.c:220 [inline]
>>>   do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>>>   __do_sys_ioctl fs/ioctl.c:596 [inline]
>>>   __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> RIP: 0033:0x7f5f13850fd9
>>> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
>>> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
>>> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
>>> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
>>>
>>> ocfs2_fiemap() takes read lock of the ip_alloc_sem semaphore (since
>>> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
>>> to read the extent list of this running mmap executable.
>>> The user supplied buffer to hold the fiemap information page faults
>>> calling ocfs2_page_mkwrite() which will take a write lock (since
>>> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
>>> semaphore will hold filesystem locks and causes a hang of the
>>> fileystem.
>>>
>>> The ip_alloc_sem protects the inode extent list and size.
>>> I read semphore could be use in ocfs2_page_mkwrite() and
>>> prevent the recursive lock.
>>>
>>> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
>>>
>>> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
>>> ---
>>>   fs/ocfs2/mmap.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
>>> index 50e2faf64c19..78513109b9b1 100644
>>> --- a/fs/ocfs2/mmap.c
>>> +++ b/fs/ocfs2/mmap.c
>>> @@ -139,11 +139,11 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
>>>        * ocfs2_truncate_file() changing i_size as well as any thread
>>>        * modifying the inode btree.
>>>        */
>>> -    down_write(&OCFS2_I(inode)->ip_alloc_sem);
>>> +    down_read(&OCFS2_I(inode)->ip_alloc_sem);
>>>        ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
>>> -    up_write(&OCFS2_I(inode)->ip_alloc_sem);
>>> +    up_read(&OCFS2_I(inode)->ip_alloc_sem);
>>>        brelse(di_bh);
>>>       ocfs2_inode_unlock(inode, 1);
>>
>> __ocfs2_page_mkwrite() performs a write operation, which should require a write lock.
> 
> thanks for the feedback. IMO, mkwrite doesn't perform IO, add extents nor change the size. There is no IO in mmap here, the mutex is taken to protect changes while write_begin/write_end add the mmap page into the cluster of pages. Other filesystem use a shared/read lock in mkwrite.

The routine __ocfs2_page_mkwrite() calls ocfs2_write_end_nolock(),
which then issues IOs (only for inline data) and updates the i_size.

> 
>> In my view, there are two ways to fix this:
>> 1. split the big semphore lock for ocfs2_fiemap(), this involves releasing the read lock after ocfs2_get_clusters_nocache(), and re- acquiring it after fiemap_fill_next_extent().
> 
> yes, I tried this also and it works. It is not very pretty.

agree

> 
>> 2. use try_down_write in ocfs2_remap_file_range().
>>
>> Thanks,
>> Heming
>>
> 
> This is a very contrived situation. It has never happened in the real world in 17 years so the urgency is extremely low. I understand if the risk/reward of the change is not worth the effort.
> 
> Mark
> 

If the <2> works, its performance impact is acceptable for fixing this issue.

Heming
