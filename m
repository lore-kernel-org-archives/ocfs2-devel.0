Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DA418DB37
	for <ocfs2-devel@lists.linux.dev>; Mon, 18 May 2026 02:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779072384; cv=none; b=O9zB+IpbY5LjirzRct2cidTYAofDoDPTULLP05pE0GZRs564fs8EwOQSYHl/OX84A0F+ghZbR47Z8rPZbHoprbscPWNFUY01jpXJZ8m3QWnbM6JsQ7G8BN/sWcXp9hpMkWcbBVJ1+09uwT3hsT6U9XUCn6SlqwwMvLIoPj4EiU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779072384; c=relaxed/simple;
	bh=ud8xXrky1wvFUPz74rNqxzcRjNvoQHe5apS3cRdP1Yo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oIy4rDVdaenUuCZU+WGmG8SVMVc7kvp3Nm2CsfRDeqy9/zkJVzyPjlU4gIEg7OBP+hzKOZUtf/AzRh7PzIzoS+DEDoEDlIJbfrT+V71tGUz0m3YEAH9clrC3LVrl6cwouzFVbvk4H5exgPJekscmLSz0lsBBRVMFL9xok/QmRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6967b799acdso3692024eaf.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 19:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779072382; x=1779677182;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HTgE6jE/F9EuHWmY+nDXPD9dvj7TdZUK/sLh8a4wvtQ=;
        b=EEf7VELcAnOCv93cR2lmgWQCmg0hjqeeFVb+F604v9QX+P3jFPwSy9e+/sxe+1gY4U
         Yns5XXbbNnTfmirKZMYozmlTK/rkiiBlIE74OHq3+GtgAowmJjWX5aaeXKVrGLocey4s
         XSv9VK8dO3B8ceqK74yk+VbqLq5CdPjRc6a9CtP+ZhhQkf+xitJuRBBASC7b/S1y1Gnb
         NFaXBQ/OZGeGIaIVbyadbYTpq5Uf2iT5B49qFeO2r75juUMy0x7B48xQRXGiK0OzV/i2
         uyIU1j7NuYGtPj2ou2rKA9K/NHWLHe+ipPrdKJM7MsetpPOJ+h8ZiwJAlYgYWZRwl2MI
         aobg==
X-Forwarded-Encrypted: i=1; AFNElJ8Dm2OfzxOOUR5QYFC8AFPIiysu9H+PLvXMBns7yKXE98BgW+7wd2E/FbTavDNkltRmwAZSMuvTlR4lKQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzIMZQqQMhPirzpnufyKeTEZU/TjkywhxRH17dv33kQ29utNDle
	gOo28E0SEX3+P07Gs3MVG6pa1r9Ks115ckUGIsmP5c4A+d+6P25nBrj1XwWgO59/aiHvHdEyYOM
	SGzX39g2hmEP2G05OUAIibBmz0uKV/SrrfSpHzezdeXur1lXE1yvXNuF1yks=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:168c:b0:696:62f6:a029 with SMTP id
 006d021491bc7-69c9436772emr8833194eaf.32.1779072382070; Sun, 17 May 2026
 19:46:22 -0700 (PDT)
Date: Sun, 17 May 2026 19:46:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0a7d7e.050a0220.298be4.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in __ocfs2_decrease_refcount
From: syzbot <syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e1914add2799 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d62196580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e1914add.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cfc9d48b6e76/vmlinux-e1914add.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e7ac48dd4788/bzImage-e1914add.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com

------------[ cut here ]------------
memset: detected buffer overflow: 384 byte write of buffer size 16
WARNING: lib/string_helpers.c:1037 at __fortify_report+0x6b/0xa0 lib/string_helpers.c:1036, CPU#0: syz.0.0/5331
Modules linked in:
CPU: 0 UID: 0 PID: 5331 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__fortify_report+0x89/0xa0 lib/string_helpers.c:1036
Code: e8 7c 6b 7e fd 48 8d 3d 45 8f 87 0b 45 84 e4 49 8b 37 48 c7 c0 c0 0e 28 8c 48 c7 c1 e0 0e 28 8c 48 0f 44 c8 4c 89 f2 49 89 d8 <67> 48 0f b9 3a 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc cc cc cc
RSP: 0018:ffffc90003076848 EFLAGS: 00010202
RAX: ffffffff8c280ec0 RBX: 0000000000000010 RCX: ffffffff8c280ee0
RDX: 0000000000000180 RSI: ffffffff8c280d80 RDI: ffffffff903bc0c0
RBP: 000000000000000f R08: 0000000000000010 R09: 1ffffffff2061b5e
R10: dffffc0000000000 R11: fffffbfff2061b5f R12: 0000000000000001
R13: 1ffff1100ab75510 R14: 0000000000000180 R15: ffffffff8c280bb8
FS:  0000555562e72540(0000) GS:ffff88808c881000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000001fc6a000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __fortify_panic+0x9/0x10 lib/string_helpers.c:1043
 fortify_memset_chk include/linux/fortify-string.h:495 [inline]
 ocfs2_remove_refcount_extent fs/ocfs2/refcounttree.c:2134 [inline]
 ocfs2_decrease_refcount_rec fs/ocfs2/refcounttree.c:2203 [inline]
 __ocfs2_decrease_refcount+0x1990/0x19e0 fs/ocfs2/refcounttree.c:2249
 ocfs2_decrease_refcount+0x59c/0x7d0 fs/ocfs2/refcounttree.c:2312
 ocfs2_remove_btree_range+0x125b/0x1610 fs/ocfs2/alloc.c:5800
 ocfs2_commit_truncate+0xbb8/0x2310 fs/ocfs2/alloc.c:7383
 ocfs2_truncate_for_delete fs/ocfs2/inode.c:701 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:868 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
 ocfs2_evict_inode+0x1023/0x43b0 fs/ocfs2/inode.c:1299
 evict+0x61e/0xb10 fs/inode.c:841
 ocfs2_dentry_iput+0x24d/0x390 fs/ocfs2/dcache.c:407
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 finish_dput+0xc9/0x480 fs/dcache.c:927
 __fput+0x691/0xa60 fs/file_table.c:518
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f402a59ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffc44472f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f402a817da0 RCX: 00007f402a59ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f402a817da0 R08: 00007f402a816038 R09: 0000000000000000
R10: 0000000000dcaba0 R11: 0000000000000246 R12: 00000000000156b7
R13: 00007f402a81609c R14: 0000000000015685 R15: 00007f402a816090
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 7c 6b 7e fd       	call   0xfd7e6b81
   5:	48 8d 3d 45 8f 87 0b 	lea    0xb878f45(%rip),%rdi        # 0xb878f51
   c:	45 84 e4             	test   %r12b,%r12b
   f:	49 8b 37             	mov    (%r15),%rsi
  12:	48 c7 c0 c0 0e 28 8c 	mov    $0xffffffff8c280ec0,%rax
  19:	48 c7 c1 e0 0e 28 8c 	mov    $0xffffffff8c280ee0,%rcx
  20:	48 0f 44 c8          	cmove  %rax,%rcx
  24:	4c 89 f2             	mov    %r14,%rdx
  27:	49 89 d8             	mov    %rbx,%r8
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	5b                   	pop    %rbx
  30:	41 5c                	pop    %r12
  32:	41 5e                	pop    %r14
  34:	41 5f                	pop    %r15
  36:	5d                   	pop    %rbp
  37:	c3                   	ret
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	cc                   	int3
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	cc                   	int3
  3f:	cc                   	int3


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
