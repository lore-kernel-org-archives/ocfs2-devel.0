Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAE926CE03
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349989; cv=none; b=OcqOvqSYEZEnv5AaKP/aOWQbPEzdyW9jI81BiibgTV8UnVoJISgjTM6lxkO7/sXoKfoTLHRVp938hbWJV2c83R76k4Q71ygia/F10f9OGJN4bss3muUX6Llk8CJ+5lM0+CTD9ZH3GgpDoMwtebHwJ2zujLAZZN1W492TkN5bT6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349989; c=relaxed/simple;
	bh=9NxKkiZK3RM97pFBWwr3Bqkwge7vLap7kRpv2/huTFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpI43otaCS2IUkOVrRv3yhG2fsql5x32m+BhfTufw2t+fjp/C69xGBv8FRCyvSYHNUyCo1t3CT70X5MXfhHZ0YhctmBq/YaEZQD+KRtaNfrkw5nd8BmDRXfRXkjY4Kp3R/sHPmgL3VJMySjKcYxpK6/TQRHYCoTGaWKDRXHkEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R2eXa28q; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R2eXa28q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756349978; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=z4ZZ6Us9NA1Pb8WiacSQoNONwQ0EAgqfyy0avSwcli8=;
	b=R2eXa28qflzbXRUyFv0JSLm8rV6eeQTl+W98+jmkBm3oVsG0V2o/YUYzTtyJXafcpBb3fdtEGh31yRHMOijgr8//R0+kEIbI1vM03kUzbZewzsmpNW25voTMVMTrwkvSx3dqRtQ/8PPmE6iJniw4YsuwDM98HFEnhoJQLwORRxg=
Received: from 30.221.144.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WmlLw6M_1756349976 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 10:59:37 +0800
Message-ID: <c01b031c-8cde-4c9b-ab28-c2eff0b06fce@linux.alibaba.com>
Date: Thu, 28 Aug 2025 10:59:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Mark Fasheh <mark@fasheh.com>,
 syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com,
 Heming Zhao <heming.zhao@suse.com>
References: <20250827145919.30162-1-mark.tinguely@oracle.com>
 <bc1472a7-493e-4696-ba72-d6b8686bea88@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <bc1472a7-493e-4696-ba72-d6b8686bea88@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/8/27 23:08, Mark Tinguely wrote:
> syzbot detected a OCFS2 hang due to a recursive semaphore on a
> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
> 
> context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>  __schedule_loop kernel/sched/core.c:7043 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7058
>  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>  rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>  __down_write_common kernel/locking/rwsem.c:1317 [inline]
>  __down_write kernel/locking/rwsem.c:1326 [inline]
>  down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>  ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>  do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>  wp_page_shared mm/memory.c:3762 [inline]
>  do_wp_page+0x268d/0x5800 mm/memory.c:3981
>  handle_pte_fault mm/memory.c:6068 [inline]
>  __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>  handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>  do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89
> f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f
> 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>  copy_to_user include/linux/uaccess.h:225 [inline]
>  fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>  ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>  ioctl_fiemap fs/ioctl.c:220 [inline]
>  do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>  __do_sys_ioctl fs/ioctl.c:596 [inline]
>  __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5f13850fd9
> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
> 
> ocfs2_fiemap() takes a read lock of the ip_alloc_sem semaphore (since
> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
> to read the extent list of this running mmap executable.
> The user supplied buffer to hold the fiemap information page faults
> calling ocfs2_page_mkwrite() which will take a write lock (since
> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
> semaphore will hold filesystem locks and causes a hang of the
> fileystem.
> 
> The ip_alloc_sem protects the inode extent list and size.
> Release the read semphore before calling fiemap_fill_next_extent().
> 
> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> ---
> v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the read semaphore before calling fiemap_fill_next_extent().
> Add a Closes: line
> ---
>  fs/ocfs2/extent_map.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 930150ed5db1..c9e19ce73976 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -762,14 +762,14 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>          goto out;
>      }
> -    down_read(&OCFS2_I(inode)->ip_alloc_sem);
> -
>      /*
>       * Handle inline-data and fast symlink separately.
>       */
>      if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) ||
>          ocfs2_inode_is_fast_symlink(inode)) {
> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
>          ret = ocfs2_fiemap_inline(inode, di_bh, fieinfo, map_start);
> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);

ocfs2_fiemap_inline() will also call fiemap_fill_next_extent(), then may fault.
So could we keep the original down_read() as it is, and do up_read() before
fiemap_fill_next_extent()?

Thanks,
Joseph

>          goto out_unlock;
>      }
>  @@ -780,8 +780,19 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>      while (cpos < mapping_end && !is_last) {
>          u32 fe_flags;
> +        /*
> +         * fiemap_fill_next_extent() can page fault on the user
> +         * provided fiemap_extent if called on the running mmap
> +         * executable file. The ip_alloc_sem cannot be held or
> +         * result in recursive deadlock on ip_alloc_sem and a
> +         * hung filesystem.
> +         */
> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +
>          ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
>                           &hole_size, &rec, &is_last);
> +
> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);
>          if (ret) {
>              mlog_errno(ret);
>              goto out_unlock;
> @@ -817,8 +828,6 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  out_unlock:
>      brelse(di_bh);
> -    up_read(&OCFS2_I(inode)->ip_alloc_sem);
> -
>      ocfs2_inode_unlock(inode, 0);
>  out:
>  -- 2.39.5 (Apple Git-154)
> 

