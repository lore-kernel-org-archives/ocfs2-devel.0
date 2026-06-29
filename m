Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E8C37A498
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jun 2026 03:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782703407; cv=none; b=g5M526dwdDlpAp8F4FLkyxQDdYQvrYFowpxdJ6LwxzBWwjLwVuuwLa+X/ZBaeZhET8nLVAaAFaoc6NOyrZhs24TyXItB4LIR/ISjz/ebWcQkZvGLLVo1LzFs5CL9ZgdVi/jZRK1JxZVVTlq9ePrQx/3XfJLZeNceyZkn6m5KUxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782703407; c=relaxed/simple;
	bh=55WMwRXmp31W/InbnLOYwF/0KZpPO5G0+YyvN2fh5po=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Y8UtRNxPjicqXuLc2N7PRXZWrNPk5QANKdRyug/tuhE0eFCQVyF5IybsH9ZV1JZxy3Gcx1k/LfbR5tdSSLE1Mf+gGFbXlAFokj1CejqiiWCQmHxC73ln1c0PO8HahqGJlayX/WOARpnQQN3DwKvCrDaIuFFVIgNP0CUOg44GMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-48e2ce64834so3187954b6e.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 28 Jun 2026 20:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782703405; x=1783308205;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b277Hg6OtDoVkxWh+Xx3bSAX5STPViSw7B6zE4/evvs=;
        b=ZHrCJrJ3VPB6kTK3c2Dm7JU8pxUa3cvUmRziE3bx2yWi7SE6P978JFNTswgdh1SABy
         06pmh/432IcnZxAZRo5wDcU3JxnzXgYcF2CiMnkYLjQbmUA2gD2VEu0RDyXoyCVJfDCU
         Gfa65oc/V6WyQ9BTR0D7uTlVxBiTPrnUea3o0dfFd1CRce4a+X2Q8WBbs6hO9ED1LJ/x
         t4FLBlaixAIilu8a5Z9/ypXPAidIucpEvbKSo2f1LDjG4W8KuyDWOYaZizUzbjGuIkkW
         ZCn+uiWOkofTOdscxEggvtLscuZtBAdmkBCwo2c5kxT3URL2f9ofhrSDsu96iyTGBMTY
         FfDw==
X-Forwarded-Encrypted: i=1; AFNElJ+aod45EHDGfYM4o0z2EBLwHTY23OcahWrDta8PNLRtncS4QCiorb1bh23yVgKyCsBG8BuZmbnwEl8J2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwqAGuW4S4cDvtSmDZyTvxjfmlIk0IcrZiYcs0Qm4t2rw6bAaXW
	jr7mI5DDuyhoOm3zOh+p6pthvpcW9OVwMQ0zc++JBd+faOON26qxIF8Y96E8G2nz6XBVooJuyOg
	vVqqnpzhkayeYRvucOkhCbAthShpkE2KrJXSz+OfGxuaMU+qugk5OkjHgiEc=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:320c:b0:495:cc7b:406e with SMTP id
 5614622812f47-495cc7b6979mr1677107b6e.30.1782703405014; Sun, 28 Jun 2026
 20:23:25 -0700 (PDT)
Date: Sun, 28 Jun 2026 20:23:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a41e52c.9dc7bc9d.3393b4.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING: locking bug in ocfs2_inode_lock_full_nested
 (3)
