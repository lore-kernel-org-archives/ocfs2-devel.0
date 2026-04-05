Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFF63B1B3
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Apr 2026 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775413533; cv=none; b=VMXMZyjPxHluzK68yculQR/ppBWxLoORIk6G4ppfWP1lapt6mII/0nEyhzTEAeKhw8RDpc1uMlJZnOVjzuHr0R4X+sDerimnO92/buGqLompJhRGpKOthGjaDAbNmwF5BEAUeW/zsErknOMeS1HVabxfgaNnpd6SDkmOMsyO5rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775413533; c=relaxed/simple;
	bh=3MP8+xtIHpAFuSaWsbUthZXG4XGmGYJ2fzWKryAU/eE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IDpKUUGw3s1Rq0qibsec/L/FEqlIfRuEhNadxpR85wcaINje7OPiDgNRzz5R57ElwOWp6Ule4d5+iA1KZ0MEDSN1gF4PRzCkTZZYfg9S2LXVAWzxCmrzr9bhD8yNL9P/NA5k7fEEh/NJWz1dUYDIJro5UW9fRj3wNkA7JdiaYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7d7e995a87cso10560046a34.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Apr 2026 11:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775413530; x=1776018330;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9tN8zKwuveEo7CHZoqJqzPXz2bqr9oUKmwyNIKP/jM=;
        b=ZXWn0JXpUs8L0wsk9XAJ+gY5ujnEmadN8D4XJ/eUSqyFzoGYGbsle2/clUiswj82iD
         gOMBypcioZXYeT9DREKYXqr/mCDVyfHrwilcP5zAMnEqsah8hLEGnv7rc6KT7UlljUJw
         UCn+y/ANIMPb8khfUF4UVhe44EwAqFoozGw10wYGBmsjTvz7DUs6jAbK/b46Av+XOb9n
         8iAr2ENTr/6Tbvtgg/LRr6ECLBjI7Mthb40vcxhPJSP83tNcUH8I8m9auCrU8EZODaJP
         7CLjnsUjB2tMJtYxLD8wOFTr51m2MAuYNjeX4RSHkQF2sm+Jg8B2dz6+ArD4YrFcn3Gp
         btNg==
X-Forwarded-Encrypted: i=1; AJvYcCUDMFrXGXUYdJHZBKeYeH73PIsqKnxpra/k1YxBLqsldg9WHYY4rNWCANyUXMgZ/OPcBWpPm3KypJr4sQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxO5hWNJKwRrK2oJv4EfeDpgVzuj4s3hOlv2wUrm1diXp6GKFbG
	hkSSEAqqvBZfenFON0RbM9xHuqSkN7d+eYSJxOhpEz1BtP+k42BibKEdkC9LPi8M5GPtf7pyVWD
	kZXEewZXnXbwpmVkGbIDcQZNqq0gvsBQ8UbVTG92wLyWZp5FjEP3WlxhoWFs=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1686:b0:684:bf61:ed2b with SMTP id
 006d021491bc7-684bf61f283mr1919785eaf.14.1775413530562; Sun, 05 Apr 2026
 11:25:30 -0700 (PDT)
Date: Sun, 05 Apr 2026 11:25:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d2a91a.a70a0220.a26f2.002d.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_end_nolock
From: syzbot <syzbot+43869fdbaad383f31077@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    3aae9383f42f Merge tag 'input-for-v7.0-rc6' of git://git.k.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D102a546a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd46eab0cfd31c21=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3D43869fdbaad383f31=
077
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-3aae9383.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c784098744b/vmlinux-=
3aae9383.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4dd41ae9f4b7/bzI=
mage-3aae9383.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+43869fdbaad383f31077@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode=
.
(syz.0.0,5324,0):ocfs2_check_set_options:1244 ERROR: Invalid heartbeat moun=
t options
loop0: detected capacity change from 32768 to 32767
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_bl=
ock *, struct buffer_head *): Invalid dinode #17058: signature =3D 9=EF=BF=
=BD=CC=93
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is=
 unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5324,0):ocfs2_assign_bh:2417 ERROR: status =3D -30
