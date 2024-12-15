Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6818D299
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Dec 2024 04:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734237920; cv=none; b=oJrUlq0VqiBjhivoaI4LrUT69OsxEqKNVBnNmu0KrOT5vEVGbErAkBpCbQ11rL4BdN0YCr6nQEhSq0qXa5GJ1SiFRrIIMwXjbJLcqDy6VGeqkjif0xpLDX2ZC4pVsGbEp1dU0hOPTWwfDH5rEv22E32kjzXIzthbz+FA3Hf4ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734237920; c=relaxed/simple;
	bh=YHgYCgJVzskQKdC5B2HeAskOqBwav2Wn3u39Kf0CAqI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Vjf/QWfDGzvRzxj4Y+0uz87P6NebUUgwku+leQvgaBFPPX4NNP+p3sgqDcK6oX5yD/rBDHktnBxH/m5ZzPs0/3dK6UCXIpGqTBgys+ZJ8NOXObCSEMuEqPghN56mxDL1rF33OevIoT0MgEqXVXUX34k43doO3ziwDJ4nEK/qOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a81684bac0so61269125ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Dec 2024 20:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734237918; x=1734842718;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qm2V9S7qyWVOnFC9225F08hc4yEndo4P5/NgAPr2gI0=;
        b=EFQzhQg2/mJgwDXkTZelszW4TjlgS8a4dCwDwT3aF1TBdr2SpBV+QQz0h9F5oeLUek
         1+BQCaCJ1rbY4aT5umBmT4+Cy33fTIHHO3h0RGKmm1ITP5PHKe0wWZmJ77JjTqU1z+Lp
         Usns2ynUU3/aecgsGsoggah5v1OhDt+AdJGtXCXmNM/3B/rpJ4yjHk4yWd2JRhUc/IKI
         3XDmZgnlkd4UMuABjegS65DuENS0lQVl1k5Fk9s4HJMbVAM/FTS+kciga0NsVDP+VYU3
         u+7XmOse38EhGJrpm5MgDcyldBvYC9L1HIhlxBCL3CsX7ZvBN6d07KsoMHMY9GGHdqmJ
         hYwg==
X-Forwarded-Encrypted: i=1; AJvYcCU/pNwth4Z50niTlzKQWUkXAZ+/sQTFdvaCk2JCvsiPk77f3Dc8QHyno5elTv4CChpYM+FETI6h3q/CGQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwaKCd9vBjHaLOCByuDlggotNOD7ZisJfruXcgqNNeDvkJLQdIj
	+BIosVtRbehtHoet7aUrixgiYngMlK/Jk53vrV9krV2qVNZupFm7t69QH05tMxrCyPj7xYeVML9
	8HsmRmFP0bmtBj0UavlaM6EdPNDv6++GGY7akGrwkoY58Pm97Vnfygak=
X-Google-Smtp-Source: AGHT+IHy7fLsUDEi1pz8Je7bgsDb5MfEA0n4VQORjEjWU7gSDMrKe7DVWnGVs5BAWYZNIJcPVbFXSD8rPo2xko+pS0TkTDTPF9vM
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2407:b0:3a7:e539:c27b with SMTP id
 e9e14a558f8ab-3aff7f16c74mr86044035ab.17.1734237918024; Sat, 14 Dec 2024
 20:45:18 -0800 (PST)
Date: Sat, 14 Dec 2024 20:45:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675e5ede.050a0220.37aaf.00ed.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_commit_truncate
From: syzbot <syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    af2ea8ab7a54 Add linux-next specific files for 20241205
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=131738f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=76f158395f6f15fd
dashboard link: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1100ccdf980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d13544580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8af0861258fa/disk-af2ea8ab.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ffb38cf7a344/vmlinux-af2ea8ab.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6fbd2e50358a/bzImage-af2ea8ab.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/cd426657b15b/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b178f8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=107178f8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b178f8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:686!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5831 Comm: syz-executor319 Not tainted 6.13.0-rc1-next-20241205-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_new_path fs/ocfs2/alloc.c:686 [inline]
RIP: 0010:ocfs2_commit_truncate+0x2547/0x2550 fs/ocfs2/alloc.c:7234
Code: 24 08 e8 ec 4c 7c fe e9 bb fb ff ff e8 a2 f3 15 fe 89 de 48 c7 c7 20 d2 e1 8e e8 74 7e 74 01 e9 c6 fb ff ff e8 8a f3 15 fe 90 <0f> 0b e8 b2 7d 42 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003be71a0 EFLAGS: 00010293
RAX: ffffffff83896896 RBX: 0000000000000138 RCX: ffff88807f9c8000
RDX: 0000000000000000 RSI: 0000000000000138 RDI: 0000000000000004
RBP: ffffc90003be74d0 R08: ffffffff83894758 R09: 0000000000000000
R10: ffffc90003be7380 R11: fffff5200077ce72 R12: dffffc0000000000
R13: 1ffff9200077ce54 R14: ffff888072c9e658 R15: 000000000000000d
FS:  0000555569c22380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555569c33738 CR3: 0000000075f4a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_truncate_for_delete fs/ocfs2/inode.c:623 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:790 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x1c46/0x4630 fs/ocfs2/inode.c:1216
 evict+0x4e8/0x9a0 fs/inode.c:796
 d_delete_notify include/linux/fsnotify.h:332 [inline]
 vfs_rmdir+0x3d7/0x510 fs/namei.c:4407
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb3f9c8cd47
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 54 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcf36a1788 EFLAGS: 00000207 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb3f9c8cd47
RDX: 0000000000008890 RSI: 0000000000000000 RDI: 00007ffcf36a2930
RBP: 0000000000000065 R08: 0000555569c3379b R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000207 R12: 00007ffcf36a2930
R13: 0000555569c33740 R14: 431bde82d7b634db R15: 00007ffcf36a4ab0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_new_path fs/ocfs2/alloc.c:686 [inline]
RIP: 0010:ocfs2_commit_truncate+0x2547/0x2550 fs/ocfs2/alloc.c:7234
Code: 24 08 e8 ec 4c 7c fe e9 bb fb ff ff e8 a2 f3 15 fe 89 de 48 c7 c7 20 d2 e1 8e e8 74 7e 74 01 e9 c6 fb ff ff e8 8a f3 15 fe 90 <0f> 0b e8 b2 7d 42 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003be71a0 EFLAGS: 00010293
RAX: ffffffff83896896 RBX: 0000000000000138 RCX: ffff88807f9c8000
RDX: 0000000000000000 RSI: 0000000000000138 RDI: 0000000000000004
RBP: ffffc90003be74d0 R08: ffffffff83894758 R09: 0000000000000000
R10: ffffc90003be7380 R11: fffff5200077ce72 R12: dffffc0000000000
R13: 1ffff9200077ce54 R14: ffff888072c9e658 R15: 000000000000000d
FS:  0000555569c22380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555569c33738 CR3: 0000000075f4a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
