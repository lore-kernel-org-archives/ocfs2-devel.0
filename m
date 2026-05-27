Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBDE3B810D
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 May 2026 07:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868695; cv=none; b=AXNxEoMgL5XMqxWkjjrDRIUBNHRgGX5H7vDLPDOJXiLuqLrPf4q+VF+7HOOPlvJXhtv7FBSXX+8OLtXS6t106+moWxlJ9FdB9Y5Wh2iZqceobRljOK4gNQPf+wU/RHAOVkbP78rlD6c111s4on5EbC5F9Mz+7rFn1Gbootu2x4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868695; c=relaxed/simple;
	bh=lWKVasS4Ly/8awszQsto0v0dzJ1wL/Z7yd12tcyyIuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hfCBfOyY/0qqP85maI6ZzdysGuefgx3u3Z5yVvWCd5iGq18sMcTy7ai1dcWr17O0nvbs9HXd6z1pbm8O65+e+MYGvRhmEQ1plG4gJDhDnpRGEmdZTta8S1ielKI+lDE73TMsQWHpUmgpOFl7A5WI5dFc1b9AEaGy2jXaTlq6nzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=a0lItUt5; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="a0lItUt5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779868685; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dedPacO08i2qgbIx8Mw2DFDnEHOhXVAP5J8dpLLhppI=;
	b=a0lItUt5mJlho+kbEK/TWIGQYnAdT0eGXFRVYGEtp2/F2SPN9R/elg7X83vIgOJf0n0uBM9UxW+zeU9nFA/pH04YH3oOlQ+FwXgvOSyQ1TenF5XefDApp5D3n3VPeK8Uvu3qaTJbzVzo80JoM7I7jiqhi/POgCBUtEA1WtsagNY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X3iroUu_1779868371;
