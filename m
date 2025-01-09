Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AB3216E16
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 11:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736423415; cv=none; b=lKg6SNVj6Nv1s7liUjEd3bEV7634okGJ5VFxqvXfkAFvTBv6IEc7aB8KhrNMVmZEMEjshPaYDq7go28rxNHJipis8p41Vfy0WDx+QW87sD6eC12kB5UQNvWVat9jNqMQNk5FdATwK70wzEE4ZzNIQHbJ6ZSq4vFUHnzY/hagUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736423415; c=relaxed/simple;
	bh=6jBsN7Trv2AJ8qt68mqTjvp/AI522+N3/C7OYSjKBcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUEp/jT3AowCgeIMUwhPDaql/fmjnnzTqKJr9Oz0lNTSNijAqkFVJZ9xnv/qSD/n2YIkx4ePmvGp+qT5jEjS/nliUa2Xp3zqswJDX0akIyZyCOvfCR567/yg4t3GAtwZCEtBNB8dXWYrY94WMnLFYSBFZx5heW8ux0bUyuBKmjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y96QbKj1; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y96QbKj1"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa6965ad2a5so14451466b.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Jan 2025 03:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736423411; x=1737028211; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Rqnegvj0VV7lIAhF9OjclFeRRDewIZzLraaLZ7Zi/E=;
        b=Y96QbKj1zFzB2TOmq3IL3XQmN4d6Q4wAcTm035sET2YYB4NJpo/NOqAUp2rqUGnGng
         mI9sYWY8a523PuuEU6roIQPjpgYoZNM7GF4+jc3G3SsY0oJM6OTew2fncljHXxR7BG4Z
         OKJQ/r1gXusW2kIJf6+kk6BkP/uLvo7lddZlT1l54V35bjo+QK0b9N+io9Fct7KMaGiB
         YrddB2ouIS6iXzxRCSPRpbrRic1nQoLRqkdF8XX7QiMYBgQ7V2SvLv76usv7S5xeq+3b
         DLUgt/GyXamQ1W0aKRzWnJm93GtCp6DbhjHC7seZ+5qQy43DjZtRy4P7/i93oBZH4kCJ
         iA4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736423411; x=1737028211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Rqnegvj0VV7lIAhF9OjclFeRRDewIZzLraaLZ7Zi/E=;
        b=WXy51UtzMouLrXVdlo1+kAlH5WTwwLvxwemihecOwLyLQebvZ9WD7Ig9gZCMunVn0L
         rCbaB6Bh2xQIT1qkFM8eXPSs9WOpn5SXoZfmnjImZEr0VwhEhF6ofp+xci3JQxjm+vDX
         vckwwF7NTzR7glkBEziWACxs2GuPfuEBrZRYkoGaIM7P9TN0GZKoiuLzM+bOqZj3vgVl
         XImWc0oUDC03spjR7iJjx5LPj3qQiPIF3b9npeVFLiwULKyJO9xD+TmVk1pU/Gy1V2P6
         st69wNQZqJtcNO1RsRT+mUAw1MkpHGENu5vSs5MIZll80solehdz/L9+8I7O+7565oHy
         t3BA==
X-Forwarded-Encrypted: i=1; AJvYcCWLODgG9HYdaKm89INIqm6Dep7MSQmzDXO2Hybcx6EoUSjxDuoYeJbnZv6Vdzr+xAVgnSC9s5rOveBMAw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzXdwoJc48ULeYeBLwz2a5CIL15JSBL8Yp67ih/gZzlD2hy5eO
	oSfxNzx+E50N33hjKg4mA5JmM+7Jr5cWTKtqIHY/6mxAWsXlSQ0sPU2vBT+Lz8o=
X-Gm-Gg: ASbGncsht90as9JcDmcO4djfR+HtCJWtJOmc9JEAErOlrJjQVA+ng0WsjIrkC+THCbb
	ldINgP94MhiRMfM40v5WDPNS7EGePBMOW4Rvm8Km5kEvpCf3aLchogruuo1JJjgqiKS2nL3VZXS
	RNLIb5mBfu+fcFDl+Uq5Wj3GIfmg1D8PkYAuefmGQl1EarH7IHmzC1vnRdzbA9kP/IE8FPFiLOx
	3hZ52rf9QU5u0+E12WS+pAJHLtfRQGhUIjntw8835oNdTqFdtLtzA1av864
X-Google-Smtp-Source: AGHT+IFN/D6o/mLnzBDHoC74lnwY90vcLfbHZP3wxvPYd53LnZ+NcD6W8z0LeflQ6uaZWrCkEvhScA==
X-Received: by 2002:a17:907:c244:b0:aae:d199:6eaf with SMTP id a640c23a62f3a-ab2ab6a8db1mr207120066b.1.1736423411533;
        Thu, 09 Jan 2025 03:50:11 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f5035sm343930185ad.180.2025.01.09.03.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 03:50:11 -0800 (PST)
Message-ID: <b6fc362d-cf7f-4cd1-bc10-60748eed620b@suse.com>
Date: Thu, 9 Jan 2025 19:50:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: check dir i_size in ocfs2_find_entry
To: Su Yue <glass.su@suse.com>, joseph.qi@linux.alibaba.com
Cc: Jiacheng Xu <stitch@zju.edu.cn>, ocfs2-devel@lists.linux.dev,
 syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
