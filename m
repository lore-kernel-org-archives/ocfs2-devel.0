Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F443BBF2
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Mar 2025 01:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743038014; cv=none; b=CdGc8go49RU4k2Fy4Rr9itNKjNEk+WXrH0K/FEGcxf7enGMSnDQThl7p7N8zHFX/bD9XK2e7IBzadR74kryDJHle84sv2F7RLluLXBytceTL9trZe/nTtGsSzFz3jGr9UgYvWPGEnZ7AMMr3/KXQFKKVzolqrlIglJNMKhu/MXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743038014; c=relaxed/simple;
	bh=uchq4aTAQ0es6LBl6vgOqfs0ndqCV/gWUkrrpTsvtw8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CHiP18eTvLfA80v90Xva79N++aHna7cM7FW7uOdA05XNQKM7YSFHYQ258iysvgdg/12dNBRzBFySQT3gYyxI8zVDcYUREs5rnUTFxCnKZKK2RwmwOhwBpf0RfAdrHVdRt9nB7Axgxqs3ifmmCfoxH309WL2mTLhgFlMrB8pAK18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d2b3a2f2d4so7498335ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 18:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743038011; x=1743642811;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCEF6T4SitcoskWj2IGtaL2AfQtoG0DKVyGCParkCeQ=;
        b=kkbUq+P7pqXtOJAuwP6qGNznDSt+jxG9jnSDBLj9XqlXOWwE7M0VcNLea7bEAbss/Z
         8ZqR9BDTMBz9NL+5reveTIFyCUIYbYAq/0wgTrajk+3rgPkynGYMXqaWD9svjOSWkpcz
         QVa3HyLtT21HxFfkvJguDzHddYkOwxHJfSrtogSQMzGBI8nCGei2/sZaJgP7vbL/Dg5B
         ZJGXJqQv/vJkMpwOSTj8PVM1Bs5zN6dqDnGwHpb2Ml0NCmIaELzeISo/CBLI9kImt4H/
         L6Itz+ghzMZ6Ll97Q+TOX1KjRm8/0c4WZEqBfHvl1y4rWsm7VmvhHwUQGh/ykmlgcWIJ
         UxTg==
X-Forwarded-Encrypted: i=1; AJvYcCXaL91NKIFUYEbCNsgSCItSHWsw06m12K6NBgnQ75vk2T4RGFsmGpI6ivqO6EjzuSTqmFYSFcqV04/OTg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxd7VlVanJRGUlzaZL37SOAFTDkodh/C77M3Zi1XEK3+xHzkXdc
	PpnYxjTcx/e4dWC3+4iMvw8N1+5MpoFTy2eBjYOCRkRNZDbNuVJiSOky1c/Ve6GBWHesGy4xCqb
	Ot5gdM/PqRLevC5Br1i5Q7Xv+gt8691ZaswjJ8j+CNJzBpQda9sdXobY=
X-Google-Smtp-Source: AGHT+IFgW3wwrE+l03drQt6xBrOXSi6sqX/MBVPWbUqeWMAsi4gFqZ7Uv/UnbAhUaOhvJ9NzVLx2xd6YQG2r/RGnk7WBO0GDEW75
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188a:b0:3d4:712e:29eb with SMTP id
 e9e14a558f8ab-3d5ccdc53c1mr21586655ab.5.1743038011130; Wed, 26 Mar 2025
 18:13:31 -0700 (PDT)
Date: Wed, 26 Mar 2025 18:13:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e4a63b.050a0220.2f068f.0017.GAE@google.com>
Subject: [syzbot] [ocfs2?] BUG: Dentry still in use in unmount (3)
From: syzbot <syzbot+e21102eb810a20a034bd@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a2392f333575 drm/panthor: Clean up FW version information ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1294443f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12ccc0a681e19f95
dashboard link: https://syzkaller.appspot.com/bug?extid=e21102eb810a20a034bd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1695be98580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1694443f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa9dc8dca3f7/disk-a2392f33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/96ca6097aca7/vmlinux-a2392f33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/78dee40677fb/Image-a2392f33.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7db194d99ee0/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=15ed73b0580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e21102eb810a20a034bd@syzkaller.appspotmail.com

