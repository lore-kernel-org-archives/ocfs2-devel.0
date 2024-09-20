Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D81EF1D
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726852943; cv=none; b=psD5HU1hL5fdZ0/55kLV8y9qaJGv1oIEbkUieC272/k8l0/MjaR1FgUxsvM/uZHrqWmLISrebMmEVco0SrVpCVZL5lXf+RYhLf6y1YZNudzPVMX0allTBXqXIDMghqfbp0iYkkth0gjFOGz2qd2aGoNeeL0I4cukO7EWS1yM1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726852943; c=relaxed/simple;
	bh=MYe2mwASt0Kr/Dz6fXd3HxAkisl77oIagVupFy9mMxc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RcALtCKKcB7PCMcbC7BigwLFNrgnbkmoFyG8JsTs5EOCeHkAJeTs9v+PFklXzrOk61FqTCCW5XO65KR2Dy64IQQ0Z8/L5bRVIsg4EXNmQbQK7hm9m9k2Cdetq4+xIZTaltjeIzpOLMGwA0YJPpXHC5n+K8SpsPZ/RzMhmuZ8Yg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82d0daa1b09so256945639f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 10:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726852941; x=1727457741;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qB5rlmM4Nv5JWglarQhTJDqfKJ+7ew7o4CVP09McyhA=;
        b=NzW6pNCkZzE2EWucplMeVICs2El2j7wTodK3ypQbhc4s+LlzOClEm1vho5dZIm+6+y
         w3AjtQW9TLmcuroj2vk0rdZE5O7yTh7RrCK/Fm+J/2+dAyLaFM3hjjX80wOvEsxIzAqq
         f+fPKNRYXshL8S66FmZqlrcU4ew574GisG/7T+wAKq91k5dBfMss4zJHIC1eqfV1ziqA
         KsZ6AOMSjWf5GmpNeYu4sMRLnEW3GjIeyfwFReLXdBWuRcI1v/5uuRe7de7niwLCTkgf
         tnJpVuGexdn5JlLA5HtqTl3gjbMzQIlyNgYVtLzGtKwFAw4MXR7eSy5X28O8Fs3obCuV
         7bgg==
X-Forwarded-Encrypted: i=1; AJvYcCU9JfAi8l1SYJPsvoZoejTZSvtI2WISLnrMi11HuAYZDX6rcmvWjmh9aXjBVOCVKNFN7tnVXauvnF0JFg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp957BcNJ0hR3NY1n6CN+y64xS6JtzE0a5lD0MwPExoyRHJ/xn
	AN4gT82aybFpPeEtGL/XDQQFhV+JZqq+SJ729MWvbuoXHxwLSU/aE3m4NmmTe6BUSl8Sf9q3wtg
	tNw8tzbZ/qeberjVnynrvovdT1/KKr2dJqz1Nk2dkYArMKqkoShhlqRM=
X-Google-Smtp-Source: AGHT+IEHSJjYwAE2pq44nCetawHIjlRs69P3OKDZjO6KUYK5WTRXeZqQUiq7DMhAPWNxKKo4Vu3Jw5m6suKyvEqjA03hwNC/ZyHO
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cd84:0:b0:39f:5d96:1fde with SMTP id
 e9e14a558f8ab-3a0c9cd0932mr34173035ab.3.1726852941201; Fri, 20 Sep 2024
 10:22:21 -0700 (PDT)
Date: Fri, 20 Sep 2024 10:22:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66edaf4d.050a0220.3195df.0000.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING: bad unlock balance in ocfs2_inode_cache_io_unlock
From: syzbot <syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1506563b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=0e4e71041c9609d922a2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1418718b980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1306563b980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/09397442581f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e4e71041c9609d922a2@syzkaller.appspotmail.com

         option from the mount to silence this warning.
=======================================================
(syz-executor347,6405,1):ocfs2_read_blocks:240 ERROR: status = -12
=====================================
WARNING: bad unlock balance detected!
6.11.0-rc7-syzkaller-g5f5673607153 #0 Not tainted
-------------------------------------
syz-executor347/6405 is trying to release lock (&oi->ip_io_mutex) at:
[<ffff80008201e0dc>] ocfs2_inode_cache_io_unlock+0x20/0x30 fs/ocfs2/inode.c:1650
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor347/6405:
 #0: ffff0000c26140e0 (&type->s_umount_key#43/1){+.+.}-{3:3}, at: alloc_super+0x1b0/0x83c fs/super.c:344

stack backtrace:
CPU: 1 UID: 0 PID: 6405 Comm: syz-executor347 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:319
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:326
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:119
 dump_stack+0x1c/0x28 lib/dump_stack.c:128
 print_unlock_imbalance_bug+0x250/0x2a4 kernel/locking/lockdep.c:5199
 __lock_release kernel/locking/lockdep.c:5436 [inline]
 lock_release+0x4ec/0x9e8 kernel/locking/lockdep.c:5780
 __mutex_unlock_slowpath+0xe0/0x6b4 kernel/locking/mutex.c:912
 mutex_unlock+0x18/0x24 kernel/locking/mutex.c:548
 ocfs2_inode_cache_io_unlock+0x20/0x30 fs/ocfs2/inode.c:1650
 ocfs2_metadata_cache_io_unlock+0x6c/0x90 fs/ocfs2/uptodate.c:95
 ocfs2_read_blocks+0x1164/0x1638 fs/ocfs2/buffer_head_io.c:394
 ocfs2_map_slot_buffers fs/ocfs2/slot_map.c:385 [inline]
 ocfs2_init_slot_info+0x904/0x1214 fs/ocfs2/slot_map.c:424
 ocfs2_initialize_super fs/ocfs2/super.c:2274 [inline]
 ocfs2_fill_super+0x2668/0x4740 fs/ocfs2/super.c:994
 mount_bdev+0x1d4/0x2a0 fs/super.c:1679
 ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x28c fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
(syz-executor347,6405,1):ocfs2_map_slot_buffers:388 ERROR: status = -12
(syz-executor347,6405,1):ocfs2_init_slot_info:426 ERROR: status = -12
(syz-executor347,6405,1):ocfs2_initialize_super:2276 ERROR: status = -12
(syz-executor347,6405,0):ocfs2_fill_super:1178 ERROR: status = -12


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
