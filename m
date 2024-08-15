Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D008A1BBBFE
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 10:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718845; cv=none; b=EsYZoE4hRcOcAGejqcy65WdHQ18/kAkDzBbMg9vq1ZNoTbFsPNdiEfBh9a6vnVDflf860kI7AjptPhE07N4K+gviHGIz4rLufYmuHk6SVuHLeqiVeE3peRmsr9ZWwjyg/AIL3dUrcFyK5tBWMVzSxiP72qnwkmrzEAJg/bxVVVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718845; c=relaxed/simple;
	bh=1RItO4p+ev170hIK/MJDRjPZMzF55+38seCWlCOsqU0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UM2OtSpGsFd8wxGJwFa8xscVL608cw7/y522+fR5G3U8zzV5MbNhBICMSn5HMNBhPkMlNo+cZupstK+sE6IkVWaWAiZgvKF0xXCf7xtk7RbiFpYGDhMvNav+s4VvjSc3cDBSu+qM7hzMMRVB35pduaALXIIfY7bbTyIScC95bcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39b3b5858e6so7480225ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Aug 2024 03:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723718843; x=1724323643;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7VeczzzrEjWxpGG7pSmoLg+bL4Z82lYXHTGkDEdUF4s=;
        b=F/OYWZazFhtX73B1Sll3302SDMAWlsSdRNL6S39fbXRY9OZ2voIgIzsSd1HHFBFLsQ
         Kwe81jJxI/3pSEwOYeDfHykpF40bBEr5gfV4ib1Ej3SrsJ65/pCDJDS2Bs9jlK8T5JKb
         wa//uRUXa+bWkKMGfoG9bC/E+qtx9DMU4Kaf2C9X5ftlF3mzGCxZI+zjC7b0TnrffEcV
         /04dAQES1s7hNw3kWv+OpGeoQ3xjksDlfJjzV6FBHPxSkwhHA9UlDk1XViGILnRmVEcZ
         kQMdSCZuBRtvqjCMoFrmEy5OgJZrKWgJnpfA86cbMbJFTmmVD3ZPzYMrRGzlCxR5ScV4
         7zxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpLF7RaOk1POLB5vSgk3r6oND+n1hNcL3e0EGmrqDAD6psMzZhVgp5I9lACe5B3yklT4ZwC/CHAw89a5nNzR6ftWO1BAGAUNTU2jM=
X-Gm-Message-State: AOJu0YxMrDcd9jMVnqwMklay6Nl4Y4TS8tHF4uvfizBRug32uV07LUFo
	76TT04c8rmT43BVaHgzbe4R3c8vtDWnFyO27OD91vwIJBETdNZqSng3o8KpNYK3PIIvqhzHih5I
	CR5Ly1scttLPdlwZGGHJ2A6PdpqRsydK+vu6hL94zU4n+dA22xegt18Q=
X-Google-Smtp-Source: AGHT+IFhAZQFAAcScjbLus+PNzkM3outFtJXk3JsTx8ZqwAZV+0vpqfPTAev5ZjvgDgRk8ld3NE2oglIYSkAE7FwjUgSs9M6ufPu
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca6:b0:375:a55e:f5fc with SMTP id
 e9e14a558f8ab-39d12443709mr4096845ab.1.1723718842875; Thu, 15 Aug 2024
 03:47:22 -0700 (PDT)
