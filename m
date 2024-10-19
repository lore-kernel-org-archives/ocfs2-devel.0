Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA41CC8B0
	for <ocfs2-devel@lists.linux.dev>; Sat, 19 Oct 2024 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729318655; cv=none; b=tmSDMmVxGDqv/ZdLnVBLtEt1DsN2sHjr2pVQwLj/eVlfFOzdq7q4TE1MJW2+Yw3V4pWEWZJ8mXG3Mv8lP8XKKdGRJysEMaFLKJklhTleeeqIW5mptRyTFqjKAzcW4JhyPONGeoxzwlDGCnluTTTqL5o01N2U8b6KvTJwBZMxVCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729318655; c=relaxed/simple;
	bh=pCb6Vf0xt/nErwNGbj/HtBBpyAUfs/WvsUmXEMBiMbY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=liS51tkp1QjlCiYlHJ+UfCTXgHHHgXSS3DWFJYPfGJiuJHCOfoDcZDK/dI4GWcwLpaojDUVj0O4RXSO1WKEksf2Ynw8WI8RVkGwMxmT5kvmm39MU1bNHRdfeuHC+szWYzg5Wz9NO0DutKB11ejzksJaUWBW1cuy3DIbGPQqOD9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3ae775193so31235985ab.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 18 Oct 2024 23:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729318652; x=1729923452;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3dHI7vFuVTi22tig/S/B1drGrwXthGedqNaCXEPDuQ=;
        b=EqvcEZolOT5aF8kZrRMwsrNO/IdbgYl4oqWLrp69RNzn8Xe+SPFIIoBV7Mu6ZKJg7X
         WWBcCY/qgG8em28TmScrMKetwB5beLSzoHC5Affp4cyXlHG6Y6Uq+PhbHeii7q5piLnK
         30BHRu+XhZbnX5t/e5F/PKpO5ZO6re8pSy6SI+0nQxbgWYqOBq4oJ/5sgAFfMbHmOUbu
         r7L+z87RIbPqaXRALeHmSnP/DRFDdYAI3NDNRbEbI7sqxKziAj4UKn08TPHJavWozNyo
         PTo5SQtIZAALDkqFkG7YE1Ef7eqnsxCnt+oQxthnbPaWnGZER3xjZy0G9VnDQUzNwfYM
         3tIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpR1dEWW1ygPB1TYT21rk2Dh/TQ2HdRmYu/X9D7dCzTbbt0Q0bbRl+YkLnlHI7P/Y33vIgTrBc2Lji5g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwKg2VxZhUKHgY5ZSjCJaLzlIKJeML23fJmWTMajNJsAwA0CAET
	e4IeBI59hdx+CiajV7NR77JoJHKsoU5HZJvxct27zv1XRC+WVhDgA6oPwJXP3vHVX0uneTrQDyS
	S2qI7DC9gSxrmR2RdzIzEQXcZ8QZ+DKo4Ece9SQ7v3nxni0aTriHwF5Q=
X-Google-Smtp-Source: AGHT+IHUO5IjMFwmA29Lc8PTwRi3+682lG25ej9Z6Atr2VkxhXWKp8q4vEKDXTnk5TpmQAxdYCHIyzvcSt9+uoOrqYB8TeFQSpAc
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:190d:0:b0:3a0:915d:a4a7 with SMTP id
 e9e14a558f8ab-3a3f4050120mr38985245ab.2.1729318652494; Fri, 18 Oct 2024
 23:17:32 -0700 (PDT)