References: <20250106140640.92260-1-glass.su@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20250106140640.92260-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 22:06, Su Yue wrote:
> syz reports an out of bounds read:
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ocfs2_match fs/ocfs2/dir.c:334
> [inline]
> BUG: KASAN: slab-out-of-bounds in ocfs2_search_dirblock+0x283/0x6e0
> fs/ocfs2/dir.c:367
> Read of size 1 at addr ffff88804d8b9982 by task syz-executor.2/14802
> 
> CPU: 0 UID: 0 PID: 14802 Comm: syz-executor.2 Not tainted 6.13.0-rc4 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
> Sched_ext: serialise (enabled+all), task: runnable_at=-10ms
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x229/0x350 lib/dump_stack.c:120
> print_address_description mm/kasan/report.c:378 [inline]
> print_report+0x164/0x530 mm/kasan/report.c:489
> kasan_report+0x147/0x180 mm/kasan/report.c:602
> ocfs2_match fs/ocfs2/dir.c:334 [inline]
> ocfs2_search_dirblock+0x283/0x6e0 fs/ocfs2/dir.c:367
> ocfs2_find_entry_id fs/ocfs2/dir.c:414 [inline]
> ocfs2_find_entry+0x1143/0x2db0 fs/ocfs2/dir.c:1078
> ocfs2_find_files_on_disk+0x18e/0x530 fs/ocfs2/dir.c:1981
> ocfs2_lookup_ino_from_name+0xb6/0x110 fs/ocfs2/dir.c:2003
> ocfs2_lookup+0x30a/0xd40 fs/ocfs2/namei.c:122
> lookup_open fs/namei.c:3627 [inline]
> open_last_lookups fs/namei.c:3748 [inline]
> path_openat+0x145a/0x3870 fs/namei.c:3984
> do_filp_open+0xe9/0x1c0 fs/namei.c:4014
> do_sys_openat2+0x135/0x1d0 fs/open.c:1402
> do_sys_open fs/open.c:1417 [inline]
> __do_sys_openat fs/open.c:1433 [inline]
> __se_sys_openat fs/open.c:1428 [inline]
> __x64_sys_openat+0x15d/0x1c0 fs/open.c:1428
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf6/0x210 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f01076903ad
> Code: c3 e8 a7 2b 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f01084acfc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f01077cbf80 RCX: 00007f01076903ad
> RDX: 0000000000105042 RSI: 0000000020000080 RDI: ffffffffffffff9c
> RBP: 00007f01077cbf80 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f01077cbf80 R14: 00007f010764fc90 R15: 00007f010848d000
> </TASK>
> ==================================================================
> 
> And a general protection fault in ocfs2_prepare_dir_for_insert:
> 
> ==================================================================
> loop0: detected capacity change from 0 to 32768
> JBD2: Ignoring recovery information on journal
> ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data
> mode.
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 5096 Comm: syz-executor792 Not tainted
> 6.11.0-rc4-syzkaller-00002-gb0da640826ba #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ocfs2_find_dir_space_id fs/ocfs2/dir.c:3406 [inline]
> RIP: 0010:ocfs2_prepare_dir_for_insert+0x3309/0x5c70 fs/ocfs2/dir.c:4280
> Code: 00 00 e8 2a 25 13 fe e9 ba 06 00 00 e8 20 25 13 fe e9 4f 01 00 00
> e8 16 25 13 fe 49 8d 7f 08 49 8d 5f 09 48 89 f8 48 c1 e8 03 <42> 0f b6
> 04 20 84 c0 0f 85 bd 23 00 00 48 89 d8 48 c1 e8 03 42 0f
> RSP: 0018:ffffc9000af9f020 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000009 RCX: ffff88801e27a440
> RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000008
> RBP: ffffc9000af9f830 R08: ffffffff8380395b R09: ffffffff838090a7
> R10: 0000000000000002 R11: ffff88801e27a440 R12: dffffc0000000000
> R13: ffff88803c660878 R14: f700000000000088 R15: 0000000000000000
> FS:  000055555a677380(0000) GS:ffff888020800000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000560bce569178 CR3: 000000001de5a000 CR4: 0000000000350ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
> vfs_mknod+0x36d/0x3b0 fs/namei.c:4088
> do_mknodat+0x3ec/0x5b0
> __do_sys_mknodat fs/namei.c:4166 [inline]
> __se_sys_mknodat fs/namei.c:4163 [inline]
> __x64_sys_mknodat+0xa7/0xc0 fs/namei.c:4163
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2dafda3a99
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89
> f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08
> 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8
> 64 89 01 48
> RSP: 002b:00007ffe336a6658 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000103
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> 00007f2dafda3a99
> RDX: 00000000000021c0 RSI: 0000000020000040 RDI:
> 00000000ffffff9c
> RBP: 00007f2dafe1b5f0 R08: 0000000000004480 R09:
> 000055555a6784c0
> R10: 0000000000000103 R11: 0000000000000246 R12:
> 00007ffe336a6680
> R13: 00007ffe336a68a8 R14: 431bde82d7b634db R15:
> 00007f2dafdec03b
> </TASK>
> ==================================================================
> 
> The two reports are all caused invalid negative i_size of dir inode.
> For ocfs2, dir_inode can't be negative or zero.
> 
> Here add a check in which is called by ocfs2_check_dir_for_entry().
> It fixes the second report as ocfs2_check_dir_for_entry() must
> be called before ocfs2_prepare_dir_for_insert().
> Also set a up limit for dir with OCFS2_INLINE_DATA_FL. The i_size
> can't be great than blocksize.
> 
> Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
> Link: https://lore.kernel.org/ocfs2-devel/17a04f01.1ae74.19436d003fc.Coremail.stitch@zju.edu.cn/T/#u
> Reported-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/0000000000005894f3062018caf1@google.com/T/
> Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>   fs/ocfs2/dir.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)

Reviewed-by: Heming Zhao <heming.zhao@suse.com>

ps: leave the 'Fixes:' tag to Joseph. For my side, I prefer to remove it.

- Heming