(syz.0.0,5324,0):ocfs2_inode_lock_full_nested:2512 ERROR: status =3D -30
(syz.0.0,5324,0):ocfs2_reflink_inodes_lock:4748 ERROR: status =3D -30
------------[ cut here ]------------
kernel BUG at ./include/linux/highmem.h:577!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2 04/01/2014
RIP: 0010:memcpy_from_folio include/linux/highmem.h:577 [inline]
RIP: 0010:ocfs2_write_end_inline fs/ocfs2/aops.c:1915 [inline]
RIP: 0010:ocfs2_write_end_nolock+0x1760/0x18f0 fs/ocfs2/aops.c:1949
Code: 90 0f 0b e8 52 c5 09 fe 90 0f 0b e8 4a c5 09 fe 48 8b 7c 24 10 48 c7 =
c6 e0 05 12 8c e8 09 1c 6c fd 90 0f 0b e8 31 c5 09 fe 90 <0f> 0b 65 44 8b 2=
5 ea 70 61 0f bf 07 00 00 00 44 89 e6 e8 59 c9 09
RSP: 0018:ffffc9000f1b71e0 EFLAGS: 00010287
RAX: ffffffff83bbff3f RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 0000000000002df5 RDI: 0000000000002df6
RBP: ffffc9000f1b7350 R08: ffffea000049d947 R09: 1ffffd4000093b28
R10: dffffc0000000000 R11: fffff94000093b29 R12: 0000000000001000
R13: 0000000000002000 R14: 0000000000001000 R15: 0000000000000000
FS:  00007f88812346c0(0000) GS:ffff88808ca49000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7aaef4a000 CR3: 000000001245d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_write_end+0x58/0x90 fs/ocfs2/aops.c:2059
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4340
 ocfs2_file_write_iter+0x1663/0x1ed0 fs/ocfs2/file.c:2476
 iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 vfs_copy_file_range+0xb02/0x1370 fs/read_write.c:1634
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f888039c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8881233fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f8880615fa0 RCX: 00007f888039c819
RDX: 0000000000000004 RSI: 00002000000001c0 RDI: 0000000000000005
RBP: 00007f8880432c91 R08: ffffffffa003e45b R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8880616038 R14: 00007f8880615fa0 R15: 00007ffcbc2fcaf8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:memcpy_from_folio include/linux/highmem.h:577 [inline]
RIP: 0010:ocfs2_write_end_inline fs/ocfs2/aops.c:1915 [inline]
RIP: 0010:ocfs2_write_end_nolock+0x1760/0x18f0 fs/ocfs2/aops.c:1949
Code: 90 0f 0b e8 52 c5 09 fe 90 0f 0b e8 4a c5 09 fe 48 8b 7c 24 10 48 c7 =
c6 e0 05 12 8c e8 09 1c 6c fd 90 0f 0b e8 31 c5 09 fe 90 <0f> 0b 65 44 8b 2=
5 ea 70 61 0f bf 07 00 00 00 44 89 e6 e8 59 c9 09
RSP: 0018:ffffc9000f1b71e0 EFLAGS: 00010287
RAX: ffffffff83bbff3f RBX: 0000000000000000 RCX: 0000000000100000
RDX: ffffc90020001000 RSI: 0000000000002df5 RDI: 0000000000002df6
RBP: ffffc9000f1b7350 R08: ffffea000049d947 R09: 1ffffd4000093b28
R10: dffffc0000000000 R11: fffff94000093b29 R12: 0000000000001000
R13: 0000000000002000 R14: 0000000000001000 R15: 0000000000000000
FS:  00007f88812346c0(0000) GS:ffff88808ca49000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bc117cd168 CR3: 000000001245d000 CR4: 0000000000352ef0


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
