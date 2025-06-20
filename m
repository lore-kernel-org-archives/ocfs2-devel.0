Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975530E844
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Jun 2025 06:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750399832; cv=none; b=nsL9LFBvCafm5dk4IhDYK6Jgb9G4rWHK9rVQLVVKTCkNOYzzCzEtnxiHHeqiC5IrDWm5eI0f4Pmb9ViDQWZsQcFIEpz+34Q0VDJIHRp8od2e6LERo+PXm2k8xy546Q4S2mjMT5n5uKOhj5ZumfIA9gH5zxms0FzzeuVFz46PhUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750399832; c=relaxed/simple;
	bh=Q2asxAaLuQY8OvV1koveKUUJ3ul2GSnTWyMWfO/PD3s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jEOPfUi36ugiyuHoO9WgCP6TwdEm/yZgy3DzztiGPV2eYGNXpYK1gyloPsrZ26u7L0Ld2qaKntxAtg+PUJVq/OiBX5k8zlsSkAgCKdy/aLbUI5XJGciTI2cxYLBxpz2lVkhOiA8Vme/7Nxnnar9mR3oEuaKIJKnd7nIUj4X8SM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddccc79b55so9989585ab.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Jun 2025 23:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750399830; x=1751004630;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=209ZVpv8CMMTqEYks0rfmmhFBx04iaPlii4dpd1p6BU=;
        b=qxNJLqNtBeGpgxweikqm+M99BAzIsH9Xh5hzDlKVLF/8U5tADQyN/CfvENaRXd3kZf
         tEEMO/GgP5/+1kC7xmQybQGYkPvhfBJ2b3hOLtILbVlnTLGWKvjnQeVo2rU1ztIA6AQt
         67Tnqb3RO+OpEGmcC3kaDjt/LCEf8MlBDNcrlXt9WTBRK/2B/gBomI5ngrKycg3V43QM
         sePgsAnVaMbelVKiFUcLmZGy5J8QuaDX8yqlo9iDmCRfWZqyovM4rfPEyIfranNFflHx
         DcNCk0PKAx8ZeQmi1/ERpFkPfKsSlAARRYn6GoPaRfcvOXHGwNHXZBQfqpzXEaUU6ZoC
         yFYw==
X-Forwarded-Encrypted: i=1; AJvYcCXuRZPblU2Nn/dBbjTKXvJIUvzBMpEYtZhCLU0MLiXABzkOYqCXQVlxqJ1sakYMyoV8v68V/hNg+odiuw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzeNlMvJanzx28xyqkW/ln6ZNm/wf+9LkbMD+F+0FRqPfSbEiQX
	828TInY8+NWoECIzL3EXCmoyO9ymU0bRWFrb/QTnMaH0dIlE+ftJ9BE9EcnkTe5kkKtdepUEreE
	M7qKe7kjmRhBUZ+/NZZQM0Jwvn30+o6Z4MALTzta2mocHe2GvktycxjeIRdo=
X-Google-Smtp-Source: AGHT+IHRuNbfzZPRCCraj0WT1aKNeXXzxCBIF34bvFsisAwtQ8wKW0uEawROYjeiF67mpEgYIF1Inf9oh+DobqgTmZAVwFaSzy3k
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216e:b0:3dd:e7d7:3e1b with SMTP id
 e9e14a558f8ab-3de38cca784mr14591275ab.18.1750399829776; Thu, 19 Jun 2025
 23:10:29 -0700 (PDT)
Date: Thu, 19 Jun 2025 23:10:29 -0700
In-Reply-To: <683bef14.a70a0220.1a6ae.0011.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6854fb55.a00a0220.137b3.002f.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_remove_extent
From: syzbot <syzbot+8882b2f5f48a7170a726@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2c923c845768 Add linux-next specific files for 20250619
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=153d9d0c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58afc4b78b52b7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=8882b2f5f48a7170a726
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f23d0c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b4ef8488b2c5/disk-2c923c84.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/97fc575793ea/vmlinux-2c923c84.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b8095fa1838d/bzImage-2c923c84.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3778419fa82a/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1441f5d4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8882b2f5f48a7170a726@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5581!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6023 Comm: syz.1.19 Not tainted 6.16.0-rc2-next-20250619-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:ocfs2_remove_extent+0x1ecf/0x2020 fs/ocfs2/alloc.c:5581
Code: fa ff ff 48 8b 4c 24 08 80 e1 07 fe c1 38 c1 0f 8c 95 fa ff ff 48 8b 7c 24 08 e8 7c 70 8e fe e9 86 fa ff ff e8 d2 49 2a fe 90 <0f> 0b f3 0f 1e fa 44 89 6c 24 10 65 8b 1d 63 61 09 0f bf 07 00 00
RSP: 0000:ffffc9000216e640 EFLAGS: 00010293
RAX: ffffffff83961ebe RBX: ffffc9000216ee38 RCX: ffff888034273c00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
RBP: ffffc9000216e990 R08: ffff888034273c00 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: 1ffff1100b8fb49a
R13: 0000000000000006 R14: ffff88805c7da4d0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888125d28000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff5456df38 CR3: 0000000075e08000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_remove_btree_range+0xdef/0x1540 fs/ocfs2/alloc.c:5778
 ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7373
 ocfs2_truncate_for_delete fs/ocfs2/inode.c:637 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:804 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1093 [inline]
 ocfs2_evict_inode+0x1138/0x40e0 fs/ocfs2/inode.c:1230
 evict+0x501/0x9c0 fs/inode.c:810
 ocfs2_dentry_iput+0x247/0x370 fs/ocfs2/dcache.c:407
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 dput+0x19f/0x2b0 fs/dcache.c:911
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6b5/0x2300 kernel/exit.c:959
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1100
 get_signal+0x1286/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0x9a/0x750 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
 irqentry_exit_to_user_mode+0x81/0x120 kernel/entry/common.c:184
 exc_page_fault+0x9f/0xf0 arch/x86/mm/fault.c:1535
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f056b38e886
Code: Unable to access opcode bytes at 0x7f056b38e85c.
RSP: 002b:00007ffea35be310 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000058 RCX: 00007f056b38e929
RDX: 00007ffea35be350 RSI: 0000000000000000 RDI: 00000000000249f0
RBP: 00007f056b410b39 R08: 0000000000000000 R09: 0000000000000058
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f056b5b5fa0 R14: 00007f056b5b5fa0 R15: 0000000000000002
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_remove_extent+0x1ecf/0x2020 fs/ocfs2/alloc.c:5581
Code: fa ff ff 48 8b 4c 24 08 80 e1 07 fe c1 38 c1 0f 8c 95 fa ff ff 48 8b 7c 24 08 e8 7c 70 8e fe e9 86 fa ff ff e8 d2 49 2a fe 90 <0f> 0b f3 0f 1e fa 44 89 6c 24 10 65 8b 1d 63 61 09 0f bf 07 00 00
RSP: 0000:ffffc9000216e640 EFLAGS: 00010293
RAX: ffffffff83961ebe RBX: ffffc9000216ee38 RCX: ffff888034273c00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
RBP: ffffc9000216e990 R08: ffff888034273c00 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000000 R12: 1ffff1100b8fb49a
R13: 0000000000000006 R14: ffff88805c7da4d0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888125d28000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7a6d9f37b0 CR3: 00000000338ec000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
