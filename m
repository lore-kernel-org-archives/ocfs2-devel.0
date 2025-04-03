Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4E13AD22
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743644678; cv=none; b=QnG49mHHITE31LzZ1Qnt89ITmLileFNirF8e0EFFxoB4Cavi7+rOKl8pq1foTLi6LmFLvK0axpxAwAh8pgK6KJmgnOZOrpXzv8rvKKdJlVyF/luzLvXFojmJytMJ/s0bDOiytaOurC9Kqo4dHlyYSXsxSa77/9Yf5NQV1kR0TMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743644678; c=relaxed/simple;
	bh=LWQPkBkP9hDcVWXPZJtf7g3j0cR0nSkuarPCHngG7XI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LO3DSpwPiyoUtenW0snd3YdufhL/uID4g/xYCZrKc7lb5+1tOsB+dmudP6LXpZR6Gwb1qru294vz/M4dtuWrv8k1XLwePjIIA83+A4Ylru0r9TXX1WaEyHFQhEcF8X3WbU406diJYxL0qlfAZ4vsEceWoFy2ll8epMriiq1dYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b72tlPgo; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b72tlPgo"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43ce4e47a85so397745e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Apr 2025 18:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743644673; x=1744249473; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UUbxWhR/8GWhGNCmjPJ2Bd3Q1OUo+M8Y2p8qU8lApN4=;
        b=b72tlPgozt9HK7wxcA+xEmPhO29X9+fOlLXDqkjF06VZGyBkMt2tjKfxT7o62sSQvQ
         Fb4QpMKHVrWAnGhQPybG1bgUEfW4Nt3rnQKx/0JXYyMsn2msLfun5YylctxMMRsw1jWN
         L0lpsvJwcARXIgUgWwSE8gtD/0WHwhUFfnnFwJsZrnTkNpmfvUqm15aFRYutk/oUrMh1
         QxaT1p1Y0a7wF0H7YatkxsbkGtI4aOr0qGIkbTl2GYu0/1bqZzyVt+/Znp/Nb+GyPXeZ
         z5hF9UCEPziJbjhL5ZfL3ti3Ft1MzgNn8lUxu77ULo7GDKIDtmLAa3JNx3ZvTEYBDl87
         BF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743644673; x=1744249473;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUbxWhR/8GWhGNCmjPJ2Bd3Q1OUo+M8Y2p8qU8lApN4=;
        b=xCvvyErNkUpODfBWpqUMg2R0VDNa/1KNYwL3Am3JL6hVD1k/swLYLYXaGq+pNW6Pq0
         nqjX7zw5Uo6MJ8TurBNFFuIRokr39etMQr2UIV0mR2Y2WPbNRQOzl01uUy8O3BbgfLXN
         akCYHZY91QbEQlY1pYQ0o1ymBeZFHsyxI5DR9HhJRMd0GxnRMpt/MPRCqB206f7yKa07
         m3rwKafqdQEry7Shzz131vV0UD1aMWvRsEJoH7+uu4EOAu51guwFF857zqahN22AuOiG
         3B371Ac9wGps3bRLoKmrsonLpdumM5P1cz341+XhFqYcetVTBynu/ju0q1Giv5nKKPnK
         oNCw==
X-Forwarded-Encrypted: i=1; AJvYcCUB8ct36e/F2b6P40202PxtFhUnkXFRWBNdwQ/dg9Ygj6fezefbLm1+SWHazk9aoh3CozCuMxtOSsIyjg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyjkxwnNE/O804oxsbulSyOrFB7kKmNEGASCyJW9TE689bM3B85
	HtgCmZHhKNGonGOQVU02gflRI1NOqnMxL7OefceyZvsHorKoHIu3QwQ/x8Wb1eZPZySYbI5CzR6
	p
X-Gm-Gg: ASbGncvumJ5RldlQA2AQySXMCCUBN4647TeuZjIehPqbp51CQNgbk+QrCPJsjrRjAQP
	TJdFjMQw73b6ekr37BxqdL0KUoSAhgY+yjOXbG5298Xwqy55n9eCGtQBb5P+ynPuEKAENm2F5cn
	yHkPViqc6uU665UnEXs62+zUMGY/3Wd3LjSqKN0nEbtQ/8blX0zNA/pFRHO4fQYhz5FuJS5KL26
	bG4VW10y7PmxZ1GhCbwewiJd1Orb7kBNjZhg3JlpnFadz21M1Iyf6DACJ0J9Grm43q/R33wgUso
	rHH0rpiZKElWmsiQfP/BtaA21G0FkZC6ApdlgYm7/V+iSdbEI0k=