Received: from 30.221.145.39(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3iroUu_1779868371 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 15:52:52 +0800
Message-ID: <db59e9fd-e7e0-4cd0-9dd6-a462e8c21676@linux.alibaba.com>
Date: Wed, 27 May 2026 15:52:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: On
 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=775c17386a6fd
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <979042b0a8e9a70189c9195c81dfb9fa26f789ef.camel@yandex.ru>
 <66faed08-ed79-42ba-a605-3ec8465c89ca@linux.alibaba.com>
 <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <dd77ed3f10fafc5b9e412eeecb568bc03129051b.camel@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/26/26 9:59 PM, Dmitry Antipov wrote:
> On Tue, 2026-05-26 at 21:18 +0800, Joseph Qi wrote:
> 
>> Don't understand in which case we will see a corrupted dr_list in
>> ocfs2_dx_dir_lookup_rec().
>>
>> When ocfs2_validate_dx_root() fails, it will jump to read_failure logic
>> and buffer is not set to uptodate.
>>
>> Could you please list a detail flow for it?
> 
> Good question. At least C reproducer from https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
> works for me again, and the backtrace (reported with KASAN) is very similar to one reported with UBSAN
> at https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9 (see console log from there):
> 
> [   42.097756][ T5684] loop0: detected capacity change from 0 to 32768
> [   42.104863][ T5684] JBD2: Ignoring recovery information on journal
> [   42.113619][ T5684] ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
> [   42.135689][ T5684] (repro-30b53487d,5684,2):ocfs2_check_set_options:1244 ERROR: Invalid heartbeat mount options
> [   42.208624][ T5684] loop0: detected capacity change from 32768 to 32767
> [   42.214609][ T5684] OCFS2: ERROR (device loop0): int ocfs2_validate_dx_root(struct super_block *, struct buffer_head *): Dir Index Root # 74 has bad signature XDIR01
> [   42.215237][ T5684] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
> [   42.215663][ T5684] OCFS2: File system is now read-only.
> [   42.215891][ T5684] (repro-30b53487d,5684,0):ocfs2_find_entry_dx:1065 ERROR: status = -30
> [   42.216256][ T5684] ==================================================================
> [   42.216601][ T5684] BUG: KASAN: use-after-free in ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
> [   42.216971][ T5684] Read of size 4 at addr ffff88802fdfd2c0 by task repro-30b53487d/5684
> [   42.217341][ T5684] 
> [   42.217452][ T5684] CPU: 0 UID: 0 PID: 5684 Comm: repro-30b53487d Tainted: G        W           7.1.0-rc5-00006-ge8c2f9fdadee #7 PREEMPT(full) 
> [   42.217459][ T5684] Tainted: [W]=WARN
> [   42.217460][ T5684] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-10.fc44 06/10/2025
> [   42.217462][ T5684] Call Trace:
> [   42.217465][ T5684]  <TASK>
> [   42.217467][ T5684]  dump_stack_lvl+0xe8/0x150
> [   42.217473][ T5684]  print_address_description+0x55/0x1e0
> [   42.217479][ T5684]  ? ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
> [   42.217484][ T5684]  print_report+0x58/0x70
> [   42.217490][ T5684]  kasan_report+0x117/0x150
> [   42.217496][ T5684]  ? ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
> [   42.217502][ T5684]  ocfs2_dx_dir_lookup_rec+0x23c/0x6f0
> [   42.217508][ T5684]  ? __pfx_ocfs2_dx_dir_lookup_rec+0x10/0x10
> [   42.217513][ T5684]  ? ocfs2_dx_dir_name_hash+0x252/0xb50
> [   42.217518][ T5684]  ? __asan_memcpy+0x40/0x70
> [   42.217522][ T5684]  ? ocfs2_dx_dir_name_hash+0x9fb/0xb50
> [   42.217527][ T5684]  ocfs2_dx_dir_lookup+0xd3/0x530
> [   42.217532][ T5684]  ? __pfx_ocfs2_dx_dir_name_hash+0x10/0x10
> [   42.217537][ T5684]  ? __pfx_ocfs2_dx_dir_lookup+0x10/0x10
> [   42.217543][ T5684]  ocfs2_find_entry+0xefe/0x2050
> [   42.217549][ T5684]  ? __pfx_ocfs2_find_entry+0x10/0x10
> [   42.217554][ T5684]  ? console_unlock+0x150/0x1c0
> [   42.217560][ T5684]  ? __pfx_console_unlock+0x10/0x10
> [   42.217566][ T5684]  ? irq_work_queue+0xc3/0x140
> [   42.217571][ T5684]  ? ocfs2_read_inode_block+0x152/0x1c0
> [   42.217576][ T5684]  ? __pfx_ocfs2_read_inode_block+0x10/0x10
> [   42.217580][ T5684]  ? do_raw_spin_unlock+0xf5/0x210
> [   42.217584][ T5684]  ? ocfs2_inode_lock_full_nested+0xaad/0x1b30
> [   42.217589][ T5684]  ? ocfs2_read_blocks+0x119f/0x1510
> [   42.217594][ T5684]  ? __pfx_ocfs2_inode_lock_full_nested+0x10/0x10
> [   42.217599][ T5684]  ocfs2_check_dir_for_entry+0x13c/0x410
> [   42.217605][ T5684]  ? __pfx_ocfs2_check_dir_for_entry+0x10/0x10
> [   42.217609][ T5684]  ? do_file_open+0x23e/0x4a0
> [   42.217613][ T5684]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   42.217618][ T5684]  ocfs2_mknod+0x6bc/0x2240
> [   42.217623][ T5684]  ? __pfx_ocfs2_mknod+0x10/0x10
> [   42.217626][ T5684]  ? __pfx_ocfs2_find_entry+0x10/0x10
> [   42.217631][ T5684]  ? ocfs2_inode_lock_full_nested+0xaad/0x1b30
> [   42.217636][ T5684]  ? register_lock_class+0x31/0x2e0
> [   42.217642][ T5684]  ? __lock_acquire+0x683/0x2cd0
> [   42.217649][ T5684]  ? start_dir_add+0x19c/0x270
> [   42.217654][ T5684]  ? do_raw_spin_lock+0x12b/0x2f0
> [   42.217658][ T5684]  ? do_raw_spin_unlock+0xf5/0x210
> [   42.217662][ T5684]  ? _raw_spin_unlock+0x28/0x50
> [   42.217670][ T5684]  ? rcu_is_watching+0x15/0xb0
> [   42.217675][ T5684]  ? ocfs2_lookup+0x5f4/0xa00
> [   42.217681][ T5684]  ? __pfx_apparmor_path_mknod+0x10/0x10
> [   42.217686][ T5684]  ocfs2_create+0x195/0x460
> [   42.217691][ T5684]  ? __pfx_ocfs2_lookup+0x10/0x10
> [   42.217697][ T5684]  ? __pfx_ocfs2_create+0x10/0x10
> [   42.217703][ T5684]  ? bpf_lsm_inode_permission+0x9/0x20
> [   42.217707][ T5684]  ? security_inode_permission+0xb7/0x2e0
> [   42.217713][ T5684]  ? may_o_create+0x2d2/0x370
> [   42.217717][ T5684]  ? bpf_lsm_inode_create+0x9/0x20
> [   42.217720][ T5684]  ? __pfx_ocfs2_create+0x10/0x10
> [   42.217726][ T5684]  path_openat+0x17ba/0x3890
> [   42.217733][ T5684]  ? __pfx_path_openat+0x10/0x10
> [   42.217737][ T5684]  ? stack_trace_save+0xa9/0x100
> [   42.217742][ T5684]  do_file_open+0x23e/0x4a0
> [   42.217746][ T5684]  ? __pfx_do_file_open+0x10/0x10
> [   42.217753][ T5684]  ? alloc_fd+0x5f8/0x660
> [   42.217759][ T5684]  do_sys_openat2+0x113/0x200
> [   42.217764][ T5684]  ? __pfx_lo_ioctl+0x10/0x10
> [   42.217772][ T5684]  ? __pfx_do_sys_openat2+0x10/0x10
> [   42.217777][ T5684]  ? blkdev_ioctl+0x5e3/0x740
> [   42.217782][ T5684]  ? rcu_is_watching+0x15/0xb0
> [   42.217788][ T5684]  __x64_sys_openat+0x138/0x170
> [   42.217793][ T5684]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   42.217797][ T5684]  do_syscall_64+0x15f/0x560
> [   42.217808][ T5684]  ? trace_irq_disable+0x3b/0x140
> [   42.217813][ T5684]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   42.217817][ T5684] RIP: 0033:0x42025d
> [   42.217821][ T5684] Code: d5 48 8d 3c 0a eb 91 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 f0 ff ff ff f7 d8 64 89 01 48
> [   42.217825][ T5684] RSP: 002b:00007fff7b8ee288 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> [   42.217830][ T5684] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000042025d
> [   42.217833][ T5684] RDX: 0000000000105042 RSI: 0000200000000080 RDI: 00000000ffffff9c
> [   42.217836][ T5684] RBP: 0000200000000040 R08: 00007fff7b8ee2b0 R09: 00007fff7b8ee2b0
> [   42.217839][ T5684] R10: 00000000000001ff R11: 0000000000000246 R12: 0000200000000100
> [   42.217842][ T5684] R13: 0000200000000040 R14: 0000000000000002 R15: 00000000004b10a0
> [   42.217846][ T5684]  </TASK>
> 

ocfs2_validate_dx_root() returns -EROFS
ocfs2_read_blocks() goto read_failure → put_bh, bhs[0]=NULL, return -EROFS
ocfs2_read_block() returns -EROFS
ocfs2_read_dx_root() returns -EROFS
ocfs2_find_entry_dx() goto out, returns -EROFS

On a second read of the same block, ocfs2_buffer_uptodate(ci, bh)
returns false (block was never added to the ocfs2 metadata cache because
the first read failed), so the block is re-read from disk and
re-validated — failing again.

Am I missing something?

Thanks,
Joseph