Date: Thu, 15 Aug 2024 03:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000528f32061fb69112@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_buffer_cached
From: syzbot <syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07b43284ab3 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=126c2aa3980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=adfd64e93c46b99c957e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1206cdd3980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cfea91980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d07b4328.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/91ceec6e19d3/vmlinux-d07b4328.xz
kernel image: https://storage.googleapis.com/syzbot-assets/be11646b0c05/bzImage-d07b4328.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/90c0e9dcfbf9/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+adfd64e93c46b99c957e@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
(syz-executor178,5091,0):ocfs2_read_blocks:240 ERROR: status = -12
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 5091 Comm: syz-executor178 Not tainted 6.11.0-rc3-syzkaller-00060-gd07b43284ab3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_buffer_cached+0xcb/0x840 fs/ocfs2/uptodate.c:237
Code: eb b2 65 fe 4c 89 7c 24 20 4c 8b 5d 00 48 89 5c 24 08 48 89 df 41 ff d3 66 90 48 89 44 24 18 49 83 c5 18 4d 89 ec 49 c1 ec 03 <43> 80 3c 34 00 74 08 4c 89 ef e8 b6 b2 65 fe 49 8b 55 00 48 8b 44
RSP: 0018:ffffc9000b01e620 EFLAGS: 00010206
RAX: 0000000000000012 RBX: ffff88805f1faa70 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88805f1faa70
RBP: ffffffff8c48fcc0 R08: 0000000000000003 R09: fffff52001603cb4
R10: dffffc0000000000 R11: ffffffff8385d210 R12: 0000000000000003
R13: 0000000000000018 R14: dffffc0000000000 R15: 1ffff1100be3f54e
FS:  00005555632e5380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc970f4c08 CR3: 0000000036024000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_set_buffer_uptodate+0xa1/0x1350 fs/ocfs2/uptodate.c:474
 ocfs2_read_blocks+0x103e/0x1620 fs/ocfs2/buffer_head_io.c:392
 ocfs2_read_virt_blocks+0x4c8/0xa50 fs/ocfs2/extent_map.c:1010
 ocfs2_read_dir_block fs/ocfs2/dir.c:508 [inline]
 ocfs2_find_entry_el fs/ocfs2/dir.c:715 [inline]
 ocfs2_find_entry+0x43b/0x2780 fs/ocfs2/dir.c:1080
 ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1980
 ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2002
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
 ocfs2_get_system_file_inode+0x305/0x7b0 fs/ocfs2/sysfile.c:112
 ocfs2_init_global_system_inodes+0x32c/0x730 fs/ocfs2/super.c:457
 ocfs2_initialize_super fs/ocfs2/super.c:2250 [inline]
 ocfs2_fill_super+0x3068/0x5880 fs/ocfs2/super.c:994
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4945e4ddea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdf618e318 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdf618e330 RCX: 00007f4945e4ddea
RDX: 0000000020004480 RSI: 00000000200044c0 RDI: 00007ffdf618e330
RBP: 0000000000000004 R08: 00007ffdf618e370 R09: 000000000000446f
R10: 0000000002800400 R11: 0000000000000282 R12: 0000000002800400
R13: 00007ffdf618e370 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_buffer_cached+0xcb/0x840 fs/ocfs2/uptodate.c:237
Code: eb b2 65 fe 4c 89 7c 24 20 4c 8b 5d 00 48 89 5c 24 08 48 89 df 41 ff d3 66 90 48 89 44 24 18 49 83 c5 18 4d 89 ec 49 c1 ec 03 <43> 80 3c 34 00 74 08 4c 89 ef e8 b6 b2 65 fe 49 8b 55 00 48 8b 44
RSP: 0018:ffffc9000b01e620 EFLAGS: 00010206
RAX: 0000000000000012 RBX: ffff88805f1faa70 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88805f1faa70
RBP: ffffffff8c48fcc0 R08: 0000000000000003 R09: fffff52001603cb4
R10: dffffc0000000000 R11: ffffffff8385d210 R12: 0000000000000003
R13: 0000000000000018 R14: dffffc0000000000 R15: 1ffff1100be3f54e
FS:  00005555632e5380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc970f4c08 CR3: 0000000036024000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	eb b2                	jmp    0xffffffb4
   2:	65 fe 4c 89 7c       	decb   %gs:0x7c(%rcx,%rcx,4)
   7:	24 20                	and    $0x20,%al
   9:	4c 8b 5d 00          	mov    0x0(%rbp),%r11
   d:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  12:	48 89 df             	mov    %rbx,%rdi
  15:	41 ff d3             	call   *%r11
  18:	66 90                	xchg   %ax,%ax
  1a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  1f:	49 83 c5 18          	add    $0x18,%r13
  23:	4d 89 ec             	mov    %r13,%r12
  26:	49 c1 ec 03          	shr    $0x3,%r12
* 2a:	43 80 3c 34 00       	cmpb   $0x0,(%r12,%r14,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ef             	mov    %r13,%rdi
  34:	e8 b6 b2 65 fe       	call   0xfe65b2ef
  39:	49 8b 55 00          	mov    0x0(%r13),%rdx
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	44                   	rex.R


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
