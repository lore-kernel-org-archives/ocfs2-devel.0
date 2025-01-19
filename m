Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D058029415
	for <ocfs2-devel@lists.linux.dev>; Sun, 19 Jan 2025 19:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737314303; cv=none; b=m7bPFY7SnURMThSLjC/o+GWtV00lgnaRIiesYs3KpBcvLoStbvum/5tWc4MLdTcCkoom0RNAoY08ht6EIf7CmZRc8yu4q68TyhG7euLkirrjYFQqImNQR62PNGBczcS8BBaFsa6VhrEOg0aOlM26ejMreLXmRp9Nj/2FcRSlDKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737314303; c=relaxed/simple;
	bh=BGD0AXioDN8MrZD36rHc51cRupH6jh57DoOKteUpVOI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UargT+lW/9nubNoVqFa+aQwiYnpblil5zj4xJ2OcHAn+G4vVkMtY1tPKXUNbQGoMsPeQv+Z0OuWwkCip5fxBnXF4jua9OiB9UlsZbRiHROEhWijHLQg9+PgFBOoaNOE/EQa80LsArcd3PmRgGAwL+gxAYvPrBVtAhJfMimprAXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-8498a21afc2so250938339f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 19 Jan 2025 11:18:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737314301; x=1737919101;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IuvX/zZGMHKhOPrpGTlAhmyFOpXSf0VgAMJ9hegclxs=;
        b=q/epXLzwnPbnZWFRCwPLrOfsXAvy6QnbyGZnprmYhDUGN3o0SOKLp/AEYykYbzCsLS
         RbP0GfW47ADynK9UwGJKnTQiqSmHZ1P7Z0WB9YQiD8/2NyTC4D3IOXpJqgL2VfPhx2IE
         frQ18Pzjy0zYrFXl4kj4+8WTmxzgH0H9rx24MDqjyAg4K0qSdJM8lVy+WYErBZ/yM6hX
         IqGHdJjNUOHvI1BaCw1II/pQ0kzz6HDQSrP4cUlHgVdM5FioRKlnNMKrA0BSbZsZ5yjx
         NDBqTNqyrFKH1VERldIuGXntBPZdU294+qS0NueyVz+1xltt/dFVTUGV8QBXr+sUE1Ip
         Y8Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWFwM2JHS8AQM8E57k0SJJXMCgfX8QN+2m3oNk52ye1Ez1+E9WwqHLYtQchV1O2Dtqwu/7UWAdo5FKSHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIvXXgCpDtxIB5dLTUVugHDoPzQOPLiREaJASvZ16EHZ3XHIB2
	wWREnXC2DhVaZ2QEZ2s6yvOtNGnzY0L6Gpnm1epJ2SxswfT2xrpEOgiKZzq9z8j4336llMZ7Ot6
	3MV/rjADjc1olYNG8/q8DEsWpk2XtZPYu+OTiethkazj5iRw8YE6x8ug=
X-Google-Smtp-Source: AGHT+IFw31N2MykAvCgu/la6XI7sq6tpEWAW/VVKJYEErR4jN7bNC50zLZD9bQGkIhSHku13KrC5Mls8/ZJgZn2Ia31PonfqX7Q+
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3042:b0:3ce:7eae:45c5 with SMTP id
 e9e14a558f8ab-3cf7447b9dcmr77421215ab.15.1737314300945; Sun, 19 Jan 2025
 11:18:20 -0800 (PST)
Date: Sun, 19 Jan 2025 11:18:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678d4ffc.050a0220.303755.005b.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING: locking bug in igrab
From: syzbot <syzbot+f40155971e0e3f988550@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    619f0b6fad52 Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ff41f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aadf89e2f6db86cc
dashboard link: https://syzkaller.appspot.com/bug?extid=f40155971e0e3f988550
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-619f0b6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f181fafa1b35/vmlinux-619f0b6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/174e5d6e6837/bzImage-619f0b6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f40155971e0e3f988550@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 5315 at kernel/locking/lockdep.c:232 hlock_class kernel/locking/lockdep.c:232 [inline]
WARNING: CPU: 0 PID: 5315 at kernel/locking/lockdep.c:232 check_wait_context kernel/locking/lockdep.c:4850 [inline]
WARNING: CPU: 0 PID: 5315 at kernel/locking/lockdep.c:232 __lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5176
Modules linked in:
CPU: 0 UID: 0 PID: 5315 Comm: syz.0.0 Not tainted 6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:hlock_class kernel/locking/lockdep.c:232 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4850 [inline]
RIP: 0010:__lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5176
Code: 00 00 83 3d 01 eb 9e 0e 00 75 23 90 48 c7 c7 80 97 0a 8c 48 c7 c6 80 9a 0a 8c e8 c7 5c e5 ff 48 ba 00 00 00 00 00 fc ff df 90 <0f> 0b 90 90 90 31 db 48 81 c3 c4 00 00 00 48 89 d8 48 c1 e8 03 0f
RSP: 0018:ffffc9000d416b90 EFLAGS: 00010046
RAX: e4c85f3ada31ea00 RBX: 0000000000000c69 RCX: ffff888000882440
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000040c69 R08: ffffffff81602ac2 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff888000882f04
R13: 000000000000000f R14: 1ffff110001105f7 R15: ffff888000882fb8
FS:  000055555edb6500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f31d85ff000 CR3: 0000000043302000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 igrab+0x21/0xb0 fs/inode.c:1589
 ocfs2_get_system_file_inode+0x1c7/0x7b0 fs/ocfs2/sysfile.c:104
 ocfs2_xattr_free_block fs/ocfs2/xattr.c:2517 [inline]
 ocfs2_xattr_remove+0xac4/0x18d0 fs/ocfs2/xattr.c:2600
 ocfs2_wipe_inode fs/ocfs2/inode.c:806 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x1f5e/0x4630 fs/ocfs2/inode.c:1216
 evict+0x4e8/0x9a0 fs/inode.c:796
 ocfs2_dentry_iput+0x232/0x380 fs/ocfs2/dcache.c:411
 __dentry_kill+0x20d/0x630 fs/dcache.c:625
 dput+0x19f/0x2b0 fs/dcache.c:867
 __fput+0x5ba/0xa50 fs/file_table.c:458
 task_work_run+0x24f/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f31e3785d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcc65584f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 0000000000010c94 RCX: 00007f31e3785d29
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f31e3977ba0 R08: 0000000000000001 R09: 00007ffcc65587ef
R10: 00007f31e35ff02c R11: 0000000000000246 R12: 0000000000011183
R13: 00007f31e3975fa0 R14: 0000000000000032 R15: ffffffffffffffff
 </TASK>


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
