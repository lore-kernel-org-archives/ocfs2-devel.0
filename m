Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A3770808
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Sep 2025 01:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758850471; cv=none; b=Com4ykXf6pZ2ztGUrU17aMTSQVW1xjTj8rwjuHNzkHc0YqfAQ1itCbJ9pHNh67fjMCWsu7gsmEQAWfTcFkm6FVKB8N3RxxoJ0+yLGVe7h5SylM90ed9vru1LYaMVWEzUF5/x/EOo+su2740I7J1jmYnjStBeyZnnWr1HrPiHo8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758850471; c=relaxed/simple;
	bh=2ZB6QYtzj2FL58Z6VfYBzCQUKiIq4W9JRITPM3KaP8U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gtTo+bX5KtB8RAyzMJ0EoSt2U0dURv2rng/JcOk6BgBceG2o/25TMWpexacScNrSJBSv9+r6L2HpHxYsmpBbIPkWCuF/Lb5CMjES6TbM+MmsfqsTWDrkD9GvBqqtzPVju6z0rky+x4koiPLcM1714sSy4HtlecjCbUG1BdvC9Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-8e621d97671so443748339f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Sep 2025 18:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758850469; x=1759455269;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/4ZZzA+ruNN8Rv0JHDrG8qge6jZmVnlsd4nZK4zP7E=;
        b=qgOB0mNA4p68MZ6KkPmw3IuhynDn6c0JmE8kcpylLh4Sks5bkqKrLnCY5k8aNnXFe/
         zqIyrEu+I44rGonz1YeSI0coy3uDmqzWB2KGcqM9vq77rHPyCAvRmdTHSz2iOruAw3p3
         hduyukKhdgIXM5XoP6QB0ds7wCLGpPX9F2uKau/I4qbDr/JC5wH/WPbtWy7ZXOa5JMjq
         ecs2yI3sNgQIvQJc1p+1xwzDBHO+UKI+gS9qsHF6vAKwSILvFEFvzJhBivKlVFu+7+Fx
         cz9oEup/a+47ee5yvU3VeA1V4Htk3aimH7uUjrT/wmWLoQIMR1r44LZ2YGHtyUe0cneL
         zX/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNWn6NPlvQRaoW36k2T9jBziM66xaU4oHJKXULMh4BnUHA/mp3pvDCP4/O+mDOnSjAaGUBTEB1iAbWXQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyGINf+un2Ru9ukr2UwZqDuojxPme56obITtTb8Vx7bfZeJfyQW
	wHxIKNiOMry9qtis/Y1VOVzbVeYaBSznRGnsCzMh7+3m9puhHc7gEy8tL9d3FVYcHaZfQAWGHfT
	U8XT/TE5bRtyumwaWhlYqhanHrcMxBCZbgrVUX1WHXLLD6gr4zKUC570ur3o=
X-Google-Smtp-Source: AGHT+IFYOOISkhsQ0oXsAqAWagtii1hl+KYxmLeXh5cEAFUU7WK9ygZikE279yi1Y9PNa/4N7Tecy/qfbNePxOSjKrMRjFjpirt5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a09:b0:425:84b6:a7ff with SMTP id
 e9e14a558f8ab-425955ed620mr98158185ab.6.1758850469379; Thu, 25 Sep 2025
 18:34:29 -0700 (PDT)
Date: Thu, 25 Sep 2025 18:34:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d5eda5.a00a0220.303701.0021.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING: locking bug in ocfs2_inode_lock_full_nested
From: syzbot <syzbot+f1b7d3d179cd1db8518a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2d5bd41a4505 Merge tag 'clk-fixes-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1029c8e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=f1b7d3d179cd1db8518a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b7202ac3386f/disk-2d5bd41a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/826ea91f3056/vmlinux-2d5bd41a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a56cfda9c03f/bzImage-2d5bd41a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1b7d3d179cd1db8518a@syzkaller.appspotmail.com

loop3: detected capacity change from 0 to 1024
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(!test_bit(class_idx, lock_classes_in_use))
WARNING: CPU: 0 PID: 10994 at kernel/locking/lockdep.c:5207 __lock_acquire+0xc0c/0xd20 kernel/locking/lockdep.c:5207
Modules linked in:
CPU: 0 UID: 0 PID: 10994 Comm: syz.3.280 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:__lock_acquire+0xc0c/0xd20 kernel/locking/lockdep.c:5207
Code: ff ff 90 e8 26 94 18 03 85 c0 74 22 83 3d bf 60 81 0d 00 75 19 90 48 c7 c7 2c 9f 21 8d 48 c7 c6 ca ed 09 8d e8 75 2c e7 ff 90 <0f> 0b 90 90 90 e9 8f 00 00 00 90 0f 0b 90 e9 8d fe ff ff 90 e8 eb
RSP: 0018:ffffc90004b97410 EFLAGS: 00010046
RAX: a5a653e04eba8400 RBX: ffff88802d45d940 RCX: 0000000000080000
RDX: ffffc9000db71000 RSI: 0000000000000af6 RDI: 0000000000000af7
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1017104863 R12: 0000000000000004
R13: 0000000000000004 R14: ffff88802d45e4b0 R15: 0000000000000000
FS:  00007f39acc7e6c0(0000) GS:ffff8881268bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000003cd8e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 rt_spin_lock+0x88/0x2c0 kernel/locking/spinlock_rt.c:56
 spin_lock include/linux/spinlock_rt.h:44 [inline]
 ocfs2_is_hard_readonly fs/ocfs2/ocfs2.h:665 [inline]
 ocfs2_inode_lock_full_nested+0x120/0x1b20 fs/ocfs2/dlmglue.c:2446
 ocfs2_inode_lock_tracker+0x1be/0x660 fs/ocfs2/dlmglue.c:2691
 ocfs2_setattr+0x731/0x1b40 fs/ocfs2/file.c:1173
 notify_change+0xb34/0xe60 fs/attr.c:552
 chown_common+0x40c/0x5c0 fs/open.c:791
 do_fchownat+0x161/0x270 fs/open.c:822
 __do_sys_lchown fs/open.c:847 [inline]
 __se_sys_lchown fs/open.c:845 [inline]
 __x64_sys_lchown+0x85/0xa0 fs/open.c:845
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f39aea1ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f39acc7e038 EFLAGS: 00000246 ORIG_RAX: 000000000000005e
RAX: ffffffffffffffda RBX: 00007f39aec65fa0 RCX: 00007f39aea1ec29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000a80
RBP: 00007f39aeaa1e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f39aec66038 R14: 00007f39aec65fa0 R15: 00007ffeedc44808
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
