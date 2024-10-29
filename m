Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11276207A01
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Oct 2024 23:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243135; cv=none; b=RVKuvobQKoD/3LAOkfqxEatcNxnaVRzw8kObDoW6RyGPY4naLxlpHA21rgibhZrPr1URAgaJfp/G2L1jgyFtk4XLOyuNhE4/n1hfeH26bbssKzn+9/BedqN9e8x2HyTMfWepNtstWlPcRu+KR9W5kUJX8rmA0zLW03gyIPnW6Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243135; c=relaxed/simple;
	bh=W6eAfwU4ZYAYVEV9yL7ymzhh0guUr/NGWlUgExP+tJM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ri++0iBWEJKHYZLW/Hb0QuXGUP2U8Y0g7IBPnmDlnbBY946orD/kcvZNC6S+LJLEhPA1UvEe/OqY7+CsF+d8eppl0gqxVilWOB1Pab6R56ZWxPoSrVm1CuR6qDTadlY92n5eoS+LQmjMY2se8cD3XLwQ10omAtCwC1Nfz+rAoVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3cb771556so52810215ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Oct 2024 16:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243132; x=1730847932;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BSPUuJJ+DkuJU40yALrJvhSsilw5ZuPowj+91VKTDbE=;
        b=OoLcnhbrftroBGSFjxITHIbY+Inv+/Q9AdmxNJb+3k47PvRO3wzmtYBCWu6Zn+NwTK
         Y25cRJp8OrMiX+K/z1GIeMDKPcGUe6Rc8G3OYtbzsx9yrqXpZixZGexmy7dcOUcQVNYm
         T5HRSwoB9sleJ50AhwHKarW54lCNGP0YC05koaz0Y9j3TOATLEieRuhMhc0Djx6zecIX
         hCkTBt+4u3lH5I0U7NlNHysW7pzW4TMH2hCdfq/7ZJbEB7sdn4YTn2uVa/V5U3Uj6mu6
         G3YPdaNaqHKPAslRT5EejKX2yjDsFp23vUZ1WHsvcv1mpWRjV0sniJ2WACGoG/RP+U05
         jSCw==
X-Forwarded-Encrypted: i=1; AJvYcCUAqXN6xocmaIRHzY3vQhL1aSkVpIO4KVoa3fUjDO//ZG8WjnHwKPiHdPu80xpNvdHKs+fOzfY7p+voOw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb5ZMOC019lrQM8pkVX8Q5PaH0SgSA8w2an7iISUodgE4xsq5v
	K20aOWGcj8Wsu6ROFZ46CyzEtA5Hqdwmhx+sV9MTliqGOXYHsr1UGqBVxB9ZyAjEVIEtySnWe5v
	IAoJl6x0Djvk77fs4IpD+JyvlZQuKVg48jrdKyqaSOGU5k6lWLoSIhrE=
X-Google-Smtp-Source: AGHT+IGSbJIpJPyZyyURIDVCQgOWUPyda7b5ZCDQcQGDJR+SeN0kqJTKbTNOmVvWpISl8xfqq0TWXurF5HwokLz83mv8Wu/vrr4t
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c6:b0:39d:2939:3076 with SMTP id
 e9e14a558f8ab-3a4ed3669d1mr130336055ab.25.1730243132229; Tue, 29 Oct 2024
 16:05:32 -0700 (PDT)
Date: Tue, 29 Oct 2024 16:05:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67216a3c.050a0220.24951d.007b.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in ocfs2_trim_fs_lock_res_init
From: syzbot <syzbot+ebb818a7a0f6d899fd31@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ae90f6a6170d Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10d78230580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd919c0fc1af4272
dashboard link: https://syzkaller.appspot.com/bug?extid=ebb818a7a0f6d899fd31
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/00df9f52ecde/disk-ae90f6a6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b3072e6045dd/vmlinux-ae90f6a6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/947413a59298/bzImage-ae90f6a6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ebb818a7a0f6d899fd31@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 0 PID: 10708 at kernel/locking/mutex.c:587 __mutex_lock_common kernel/locking/mutex.c:587 [inline]
WARNING: CPU: 0 PID: 10708 at kernel/locking/mutex.c:587 __mutex_lock+0xc41/0xd70 kernel/locking/mutex.c:752
Modules linked in:
CPU: 0 UID: 0 PID: 10708 Comm: syz.3.583 Not tainted 6.12.0-rc4-syzkaller-00161-gae90f6a6170d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:587 [inline]
RIP: 0010:__mutex_lock+0xc41/0xd70 kernel/locking/mutex.c:752
Code: 0f b6 04 20 84 c0 0f 85 18 01 00 00 83 3d f6 34 55 04 00 75 19 90 48 c7 c7 00 b5 0a 8c 48 c7 c6 a0 b5 0a 8c e8 00 fd 8e f5 90 <0f> 0b 90 90 90 e9 bd f4 ff ff 90 0f 0b 90 e9 cf f8 ff ff 90 0f 0b
RSP: 0018:ffffc900046377c0 EFLAGS: 00010246
RAX: 63f6062096e8e400 RBX: 0000000000000000 RCX: ffff888067c8bc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90004637918 R08: ffffffff8155d322 R09: 1ffff110170e519a
R10: dffffc0000000000 R11: ffffed10170e519b R12: dffffc0000000000
R13: ffff888061b3cdf0 R14: 0000000000000000 R15: ffff888020ef6000
FS:  00007f6e8a0ae6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcbf95ff000 CR3: 000000007c2b6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_trim_fs_lock_res_init+0x35/0x4d0 fs/ocfs2/dlmglue.c:702
 ocfs2_trim_fs+0x13c/0x2940 fs/ocfs2/alloc.c:7662
 ocfs2_ioctl+0x71a/0x7d0 fs/ocfs2/ioctl.c:936
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6e8937e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6e8a0ae038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6e89535f80 RCX: 00007f6e8937e719
RDX: 0000000020000000 RSI: 00000000c0185879 RDI: 0000000000000004
RBP: 00007f6e893f132e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f6e89535f80 R15: 00007ffe0daebe48
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
