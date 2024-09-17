Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B6F4C66
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Sep 2024 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726579474; cv=none; b=RnJSBJDEhPRtwdw94sp11KOIKV2c7QBSGM9z+Wzo1TVVgbuBWoQH7mVh1jaDi2kle5z5VN85phlxlBkObn5G6OOylSiF07pndmXLcWDUHzpDd1Fh7HIraFeXhEycrDanO++q3QmNNTv/C9S4Q5QQxZzcAQwpfGMogtin14al6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726579474; c=relaxed/simple;
	bh=EBzTUG5OWhBLXbcnlkL2ykN2YhIZagERGwbVbL8JXYc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=h5pdShfuYIXeTllvdvZ0MilZpOnoqzSCY6XPvp6n64/wRVW/oSAdN+uF2Df4PcN6a0O3r4nNC+lt8R1d6J9/yav56fh04jjyT1moLd4bkPqc1BpgmE7PrRzCc5hAA1xATRuLl24e3LjIsTjNibnER7/oIs/2MA0T7TzQ6PGfYO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a08f88aeceso55271265ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Sep 2024 06:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726579470; x=1727184270;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DlBQ+f3ydEruwd0b8+A66aD2kQMS5RvxA8pHIQi31R4=;
        b=e/KcK4jD5e4gyQtup4HjKM+ZZllGiVFCXjtQrrB4cVJKCtvvdqc4ZueFqsOSF5kZeH
         wdH/6ebUDbQwW9jY/8WsbhcMVajrwBEdVuexb/gVa8LhKvsc9SgTpIY3ERbx/NNajPHD
         qknUbW9lQXR2lthonCZoR9kieChgBTW6xpIb21LBm0Ihr81v9TFkqdiUBXap0Lt+99Tf
         0XPBdCzhpSIVTukaH6gMXUq1XXKeMn2x9Zb8+uf8kq5llciG1lOKmIghFgHeKkm98VQ5
         dUSTjCuc47CVtgsUzDJkDcZplUKCXdyQ+6kovy9n5RA2Rn1lC2uyTRzjZU+L8atZi8hz
         ngsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW697+b/GphEf6gTyzYZxg1mWw+aJ//89UsTri6xF4H/6+/b79c0MEm7H7H79Ai287aGRQEMfHFvAOerQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh9AuQe1+vfaRGNyVhXkLGuJ8huhodWMrihfqG/oYFjHGjL1R6
	LAwzXhjP5v3IMGdhhAvitW8KkTv4dgY/VDUPjMMvk6w3i/R5tdNdmldO3LSLtHLfpu3FJtYU7L7
	y/8yL+4NUt4pgL9PPfpdl6Y77UTWjLAzp6UApnxX6QrDsiJuPkirkdzo=
X-Google-Smtp-Source: AGHT+IGUY3Fxyo6duWWPlDx1pQ9OUwr912CSHssG3vDxXEM/I/ZBAcjl6NvkUvA9DKOvQTayDaXaJnmFxgiwYHW21D4kHyRlSOg0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0c:b0:3a0:9043:59b8 with SMTP id
 e9e14a558f8ab-3a09043628emr119788345ab.12.1726579470384; Tue, 17 Sep 2024
 06:24:30 -0700 (PDT)
