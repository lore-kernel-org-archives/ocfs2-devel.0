Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6947621ABC6
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Feb 2025 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740503844; cv=none; b=IcLu+TQQFycds7y48VH5tc+TJBCyTXipPX6GOMDLqvLP2YgYXAD+chHer8SCmlLw7X4u8T7gUh6m3mCGcC4iC+iDMH4i5OOgS16MLDOInN4vcvsis7C9+H41GbJwOKVqqheUjdqd0Vk1HRL0PrvHw73fFcSbMAx7FwJj3UUUGlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740503844; c=relaxed/simple;
	bh=ZKIhC9tGj97LCEefR0plno0MVzRMvoqNi5sT08auSak=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oeQQSB6zykZR1qqjE3WFUsNox+TAxwobbqrY6Cf+mmdwG4tOQxaFSKA37XKzgCl2jGvvjDF1N7TscFhAw4L/M/+W2fXhfG6HXV0fD9y52cqXIgd2FMo9gFjG6fyvTqrj2Xd9+7JlKIm0TIyjnBH7GIkgrufHOs95F0lNaeeCI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d18700311dso43333375ab.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Feb 2025 09:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740503841; x=1741108641;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAf2iNmrW54MH35CZHWu3bfsqrTAwb5z63zg4OFOcfI=;
        b=qqmOInFIm7+9CrkYW2Oc+t0hzyDWkes2NaolaC3LqiXkWBVp3OA5EfC1hhK5jDMpra
         od1ZHlmNXguIU0TXoEx5sCUm1hCevGofFlKJpVTrZb2q4yKjHfhcNe/MYa/vFA77lqDq
         0ClTM8WA+KMD1xTJMUFHL5VmikLo4XzZnBRIF7By34d4LezwMWLGG9mSeKh6O/uze0cU
         gSp8vO7JwkfzN92jrCozUhm7XggCKefFwQdDOhsqbo1+jfwlM38nqo4W9aNzvp4Vi2QX
         J+Oqi/ubjiTaNJe7z/BAp1+EyKXTRfLxBhYVTkdAyXt+oDFQdBEmSytXvC32pGn1YJHd
         CjlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzmVDbWzAUSB2LsyZjVy5YfY4TgJem7DZ1qmvXD96ooDypcwE1UGgS2wrLbVomjsKWwkZlkn9CHBqeWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxB2tYQhVvDCHkqDS5+HVKLGa6n+sxVfTVH14ydxFXVNMJjHWe3
	E9n0+13gaWMJKmJdYuikPIlKY6Al3o9lXY+HNoSEc45I/MmIJoQM8Hbf951a3OaRXPLhxfDdJ2E
	65/wB5hk6Wd0GRfJW3Q9C27iAN4rLE/fo0cZS9kAlLwKEUF/BdShR6jo=
X-Google-Smtp-Source: AGHT+IFdDKzZ5NbvB5DUxXCpcSvXw7YGHy9buMR7f9g6YDZNRXvauk73Ez4fNf+D3zd4+sZS1363vjJ+T+g8HrKyyKy0+XZhxC4R
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a46:b0:3d1:97dc:2f93 with SMTP id
 e9e14a558f8ab-3d3d1fb3dbfmr3663325ab.20.1740503841520; Tue, 25 Feb 2025
 09:17:21 -0800 (PST)
Date: Tue, 25 Feb 2025 09:17:21 -0800
In-Reply-To: <66f0a364.050a0220.a27de.0009.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bdfb21.050a0220.bbfd1.00ac.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_file
From: syzbot <syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    d082ecbc71e9 Linux 6.14-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b126e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b4c41bdaeea1964
dashboard link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166f77f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b126e4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-d082ecbc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5299c562b1f/vmlinux-d082ecbc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c0bed38fa342/bzImage-d082ecbc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/30f6f2b1247c/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=10b126e4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com

(syz-executor151,5310,0):ocfs2_truncate_file:460 ERROR: bug expression: le64_to_cpu(fe->i_size) != i_size_read(inode)
(syz-executor151,5310,0):ocfs2_truncate_file:460 ERROR: Inode 17058, inode i_size = 0 != di i_size = 281481419161600, i_flags = 0x67bd
------------[ cut here ]------------
kernel BUG at fs/ocfs2/file.c:460!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5310 Comm: syz-executor151 Not tainted 6.14.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_file+0x139f/0x1560 fs/ocfs2/file.c:454
Code: 40 01 00 00 48 c7 c6 46 0d 35 8e ba cc 01 00 00 48 c7 c1 c0 69 69 8c 4d 89 e8 4d 89 f9 50 41 56 e8 d6 96 19 00 48 83 c4 10 90 <0f> 0b e8 4a f1 4b 08 f3 0f 1e fa 65 44 8b 35 aa 7a 47 7c bf 07 00
RSP: 0018:ffffc9000d257280 EFLAGS: 00010282
RAX: 5796f80f25df1300 RBX: ffff888048ec542c RCX: 5796f80f25df1300
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000d2574b0 R08: ffffffff81a113fc R09: 1ffff92001a4adbc
R10: dffffc0000000000 R11: fffff52001a4adbd R12: 1ffff110091d8a84
R13: 00000000000042a2 R14: 0001000180000000 R15: 0000000000000000
FS:  000055558b494380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056519020e6c0 CR3: 0000000043316000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_setattr+0x1890/0x1ef0 fs/ocfs2/file.c:1212
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3451 [inline]
 do_open fs/namei.c:3834 [inline]
 path_openat+0x2e1b/0x3590 fs/namei.c:3989
 do_filp_open+0x27f/0x4e0 fs/namei.c:4016
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1428
 do_sys_open fs/open.c:1443 [inline]
 __do_sys_openat fs/open.c:1459 [inline]
 __se_sys_openat fs/open.c:1454 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff7d0f62e59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffce7922bd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff7d0f62e59
RDX: 000000000000275a RSI: 0000400000000040 RDI: 00000000ffffff9c
RBP: 0000400000000040 R08: 000055558b4954c0 R09: 000055558b4954c0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffce7922c00
R13: 0000400000004500 R14: 00007ffce7922c00 R15: 00007ff7d0fac03b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_file+0x139f/0x1560 fs/ocfs2/file.c:454
Code: 40 01 00 00 48 c7 c6 46 0d 35 8e ba cc 01 00 00 48 c7 c1 c0 69 69 8c 4d 89 e8 4d 89 f9 50 41 56 e8 d6 96 19 00 48 83 c4 10 90 <0f> 0b e8 4a f1 4b 08 f3 0f 1e fa 65 44 8b 35 aa 7a 47 7c bf 07 00
RSP: 0018:ffffc9000d257280 EFLAGS: 00010282
RAX: 5796f80f25df1300 RBX: ffff888048ec542c RCX: 5796f80f25df1300
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000d2574b0 R08: ffffffff81a113fc R09: 1ffff92001a4adbc
R10: dffffc0000000000 R11: fffff52001a4adbd R12: 1ffff110091d8a84
R13: 00000000000042a2 R14: 0001000180000000 R15: 0000000000000000
FS:  000055558b494380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056519020e6c0 CR3: 0000000043316000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
