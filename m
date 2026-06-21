Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39522FDE6
	for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jun 2026 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782055941; cv=none; b=t9FQ36sNC1qVFP+/9AShWhCZvFZkyB5sXPgj5d7QQ3fTBd6RNBp8upzM+emRKNOM+EOLHa4W5xmU3N+eF4yar38BH3gLfjNtjA2r18OZtw2b/Hug83s9/ORapzOci2lLJ+E+H5JWmYxTLPLDS2b3EQw9oircb2m2P7tnvlq8XCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782055941; c=relaxed/simple;
	bh=UWY45fSq+GQahqi6YQi1VT7rJ/jR7kecEQLKHhmiOEg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q5HknDQVMB4i09V1VVeCmIsZHcGyfCQ/iUBN6QH/DB+K5lZsoNuZ0SAH0AEdxeHN6g09XckchgMW4UXamumbAJQnqgtH1bnEiD+X/8ZkozDK60AlITqj6KSy4HWiPqLpcEielek6NykJdYVHwHjDvNU/eqb8YEPJStktbwou52M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-486055c1c6fso4284736b6e.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 21 Jun 2026 08:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782055939; x=1782660739;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pni00JRPpnnkI4q8FqMuJeiuH3tdOqeWbb8g2jz9l8E=;
        b=i/+i5m4dBHUU06M2Pd1luh4GN/bNfEEguyXuIvWHIVR4NBtugIvQxL8pQLnuoegqxm
         ZtILTJnKN6edEg1vHsUseesF4fSpM6pTJ86CfBdgOYVXgtZPHGeKIIAcSXGjPlEXjrWf
         RCHI9nOFkAcmzznu6iLrcLFI6V7iAOqxJJYVF1a5GhFF55Z5LbiQw4i4LiiIHy0ZYQfV
         nseaHzpGL5yNSYzxEVQ1IxHu6ngMPGW114+OkaxHPra1DUsKUAxReOalVMdpgfL2pjW2
         oWr1xWyMLW/4FGvI/HxHra4IjzzafhxhbiTWf+cMklWeLPA1KJAL7QGUejRWQePibvTt
         tnuw==
X-Forwarded-Encrypted: i=1; AFNElJ+ogGQt1WQLDchMVEDGYNEt1hw1oltqhpU37CI+g4EyAQqwl2ZGiKV2UJNWrgPQCEzMjuM0xfDGz8l0AQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt3wzVq4Y5Dkw3kE1hx7Lo0KVACCU/feXuzgzUBHKsb1c1eRYx
	OKQKFUNCMqQDzR+thOi2QfkTTyyxj6zIGOLb25iNu48HNiDtSKMDu1q1VvCXz+1yeJeSvwNVnB2
	BOVuVzwAY4399Ghgp8H9nJmD5c/IodVZZeNPklVw/OSS+Xi741ilps2s1O6o=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:250b:b0:487:52de:3428 with SMTP id
 5614622812f47-489b0985029mr8084233b6e.24.1782055939091; Sun, 21 Jun 2026
 08:32:19 -0700 (PDT)
Date: Sun, 21 Jun 2026 08:32:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a380403.713c5d62.148f7.0008.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_evict_inode (3)
From: syzbot <syzbot+7c566c618c9fc9fbfdca@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1a3746ccbb0a Merge tag 'strncpy-removal-v7.2-rc1' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15530356580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9519196b0a0d47bc
dashboard link: https://syzkaller.appspot.com/bug?extid=7c566c618c9fc9fbfdca
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d74555c02bc2/disk-1a3746cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8ba08fd52fd4/vmlinux-1a3746cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/daed17e06386/bzImage-1a3746cc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c566c618c9fc9fbfdca@syzkaller.appspotmail.com