------------[ cut here ]------------
BUG: Dentry 000000007215d8e2{i=42a2,n=file0}  still in use (1) [unmount of ocfs2 loop0]
WARNING: CPU: 1 PID: 6436 at fs/dcache.c:1572 umount_check+0x164/0x1b8 fs/dcache.c:1564
Modules linked in:
CPU: 1 UID: 0 PID: 6436 Comm: syz-executor167 Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : umount_check+0x164/0x1b8 fs/dcache.c:1564
lr : umount_check+0x164/0x1b8 fs/dcache.c:1564
sp : ffff80009cc17a70
x29: ffff80009cc17a70 x28: 0000000000000000 x27: ffff0000daefd318
x26: ffff0000cd89e2f0 x25: ffff80008feda750 x24: ffff0000c6860000
x23: dfff800000000000 x22: ffff8000902b75a0 x21: 0000000000000001
x20: 00000000000042a2 x19: ffff0000cd89e2f0 x18: 0000000000000008
x17: 5b20293128206573 x16: ffff8000832b7b9c x15: 0000000000000001
x14: 1ffff00013982ea4 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000004 x10: 0000000000ff0100 x9 : c9b6966d3b355500
x8 : c9b6966d3b355500 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80009cc17218 x4 : ffff80008fcafb00 x3 : ffff800083249bb4
x2 : 0000000000000001 x1 : 0000000000000002 x0 : 0000000000000000
Call trace:
 umount_check+0x164/0x1b8 fs/dcache.c:1564 (P)
 d_walk+0x1d4/0x704 fs/dcache.c:1295
 do_one_tree+0x44/0xfc fs/dcache.c:1579
 shrink_dcache_for_umount+0xd8/0x188 fs/dcache.c:1595
 generic_shutdown_super+0x68/0x2bc fs/super.c:620
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1413
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1420
 task_work_run+0x230/0x2e0 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:745
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 10970
hardirqs last  enabled at (10969): [<ffff8000804afa4c>] __up_console_sem kernel/printk/printk.c:344 [inline]
hardirqs last  enabled at (10969): [<ffff8000804afa4c>] __console_unlock+0x70/0xc4 kernel/printk/printk.c:2869
hardirqs last disabled at (10970): [<ffff80008b7c3e94>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:488
softirqs last  enabled at (10964): [<ffff8000803128a4>] softirq_handle_end kernel/softirq.c:407 [inline]
softirqs last  enabled at (10964): [<ffff8000803128a4>] handle_softirqs+0xb44/0xd34 kernel/softirq.c:589
softirqs last disabled at (10723): [<ffff800080020dbc>] __do_softirq+0x14/0x20 kernel/softirq.c:595
---[ end trace 0000000000000000 ]---
ocfs2: Unmounting device (7,0) on (node local)
VFS: Busy inodes after unmount of loop0 (ocfs2)
------------[ cut here ]------------
kernel BUG at fs/super.c:652!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6436 Comm: syz-executor167 Tainted: G        W          6.14.0-rc7-syzkaller-ga2392f333575 #0
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : generic_shutdown_super+0x2b8/0x2bc fs/super.c:650
lr : generic_shutdown_super+0x2b8/0x2bc fs/super.c:650
sp : ffff80009cc17bb0
x29: ffff80009cc17bb0 x28: 1fffe0001b097193 x27: 0000000000000008
x26: 0000000000000003 x25: dfff800000000000 x24: 1fffe00018d0c0f0
x23: ffff80008bc839e0 x22: dfff800000000000 x21: 0000000000000000
x20: ffff8000902b75a0 x19: ffff0000c6860668 x18: 0000000000000008
x17: 000000000000e793 x16: ffff8000832b7b9c x15: 0000000000000001
x14: 1fffe000366f60f2 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000001 x10: 0000000000ff0100 x9 : c9b6966d3b355500
x8 : c9b6966d3b355500 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80009cc17378 x4 : ffff80008fcafb00 x3 : ffff800080743ed0
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000002f
Call trace:
 generic_shutdown_super+0x2b8/0x2bc fs/super.c:650 (P)
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1413
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1420
 task_work_run+0x230/0x2e0 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:745
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: d00562e0 91208000 aa1303e1 97cfdf8f (d4210000) 
---[ end trace 0000000000000000 ]---


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
