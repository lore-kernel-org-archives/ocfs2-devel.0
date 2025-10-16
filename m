Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C020221CC5A
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760611832; cv=none; b=C9jf8ig3xayHfZnuM6tGufRTky2g5zmo80sQU9K+5kG9tX9riSkNQ+XqduMho2ClXtn2PNDXJPIO1Mk3aYCXTG+Ykr5rvbvfqBb8FwFTJDXzl/U1x7pA1zG+dHgCK1DRt65ULA6KA6c91rDP4/nOanesRAUFRBTjUS7NGTWbm8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760611832; c=relaxed/simple;
	bh=iUimImXCJHRuxM+ASUI/KeliJruswQ7KPnJH+9RiblI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MeW67/j3GtqzEbM/Ix1PAkd8qT7+vGPfT/UqGj6u5MepnyKhtYTCDx8HalBDH+6eaesTJSbrKji+86J/IIE4K0nx+yJNQwt9R0FKbTl3hqy1bb7/GnlijZ7MPeOzHv/7thxoHqn4Sme88fTA2mgsQFtvU3JBmFJxUDW1iWBkL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-886e347d2afso58247939f.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 03:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760611830; x=1761216630;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2VRpPqbYQd8sxTXcJe2EMXYwiy1HHrToaw6ZD3UJcaQ=;
        b=PLpvGvnWdhXQ0LVR5T2zZLz1g3Zg2TUumNe+DeBgJYoVY5l+GLwchqaBPkaJkcxT5k
         Njfp/JxChqmHROGbcPb/UBsGd720GvQKUikroM92LCluEgNLf+rkEzY3GdiJN77rTfPV
         fvSJA+E8XsmxBoWxuHj/9kBDLKBrjZO4MTJwCxfTIb9d2vPTOl1yx7E9jUa7iyGoAtFJ
         lHCrYmCtucX8VIrKClfoo1yl1nBsGOM9XfnwMRrbRyeHmpP8wt9b1HrAcNZogILcQHgt
         QebpYxK7+2sfrKCm8NU8YRugLBR4ryELjcbcS1pdhT4FMwwnr9kSWG7tHVPugUTjTu90
         ymdg==
X-Forwarded-Encrypted: i=1; AJvYcCUCbTElMtYMGQDfK2QIji2FU5+9GSrI0dHHRKOq1OYjbAVv738LweXOJmRF/qoFUFc4SOkaNjDpuwXaYw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxOGzw/rtWskoW6CAd02FCqFMxw0qNVZQXKWT0jXAlTA0ymnNLO
	O03fr1BZ+ACtXxn/5wsTSIsRO8tfIRelQ8hR2+w83MYmHsFfFrArpkQimZxZGX7+K8H6PVr+Thh
	jlTH7p2tFmUb3lXfricwL9IpGXCTuD45TQNewtu6TpEF7/mSj/hz29lJVoRw=
X-Google-Smtp-Source: AGHT+IGm2O7kHHj//MbzVo5A06W3sAnwrvGAl6cnxYTO2nfeZ1rZIMSRkjGT+i+7SOZFbE1x4OZFZJJ7XIOldYDMfW3uCZVmE2sq
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1529:b0:3f3:4562:ca92 with SMTP id
 e9e14a558f8ab-42f8736a83fmr375595265ab.10.1760611829829; Thu, 16 Oct 2025
 03:50:29 -0700 (PDT)