Date: Tue, 17 Sep 2024 06:24:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66e9830e.050a0220.115905.000e.GAE@google.com>
Subject: [syzbot] [ocfs2?] INFO: trying to register non-static key in ocfs2_dlm_shutdown
From: syzbot <syzbot+d7935821694d430624ea@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a430d95c5efa Merge tag 'lsm-pr-20240911' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a8dfc7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1653f803fffa3848
dashboard link: https://syzkaller.appspot.com/bug?extid=d7935821694d430624ea
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3504d54974f/disk-a430d95c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c6ac1db8c146/vmlinux-a430d95c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/938026534cb3/bzImage-a430d95c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7935821694d430624ea@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 7384 Comm: syz-executor Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 assign_lock_key+0x238/0x270 kernel/locking/lockdep.c:975
 register_lock_class+0x1cf/0x980 kernel/locking/lockdep.c:1288
 __lock_acquire+0xf0/0x2040 kernel/locking/lockdep.c:5019
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
 ocfs2_mark_lockres_freeing+0x15e/0x690 fs/ocfs2/dlmglue.c:3516
 ocfs2_simple_drop_lockres fs/ocfs2/dlmglue.c:3572 [inline]
 ocfs2_drop_osb_locks fs/ocfs2/dlmglue.c:3580 [inline]
 ocfs2_dlm_shutdown+0x3a/0x240 fs/ocfs2/dlmglue.c:3390
 ocfs2_dismount_volume+0x487/0x8f0 fs/ocfs2/super.c:1920
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff0e037f227
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fff70c741b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007ff0e037f227
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fff70c74270
RBP: 00007fff70c74270 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fff70c752f0
R13: 00007ff0e03f0a14 R14: 0000000000061ea2 R15: 00007fff70c75330
 </TASK>
ocfs2: Unmounting device (7,4) on (node local)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 7384 Comm: syz-executor Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 cf 3f 73 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 ae 3f 73 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000cd37320 EFLAGS: 00010212
RAX: 0000000000000001 RBX: fffff520019a6e78 RCX: ffff88802ef63c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000cd37a70 R08: ffffffff8387ab2e R09: 1ffff1100cabf0be
R10: dffffc0000000000 R11: ffffed100cabf0bf R12: 0000000000000008
R13: 1ffff1100cabf0ec R14: dffffc0000000000 R15: ffff8880655f8878
FS:  000055558db0c500(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4628955f98 CR3: 0000000069526000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 evict+0x4ea/0x9b0 fs/inode.c:731
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:307 [inline]
 ocfs2_free_slot_info+0x94/0x270 fs/ocfs2/slot_map.c:443
 ocfs2_delete_osb+0x58/0x180 fs/ocfs2/super.c:2499
 ocfs2_dismount_volume+0x594/0x8f0 fs/ocfs2/super.c:1938
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1696
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff0e037f227
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fff70c741b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007ff0e037f227
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fff70c74270
RBP: 00007fff70c74270 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fff70c752f0
R13: 00007ff0e03f0a14 R14: 0000000000061ea2 R15: 00007fff70c75330
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1208 [inline]
RIP: 0010:ocfs2_evict_inode+0xdd3/0x4680 fs/ocfs2/inode.c:1220
Code: 00 00 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 cf 3f 73 fe 4c 01 f3 4d 8b 24 24 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 ae 3f 73 fe 49 8b 3c 24 49 81 c7
RSP: 0018:ffffc9000cd37320 EFLAGS: 00010212
RAX: 0000000000000001 RBX: fffff520019a6e78 RCX: ffff88802ef63c00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000cd37a70 R08: ffffffff8387ab2e R09: 1ffff1100cabf0be
R10: dffffc0000000000 R11: ffffed100cabf0bf R12: 0000000000000008
R13: 1ffff1100cabf0ec R14: dffffc0000000000 R15: ffff8880655f8878
FS:  000055558db0c500(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4cb1707ab8 CR3: 0000000069526000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	4c 89 e0             	mov    %r12,%rax
   5:	48 c1 e8 03          	shr    $0x3,%rax
   9:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
   e:	74 08                	je     0x18
  10:	4c 89 e7             	mov    %r12,%rdi
  13:	e8 cf 3f 73 fe       	call   0xfe733fe7
  18:	4c 01 f3             	add    %r14,%rbx
  1b:	4d 8b 24 24          	mov    (%r12),%r12
  1f:	49 83 c4 08          	add    $0x8,%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 e7             	mov    %r12,%rdi
  34:	e8 ae 3f 73 fe       	call   0xfe733fe7
  39:	49 8b 3c 24          	mov    (%r12),%rdi
  3d:	49                   	rex.WB
  3e:	81                   	.byte 0x81
  3f:	c7                   	.byte 0xc7


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
