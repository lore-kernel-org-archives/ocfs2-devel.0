Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1FA1953A1
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735875991; cv=none; b=AfOBr3Q9fZDu8d99HUsyb6cysyB0JfaqNuvzkNCaNp9IwfYR/XsmUv5kFynS4844R5wOJpUUxk5zBl6BucwlE9Ab/bFJxtS74EN3bff+9grHMXNDytZB/4QSXXtQH22WhCdtJyaJiU7E3Em9Xcpw3Bol7keACCCcJ5GfWBl8Dzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735875991; c=relaxed/simple;
	bh=wn6kC7k1Vd7wPHfJIiTn0wVmttTnoS0+hiSnYMVhn94=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ilGFgJknK0QfA0yzt/v1AiTvCcrjusAybvAHP+evYF3WJ6CN2QFiWe7QpEzjscJI5CJtsoa6AukolNuRTAVFtuY0+lOXVW0rp2l30V2pmSrJlkHMu8xph75wdJeViMm2mEU9A0s5sQZOwg54fbbMLqOwfFvEMVftU3GZZ9csHkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-844db0decffso989294639f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 19:46:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735875988; x=1736480788;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tpVGg86uB4JHEkmHi9hYvbi1qxC3jfJ5oXO/BizC0Sc=;
        b=kQ+hpspuHltQSZwThren02D6+nA5jFHoqE1dUP+rIqgd1RkbKpQYagKQkKwexwgizi
         k5biDUPcwV7FjX++C6MRVllRR19qyNIp/0ARtWzRMuEKd99ob2svY4b25AbYGs7a2Nd4
         DKEHBFFXe/CgEHrqM+zjeCCz/3SFnJw9EqwmyvpP1NImDpuNV6ldzEnJqJtb1MULvq27
         EQQTmrSHImYg7AEml2gK60b+gdFX5FBTICsedawXeFggRkqeB1flCqA63ItCiYffVtGB
         2HKSI59ccZ8FTOL6onOp3Uk3A0S9p3ZDkbiUGHDm4NSIvIzZ/tseTl3r/klPWIKyZL90
         5f0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvCo7hvs/DfPr5a/Y9NxXqsZu9I3f9XIoU04OZCap+Rfl/2PkcCYe24NfZBfleN0LFClqqWZ+nvFeTiA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPvHLB7yG2ieYLAYXPfSqN0NbD6jnMdOP0ik4NEqMShNz2Cu6P
	p57QZIM+jMrNpPqwSXwptHWRbzmf63MQp7+CaT9sQ3W9OrBkPOT9gbVpIOn6eHya/qG9vXwxKvY
	vcmaLVP1gREX3Wb2M1gXPc7jwbx1szJQUQhkovYBbFQsnkqa8cOw3D4Q=
X-Google-Smtp-Source: AGHT+IFAIoNFLqMYbWnezEWZYJwmilYrl3u4L0EkW34OaMqYwTUqMS+L+f9yDwpQdm9sqP9jOhGCTp4fJyusCdUEq4VZJIidsvab
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1a:b0:3a7:e069:95e0 with SMTP id
 e9e14a558f8ab-3c2fe53a7d5mr335486195ab.1.1735875988320; Thu, 02 Jan 2025
 19:46:28 -0800 (PST)
Date: Thu, 02 Jan 2025 19:46:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67775d94.050a0220.178762.003a.GAE@google.com>
Subject: [syzbot] [ext4?] [ocfs2?] WARNING in __jbd2_log_wait_for_space
From: syzbot <syzbot+04ae2c9e709a347f1a81@syzkaller.appspotmail.com>
To: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    573067a5a685 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=120daaf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd7202b56d469648
dashboard link: https://syzkaller.appspot.com/bug?extid=04ae2c9e709a347f1a81
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124126df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14652ac4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d3b5c855aa0/disk-573067a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0c06fc1ead83/vmlinux-573067a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3390e59b9e4b/Image-573067a5.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/8351bb578424/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+04ae2c9e709a347f1a81@syzkaller.appspotmail.com

