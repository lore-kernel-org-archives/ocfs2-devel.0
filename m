Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE951CCB4A
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Nov 2024 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732633232; cv=none; b=sSkb4X6crCdWtZn+L/a/qslIezBlCBOQcel+RXmvR2vN6RJcXIB9a71WnxUPbHyzC1nxg2dWAVceb+b76jb9+ettis3SGAEYEzkPfUzUiFQ5vSyjZaXoiKXz1d9ei15AXkBvMSHE3kq3H8R+oq4ZHdiMUpLVWND/2cPnozDYmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732633232; c=relaxed/simple;
	bh=GC9iqk70tSEgFNqOzMWsBYvRtSMtmUJxKFihz35MT1E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=If1QRkdEPxXXyZW3mZvxNOBAaiFo/fDGgRwsXu9e8strnCFxalAmF6PiyIwtMGoJ+biYHzboayrxgKU9Sa9DkCHJmMutkMmzlEJHXxGcQ0Pv/2QtpBMsJkTxg6Koj8I6ZskLYoTZZF/VANuNSCajVvomSKxQ9Mk74kBCkDsqNho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7a1e95f19so48818765ab.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Nov 2024 07:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732633230; x=1733238030;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=su2WCsY/sMIgvzRO+AQtv1gt0oL6li6aXAIe6ZKuOB0=;
        b=pKWbYc/LsQ/QB+UGKCRGrwAi/Bk+oAa01BpcHpQKovJX6ufqYWYsMlHvS0XdcWH8aE
         iXePBjodDKTMy9SBRj79OxiPfP/k9W3RYDQQQNvvPNgbKrN4WXCUC4QCZTOxb/gTsopL
         IByFrV3P9mE41fJ+JOzUUbcSEEzgIHPkhxqpV7zZZE/wyliy3/MdPvKOmDo4jsDWgd7h
         GcWFhExTWEXG3iwJ0s9OzlVx+gKFM8zbgSAkffnlHl9cgVeKCmx8bG6fee4ceQWHad2D
         0vDsvM/7jXvt1gC7+Z+NcltVej5vDG6tFuRdY3EhYQwY3qCG7VGqYrUbpS4Kqsckc5KH
         WYNg==
X-Forwarded-Encrypted: i=1; AJvYcCXhJYYr5vAhAZs+vC73iAuqysLY0d/f7bUJOasAeH4JrIu/eSMe3d0IjeciklWjT7gc3UTroavC3+eo8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQNLW1kbj1ZrrpbzYD4BnYAimWhT1Vw9JyIg+x8MdoDPtWVxhM
	gRQd9msgAcLSy5MT5yqkKw9A+CehNqBSC4lErABcHiv64k+l7VZqMgzwdC45hG85S49MhGXNo7l
	FWBaWsLb+zcCI5rkQ79xW/BfM+FZpqlFRKdIxebr1Edhill8f3msakuU=
X-Google-Smtp-Source: AGHT+IFLBt1ZGfN48llJgJ2x/XK+b/1cPYvRzEvOmYKtmeQ7bUZx/7BfXb3EMAJEsBYK5W+SCxOcRg3V2/mHXwj8BPdMf9PJG8fh
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152d:b0:3a7:8d8e:e730 with SMTP id
 e9e14a558f8ab-3a79af23627mr152483875ab.22.1732633229653; Tue, 26 Nov 2024
 07:00:29 -0800 (PST)
Date: Tue, 26 Nov 2024 07:00:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745e28d.050a0220.1286eb.001e.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_clear_inode
From: syzbot <syzbot+b61ccbb38392c822082b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0a9b9d17f3a7 Merge tag 'pm-6.12-rc8' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127161a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3a3896a92fb300b
dashboard link: https://syzkaller.appspot.com/bug?extid=b61ccbb38392c822082b
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4675f27017d1/disk-0a9b9d17.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/880b676fc240/vmlinux-0a9b9d17.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b54f7f03e699/bzImage-0a9b9d17.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b61ccbb38392c822082b@syzkaller.appspotmail.com

RBP: 00007ffc6312dab0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc6312eb30
R13: 00007fc0479f15fc R14: 0000000000044f12 R15: 00007ffc6312eb70
 </TASK>
ocfs2: Unmounting device (7,3) on (node local)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 8245 Comm: syz-executor Not tainted 6.12.0-rc7-syzkaller-00070-g0a9b9d17f3a7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
RIP: 0010:ocfs2_clear_inode+0x571/0x1430 fs/ocfs2/inode.c:1208
Code: 48 c1 ea 03 80 3c 02 00 0f 85 b7 07 00 00 49 8b 9e 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 07 00 00 48 8b 7b 08 e8 7c 7b f7 fe 48 8b 4c
RSP: 0018:ffffc90002fdf890 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff836d638d
RDX: 0000000000000001 RSI: ffff888079b6d440 RDI: 0000000000000008
RBP: ffff888079b6cf50 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888079b6cea0
R13: 0000000000000000 R14: ffff88802a14c000 R15: ffff888079b6cb38
FS:  00005555850a7500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562453259680 CR3: 000000005e430000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ocfs2_evict_inode+0x8d6/0x15d0 fs/ocfs2/inode.c:1220
 evict+0x40c/0x970 fs/inode.c:725
 iput_final fs/inode.c:1877 [inline]
 iput fs/inode.c:1903 [inline]
 iput+0x530/0x890 fs/inode.c:1889
 __ocfs2_free_slot_info.part.0+0x3e/0x210 fs/ocfs2/slot_map.c:307
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:304 [inline]
 ocfs2_free_slot_info+0x47/0x60 fs/ocfs2/slot_map.c:443
 ocfs2_delete_osb+0x52/0x1f0 fs/ocfs2/super.c:2502
 ocfs2_dismount_volume+0x442/0xa00 fs/ocfs2/super.c:1936
 generic_shutdown_super+0x15f/0x3d0 fs/super.c:642
 kill_block_super+0x3b/0x90 fs/super.c:1710
 deactivate_locked_super+0xc1/0x1a0 fs/super.c:473
 deactivate_super+0xde/0x100 fs/super.c:506
 cleanup_mnt+0x222/0x450 fs/namespace.c:1373
 task_work_run+0x151/0x250 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc04797fa47
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffc6312d9f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fc04797fa47
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc6312dab0
RBP: 00007ffc6312dab0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc6312eb30
R13: 00007fc0479f15fc R14: 0000000000044f12 R15: 00007ffc6312eb70
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_inode+0x571/0x1430 fs/ocfs2/inode.c:1208
Code: 48 c1 ea 03 80 3c 02 00 0f 85 b7 07 00 00 49 8b 9e 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 07 00 00 48 8b 7b 08 e8 7c 7b f7 fe 48 8b 4c
RSP: 0018:ffffc90002fdf890 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff836d638d
RDX: 0000000000000001 RSI: ffff888079b6d440 RDI: 0000000000000008
RBP: ffff888079b6cf50 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888079b6cea0
R13: 0000000000000000 R14: ffff88802a14c000 R15: ffff888079b6cb38
FS:  00005555850a7500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f8a5916131 CR3: 000000005e430000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 b7 07 00 00    	jne    0x7c5
   e:	49 8b 9e 90 02 00 00 	mov    0x290(%r14),%rbx
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 d9 07 00 00    	jne    0x80d
  34:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  38:	e8 7c 7b f7 fe       	call   0xfef77bb9
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	4c                   	rex.WR


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
