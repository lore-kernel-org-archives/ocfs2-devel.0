Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1180B2BE7AB
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Jan 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769154632; cv=none; b=lxGKgfmRUCZuYe2VWkDeCq1+fePvwNjNPt6H/6WWuKEEq08sa0AGn3vwgqHVyj96Bdh4It5lA24ZWMyq7hmhC8TcBLQtqPUbguw5BPPF1hI7ZSrxmSwlKdZB9TJVudptH6LsBBNawU1kNvzorFWAHK4OtUhJTM38nX1HljIiw3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769154632; c=relaxed/simple;
	bh=8iH7CqwviB2OTOwpaUhEQNzIcPwD6MVdvaK3KqBgvn0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FTxrB2klkcU97HVTpLAVRh7+7M/yqTru/++n0ovO0UZKTqj7DMTYfHOrZLvCFSRAf+TbQX2PT/wBE6p6vhkYwSBpBJRwRB1hi5bqK+cy+8j50ZYLV6lNeXEzsBksemtqGS6yqK+hy00keJLEaNLVqven7dKJ0nIHv2eP4c6RP/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d0fec88cfaso3822651a34.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Jan 2026 23:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769154627; x=1769759427;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jdY517WDjrfNmxiO1M46UIehtw0ZMAldRfRYtjQNweg=;
        b=EtYGmJ9pDlS5ZP+Xy8QW2GD5VkWSl+cdmC3yfeY/jcZa1dZ3xkQfV+AJ8mvZmVO68l
         a0t/L9/ucapVD45KvT1OjdtGfCYclpVQzymOK/Pf++mkMpGEz6KTwJ/nnOqgPeaGd71x
         BsRpVNEoiHD6+3tmeAiy1knivz4E0gV9nwCI1tPQ8zSr343Kk6ClCcmq8vo+2gKDSmIi
         FukOYrXVF8RdLFa6qC3UiGKxtthmegr9JcUhaAqFkwmUVxfkWOopsSEK4TCUNkQx0YO8
         tNgpT2aGV0mi4YE2b0s48LSXed7lBvwVGXsq/0suT3ZCHXhcQIhwNru2LtBXgC7fOTJr
         wnpA==
X-Forwarded-Encrypted: i=1; AJvYcCVA1e5dQFSSzgFWqZXtvsa/yC5hni6nOETYytUlGjPsBot3EuH+TOXKNADwJHuvLZqEZDVOHGkFWFizJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzpbv/kf9f39NdLiMEydu9pVcMVsfDGvuJwIrcq9SbE3LU14jFs
	AQzhhhsvWrgSOMM4xHW/0iBlR45ii6eTyiXx2j2eKupta+l6yLmNdPh5pBeIyyVp/Z0zFE0ulJ4
	DqfTFeYyKj/adRLUwjHxGv+elXvwkTsHjRo7+J16WuYVd0oDyJj8L9P6GfQw=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2219:b0:65d:1e7:9527 with SMTP id
 006d021491bc7-662cab44f8amr1073260eaf.51.1769154627645; Thu, 22 Jan 2026
 23:50:27 -0800 (PST)
Date: Thu, 22 Jan 2026 23:50:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69732843.a70a0220.35de72.0005.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING: locking bug in ocfs2_inode_lock_full_nested
 (2)
From: syzbot <syzbot+fa955ec87d549a2fa2fc@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    24d479d26b25 Linux 6.19-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13558bfc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=125beb5080319baf
dashboard link: https://syzkaller.appspot.com/bug?extid=fa955ec87d549a2fa2fc
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa67e3d875aa/disk-24d479d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9e8bfd6d7919/vmlinux-24d479d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/00af377d85ac/bzImage-24d479d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa955ec87d549a2fa2fc@syzkaller.appspotmail.com

loop2: detected capacity change from 0 to 1024
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(!test_bit(class_idx, lock_classes_in_use))
WARNING: kernel/locking/lockdep.c:5207 at __lock_acquire+0x183b/0x2890 kernel/locking/lockdep.c:5207, CPU#0: syz.2.15272/17180
Modules linked in:
CPU: 0 UID: 0 PID: 17180 Comm: syz.2.15272 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__lock_acquire+0x1842/0x2890 kernel/locking/lockdep.c:5207
Code: 89 0e 03 85 c0 74 0d 83 3d ba 4a ef 0e 00 0f 84 e7 0a 00 00 90 31 c0 e9 5a fa ff ff 48 8d 3d 55 65 f2 0e 48 c7 c6 78 b3 bd 8d <67> 48 0f b9 3a e9 b4 ec ff ff 44 8b 0d 8d 4a ef 0e 45 85 c9 0f 85
RSP: 0018:ffffc900203cf6f0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000d3d9000
RDX: 0000000000080000 RSI: ffffffff8dbdb378 RDI: ffffffff908c4c00
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: ffff888047dd4830 R12: ffff888047dd3d00
R13: 0000000000000004 R14: ffff888047dd4830 R15: 0000000000000001
FS:  00007fc5673f66c0(0000) GS:ffff8881248f2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000005140 CR3: 000000007c48e000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 ocfs2_is_hard_readonly fs/ocfs2/ocfs2.h:665 [inline]
 ocfs2_inode_lock_full_nested+0x101/0x1f40 fs/ocfs2/dlmglue.c:2446
 ocfs2_inode_lock_tracker+0x20f/0x6e0 fs/ocfs2/dlmglue.c:2691
 ocfs2_permission+0xcf/0x1c0 fs/ocfs2/file.c:1355
 do_inode_permission fs/namei.c:526 [inline]
 inode_permission+0x400/0x640 fs/namei.c:596
 xattr_permission+0x1ad/0x240 fs/xattr.c:155
 vfs_getxattr+0xa4/0x290 fs/xattr.c:434
 do_getxattr+0x259/0x360 fs/xattr.c:787
 filename_getxattr+0xe9/0x1a0 fs/xattr.c:817
 path_getxattrat+0x203/0x2d0 fs/xattr.c:859
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc56918f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc5673f6038 EFLAGS: 00000246 ORIG_RAX: 00000000000000bf
RAX: ffffffffffffffda RBX: 00007fc5693e5fa0 RCX: 00007fc56918f749
RDX: 0000000000000000 RSI: 0000200000000b00 RDI: 0000200000005140
RBP: 00007fc569213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc5693e6038 R14: 00007fc5693e5fa0 R15: 00007ffe39e83ee8
 </TASK>
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	85 c0                	test   %eax,%eax
   2:	74 0d                	je     0x11
   4:	83 3d ba 4a ef 0e 00 	cmpl   $0x0,0xeef4aba(%rip)        # 0xeef4ac5
   b:	0f 84 e7 0a 00 00    	je     0xaf8
  11:	90                   	nop
  12:	31 c0                	xor    %eax,%eax
  14:	e9 5a fa ff ff       	jmp    0xfffffa73
  19:	48 8d 3d 55 65 f2 0e 	lea    0xef26555(%rip),%rdi        # 0xef26575
  20:	48 c7 c6 78 b3 bd 8d 	mov    $0xffffffff8dbdb378,%rsi
* 27:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2c:	e9 b4 ec ff ff       	jmp    0xffffece5
  31:	44 8b 0d 8d 4a ef 0e 	mov    0xeef4a8d(%rip),%r9d        # 0xeef4ac5
  38:	45 85 c9             	test   %r9d,%r9d
  3b:	0f                   	.byte 0xf
  3c:	85                   	.byte 0x85


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