ocfs2: Unmounting device (7,5) on (node 0)
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 17613 Comm: syz-executor Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:ocfs2_ci_fully_checkpointed fs/ocfs2/journal.h:98 [inline]
RIP: 0010:ocfs2_checkpoint_inode fs/ocfs2/journal.h:199 [inline]
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1224 [inline]
RIP: 0010:ocfs2_evict_inode+0x2558/0x43e0 fs/ocfs2/inode.c:1303
Code: 41 80 3c 04 00 74 08 4c 89 f7 e8 f3 08 6a fe 4d 89 f7 4d 8b 36 48 83 c3 70 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ca 08 6a fe 48 8b 1b 48 c7 c7 c0 e8
RSP: 0018:ffffc90006c37300 EFLAGS: 00010212
RAX: 000000000000000e RBX: 0000000000000070 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90006c37280
RBP: ffffc90006c37a50 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000d86e50 R12: 1ffff1100a6c4485
R13: fffff52000d86e74 R14: 0000000000000000 R15: ffff888053622428
FS:  0000555569364500(0000) GS:ffff888125253000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bcbe74368 CR3: 0000000025059000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 evict+0x624/0xb50 fs/inode.c:828
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:311 [inline]
 ocfs2_free_slot_info+0x6f/0x220 fs/ocfs2/slot_map.c:465
 ocfs2_delete_osb+0x58/0x170 fs/ocfs2/super.c:2449
 ocfs2_dismount_volume+0x572/0x8d0 fs/ocfs2/super.c:1883
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:647
 kill_block_super+0x44/0x90 fs/super.c:1665
 deactivate_locked_super+0xbc/0x130 fs/super.c:477
 cleanup_mnt+0x3d3/0x460 fs/namespace.c:1317
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1fa/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fafb5d9e097
Code: a2 c7 05 5c 06 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd855161c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fafb5e322ca RCX: 00007fafb5d9e097
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd85516280
RBP: 00007ffd85516280 R08: 00007ffd85517280 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd85517310
R13: 00007fafb5e322ca R14: 000000000011717b R15: 00007ffd85517350
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_ci_fully_checkpointed fs/ocfs2/journal.h:98 [inline]
RIP: 0010:ocfs2_checkpoint_inode fs/ocfs2/journal.h:199 [inline]
RIP: 0010:ocfs2_clear_inode fs/ocfs2/inode.c:1224 [inline]
RIP: 0010:ocfs2_evict_inode+0x2558/0x43e0 fs/ocfs2/inode.c:1303
Code: 41 80 3c 04 00 74 08 4c 89 f7 e8 f3 08 6a fe 4d 89 f7 4d 8b 36 48 83 c3 70 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 ca 08 6a fe 48 8b 1b 48 c7 c7 c0 e8
RSP: 0018:ffffc90006c37300 EFLAGS: 00010212
RAX: 000000000000000e RBX: 0000000000000070 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90006c37280
RBP: ffffc90006c37a50 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000d86e50 R12: 1ffff1100a6c4485
R13: fffff52000d86e74 R14: 0000000000000000 R15: ffff888053622428
FS:  0000555569364500(0000) GS:ffff888125253000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bcbe74368 CR3: 0000000025059000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	41 80 3c 04 00       	cmpb   $0x0,(%r12,%rax,1)
   5:	74 08                	je     0xf
   7:	4c 89 f7             	mov    %r14,%rdi
   a:	e8 f3 08 6a fe       	call   0xfe6a0902
   f:	4d 89 f7             	mov    %r14,%r15
  12:	4d 8b 36             	mov    (%r14),%r14
  15:	48 83 c3 70          	add    $0x70,%rbx
  19:	48 89 d8             	mov    %rbx,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 df             	mov    %rbx,%rdi
  33:	e8 ca 08 6a fe       	call   0xfe6a0902
  38:	48 8b 1b             	mov    (%rbx),%rbx
  3b:	48                   	rex.W
  3c:	c7                   	.byte 0xc7
  3d:	c7                   	.byte 0xc7
  3e:	c0                   	.byte 0xc0
  3f:	e8                   	.byte 0xe8


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