__jbd2_log_wait_for_space: needed 5461 blocks and only had 1246 space available
__jbd2_log_wait_for_space: no way to get more journal space in loop0-75
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6419 at fs/jbd2/checkpoint.c:115 __jbd2_log_wait_for_space+0x400/0x5cc fs/jbd2/checkpoint.c:116
Modules linked in:
CPU: 1 UID: 0 PID: 6419 Comm: syz-executor202 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __jbd2_log_wait_for_space+0x400/0x5cc fs/jbd2/checkpoint.c:116
lr : __jbd2_log_wait_for_space+0x3f8/0x5cc fs/jbd2/checkpoint.c:112
sp : ffff8000a2506fe0
x29: ffff8000a25070e0 x28: 0000000000000000 x27: dfff800000000000
x26: ffff0000c5fc00b0 x25: ffff0000c5fc0190 x24: 0000000000000000
x23: ffff0000c5fc0690 x22: 0000000000001555 x21: ffff80008ef538c1
x20: 00000000000004de x19: ffff0000c5fc0000 x18: 0000000000000008
x17: 6c206e6920656361 x16: ffff800083275834 x15: 0000000000000001
x14: 1fffe00036700aea x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000001 x10: 0000000000ff0100 x9 : b8bdcb2c5f900500
x8 : b8bdcb2c5f900500 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff8000a2506738 x4 : ffff80008fa8f840 x3 : ffff80008073f2fc
x2 : 0000000000000001 x1 : 00000000fffffffb x0 : ffff0000c5fc0000
Call trace:
 __jbd2_log_wait_for_space+0x400/0x5cc fs/jbd2/checkpoint.c:116 (P)
 add_transaction_credits+0x868/0xbec fs/jbd2/transaction.c:283
 start_this_handle+0x574/0x11c4 fs/jbd2/transaction.c:407
 jbd2__journal_start+0x298/0x544 fs/jbd2/transaction.c:505
 jbd2_journal_start+0x3c/0x4c fs/jbd2/transaction.c:544
 ocfs2_start_trans+0x3d0/0x71c fs/ocfs2/journal.c:352
 ocfs2_shutdown_local_alloc+0x1d8/0x8d8 fs/ocfs2/localalloc.c:417
 ocfs2_dismount_volume+0x1f4/0x920 fs/ocfs2/super.c:1877
 ocfs2_put_super+0xec/0x368 fs/ocfs2/super.c:1608
 generic_shutdown_super+0x12c/0x2bc fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1373
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1380
 task_work_run+0x230/0x2e0 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0x4ec/0x1ad0 kernel/exit.c:938
 do_group_exit+0x194/0x22c kernel/exit.c:1087
 __do_sys_exit_group kernel/exit.c:1098 [inline]
 __se_sys_exit_group kernel/exit.c:1096 [inline]
 pid_child_should_wake+0x0/0x1dc kernel/exit.c:1096
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 66566
hardirqs last  enabled at (66565): [<ffff8000804aab50>] __up_console_sem kernel/printk/printk.c:344 [inline]
hardirqs last  enabled at (66565): [<ffff8000804aab50>] __console_unlock+0x70/0xc4 kernel/printk/printk.c:2869
hardirqs last disabled at (66566): [<ffff80008b69c83c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:488
softirqs last  enabled at (64790): [<ffff800080129934>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (64788): [<ffff800080129900>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
Aborting journal on device loop0-75.
(syz-executor202,6419,1):ocfs2_start_trans:357 ERROR: status = -30
OCFS2: abort (device loop0): handle_t *ocfs2_start_trans(struct ocfs2_super *, int): Detected aborted journal
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz-executor202,6419,1):ocfs2_shutdown_local_alloc:419 ERROR: status = -30
(syz-executor202,6419,1):ocfs2_journal_shutdown:1085 ERROR: status = -5
ocfs2: Unmounting device (7,0) on (node local)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
