Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0D1E511;
	Thu,  8 Jan 2026 01:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767835760; cv=none; b=EpYT8wXBjaY6Ct5hQjL99K9R1rScG9Ni7W3ALCZK/8fUEtNbZXHk1FZaAS2r0G8MSy0Y2pyHxLIcnFRrvw2Ywo5X1JL9yewApUjXlqIFrfGBl3NDRuRbx3ia6zeUvj4+WP49/fjEO2uUA/svj06B+X+XoMq9t4wpFk6585uw2Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767835760; c=relaxed/simple;
	bh=F6Ydwq3mfkWXzvZIrp1ucG0FulrTWaNCAfgFyTNkPbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I0LyhJeTw6944AdQ1pn26XpD6sQcGoVQkn+4NHUfC6gqQxqdo8GmilitBxaFD7YvdbyjBhNG404Em5qouEYU+voo+3adSEXwsQHqNz1hrMkSuARJogpxjVxdOJG9334flHlXlclKPXhhq2brG6II/ijWV0buSUSS/ijVCSfArUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YDWvhEUu; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YDWvhEUu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767835753; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UXDaSi1/LDpEkmhDCd4oaUbfPpfa1uXY5JlPhY3BLZQ=;
	b=YDWvhEUujIzKtObiZqlVs76fM6rwPq0k6Fmg9GP4S03qJwadn4fNUGbr84xDwMCI9PkxtfLWUJj4TueGY/Syc44xWsDSrwPHtixwyGisiHcLdYGs3X6KKHljvaW47OqKXyEwnCuIEDLT+2Qzz0C73cMURyzD8u3F2l495D938g4=
Received: from 30.221.145.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WwamNmk_1767835752 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Jan 2026 09:29:12 +0800
Message-ID: <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
Date: Thu, 8 Jan 2026 09:29:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
To: Prithvi Tambewagh <activprithvi@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: heming.zhao@suse.com, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org,
 syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
References: <20260106125100.327980-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260106125100.327980-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/1/6 20:51, Prithvi Tambewagh wrote:
> A possible circular locking dependency in ocfs2_del_inode_from_orphan()
> is detected by syzbot, which occurs due to change in the sequence of
> acquiring locks. The existing chain is:
> 
> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] --> &dquot->dq_lock --> 
> &ocfs2_quota_ip_alloc_sem_key
> 
> In ocfs2_dio_end_io_write(), &ocfs2_quota_ip_alloc_sem_key is acquired,
> and then ocfs2_del_inode_from_orphan() is called, which acquires
> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]. This opposes the
> existing dependency chain:
> 

IIUC, ocfs2_dio_end_io_write() only gets the &ocfs2_file_ip_alloc_sem_key.
So how it happens?

Thanks,
Joseph

