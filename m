Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C302F8E85
	for <ocfs2-devel@lists.linux.dev>; Sat,  9 May 2026 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778307611; cv=none; b=uAVr18Y6nCPsHkrXE55DYeJ2ZQ62UoPp5emPEkGu7ZeR4E2m6gXJ3hMRoz4B6JQUq3GxXbdjqHuolw49kX5lFeHZEo/qQQRuFhTlkrRFW/42VOHnF6zcgkBqylQVu0vb6ackaqiQESLyz5gEcRcN08WQOq8H3bNYGpStZVfxYCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778307611; c=relaxed/simple;
	bh=WR8MMYFpeWyY61ViYsdXPqtPRO8Rl7fEXQvBUWtXMAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDLbQ8qaxBs5+lbXJmuby3C6MH6gJAavvad4A4oZOIdScVZlj9ZPaHGzAxr8f7SE+McSRl5yLfMt2lJcadsdY3efyViguzhVGAjHMu1E+sWAM15UQ/bWr64l1S/XlB2WR4byUR2vPsVeg91V5rcY7XsLOcTRCH/UB5gPNTTG044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CwJwebkP; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CwJwebkP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778307605; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iu5X8gIAWbpOzTgDpJdNvCQ9mknIeveQAOiM9eNkjD8=;
	b=CwJwebkPem3n2PanbO3/JmYjPmlR1FN4TJmn0a9i2nkxNa94AAQPQxYDmhGx+Lfr7lGXmNN+ZsKWzlAnFaSVs//ccEulqK7HcVFQpIxupLBBsgz9zGPwCby2MeZoc8csFT6rDuALJEA4vBbxDeEkNqQx0Xs09NwAkHrB69A44qk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X2Za9U2_1778307604;
Received: from 30.221.129.99(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2Za9U2_1778307604 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 09 May 2026 14:20:04 +0800
Message-ID: <af0ae50e-1bcf-40cb-820f-aff07af156a5@linux.alibaba.com>
Date: Sat, 9 May 2026 14:20:04 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested
 during unmount
To: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Cc: heming.zhao@suse.com, jlbec@evilplan.org, kurt.hackel@oracle.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev
References: <75570681-a25a-4cec-9874-b76fec6167e8@linux.alibaba.com>
 <20260509042841.2038191-1-xujiakai24@mails.ucas.ac.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260509042841.2038191-1-xujiakai24@mails.ucas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/9/26 12:28 PM, Jiakai Xu wrote:
>> It seems this is not enough, or TOCTOU still exists. Say:
>>
>> Thread A			Thread B
>> osb = OCFS2_SB(inode->i_sb)
>> 				ocfs2_dismount_volume()
>> 				-> sb->s_fs_info = NULL
>> 				-> kfree(osb)
>> use freed osb
>>
> 
> Hi Joseph,
> 
> Thank you very much for the review! You are absolutely right about the
> TOCTOU issue — simply adding a NULL check after OCFS2_SB() cannot
> prevent the race where thread A reads a valid osb pointer before thread
> B frees it.
> 
>> BTW, how did you find this issue?
> 
> I found this issue through fuzzing. The crash report shows a page fault 
> at __pv_queued_spin_lock_slowpath via the call path:
> 
>   ocfs2_permission -> ocfs2_inode_lock_tracker ->
>   ocfs2_inode_lock_full_nested -> ocfs2_is_hard_readonly ->
>   spin_lock(&osb->osb_lock)

What is the operation?
We expect all operations cannot access filesystem during filesystem shutdown.

> 
> The fault address was in the kernel static data region, indicating that
> the osb structure had been freed and its memory reused.
> 
> I have been thinking about a more robust fix and would like to get your
> opinion on the following approach:
> 
> Currently, ocfs2_dismount_volume() is called from ocfs2_put_super(),
> which runs inside generic_shutdown_super() while s_umount is still held.
> The osb structure is freed at this point, but inodes with elevated
> refcounts (e.g., held by inotify) survive evict_inodes() and may still
> trigger filesystem operations (like ocfs2_permission) that access osb.
> 
> The idea is to move the osb cleanup out of ocfs2_dismount_volume() and
> into an ocfs2-specific ->kill_sb() callback, so that the cleanup happens
> after generic_shutdown_super() has completed and all concurrent VFS
> operations have drained.
> 
> Specifically:
> 
> 1. Remove ocfs2_delete_osb(), kfree(osb), and sb->s_fs_info = NULL from
>    ocfs2_dismount_volume(). Keep all the subsystem shutdown (journal,
>    dlm, recovery, quota, etc.) there.
> 
> 2. Add a new ocfs2_kill_sb() that wraps kill_block_super():
> 
>    static void ocfs2_kill_sb(struct super_block *sb)
>    {
>        struct ocfs2_super *osb = OCFS2_SB(sb);
> 
>        kill_block_super(sb);
>        // At this point generic_shutdown_super() has completed,
>        // SB_DYING is set, and no new VFS operations can enter.
> 
>        if (osb) {
>            ocfs2_delete_osb(osb);
>            kfree(osb);
>            sb->s_fs_info = NULL;
>        }
>    }
> 
> 3. Update ocfs2_fs_type to use ocfs2_kill_sb instead of kill_block_super.
> 
> 4. The NULL check in ocfs2_inode_lock_full_nested() can optionally be
>    kept as a defense-in-depth measure, though it is no longer strictly
>    necessary if the life-cycle ordering is correct.
> 
> This pattern is similar to ext4 — ext4_kill_sb() calls kill_block_super()
> first and then handles cleanup after (e.g., journal_bdev_file).
> 
> Does this approach make sense?
> 

In generic_shutdown_super(), it clears SB_ACTIVE.
So it seems we can check this flag.

Thanks,
Joseph
