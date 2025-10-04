Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009D419ABC6
	for <ocfs2-devel@lists.linux.dev>; Sat,  4 Oct 2025 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759555896; cv=none; b=OPIeATSzJWP9orFEc76Zu35AfMpjULaZVe4HlFwm92QL7AtJ88yy5gpZilYno1+PYk4081Qhs0nWdA6Ufj5FEnsEZRr5f71Ca7rYds/hePB0DvOTEoX3dhV+2geMjP/sVlKk6qqb/ls1EqJuveqheh+HZvhNWyz2BTvUdp0jR0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759555896; c=relaxed/simple;
	bh=Msh5q5/tToZaTH3AP/OWVHXVJPHfkLxOp9cj1IfNjB8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ieM1iImvgpP1i4NCZl4vLRv6LcOi44MFauzZdVXL007ST8pgiLqXZO1HHyS2bIRfeu/Id7JK2GAOBesGQ2FAgW/jYurMu9oqkRqjuaW+3vsSfQ+E3tnfuwhAP70g4fue9ONtkfapCYeFylyeO9cPNBpXv5vkkpfhh5hsxEt5us0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42486b1d287so87180875ab.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 03 Oct 2025 22:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759555894; x=1760160694;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6/r9vzzDPn9YCHOBtkYu9Mz2upRISy7aH063KJreCS0=;
        b=RgNumRpJ0zUrtHM/ZSC3/sfrmWkumCCcRuuPqVgJWoHRZh+f7zEXkMgyel47u52SZv
         R3YewjD2jdCwc+0WzSdINDEXnXtjwTg65MTaS26VNxA1y//O8RmsBOF4byLBd6Rzd6ki
         iHqLSbTGYRhe7pfWzNagH7YJzPb2oXSvX04kilZv/8DVKI96aeQB+VhhvdexQiBZubEP
         ysfFE8lWSbfzCXMTnWsHooqpfEdEftDruoQavUPgFm6tYr86NUR4lm4FqMrxJGMuHA9D
         +dTmxr2/Dj+PF2xJujEvcqphNw+Uz+Sv3MRYsLbfvkUARNfSIWymRKUGHzRci0f26gIl
         txLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXq+POU+spxUbQzCH/EUmJqD85uXQtl+d9HcIv+PK+EIEQlApo78ZviK14K2q8ufjh9T7yT+YePEFaUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqykEg9ZEc3a4hZrbnRVDphMkN45H1iy3f3qZz99CLZ00X08Sn
	/feO/kBUkCZtQgP8XZLjS8h+389f8bvJE4SAMAcYD2/kz0s0chHjUWQsfTHH+PNYCbaLZbaE6NQ
	4x4Ydq3OoFQmWTmAhQgj9rXCOYhdMxYfWZFYcgANF8YuV90rTDJTc54Y+aaw=
X-Google-Smtp-Source: AGHT+IHYQKxsFVz0yqASVCHIRyez4nQPsGpRoe/oTcmmwUqE4Iifm5EK5arkuMRrlmgo3x5fDF/TG2VxQi8kanQ8iu49NEkAd1tS
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198a:b0:424:8b1a:9326 with SMTP id
 e9e14a558f8ab-42e7ad97443mr83371385ab.21.1759555894158; Fri, 03 Oct 2025
 22:31:34 -0700 (PDT)
Date: Fri, 03 Oct 2025 22:31:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e0b136.050a0220.2c17c1.002d.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_refcount_cal_cow_clusters
From: syzbot <syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f79e772258df Merge tag 'media/v6.18-1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=151d1ee2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f967f2c97bd611a
dashboard link: https://syzkaller.appspot.com/bug?extid=6fdd8fa3380730a4b22c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e84458580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163c9214580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f79e7722.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d29501fc412/vmlinux-f79e7722.xz
kernel image: https://storage.googleapis.com/syzbot-assets/773691b45948/bzImage-f79e7722.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2a53f186d930/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12731092580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com

         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/refcounttree.c:2678!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5498 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_refcount_cal_cow_clusters+0x12a1/0x12b0 fs/ocfs2/refcounttree.c:2678
Code: 94 6d 8d ba 69 0a 00 00 48 c7 c1 a0 40 8b 8b 4c 8b 4c 24 30 e8 00 51 10 00 90 0f 0b e8 d8 83 17 fe 90 0f 0b e8 d0 83 17 fe 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc90002bbf5e0 EFLAGS: 00010293
RAX: ffffffff83a70250 RBX: 1ffff1100863069a RCX: ffff888000bdc900
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002bbf7a8 R08: 00000000ffffffff R09: ffffc90002bbf85c
R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff1100863069a R14: ffff8880431834d0 R15: 0000000000000000
FS:  0000555579608500(0000) GS:ffff88808d969000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b000 CR3: 000000004f2d3000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3385 [inline]
 ocfs2_refcount_cow+0x31f/0xc90 fs/ocfs2/refcounttree.c:3467
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2340 [inline]
 ocfs2_file_write_iter+0xe28/0x1d10 fs/ocfs2/file.c:2451
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f386f58eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecc491f98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f386f7e5fa0 RCX: 00007f386f58eec9
RDX: 000000000000001c RSI: 0000200000000100 RDI: 0000000000000005
RBP: 00007f386f611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f386f7e5fa0 R14: 00007f386f7e5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_refcount_cal_cow_clusters+0x12a1/0x12b0 fs/ocfs2/refcounttree.c:2678
Code: 94 6d 8d ba 69 0a 00 00 48 c7 c1 a0 40 8b 8b 4c 8b 4c 24 30 e8 00 51 10 00 90 0f 0b e8 d8 83 17 fe 90 0f 0b e8 d0 83 17 fe 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc90002bbf5e0 EFLAGS: 00010293
RAX: ffffffff83a70250 RBX: 1ffff1100863069a RCX: ffff888000bdc900
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002bbf7a8 R08: 00000000ffffffff R09: ffffc90002bbf85c
R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff1100863069a R14: ffff8880431834d0 R15: 0000000000000000
FS:  0000555579608500(0000) GS:ffff88808d969000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000b000 CR3: 000000004f2d3000 CR4: 0000000000352ef0


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
