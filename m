Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B21A5B9E
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Aug 2025 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756650015; cv=none; b=YOXH/R5ncQtDD9WfOd5NrJzSMkEGnBUHn7uk53bnOnSFY/EyGDrgkpTzEyC5pe5HUQ9ZNkkfd2svWKFRXStuuWe6hA//rT2Mgf5XPcfvdcIVBZHma5V+4QnLhcH4sChd30VK06T8U7RrWne0MkaTrUUKP57mqSDT/zOIqTALkJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756650015; c=relaxed/simple;
	bh=yX9o0oNGVDqvD2+R5R0XPps+uLJdlurP2v5AHd9sigY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUfSBj7+fKhebEJqvapPuQbIl0r9K9slbFc0xApzoV5vea97tzl1WHt1ba62M8W8KzJ+nCxgaWwGFcuSbKErvZ0sR+5nYm7dEhRDynclTB2h8ibSNqFIicFbSmKXXOZ4qnihcHUcQOTjb9xB775DFNfAfuEXU+X319dvXs5bb/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=s0ORCAH1; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="s0ORCAH1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756650003; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OctcnBX0Mnmd+G1qncCzKrz7o8G4yc60oWBgHCVEFkA=;
	b=s0ORCAH1HqO26CUXtNHsVNVYtITfpPGpTj91+yaXgVHg6iVbpub9WhT3h26rKnU0IhSEFsU0UXwQMMkSLyaD7Vo57krRD1iUcbGcmLGh3SJZJXosLGB+nHaf2P+cxKWp6PHhr2B1nCQWZEZUrPMhRvFvzJn+GaKIvN8DrqJMWJA=
Received: from 30.170.175.249(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wmwe0g5_1756650001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 31 Aug 2025 22:20:02 +0800
Message-ID: <65e1213a-723e-46fe-83ca-08e5cc37faef@linux.alibaba.com>
Date: Sun, 31 Aug 2025 22:19:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
To: Mark Tinguely <mark.tinguely@oracle.com>,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 akpm <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>,
 syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
References: <20250829150620.22710-1-mark.tinguely@oracle.com>
 <61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <61d1a62b-2631-4f12-81e2-cd689914360b@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/8/29 23:18, Mark Tinguely wrote:
> syzbot detected a OCFS2 hang due to a recursive semaphore on a
> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
> 
> context_switch kernel/sched/core.c:5357 [inline]
>   __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>   __schedule_loop kernel/sched/core.c:7043 [inline]
>   schedule+0x165/0x360 kernel/sched/core.c:7058
>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>   rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>   __down_write_common kernel/locking/rwsem.c:1317 [inline]
>   __down_write kernel/locking/rwsem.c:1326 [inline]
>   down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>   ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>   do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>   wp_page_shared mm/memory.c:3762 [inline]
>   do_wp_page+0x268d/0x5800 mm/memory.c:3981
>   handle_pte_fault mm/memory.c:6068 [inline]
>   __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>   handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>   do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>   exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
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
>   copy_to_user include/linux/uaccess.h:225 [inline]
>   fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>   ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>   ioctl_fiemap fs/ioctl.c:220 [inline]
>   do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>   __do_sys_ioctl fs/ioctl.c:596 [inline]
>   __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
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
> Release the read semphore before calling fiemap_fill_next_extent()
> in ocfs2_fiemap() and ocfs2_fiemap_inline(). This does an
> unnecessary semaphore lock/unlock on the last extent but simplifies
> the error path.
> 
> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=541dcc6ee768f77103e7
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v4: use Joseph Qi version. This was my original test case but v3 was
>     done to remove the unnecessary semaphore lock/unlock round trip.
>     This version simplifies the ocfs2_fiemap_inline() and error path.
> 
> v3: also release semaphore in ocfs2_fiemap_inline() with semaphore released
>     move semaphore before calling fiemap_fill_next_extent()
>     change the error path to release the semaphore to avoid an unnecessary
>     semaphore down/up in the last loop..
> 
> v2: leave the write semaphore in ocfs2_page_mkwrite() but remove the
>     read semaphore before calling fiemap_fill_next_extent().
>     Add a Closes: line
>     review noted missing semaphore change to ocfs2_fiemap_inline()
>            suggest moving locks to fiemap_fill_next_extent() call.
> 
> v1: change the ip_alloc_sem from write to read.
>     rejected in review.
> ---
>  fs/ocfs2/extent_map.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 930150ed5db1..9ab22875bef9 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -706,6 +706,8 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
>   * it not only handles the fiemap for inlined files, but also deals
>   * with the fast symlink, cause they have no difference for extent
>   * mapping per se.
> + *
> + * Must be called with ip_alloc_sem semaphore held.
>   */
>  static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>                     struct fiemap_extent_info *fieinfo,
> @@ -718,6 +720,8 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>      u32 flags = FIEMAP_EXTENT_DATA_INLINE|FIEMAP_EXTENT_LAST;
>      struct ocfs2_inode_info *oi = OCFS2_I(inode);
> +    lockdep_assert_held_read(&oi->ip_alloc_sem);
> +
>      di = (struct ocfs2_dinode *)di_bh->b_data;
>      if (ocfs2_inode_is_fast_symlink(inode))
>          id_count = ocfs2_fast_symlink_chars(inode->i_sb);
> @@ -732,8 +736,11 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
>              phys += offsetof(struct ocfs2_dinode,
>                       id2.i_data.id_data);
> +        /* Release the ip_alloc_sem to prevent deadlock on page fault */
> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);
>          ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
>                            flags);
> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
>          if (ret < 0)
>              return ret;
>      }
> @@ -803,8 +810,11 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>          phys_bytes = le64_to_cpu(rec.e_blkno) << osb->sb->s_blocksize_bits;
>          virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
> +        /* Release the ip_alloc_sem to prevent deadlock on page fault */
> +        up_read(&OCFS2_I(inode)->ip_alloc_sem);
>          ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
>                            len_bytes, fe_flags);
> +        down_read(&OCFS2_I(inode)->ip_alloc_sem);
>          if (ret)
>              break;
>  -- 2.39.5 (Apple Git-154)

