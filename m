Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266FD168DA
	for <ocfs2-devel@lists.linux.dev>; Fri,  1 Nov 2024 20:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730494290; cv=none; b=gQsDVNrgb3irVN5CjhpAA0EEydwc6eKQMaFqqNAx0v9tMxT2YGzJYvJrvYMkmRsCUINPISC1L9Zny6pScHuMgXV4UBXNEejeAmP/aj7PLVfxCxQHYX6lnu8hE1YcfBOPVOzrF2/Jj5ZbuhMhV5l9vmaYX8Q/fuI8LvFH1dfcjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730494290; c=relaxed/simple;
	bh=hfJrp5RXJzlmrok5eGjT5/j/5SjyNfDgceV9I9OuEVg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZXFIfFe/aD5wLQTSXZu9iOUJzINQAua14R22a87e+ABktt+fZNgA/zhBEhhS8BRGzjPCRh1Oidn8ZDPMq9oIh3xj0ZuqtpzqtJreX4RFx1te1yIreh7fAB7rLsZ2wUiavow700oV1vBoJq/qcVsuRvHXRi02khgxWM9in6bpTRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83ab369a523so259995439f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 01 Nov 2024 13:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730494288; x=1731099088;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qJ5AkDEo06udVkkj5suyqB4HGMHpVlnztSeXnF3WmT4=;
        b=oNvmTpdh7ITjGOAitcDwV+NGW5eMaTLx737Ipet0SwEy/489FpJKaALSG9gEIsPqzF
         2PDhukI/xo63R/BEE33xKQQRIi3bFTwEYjTe2RpEuBwGXCVJOSryUBW7/09F19pD9PuP
         +Pp6Ugw577/Qu3/YoG05PtV2qb4BHq5ZXYskCY4tkCCk3bk/Kv4vYgrbF1O/go7K+FrD
         kpLJ9XDoiJKSJcaN1j6Up2nLAohqtiUctU0jXua0Gu4iy6zxUZka9dZyld2O0weCLbg3
         /hOu9IpJcE+hhaOTUUEgtQYUZ2VbGuFqMXzAfiYR6bVukl0ZfsDJzFTuXq/ONLkwXu0+
         YNKw==
X-Forwarded-Encrypted: i=1; AJvYcCVmcQBE/AWB+lowv3ViTGAh8lhx52E32PPoGjCxOvUeug/p6Gut6Ditz1us2/X4kTMaMkKWEMw3ftXqaQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn+MWJn6vhV2H/dma57OqoG6Iw1sXu3tXzxINmuGi82L2nJJ6V
	tNorJZeJJnszWbsjH4jwpol5g11MvLFkltCdG+FdB5GXrr/oCvE42JVYIs7I2wGrt3lLd9x+VRJ
	sbxkjj4NYZwA1s9dylDrk/6d8DfXjQsbgP7q1+6cjMxewWza8fsVuZlQ=
X-Google-Smtp-Source: AGHT+IEaPxDXclfpYQQWQvtbYxa6Bovpe69PYyQ/lngKyrUymtBoai0Wed6DrokyvdTEXVXwdN7is/yLqHL9AJ6J4/O9EBaU5J+v
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20cc:b0:3a6:b5b9:3e51 with SMTP id
 e9e14a558f8ab-3a6b5b9415dmr29055875ab.8.1730494288368; Fri, 01 Nov 2024
 13:51:28 -0700 (PDT)
Date: Fri, 01 Nov 2024 13:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67253f50.050a0220.35b515.0179.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_reserve_suballoc_bits
From: syzbot <syzbot+fd05de09d1267725aa95@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    819837584309 Linux 6.12-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1787fe5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aec7739e14231a7
dashboard link: https://syzkaller.appspot.com/bug?extid=fd05de09d1267725aa95
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-81983758.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c67be4ca64cb/vmlinux-81983758.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d6ab06862875/bzImage-81983758.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd05de09d1267725aa95@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 32767
OCFS2: ERROR (device loop0): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode #65: signature = NODE01
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
(syz.0.0,5334,0):ocfs2_find_entry_id:407 ERROR: status = -30
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:804!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5334 Comm: syz.0.0 Not tainted 6.12.0-rc5-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_reserve_suballoc_bits+0x479b/0x4eb0 fs/ocfs2/suballoc.c:804
Code: e1 07 80 c1 03 38 c1 0f 8c 75 dd ff ff 48 8d bc 24 b0 01 00 00 e8 95 c8 68 fe e9 63 dd ff ff e8 2b 19 31 08 e8 06 0b ff fd 90 <0f> 0b e8 fe 0a ff fd 48 c7 c7 00 a8 e3 8e 48 8b 74 24 28 48 89 da
RSP: 0018:ffffc9000d4cec80 EFLAGS: 00010283
RAX: ffffffff8395cd8a RBX: 0000000000000001 RCX: 0000000000040000
RDX: ffffc9000ddd1000 RSI: 000000000000211e RDI: 000000000000211f
RBP: ffffc9000d4cf170 R08: ffffffff83958865 R09: 1ffffffff203a065
R10: dffffc0000000000 R11: fffffbfff203a066 R12: 1ffff92001a99e10
R13: ffff888012259c00 R14: ffff88801fd83e00 R15: dffffc0000000000
FS:  00007fef2b9c46c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef1ffff000 CR3: 000000001cdca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_reserve_cluster_bitmap_bits fs/ocfs2/suballoc.c:1132 [inline]
 ocfs2_reserve_clusters_with_limit+0x3dd/0xb60 fs/ocfs2/suballoc.c:1177
 ocfs2_mknod+0x1486/0x2b40 fs/ocfs2/namei.c:352
 ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fef2ab7e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fef2b9c4038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fef2ad36058 RCX: 00007fef2ab7e719
RDX: 0000000000000004 RSI: 0000000000060142 RDI: 0000000020000140
RBP: 00007fef2abf132e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fef2ad36058 R15: 00007ffcfafd11e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_reserve_suballoc_bits+0x479b/0x4eb0 fs/ocfs2/suballoc.c:804
Code: e1 07 80 c1 03 38 c1 0f 8c 75 dd ff ff 48 8d bc 24 b0 01 00 00 e8 95 c8 68 fe e9 63 dd ff ff e8 2b 19 31 08 e8 06 0b ff fd 90 <0f> 0b e8 fe 0a ff fd 48 c7 c7 00 a8 e3 8e 48 8b 74 24 28 48 89 da
RSP: 0018:ffffc9000d4cec80 EFLAGS: 00010283
RAX: ffffffff8395cd8a RBX: 0000000000000001 RCX: 0000000000040000
RDX: ffffc9000ddd1000 RSI: 000000000000211e RDI: 000000000000211f
RBP: ffffc9000d4cf170 R08: ffffffff83958865 R09: 1ffffffff203a065
R10: dffffc0000000000 R11: fffffbfff203a066 R12: 1ffff92001a99e10
R13: ffff888012259c00 R14: ffff88801fd83e00 R15: dffffc0000000000
FS:  00007fef2b9c46c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560fa8a720b8 CR3: 000000001cdca000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
