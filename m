Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F041238B7D7
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 03:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356978; cv=none; b=HQ1Lo5S6vHr1hLRbc/7i3e1e9PxGrF6zg3yaB5KxYoezWfvllL0KsD+ImkifjBJMfBvZfhgXHNIfoZscsO2pm2qH9zHnapKjsNJ2R/5hx6tZXPCX6qj2j/yHfJGjqQn6UcP89KGpkH6V1Lq5h+cFzgiTN3bpns82O2mjysUR7bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356978; c=relaxed/simple;
	bh=NA7V7lZWrtyGYE7nNAzfEuCaHe14WCLE+QbbNTTKvyk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ac3I2K8Vtf3naqgPQB1O9psk75r3YlqUN7HZG7frkjdLcYoZcWtddH0LUouRCHCJEkJg77OigZqWRkdwRZD95hBoEr4Ed5aDQ6kZj2Vd4kjqshq15z2MSzMqI/nzxHgb1O9D4cSrHhjY2v7IEDwJ9Mrj+kKZP65J3DYYe+LyCPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7e93d1dd897so2635088a34.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 24 Jun 2026 20:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782356976; x=1782961776;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EZ9CKbVUnzXnBukVOwXZeNPfZ3aYNvxS6k+XTFAFuDU=;
        b=lRKkw/UIR+2UqA0CvX1gtRGncrxeHttLHnTcOccBn9UC20vEY9EStZqEtHYDAOcEtC
         w7We34n8FIW5BFvDdzkUSvIqqVH2+qwMAKHoRXyo4d4tFUyze3dEXZq4JR4ziSyIquXo
         q3is513vRH/EAhEpz5Qu/4RKUliAhgPBnmchTlyPNrzjzmlTIaURD0jfpoIlh73gWkxb
         N9KfxQCUP6S74Z0opoxc5UYs5j6IOIMu5dDeURQInlT+6Kq/Pjc/EWGSvGvZcC7gzeZs
         VcpK5sya9tdq214W4BRC+sNcvzgUBU88Md11B6/eQruVrpiei27jgHsq7o9al07t5QrR
         B6kg==
X-Forwarded-Encrypted: i=1; AFNElJ9QhW4TYI1Zx+sa36y0pRMGVi0Hg0r85baBQfJfzAlKtzlJJuFg966KG0gAbDcZXkOrkxJjB8+nfeVTwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwgNREvZ3wHVA8bMExscSvVCyeswxL+A+cmQQyGT8YUR5xJGr/2
	w98BMzqk2WRMxc9MtiQbo67p8LNgu5xepVyZTLF3zoLEk3Y8JMCPENGpJp3IeW0zE7B559DzjuE
	WiKQFdxK0EyWYp+HATs5gmhJt8WsGUS3d2GGfFShlWivveOqbly1QLvTmcH0=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fcb:b0:491:eac0:d56b with SMTP id
 5614622812f47-4921890a19amr801148b6e.38.1782356975991; Wed, 24 Jun 2026
 20:09:35 -0700 (PDT)
Date: Wed, 24 Jun 2026 20:09:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3c9bef.cf1c467f.2941c6.0003.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_journal_toggle_dirty (2)
From: syzbot <syzbot+b79139db690388bc53ce@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    1a3746ccbb0a Merge tag 'strncpy-removal-v7.2-rc1' of git:/.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D177187b6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df5fece1a9477c32=
1
dashboard link: https://syzkaller.appspot.com/bug?extid=3Db79139db690388bc5=
3ce
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-=
1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-1a3746cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/376997b632fc/vmlinux-=
1a3746cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0920309c4838/bzI=
mage-1a3746cc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+b79139db690388bc53ce@syzkaller.appspotmail.com

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
ocfs2: Slot 0 on device (7,0) was already allocated to this node!
JBD2: Ignoring recovery information on journal
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_bl=
ock *, struct buffer_head *): Invalid dinode #75: signature =3D d=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=0B
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is=
 unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5323,0):ocfs2_read_journal_inode:1661 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_mark_dead_nodes:1937 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_check_volume:2419 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_check_volume:2431 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_mount_volume:1763 ERROR: status =3D -30
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_bl=
ock *, struct buffer_head *): Invalid dinode #71: signature =3D d=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=07
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is=
 unmounted.
(syz.0.0,5323,0):ocfs2_assign_bh:2417 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_inode_lock_full_nested:2512 ERROR: status =3D -30
(syz.0.0,5323,0):ocfs2_shutdown_local_alloc:412 ERROR: status =3D -30
------------[ cut here ]------------
kernel BUG at fs/ocfs2/journal.c:1029!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5323 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2 04/01/2014
RIP: 0010:ocfs2_journal_toggle_dirty+0x345/0x350 fs/ocfs2/journal.c:1029
Code: ff e8 9f be e3 07 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 56 fe ff ff =
4c 89 ff e8 86 c7 68 fe e9 49 fe ff ff e8 8c af f9 fd 90 <0f> 0b 66 0f 1f 8=
4 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000ded6fa0 EFLAGS: 00010293
RAX: ffffffff83cc9574 RBX: 1ffff110087936e5 RCX: ffff888038a40000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000ded7070 R08: ffffffff9031d0f7 R09: 1ffffffff2063a1e
R10: dffffc0000000000 R11: fffffbfff2063a1f R12: 0000000000000001
R13: ffff8880530f7600 R14: ffff88803f40b000 R15: 0000000000000000
FS:  00007ff2dfa446c0(0000) GS:ffff88808c848000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563130104b30 CR3: 0000000012505000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_journal_shutdown+0x540/0xb70 fs/ocfs2/journal.c:1111
 ocfs2_mount_volume fs/ocfs2/super.c:1784 [inline]
 ocfs2_fill_super+0x5a04/0x6860 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff2deb9e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff2dfa43e18 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ff2dfa43ea0 RCX: 00007ff2deb9e0ca
RDX: 0000200000004440 RSI: 0000200000000040 RDI: 00007ff2dfa43e60
RBP: 0000200000004440 R08: 00007ff2dfa43ea0 R09: 00000000000008c0
R10: 00000000000008c0 R11: 0000000000000246 R12: 0000200000000040
R13: 00007ff2dfa43e60 R14: 0000000000004451 R15: 0000200000000080
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_journal_toggle_dirty+0x345/0x350 fs/ocfs2/journal.c:1029
Code: ff e8 9f be e3 07 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 56 fe ff ff =
4c 89 ff e8 86 c7 68 fe e9 49 fe ff ff e8 8c af f9 fd 90 <0f> 0b 66 0f 1f 8=
4 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000ded6fa0 EFLAGS: 00010293
RAX: ffffffff83cc9574 RBX: 1ffff110087936e5 RCX: ffff888038a40000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000ded7070 R08: ffffffff9031d0f7 R09: 1ffffffff2063a1e
R10: dffffc0000000000 R11: fffffbfff2063a1f R12: 0000000000000001
R13: ffff8880530f7600 R14: ffff88803f40b000 R15: 0000000000000000
FS:  00007ff2dfa446c0(0000) GS:ffff88808c848000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ca07f64168 CR3: 0000000012505000 CR4: 0000000000352ef0


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
