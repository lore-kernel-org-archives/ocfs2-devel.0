Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850121F418F
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Aug 2025 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756174772; cv=none; b=Wif1gIVL4Lb8H3CSYw2NVWxpqS5H0/qp8X90YEcagwgDW2bhdzcaU/cLLqkzY8DTTlN0C0Qmc9CobYsjWUIJ92ILN7Bxzpcr71sObCtORjPYUHddNM6PViUyUWVC5lIgj37wYet0vdvCG1nJHS8nU5tb5ixzp+TjObB1I49LPc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756174772; c=relaxed/simple;
	bh=QqdY/sXwtEhBkXQFQQ4E9mro11jCCLH5qzzELsQ/YDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijsXyxSWQFBf/GO88HB/ox6C00IwTmrHVPikOfQX3PVQVg9HJ3mjXNtIZe6GFoIKM3G+D5BkTV5NhLyT7u98AtCpsaN9JLf9g9NQoaYFvDALxtucrcMzIfpex8o151hnf9q+LWV+4ha/LSMBG0JLuoZHotnyFKlv0wvYJv6Ii5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SYKVdM8Y; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SYKVdM8Y"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c77e37b52dso237763f8f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 19:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756174768; x=1756779568; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eg75ZtFsDUzoquLaw8n8nOPLjq5bu+HPjgxDljQ8+wc=;
        b=SYKVdM8YmcbV5mnh2kFue7HVtk0R5U6lurkHmE5rGQpsg7QkbtO5X/txorP+YzCSAx
         CbDTi69bHIH65Gclf/u/mU66qJvI9aBpFmtlqYhl4WWai8a6gCru++9pnOI31ps+xW6f
         wBZof+ddHt4CeigPvaNIKTKP5N4SmgUGZ+v4Bppl1EoxuxP0jWhfO35G0xTrkiTwohnt
         ZTCis6mjnmgGDWLq3EmFiEOnflNiKpTOvr5Fg45j5bwk9dAtJxX20cRNyiFChkQJLpRs
         Od2V/ZuOUeS5zRcvvJloeU5beOOaa2U/bUvVB/NATOrzQDF6BRF4j5uYBV0/ERkX74iO
         bZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756174768; x=1756779568;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eg75ZtFsDUzoquLaw8n8nOPLjq5bu+HPjgxDljQ8+wc=;
        b=c8eHFLvDikqhEhAkcuaSub7XVagyBqjCCzJNcBnZ8LPO8NXoT8zOvCpIyRa3FkA6DY
         U8cFpA/+RIytZA29fnd6ZxdVv9lfE32wVzaqAIUzxXThA+rGVKPQr8gjN2Ox5E6/oAPu
         dq7Xnjx32PhNs3Z9qWn15lhZNhT/JwKJ7CWA8ebOFI2yqaGDKyCeBYMvJ8XqSk/Zbydb
         gL87YsQLdPKqz5obxn9z8ayXCmQJs4pE/Jg4jWGbIK27/pgwWBKwgexm0QFpvyE/jQzz
         v3MHYjAKY/Wf+id2bw3hgO+DbLyYRTj7l/P3M2HGKrgFcRqNeTYIC1uX0vj8Ve0Ve7sE
         cHCQ==
X-Gm-Message-State: AOJu0Yx7c24tacp2Y+GtzQ7dunLdG9yB42whawmGs1S/M9N5yQQJRBpB
	xMMY2vBS9TKbJrsoFQsttlYpvTq4MeYaUKhd2IVJIK4DXKK2dfU5FDxVF25r3qhzZg8=
X-Gm-Gg: ASbGnctaRCE9gNJTUnt/XQXwaWhhdni61+ydHhD7JwPo2CIuAFABADuBJkqwP4bT1rv
	06MfTl20d4NIofG4ViiHqdrWpTI9YxNCzyEZV0LSyeEb1QRkhSl2YeaB97ttGaE3cwPBHgxvjJT
	+4c85Z4BlukSymxzB/R5YGvgIdxaIVJKL88FkCcyqrhBenzcdOgMFY4ZduG/67wn17YkcSoGkd5
	QDBK/okL1ukZyR+l8ZnPWMidgwbP6C/Pgao03hR2EyptKCK0ajY4U/wnB9PZKfHGjIioYpzZke8
	0/TS+8Dn020stLcrY16Ol7I+9LKLq8KAtP3GsYzALxemIhTjzN2vtmkPJu+ydavuyXGulQc57ts
	Hfn3IbRer0S/u74tx2513nmrQqllWBl5I/kr+jG4=
X-Google-Smtp-Source: AGHT+IHTM/KIESGQMRMI5/C4eJdjduX+Yp7gDoatJKSrMrz3Qqzwr2rlOblmKBea8vkP7coS9hTjTw==
X-Received: by 2002:a05:6000:230a:b0:3ca:ad45:632a with SMTP id ffacd0b85a97d-3caad456584mr1013709f8f.6.1756174767765;
        Mon, 25 Aug 2025 19:19:27 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466877c0aasm81286385ad.15.2025.08.25.19.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 19:19:27 -0700 (PDT)
