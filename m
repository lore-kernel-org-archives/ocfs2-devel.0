Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45F43D966F;
	Tue, 16 Jun 2026 06:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589648; cv=none; b=SaGk0pxW4s3r1EWGWEJNoH06hJfqvdeeeEUohiHjbJnpI1OV6hmUP6lG/HfjsG/X6qwMtV2l5HH4gQebQVrxIsYpHmOUyXCeIdCiKHHnpv+mwxi40z7ysBBZK4O8/eUi891o1bn5+M54KMlzSZtTjq0QHxNYI+82shMRlsfy4BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589648; c=relaxed/simple;
	bh=RHiDjfPGyjzwJA9XleoqFxc1SXobyVlg8CDllrM/GZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCMlmp5uc3uJozy5QA7LcXRx76iAjW+WZiK+JLpSnyukNxuqzHDNApjDY4m8SZnTXNYEqfLpiP2FJO0ls1g+mb2NhJiPqFj/H2cyoJToeyu/t4FjwPA4C1yy0CCzuA6lpdt0Bt35CJmZ9wLuVO6OVueYPlUXS0nmDOkSzIPYQpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HeF1/ZxA; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HeF1/ZxA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781589642; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JHVdgI38vU8InSz4ekfmHoTl4B0c/zoZFuDfyGeoFak=;
	b=HeF1/ZxAu5qub1qGceuK3lUP5xHMqKjAi4IbyXiWb1CQ9EGUDY2NmoPTFmoD7HsEzAFLEOwFx0YPiWmrWt43sr1+q4WG+YL9zkE1XgQzhzz/0yFCJ7VZM846McyTrqTa2j4Iow5HV28O9aLJofp85VN1RQ6UYA7WrzJm87pJI40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X5-Edtn_1781589640;
Received: from 30.221.145.41(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5-Edtn_1781589640 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 14:00:41 +0800
Message-ID: <6f95cc40-3014-4628-9739-28f47bec825b@linux.alibaba.com>
Date: Tue, 16 Jun 2026 14:00:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_dio_end_io_write
To: Heming Zhao <heming.zhao@suse.com>, syzbot <syzbot@kernel.org>,
 Aleksandr Nogikh <nogikh@google.com>
Cc: syzkaller-bugs@googlegroups.com, Joel Becker <jlbec@evilplan.org>,
 Mark Fasheh <mark@fasheh.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>
 <ai-qJbXLuniGv-mr@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ai-qJbXLuniGv-mr@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/15/26 3:32 PM, Heming Zhao wrote:
> On Fri, Jun 12, 2026 at 11:50:20AM +0000, syzbot wrote:
>> From: Aleksandr Nogikh <nogikh@google.com>
>>
>> A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
>> EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.
>>
>> 1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
>> 2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
>> then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
>> EXTENT_ALLOC.
>> 3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
>> ocfs2_remove_inode.
>>
>> Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
>> contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.
>>
>> WARNING: possible circular locking dependency detected
>> ------------------------------------------------------
>> is trying to acquire lock:
>> ffff8881e78b33a0
>> (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
>> ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
>>
>> but task is already holding lock:
>> ffff8881e78b4fa0
>> (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
>> ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
>>        inode_lock include/linux/fs.h:1029 [inline]
>>        ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
>>        ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
>>        dio_complete+0x25b/0x790 fs/direct-io.c:281
>>
>> -> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>>        inode_lock include/linux/fs.h:1029 [inline]
>>        ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
>>        ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
>>        fs/ocfs2/suballoc.c:1078
>>        ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
>>
>> -> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>>        down_write+0x96/0x200 kernel/locking/rwsem.c:1625
>>        inode_lock include/linux/fs.h:1029 [inline]
>>        ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
>>        ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
>>        ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
>>        ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
>>
>> Chain exists of:
>>   &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
>>   &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
>>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]
>>
>>  Possible unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>>                                lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
>>                                lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>>   lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
>>
>>  *** DEADLOCK ***
>>

Better to describe the solution here.

>> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
>> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
>> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
>> Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
>> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> 
> LGTM.
> After d647c5b2fbf8, ocfs2_dio_end_io_write() spends a significant amount of time
> looping through the unwritten extent list before it finally acquires the
> ORPHAN_DIR lock. This gives other functions (such as ocfs2_wipe_inode() mentioned
> in this patch) a chance to preemptively grab the ORPHAN_DIR lock, thereby
> triggering the circular locking.
> What d647c5b2fbf8 actually did was widen the race window, turning a pre-existing,
> low-probability issue into an easily reproducible one.
> 

Ummm... before d647c5b2fbf8, ocfs2_del_inode_from_orphan() is called
before down_write(&ip_alloc_sem) and ocfs2_lock_allocators().
So I think the 'Fixes' tag looks reasonable.

Thanks,
Joseph

> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>>
>> ---
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 6ec198bda..4acdbb708 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>  unlock:
>>  	up_write(&oi->ip_alloc_sem);
>>  
>> +	if (data_ac) {
>> +		ocfs2_free_alloc_context(data_ac);
>> +		data_ac = NULL;
>> +	}
>> +	if (meta_ac) {
>> +		ocfs2_free_alloc_context(meta_ac);
>> +		meta_ac = NULL;
>> +	}
>> +
>>  	/* everything looks good, let's start the cleanup */
>>  	if (!ret && dwc->dw_orphaned) {
>>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
>> @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>  	ocfs2_inode_unlock(inode, 1);
>>  	brelse(di_bh);
>>  out:
>> -	if (data_ac)
>> -		ocfs2_free_alloc_context(data_ac);
>> -	if (meta_ac)
>> -		ocfs2_free_alloc_context(meta_ac);
>>  	ocfs2_run_deallocs(osb, &dealloc);
>>  	ocfs2_dio_free_write_ctx(inode, dwc);
>>  
>>
>>
>> base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
>> -- 
>> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
>> You can comment on the patch as usual, syzbot will try to address
>> the comments and send a new version of the patch if necessary.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>

