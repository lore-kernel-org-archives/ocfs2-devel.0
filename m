Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BE19DF60;
	Sat, 12 Jul 2025 23:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752362294; cv=none; b=JyVl5UbdLaGXiPhvQx/YhnpTqUog1B192PkMb+nPAkS2PUN8zADzA1h7uPExA2mG9IxAY2/7bBsClNePUMgpBZZFo3nLPbzdcgQPM5/wgL6a/05H/p9NqsjJKy+Y1enOXpjOkKYz4VLAe1hgto/wmQ5oqnkvUF0zMiUFVLmPfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752362294; c=relaxed/simple;
	bh=r1SaOoZt7FzQ6Gt3JS5iJQ6793PbUaiJfuBYkJxxFwA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=q4+wR4F2EJOB86Ib7qqrwFH5kfRzc8dmWjoKuMA3jDgN6pkXDbTlubetvucdA7BDJLH7ocd7qG672yub+mEfj3cAigM0uGHy4x8eEL7hYZ4IJJHJvzXOnUtFhDTJskFl/GsCw3M3bggblPjTAsu5kXh9ibfjOvEmHTV4GzZGjAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LTgbB66i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LTgbB66i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2A0C4CEEF;
	Sat, 12 Jul 2025 23:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752362293;
	bh=r1SaOoZt7FzQ6Gt3JS5iJQ6793PbUaiJfuBYkJxxFwA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LTgbB66iEBsXt7LbwFWnZ5SrXdHATRRE/wAIRhpWOc7hY4A6j/AAzkXGD/iY7PeE2
	 DpZafWDJXTdOoZYOesNQG7sbzBz0CPDtv/I7xpjDCyfIkSrVpVfaxM2DQz5JF+aGkE
	 0LH2vBVN4c5j+MjOHGJXBHxqmYN3p8auqirYfd3s=
Date: Sat, 12 Jul 2025 16:18:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?55m954OB5YaJ?= <baishuoran@hrbeu.edu.cn>
Cc: "Kun Hu" <huk23@m.fudan.edu.cn>, "Jiaji Qin" <jjtan24@m.fudan.edu.cn>,
 syzkaller@googlegroups.com, linux-kernel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
Subject: Re: BUG: unable to handle kernel paging request in
 const_folio_flags
Message-Id: <20250712161813.44b62c947535cb78a3a4c9be@linux-foundation.org>
In-Reply-To: <45a4da17.13ec7.197f8ec50fb.Coremail.baishuoran@hrbeu.edu.cn>
References: <45a4da17.13ec7.197f8ec50fb.Coremail.baishuoran@hrbeu.edu.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

(cc ocfs2-devel)

On Fri, 11 Jul 2025 17:58:46 +0800 (GMT+08:00) 白烁冉 <baishuoran@hrbeu.edu.cn> wrote:

