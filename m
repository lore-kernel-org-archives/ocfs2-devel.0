Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D669F4FA
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726845685; cv=none; b=Xk43t0pqcUysySqRoaJXHGnoDgTPLrPnXChESc3UcmVKWo3wxw2aWUu8VZkmu4tZT0coJ/0hucUV3KwmnAJNZtkYrErHuJc7E39tdXxvRvIaTecvnrX1ZbfpFkpeV51w7PNyFis6NVVLsNMakYw8pzYfk7+2XHONi4g/EQJdIb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726845685; c=relaxed/simple;
	bh=ZKN/Jx0Cgg3E49vF+Ha0Y1UmXQXpo/qvF2nu4rNnzQo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PdHNj6Ck9VXPwQ1I5PtKiMP184xVCXmef8xahA/pB7vimcx2rdHCaQUCyhOfJOHICNyFJWWsVJXoiYsBIg6nH/KwKYX0Ap8crw1rXNKluhqDPpea9VG/v27K4v2JNcM0sNR3h8PNGE0NEm9x9uQGONVSCt/c4uDnwKs53GrHNbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a09da3baa8so29066095ab.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Sep 2024 08:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726845683; x=1727450483;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fr78q/KfWsNOxKd5MbJvZ/ms4Nh44n0ECdqoTNwBoQ0=;
        b=RQ5QscHOUBjtT35vSz0R3iXTlQBG0iLV5srUvyP4d/+kdUq/n8+JilWPmL/ASOV7WY
         CNo5K78ZxS7n38fSHKitLI73fFOV5y8mTMzQ/GQQSBXXv/Ef/VBwTcJeefTVWs2xv79g
         QZGKpTMQ5Zr6TjU8AbGYdk0wyhNT7Q8lejpdSO1n4qb/8b4DssurtgBYSb+2MYS81+Xc
         QBdlwyO0Sj/F1uq0xxvg1n72g2pep5lETvUljBgYE5TXHh25TF4ATk2Cs0f/MkTc6XBI
         e8+xTATZ7X4lkmm6gYHPyQ50CRWH4WaOnxB+x6p/vcvOm6u4kE8KRMUdGkpjdQXNcI58
         jnHg==
X-Forwarded-Encrypted: i=1; AJvYcCWSMsuQ9AdKyHUvF7cGOukK7kcUnfldCYZ/NQE+fZF6h8hH9OTb6K20SissoLQOsryt5RtJ9tdtghUyng==@lists.linux.dev
X-Gm-Message-State: AOJu0YwVxp58TuCKx58pO1j5zUVk2s8ntaoTvkeuubnvIppr6IDVrxSa
	wGC72POfSOq2RqpZfE7ldPSbq6kgUcRdDrzEW4aE1hJURBmzMbInZEGFxhkUmtlwOutjcQMxPIJ
	xQ9QAX9gFhPqhNFNNazT2zM1Hoqn1k3Ip4Ip+H7N12XoazyxBooktnRM=
X-Google-Smtp-Source: AGHT+IFJ7PooyB6Fp2shSustKNFxH99VCZua4ONb9rvwq7nmc5I2bzlN/pp+wfJk9EL3oWivxGfTtqa9mhtGxXQ6zuroZ2O3MP+i
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cc:b0:3a0:a057:6908 with SMTP id
 e9e14a558f8ab-3a0c8a225edmr25801565ab.11.1726845682764; Fri, 20 Sep 2024
 08:21:22 -0700 (PDT)
Date: Fri, 20 Sep 2024 08:21:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ed92f2.050a0220.29194.005a.GAE@google.com>
Subject: [syzbot] [ocfs2?] KMSAN: uninit-value in from_kuid (2)
From: syzbot <syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2004cef11ea0 Merge tag 'sched-core-2024-09-19' of git://gi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1737fb00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea86c03799707382
dashboard link: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ad1607980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b7fb00580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/712bb1e6270f/disk-2004cef1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4c85f46e8c8b/vmlinux-2004cef1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e811c6cc65b/bzImage-2004cef1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2a5b0a53fa65/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
=====================================================
BUG: KMSAN: uninit-value in map_id_up_base kernel/user_namespace.c:355 [inline]
BUG: KMSAN: uninit-value in map_id_up kernel/user_namespace.c:385 [inline]
BUG: KMSAN: uninit-value in from_kuid+0x41e/0x990 kernel/user_namespace.c:433
 map_id_up_base kernel/user_namespace.c:355 [inline]
 map_id_up kernel/user_namespace.c:385 [inline]
 from_kuid+0x41e/0x990 kernel/user_namespace.c:433
 ocfs2_setattr+0x254/0x3140 fs/ocfs2/file.c:1133
 notify_change+0x1a8e/0x1b80 fs/attr.c:503
 do_truncate fs/open.c:65 [inline]
 do_ftruncate+0x8c1/0xbf0 fs/open.c:181
 do_sys_ftruncate fs/open.c:199 [inline]
 __do_sys_ftruncate fs/open.c:207 [inline]
 __se_sys_ftruncate fs/open.c:205 [inline]
 __x64_sys_ftruncate+0x133/0x280 fs/open.c:205
 x64_sys_call+0x9e4/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:78
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable newattrs.i created at:
 do_truncate fs/open.c:43 [inline]
 do_ftruncate+0x600/0xbf0 fs/open.c:181
 do_sys_ftruncate fs/open.c:199 [inline]
 __do_sys_ftruncate fs/open.c:207 [inline]
 __se_sys_ftruncate fs/open.c:205 [inline]
 __x64_sys_ftruncate+0x133/0x280 fs/open.c:205

CPU: 0 UID: 0 PID: 5177 Comm: syz-executor217 Not tainted 6.11.0-syzkaller-07337-g2004cef11ea0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
=====================================================


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