Date: Thu, 16 Oct 2025 03:50:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f0cdf5.050a0220.91a22.0409.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_dinode_sanity_check
From: syzbot <syzbot+53383c9029311788bacc@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    98906f9d850e Merge tag 'rtc-6.18' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120a3892580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2d7b4143707d3a0
dashboard link: https://syzkaller.appspot.com/bug?extid=53383c9029311788bacc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-98906f9d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d82186923244/vmlinux-98906f9d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a23e980d2d8e/bzImage-98906f9d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53383c9029311788bacc@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5378,0):ocfs2_check_set_options:1244 ERROR: Invalid heartbeat mount options
loop0: detected capacity change from 32768 to 32752
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode #17059: signature = 
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5378,0):ocfs2_assign_bh:2417 ERROR: status = -30
(syz.0.0,5378,0):ocfs2_inode_lock_full_nested:2512 ERROR: status = -30
(syz.0.0,5378,0):ocfs2_inode_lock_tracker:2694 ERROR: status = -30
(syz.0.0,5378,0):ocfs2_xattr_get:1335 ERROR: status = -30
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:238!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5378 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_dinode_sanity_check+0x8e/0x90 fs/ocfs2/alloc.c:238
Code: ff 89 c6 e8 94 f7 21 fe 85 db 75 18 e8 4b f3 21 fe 31 c0 5b 41 5e e9 51 84 b2 07 cc e8 3b f3 21 fe 90 0f 0b e8 33 f3 21 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d2c63a8 EFLAGS: 00010283
RAX: ffffffff839e605d RBX: 00000000ffffffff RCX: 0000000000100000
RDX: ffffc9000e172000 RSI: 0000000000003cbb RDI: 0000000000003cbc
RBP: ffffc9000d2c6570 R08: ffff888000eb8000 R09: 0000000000000006
R10: 00000000fffffffc R11: ffffffff839e5fd0 R12: ffff88803209a790
R13: 1ffff92001a58c84 R14: dffffc0000000000 R15: ffffc9000d2c7160
FS:  00007f71f71ed6c0(0000) GS:ffff88808d301000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71f71cbfc8 CR3: 0000000042704000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_et_sanity_check fs/ocfs2/alloc.c:558 [inline]
 ocfs2_remove_rightmost_path+0xfd/0x990 fs/ocfs2/alloc.c:3040
 ocfs2_rotate_tree_left+0x742/0xd40 fs/ocfs2/alloc.c:3225
 ocfs2_truncate_rec+0x1411/0x1af0 fs/ocfs2/alloc.c:5510
 ocfs2_remove_extent+0xdfc/0x2020 fs/ocfs2/alloc.c:5589
 ocfs2_remove_btree_range+0xdef/0x1540 fs/ocfs2/alloc.c:5778
 ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7372
 ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4134
 do_filp_open+0x1fa/0x410 fs/namei.c:4161
 do_sys_openat2+0x121/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_creat fs/open.c:1530 [inline]
 __se_sys_creat fs/open.c:1524 [inline]
 __x64_sys_creat+0x8f/0xc0 fs/open.c:1524
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f71fad8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f71f71ed038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f71fafe5fa0 RCX: 00007f71fad8eec9
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000200000000080
RBP: 00007f71fae11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f71fafe6038 R14: 00007f71fafe5fa0 R15: 00007ffdd473cfa8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_dinode_sanity_check+0x8e/0x90 fs/ocfs2/alloc.c:238
Code: ff 89 c6 e8 94 f7 21 fe 85 db 75 18 e8 4b f3 21 fe 31 c0 5b 41 5e e9 51 84 b2 07 cc e8 3b f3 21 fe 90 0f 0b e8 33 f3 21 fe 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d2c63a8 EFLAGS: 00010283
RAX: ffffffff839e605d RBX: 00000000ffffffff RCX: 0000000000100000
RDX: ffffc9000e172000 RSI: 0000000000003cbb RDI: 0000000000003cbc
RBP: ffffc9000d2c6570 R08: ffff888000eb8000 R09: 0000000000000006
R10: 00000000fffffffc R11: ffffffff839e5fd0 R12: ffff88803209a790
R13: 1ffff92001a58c84 R14: dffffc0000000000 R15: ffffc9000d2c7160
FS:  00007f71f71ed6c0(0000) GS:ffff88808d301000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f71f71cbfc8 CR3: 0000000042704000 CR4: 0000000000352ef0


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