> Dear Maintainers,
> 
> 
> When using our customized Syzkaller to fuzz the latest Linux kernel, the following crash (121th)was triggered.
> 
> 
> 
> 
> HEAD commit: 6537cfb395f352782918d8ee7b7f10ba2cc3cbf2
> git tree: upstream
> Output: https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG%3A%20unable%20to%20handle%20kernel%20paging%20request%20in%20const_folio_flags/121report.txt
> Kernel config:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/config.txt
> C reproducer:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG%3A%20unable%20to%20handle%20kernel%20paging%20request%20in%20const_folio_flags/121repro.c
> Syzlang reproducer:https://github.com/pghk13/Kernel-Bug/blob/main/0702_6.14/BUG%3A%20unable%20to%20handle%20kernel%20paging%20request%20in%20const_folio_flags/121repro.txt
> 
> Our reproducer uses mounts a constructed filesystem image.
>  
>  This may be an error code mistakenly used as a pointer bug, occurring around line 308 of the code: 1. OCFS2 error handling issue: ocfs2_write_begin_nolock returns -ENOMEM (-12) when it encounters a memory allocation failure. 2. Incorrect error handling: In the error handling path, a certain function (most likely ocfs2_unlock_and_free_folios) incorrectly passed the error code -12 as a valid folio pointer to folio_unlock.
> 
> We have reproduced this issue several times on 6.14 again.
> 
> 
> 
> 
> 
> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>, Shuoran Bai <baishuoran@hrbeu.edu.cn>
> 
> (syz.5.1560,31124,2):ocfs2_write_begin_nolock:1798 ERROR: status = -12
> BUG: unable to handle page fault for address: fffffffffffffffc
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD df84067 P4D df84067 PUD df86067 
> PMD 0 
> Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 2 UID: 0 PID: 31124 Comm: syz.5.1560 Not tainted 6.14.0 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:const_folio_flags.constprop.0+0x27/0x70
> Code: 90 90 90 41 54 49 89 fc 53 e8 65 c3 ca ff 49 8d 7c 24 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 3e <49> 8b 5c 24 08 31 ff 83 e3 01 48 89 de e8 77 c5 ca ff 48 85 db 75
> RSP: 0018:ffffc90011eef678 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff888079f54030 RCX: ffffffff839c06f7
> RDX: 1fffffffffffffff RSI: ffff888059b2a480 RDI: fffffffffffffffc
> RBP: fffffffffffffff4 R08: 0000000000000000 R09: fffffbfff20c2fa3
> R10: fffffbfff20c2fa2 R11: ffffffff90617d17 R12: fffffffffffffff4
> R13: 000000000000000e R14: dffffc0000000000 R15: 0000000000000001
> FS:  00007f2d805f6700(0000) GS:ffff88802b900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 000000004039e000 CR4: 0000000000750ef0
> PKRU: 80000000
> Call Trace:
>  <TASK>
>  folio_unlock+0x16/0xd0
>  ocfs2_unlock_and_free_folios+0x8c/0x1b0
>  ocfs2_write_begin_nolock+0x115d/0x4f60
>  ocfs2_write_begin+0x1d9/0x350
>  generic_perform_write+0x3e0/0x8c0
>  __generic_file_write_iter+0x1f6/0x240
>  ocfs2_file_write_iter+0xc44/0x2380
>  vfs_write+0xba2/0x1100
>  ksys_write+0x122/0x240
>  do_syscall_64+0xcf/0x250
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2d827acadd
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2d805f5ba8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f2d829a5fa0 RCX: 00007f2d827acadd
> RDX: 000000000000045c RSI: 0000000020000400 RDI: 0000000000000005
> RBP: 00007f2d805f5c00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
> R13: 00007f2d829a5fac R14: 00007f2d829a6038 R15: 00007f2d805f5d40
>  </TASK>
> Modules linked in:
> CR2: fffffffffffffffc
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:const_folio_flags.constprop.0+0x27/0x70
> Code: 90 90 90 41 54 49 89 fc 53 e8 65 c3 ca ff 49 8d 7c 24 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 3e <49> 8b 5c 24 08 31 ff 83 e3 01 48 89 de e8 77 c5 ca ff 48 85 db 75
> RSP: 0018:ffffc90011eef678 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffff888079f54030 RCX: ffffffff839c06f7
> RDX: 1fffffffffffffff RSI: ffff888059b2a480 RDI: fffffffffffffffc
> RBP: fffffffffffffff4 R08: 0000000000000000 R09: fffffbfff20c2fa3
> R10: fffffbfff20c2fa2 R11: ffffffff90617d17 R12: fffffffffffffff4
> R13: 000000000000000e R14: dffffc0000000000 R15: 0000000000000001
> FS:  00007f2d805f6700(0000) GS:ffff88802b900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 000000004039e000 CR4: 0000000000750ef0
> PKRU: 80000000
> ----------------
> Code disassembly (best guess):
>    0: 90                    nop
>    1: 90                    nop
>    2: 90                    nop
>    3: 41 54                push   %r12
>    5: 49 89 fc              mov    %rdi,%r12
>    8: 53                    push   %rbx
>    9: e8 65 c3 ca ff        callq  0xffcac373
>    e: 49 8d 7c 24 08        lea    0x8(%r12),%rdi
>   13: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
>   1a: fc ff df
>   1d: 48 89 fa              mov    %rdi,%rdx
>   20: 48 c1 ea 03          shr    $0x3,%rdx
>   24: 80 3c 02 00          cmpb   $0x0,(%rdx,%rax,1)
>   28: 75 3e                jne    0x68
> * 2a: 49 8b 5c 24 08        mov    0x8(%r12),%rbx <-- trapping instruction
>   2f: 31 ff                xor    %edi,%edi
>   31: 83 e3 01              and    $0x1,%ebx
>   34: 48 89 de              mov    %rbx,%rsi
>   37: e8 77 c5 ca ff        callq  0xffcac5b3
>   3c: 48 85 db              test   %rbx,%rbx
>   3f: 75                    .byte 0x75
> 
> 
> 
> thanks,
> Kun Hu