Date: Fri, 18 Oct 2024 23:17:32 -0700
In-Reply-To: <66e9830e.050a0220.115905.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67134efc.050a0220.34b26a.0002.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] INFO: trying to register non-static key in ocfs2_dlm_shutdown
From: syzbot <syzbot+d7935821694d430624ea@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b04ae0f45168 Merge tag 'v6.12-rc3-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179fb487980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11635240580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10227c5f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b04ae0f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e40a4ec7885/vmlinux-b04ae0f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9312d8ec05d3/bzImage-b04ae0f4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f8241812bcfe/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7935821694d430624ea@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
ocfs2: Readonly device (7,0) detected. Cluster services will not be used for this mount. Recovery will be skipped.
ocfs2: Mounting device (7,0) on (node local, slot 65535) with ordered data mode.
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5091 Comm: syz-executor302 Not tainted 6.12.0-rc3-syzkaller-00319-gb04ae0f45168 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 assign_lock_key+0x241/0x280 kernel/locking/lockdep.c:981
 register_lock_class+0x1cf/0x980 kernel/locking/lockdep.c:1295
 __lock_acquire+0xf0/0x2050 kernel/locking/lockdep.c:5077
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
 ocfs2_mark_lockres_freeing+0x15e/0x690 fs/ocfs2/dlmglue.c:3513
 ocfs2_simple_drop_lockres fs/ocfs2/dlmglue.c:3569 [inline]
 ocfs2_drop_osb_locks fs/ocfs2/dlmglue.c:3577 [inline]
 ocfs2_dlm_shutdown+0x3a/0x240 fs/ocfs2/dlmglue.c:3387
 ocfs2_dismount_volume+0x487/0x8f0 fs/ocfs2/super.c:1918
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3bc9aeed89
Code: Unable to access opcode bytes at 0x7f3bc9aeed5f.
RSP: 002b:00007fffe69f4fd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f3bc9aeed89
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007f3bc9b6f390 R08: ffffffffffffffb8 R09: 0000000000004469
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3bc9b6f390
R13: 0000000000000000 R14: 00007f3bc9b70100 R15: 00007f3bc9abd060
 </TASK>
ocfs2: Unmounting device (7,0) on (node local)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5091 Comm: syz-executor302 Not tainted 6.12.0-rc3-syzkaller-00319-gb04ae0f45168 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 bf 77 71 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 9e 77 71 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000af67180 EFLAGS: 00010202
RAX: 0000000000000001 RBX: fffff520015ece44 RCX: ffff888000bfc880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000af678d0 R08: ffffffff838d258e R09: 1ffff11008c13616
R10: dffffc0000000000 R11: ffffed1008c13617 R12: 0000000000000008
R13: 1ffff11008c13644 R14: dffffc0000000000 R15: ffff88804609b338
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3bc9b39378 CR3: 0000000011c58000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 evict+0x4e8/0x9b0 fs/inode.c:725
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:307 [inline]
 ocfs2_free_slot_info+0x94/0x270 fs/ocfs2/slot_map.c:443
 ocfs2_delete_osb+0x58/0x180 fs/ocfs2/super.c:2497
 ocfs2_dismount_volume+0x594/0x8f0 fs/ocfs2/super.c:1936
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3bc9aeed89
Code: Unable to access opcode bytes at 0x7f3bc9aeed5f.
RSP: 002b:00007fffe69f4fd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f3bc9aeed89
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007f3bc9b6f390 R08: ffffffffffffffb8 R09: 0000000000004469
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3bc9b6f390
R13: 0000000000000000 R14: 00007f3bc9b70100 R15: 00007f3bc9abd060
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 bf 77 71 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 9e 77 71 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000af67180 EFLAGS: 00010202
RAX: 0000000000000001 RBX: fffff520015ece44 RCX: ffff888000bfc880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000af678d0 R08: ffffffff838d258e R09: 1ffff11008c13616
R10: dffffc0000000000 R11: ffffed1008c13617 R12: 0000000000000008
R13: 1ffff11008c13644 R14: dffffc0000000000 R15: ffff88804609b338
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3bc9b39378 CR3: 0000000011c58000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	4c 89 e0             	mov    %r12,%rax
   5:	48 c1 e8 03          	shr    $0x3,%rax
   9:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
   e:	74 08                	je     0x18
  10:	4c 89 e7             	mov    %r12,%rdi
  13:	e8 bf 77 71 fe       	call   0xfe7177d7
  18:	4c 01 f3             	add    %r14,%rbx
  1b:	4d 8b 24 24          	mov    (%r12),%r12
  1f:	49 83 c4 08          	add    $0x8,%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 9e 77 71 fe       	call   0xfe7177d7
  39:	49 8b 3c 24          	mov    (%r12),%rdi
  3d:	49                   	rex.WB
  3e:	81                   	.byte 0x81
  3f:	c7                   	.byte 0xc7


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