Message-ID: <6641daab-022b-424f-9b06-068e21e1adb3@suse.com>
Date: Tue, 26 Aug 2025 10:19:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH] ocfs2: fix recursive semaphore deadlock in fiemap call
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 Mark Fasheh <mark@fasheh.com>,
 "syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com"
 <syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20250825145825.3596-1-mark.tinguely@oracle.com>
 <d05b1d06-3b03-45b3-aa5f-97b5e8366c5e@oracle.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <d05b1d06-3b03-45b3-aa5f-97b5e8366c5e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/25/25 23:13, Mark Tinguely wrote:
> 
> syzbot detected a OCFS2 hang due to a recursive semaphore on a
> FS_IOC_FIEMAP of the extent list on a specially crafted mmap file.
> 
> context_switch kernel/sched/core.c:5357 [inline]
>   __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
>   __schedule_loop kernel/sched/core.c:7043 [inline]
>   schedule+0x165/0x360 kernel/sched/core.c:7058
>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7115
>   rwsem_down_write_slowpath+0x872/0xfe0 kernel/locking/rwsem.c:1185
>   __down_write_common kernel/locking/rwsem.c:1317 [inline]
>   __down_write kernel/locking/rwsem.c:1326 [inline]
>   down_write+0x1ab/0x1f0 kernel/locking/rwsem.c:1591
>   ocfs2_page_mkwrite+0x2ff/0xc40 fs/ocfs2/mmap.c:142
>   do_page_mkwrite+0x14d/0x310 mm/memory.c:3361
>   wp_page_shared mm/memory.c:3762 [inline]
>   do_wp_page+0x268d/0x5800 mm/memory.c:3981
>   handle_pte_fault mm/memory.c:6068 [inline]
>   __handle_mm_fault+0x1033/0x5440 mm/memory.c:6195
>   handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
>   do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>   exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
> RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
> RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
> RIP: 0010:_copy_to_user+0x85/0xb0 lib/usercopy.c:26
> Code: e8 00 bc f7 fc 4d 39 fc 72 3d 4d 39 ec 77 38 e8 91 b9 f7 fc 4c 89 f7 89 de e8 47 25 5b fd 0f 01 cb 4c 89 ff 48 89 d9 4c 89 f6 <f3> a4 0f 1f 00 48 89 cb 0f 01 ca 48 89 d8 5b 41 5c 41 5d 41 5e 41
> RSP: 0018:ffffc9000403f950 EFLAGS: 00050256
> RAX: ffffffff84c7f101 RBX: 0000000000000038 RCX: 0000000000000038
> RDX: 0000000000000000 RSI: ffffc9000403f9e0 RDI: 0000200000000060
> RBP: ffffc9000403fa90 R08: ffffc9000403fa17 R09: 1ffff92000807f42
> R10: dffffc0000000000 R11: fffff52000807f43 R12: 0000200000000098
> R13: 00007ffffffff000 R14: ffffc9000403f9e0 R15: 0000200000000060
>   copy_to_user include/linux/uaccess.h:225 [inline]
>   fiemap_fill_next_extent+0x1c0/0x390 fs/ioctl.c:145
>   ocfs2_fiemap+0x888/0xc90 fs/ocfs2/extent_map.c:806
>   ioctl_fiemap fs/ioctl.c:220 [inline]
>   do_vfs_ioctl+0x1173/0x1430 fs/ioctl.c:532
>   __do_sys_ioctl fs/ioctl.c:596 [inline]
>   __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5f13850fd9
> RSP: 002b:00007ffe3b3518b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f5f13850fd9
> RDX: 0000200000000040 RSI: 00000000c020660b RDI: 0000000000000004
> RBP: 6165627472616568 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe3b3518f0
> R13: 00007ffe3b351b18 R14: 431bde82d7b634db R15: 00007f5f1389a03b
> 
> ocfs2_fiemap() takes read lock of the ip_alloc_sem semaphore (since
> v2.6.22-527-g7307de80510a) and calls fiemap_fill_next_extent()
> to read the extent list of this running mmap executable.
> The user supplied buffer to hold the fiemap information page faults
> calling ocfs2_page_mkwrite() which will take a write lock (since
> v2.6.27-38-g00dc417fa3e7) of the same semaphore. This recursive
> semaphore will hold filesystem locks and causes a hang of the
> fileystem.
> 
> The ip_alloc_sem protects the inode extent list and size.
> I read semphore could be use in ocfs2_page_mkwrite() and
> prevent the recursive lock.
> 
> Reported-by: syzbot+541dcc6ee768f77103e7@syzkaller.appspotmail.com
> 
> Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
> ---
>   fs/ocfs2/mmap.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c19..78513109b9b1 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -139,11 +139,11 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
>        * ocfs2_truncate_file() changing i_size as well as any thread
>        * modifying the inode btree.
>        */
> -    down_write(&OCFS2_I(inode)->ip_alloc_sem);
> +    down_read(&OCFS2_I(inode)->ip_alloc_sem);
>        ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
> -    up_write(&OCFS2_I(inode)->ip_alloc_sem);
> +    up_read(&OCFS2_I(inode)->ip_alloc_sem);
>        brelse(di_bh);
>       ocfs2_inode_unlock(inode, 1);

__ocfs2_page_mkwrite() performs a write operation, which should require a write lock.
In my view, there are two ways to fix this:
1. split the big semphore lock for ocfs2_fiemap(), this involves releasing the read lock after ocfs2_get_clusters_nocache(), and re-acquiring it after fiemap_fill_next_extent().
2. use try_down_write in ocfs2_remap_file_range().

Thanks,
Heming