From: syzbot <syzbot+700d389b60e8ead6de94@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ab9de95c9cf9 Merge tag 'rust-7.2-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1666ecde580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86ba763b42fa66a
dashboard link: https://syzkaller.appspot.com/bug?extid=700d389b60e8ead6de94
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c16df342a923/disk-ab9de95c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ddf00a828178/vmlinux-ab9de95c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f468c716a7be/bzImage-ab9de95c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+700d389b60e8ead6de94@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: kernel/locking/lockdep.c:238 at hlock_class kernel/locking/lockdep.c:238 [inline], CPU#1: syz.4.18034/10925
WARNING: kernel/locking/lockdep.c:238 at check_wait_context kernel/locking/lockdep.c:4854 [inline], CPU#1: syz.4.18034/10925
WARNING: kernel/locking/lockdep.c:238 at __lock_acquire+0x382/0x2cf0 kernel/locking/lockdep.c:5187, CPU#1: syz.4.18034/10925
Modules linked in:
CPU: 1 UID: 0 PID: 10925 Comm: syz.4.18034 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:hlock_class kernel/locking/lockdep.c:238 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4854 [inline]
RIP: 0010:__lock_acquire+0x389/0x2cf0 kernel/locking/lockdep.c:5187
Code: 83 3d 7a fc a8 18 00 75 27 90 e8 e2 b3 12 03 85 c0 74 1c 83 3d eb 1c 91 0e 00 75 13 48 8d 3d ce 77 94 0e 48 c7 c6 d5 21 10 8e <67> 48 0f b9 3a 90 31 c0 0f b6 98 c4 00 00 00 41 8b 45 20 25 ff 1f
RSP: 0018:ffffc90010467448 EFLAGS: 00010046
RAX: 0000000000000001 RBX: 0000000000040000 RCX: 0000000000080000
RDX: ffffc9000eebe000 RSI: ffffffff8e1021d5 RDI: ffffffff903660f0
RBP: 0000000000000001 R08: ffffffff90330603 R09: 1ffffffff20660c0
R10: dffffc0000000000 R11: fffffbfff20660c1 R12: 000000000000140e
R13: ffff88802ce50ba0 R14: ffff88802ce50000 R15: ffff88802ce50ba0
FS:  00007fc45f82b6c0(0000) GS:ffff888125327000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f917adac000 CR3: 00000000686b3000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
 spin_lock include/linux/spinlock.h:342 [inline]
 ocfs2_is_hard_readonly fs/ocfs2/ocfs2.h:663 [inline]
 ocfs2_inode_lock_full_nested+0x12f/0x1b30 fs/ocfs2/dlmglue.c:2446
 ocfs2_inode_lock_tracker+0x1cf/0x710 fs/ocfs2/dlmglue.c:2691
 ocfs2_permission+0xc6/0x1e0 fs/ocfs2/file.c:1361
 do_inode_permission fs/namei.c:583 [inline]
 inode_permission+0x3de/0x5f0 fs/namei.c:653
 lookup_inode_permission_may_exec fs/namei.c:693 [inline]
 may_lookup fs/namei.c:1961 [inline]
 link_path_walk+0xaa6/0x1910 fs/namei.c:2604
 path_parentat fs/namei.c:2860 [inline]
 __filename_parentat+0x287/0x6f0 fs/namei.c:2884
 filename_parentat fs/namei.c:2902 [inline]
 filename_unlinkat+0x104/0x610 fs/namei.c:5550
 __do_sys_unlinkat fs/namei.c:5610 [inline]
 __se_sys_unlinkat+0x83/0x1a0 fs/namei.c:5602
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc45e99ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc45f82b028 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
RAX: ffffffffffffffda RBX: 00007fc45ec15fa0 RCX: 00007fc45e99ce59
RDX: 0000000000000000 RSI: 00002000000001c0 RDI: ffffffffffffff9c
RBP: 00007fc45ea32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc45ec16038 R14: 00007fc45ec15fa0 R15: 00007ffd971d9818
 </TASK>
----------------
Code disassembly (best guess):
   0:	83 3d 7a fc a8 18 00 	cmpl   $0x0,0x18a8fc7a(%rip)        # 0x18a8fc81
   7:	75 27                	jne    0x30
   9:	90                   	nop
   a:	e8 e2 b3 12 03       	call   0x312b3f1
   f:	85 c0                	test   %eax,%eax
  11:	74 1c                	je     0x2f
  13:	83 3d eb 1c 91 0e 00 	cmpl   $0x0,0xe911ceb(%rip)        # 0xe911d05
  1a:	75 13                	jne    0x2f
  1c:	48 8d 3d ce 77 94 0e 	lea    0xe9477ce(%rip),%rdi        # 0xe9477f1
  23:	48 c7 c6 d5 21 10 8e 	mov    $0xffffffff8e1021d5,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	31 c0                	xor    %eax,%eax
  32:	0f b6 98 c4 00 00 00 	movzbl 0xc4(%rax),%ebx
  39:	41 8b 45 20          	mov    0x20(%r13),%eax
  3d:	25                   	.byte 0x25
  3e:	ff 1f                	lcall  *(%rdi)


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