> -> #3 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
>        ocfs2_create_local_dquot+0x19d/0x1a40 fs/ocfs2/quota_local.c:1227
>        ocfs2_acquire_dquot+0x80f/0xb30 fs/ocfs2/quota_global.c:883
>        dqget+0x7c1/0xf20 fs/quota/dquot.c:980
>        __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
>        ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
>        ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
>        ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
>        lookup_open fs/namei.c:3796 [inline]
>        open_last_lookups fs/namei.c:3895 [inline]
>        path_openat+0x1500/0x3840 fs/namei.c:4131
>        do_filp_open+0x1fa/0x410 fs/namei.c:4161
>        do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>        do_sys_open fs/open.c:1452 [inline]
>        __do_sys_openat fs/open.c:1468 [inline]
>        __se_sys_openat fs/open.c:1463 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1463
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #2 (&dquot->dq_lock){+.+.}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        __mutex_lock_common kernel/locking/rtmutex_api.c:535 [inline]
>        mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:547
>        wait_on_dquot fs/quota/dquot.c:357 [inline]
>        dqget+0x73a/0xf20 fs/quota/dquot.c:975
>        __dquot_initialize+0x3b3/0xcb0 fs/quota/dquot.c:1508
>        ocfs2_get_init_inode+0x13b/0x1b0 fs/ocfs2/namei.c:205
>        ocfs2_mknod+0x863/0x2050 fs/ocfs2/namei.c:313
>        ocfs2_create+0x1a5/0x440 fs/ocfs2/namei.c:676
>        lookup_open fs/namei.c:3796 [inline]
>        open_last_lookups fs/namei.c:3895 [inline]
>        path_openat+0x1500/0x3840 fs/namei.c:4131
>        do_filp_open+0x1fa/0x410 fs/namei.c:4161
>        do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>        do_sys_open fs/open.c:1452 [inline]
>        __do_sys_openat fs/open.c:1468 [inline]
>        __se_sys_openat fs/open.c:1463 [inline]
>        __x64_sys_openat+0x138/0x170 fs/open.c:1463
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
>        inode_lock include/linux/fs.h:980 [inline]
>        ocfs2_remove_inode fs/ocfs2/inode.c:731 [inline]
>        ocfs2_wipe_inode fs/ocfs2/inode.c:894 [inline]
>        ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
>        ocfs2_evict_inode+0x153d/0x40d0 fs/ocfs2/inode.c:1295
>        evict+0x504/0x9c0 fs/inode.c:810
>        do_unlinkat+0x39f/0x570 fs/namei.c:4744
>        __do_sys_unlinkat fs/namei.c:4778 [inline]
>        __se_sys_unlinkat fs/namei.c:4771 [inline]
>        __x64_sys_unlinkat+0xd3/0xf0 fs/namei.c:4771
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
>        __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>        lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>        down_write+0x3a/0x50 kernel/locking/rwsem.c:1590
>        inode_lock include/linux/fs.h:980 [inline]
>        ocfs2_del_inode_from_orphan+0x134/0x740 fs/ocfs2/namei.c:2730
>        ocfs2_dio_end_io_write fs/ocfs2/aops.c:2306 [inline]
>        ocfs2_dio_end_io+0x47b/0x1100 fs/ocfs2/aops.c:2404
>        dio_complete+0x25e/0x790 fs/direct-io.c:281
>        __blockdev_direct_IO+0x2bc0/0x31f0 fs/direct-io.c:1303
>        ocfs2_direct_IO+0x260/0x2d0 fs/ocfs2/aops.c:2441
>        generic_file_direct_write+0x1dc/0x3e0 mm/filemap.c:4189
>        __generic_file_write_iter+0x120/0x240 mm/filemap.c:4358
>        ocfs2_file_write_iter+0x157d/0x1d20 fs/ocfs2/file.c:2469
>        iter_file_splice_write+0x97a/0x10f0 fs/splice.c:738
>        do_splice_from fs/splice.c:938 [inline]
>        direct_splice_actor+0x104/0x160 fs/splice.c:1161
>        splice_direct_to_actor+0x5b3/0xcd0 fs/splice.c:1105
>        do_splice_direct_actor fs/splice.c:1204 [inline]
>        do_splice_direct+0x187/0x270 fs/splice.c:1230
>        do_sendfile+0x4ec/0x7f0 fs/read_write.c:1370
>        __do_sys_sendfile64 fs/read_write.c:1431 [inline]
>        __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fix this by acquiring &ocfs2_quota_ip_alloc_sem_key after acquiring
> &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE], effectively calling
> down_write(&oi->ip_alloc_sem) after the call to
> ocfs2_del_inode_from_orphan().
> 
> Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
> Tested-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
>  fs/ocfs2/aops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 76c86f1c2b1c..586e3b74d782 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2295,8 +2295,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  		goto out;
>  	}
>  
> -	down_write(&oi->ip_alloc_sem);
> -
>  	/* Delete orphan before acquire i_rwsem. */
>  	if (dwc->dw_orphaned) {
>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> @@ -2309,6 +2307,8 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  			mlog_errno(ret);
>  	}
>  
> +	down_write(&oi->ip_alloc_sem);
> +
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  
>  	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> 
> base-commit: 765e56e41a5af2d456ddda6cbd617b9d3295ab4e