X-Google-Smtp-Source: AGHT+IGivnZFI0zjwZJb/9NNdFq2nh3LEnQWupUU9OH0KBapBABtw+wdeBFslMb0jxlqdz1wV4tguQ==
X-Received: by 2002:a05:600c:c17:b0:439:9a5a:d3bb with SMTP id 5b1f17b1804b1-43ea933d443mr35941075e9.2.1743644672993;
        Wed, 02 Apr 2025 18:44:32 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3057ca8cffasm381189a91.26.2025.04.02.18.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 18:44:32 -0700 (PDT)
Message-ID: <fee459fe-00ab-47f3-8a4f-2aba152202b6@suse.com>
Date: Thu, 3 Apr 2025 09:44:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: Fix deadlock in ocfs2_finish_quota_recovery
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Murad Masimov <m.masimov@mt-integration.ru>, Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org,
 syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
 <20250402065628.706359-3-m.masimov@mt-integration.ru>
 <5e8fdecc-8003-4eae-8c90-94ecad20061c@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <5e8fdecc-8003-4eae-8c90-94ecad20061c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph and Murad,

On 4/3/25 09:28, Joseph Qi wrote:
> 
> 
> On 2025/4/2 14:56, Murad Masimov wrote:
>> When filesystem is unmounted all pending recovery work is processed. This
>> may lead to a deadlock in ocfs2_finish_quota_recovery() as it locks the
>> s_umount semaphore while it is already exclusively locked in
>> deactivate_super().
>>
>> Use down_read_trylock() instead and return if it fails, since that possibly
>> means that unmount may be in progress so it is not possible to finish quota
>> recovery. According to the description of ocfs2_complete_recovery(), which
>> is the caller of ocfs2_finish_quota_recovery(), by the point this job is
>> started the node can already be considered recovered. There is also no
>> error handling in ocfs2_complete_recovery() which indicates that fail is
>> not critical in this context.
>>
>> The following warning has been reported by Syzkaller:
>>
>> ================================================================
>> WARNING: possible circular locking dependency detected
>> 6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0 Not tainted
>> ------------------------------------------------------
>> kworker/u4:10/1087 is trying to acquire lock:
>> ffff88803c49e0e0 (&type->s_umount_key#42){++++}-{4:4}, at: ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
>>
>> but task is already holding lock:
>> ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
>> ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}:
>>         lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>         process_one_work kernel/workqueue.c:3214 [inline]
>>         process_scheduled_works+0x9e4/0x18e0 kernel/workqueue.c:3319
>>         worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>>         kthread+0x7a9/0x920 kernel/kthread.c:464
>>         ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>
>> -> #1 ((wq_completion)ocfs2_wq){+.+.}-{0:0}:
>>         lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>         touch_wq_lockdep_map+0xc7/0x170 kernel/workqueue.c:3907
>>         __flush_workqueue+0x14a/0x1280 kernel/workqueue.c:3949
>>         ocfs2_shutdown_local_alloc+0x109/0xa90 fs/ocfs2/localalloc.c:380
>>         ocfs2_dismount_volume+0x202/0x910 fs/ocfs2/super.c:1822
>>         generic_shutdown_super+0x139/0x2d0 fs/super.c:642
>>         kill_block_super+0x44/0x90 fs/super.c:1710
>>         deactivate_locked_super+0xc4/0x130 fs/super.c:473
>>         cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
>>         task_work_run+0x24f/0x310 kernel/task_work.c:227
>>         resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>>         exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>>         exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
>>         __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>>         syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
>>         do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> -> #0 (&type->s_umount_key#42){++++}-{4:4}:
>>         check_prev_add kernel/locking/lockdep.c:3163 [inline]
>>         check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>>         validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>>         __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>>         lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>         down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
>>         ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
>>         ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
>>         process_one_work kernel/workqueue.c:3238 [inline]
>>         process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
>>         worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>>         kthread+0x7a9/0x920 kernel/kthread.c:464
>>         ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>    &type->s_umount_key#42 --> (wq_completion)ocfs2_wq --> (work_completion)(&journal->j_recovery_work)
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock((work_completion)(&journal->j_recovery_work));
>>                                 lock((wq_completion)ocfs2_wq);
>>                                 lock((work_completion)(&journal->j_recovery_work));
>>    rlock(&type->s_umount_key#42);
>>
>>   *** DEADLOCK ***
>>
>> 2 locks held by kworker/u4:10/1087:
>>   #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
>>   #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
>>   #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
>>   #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
>>
>> stack backtrace:
>> CPU: 0 UID: 0 PID: 1087 Comm: kworker/u4:10 Not tainted 6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>> Workqueue: ocfs2_wq ocfs2_complete_recovery
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:94 [inline]
>>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>   print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
>>   check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
>>   check_prev_add kernel/locking/lockdep.c:3163 [inline]
>>   check_prevs_add kernel/locking/lockdep.c:3282 [inline]
>>   validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
>>   __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
>>   lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
>>   down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
>>   ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
>>   ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
>>   process_one_work kernel/workqueue.c:3238 [inline]
>>   process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
>>   worker_thread+0x870/0xd30 kernel/workqueue.c:3400
>>   kthread+0x7a9/0x920 kernel/kthread.c:464
>>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
>>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>   </TASK>
>> ================================================================
>>
>> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>>
>> Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
>> Reported-by: syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f
>> Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
>> ---
>>   fs/ocfs2/quota_local.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
>> index e60383d6ecc1..d3304bb03163 100644
>> --- a/fs/ocfs2/quota_local.c
>> +++ b/fs/ocfs2/quota_local.c
>> @@ -600,7 +600,16 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>>   	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
>>   	       "slot %u\n", osb->dev_str, slot_num);
>>
>> -	down_read(&sb->s_umount);
>> +	/*
>> +	 * We have to be careful here not to deadlock on s_umount as umount
>> +	 * disabling quotas may be in progress and it waits for this work to
>> +	 * complete. If trylock fails, we have to skip this step.
>> +	 */
> 
> Seems we don't have a better way.
> 
>> +	if (!down_read_trylock(&sb->s_umount)) {
>> +		status = -ENOENT;
> 
> Normally EAGAIN is a proper error code when trylock fails, though it
> hasn't been handled in caller...
> Also we'd better log an error in this case to indicate what happens.
> 
> Thanks,
> Joseph
> 

According to the commit description, one CPU handles the mounting operation,
while another handles the unmounting operation.

With this patch, the mounting thread discards the recovery job. What are the
consequences?

Under this patch, the expected result is that the mounting operation should be
aborted, and the unmounting operation should ultimately succeed.
However, I am difficult to identify the abort point during the mounting phase.

Is it reasonable/workable to set osb->vol_state to VOLUME_DISMOUNTING at
the beginning of ocfs2_dismount_volume(), and then check the vol_state at every
atomic_set(vol_state) point in ocfs2_fill_super()? If ocfs2_fill_super() detects
the vol_state in VOLUME_DISMOUNTING state, should it return an error and
abort the mounting phase?
Or, at the beginning of ocfs2_dismount_volume(), it should check the vol_state
against VOLUME_MOUNTED or VOLUME_MOUNTED_QUOTAS. If it does not match,
the unmount process should be aborted.

- Heming

>> +		goto out;
>> +	}
>> +
>>   	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
>>   		if (list_empty(&(rec->r_list[type])))
>>   			continue;
>> @@ -608,7 +617,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>>   		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
>>   		if (!lqinode) {
>>   			status = -ENOENT;
>> -			goto out;
>> +			goto out_up;
>>   		}
>>   		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
>>   						       OCFS2_META_LOCK_NOQUEUE);
>> @@ -676,8 +685,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>>   		if (status < 0)
>>   			break;
>>   	}
>> -out:
>> +out_up:
>>   	up_read(&sb->s_umount);
>> +out:
>>   	ocfs2_free_quota_recovery(rec);
>>   	return status;
>>   }
>> --
>> 2.39.2
> 
> 

