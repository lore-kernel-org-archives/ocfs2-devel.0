Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13A12F43
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jan 2025 20:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736454514; cv=none; b=TqdeH36MSFvzs1XEaZucTvjtJA/f+AR68eMuD6D7MvB9gWWp5NGIw95xLAmmWWj56n9UHBjk1kQ+Cx+GB2+XEsTPzlVHs+y5LniJWsfAyUzqKL5diwwsTzER2TtZBH3Z+QzDe2QVGwbEgG7RBs1R84NKF7zKKCtN+JkKWHgVLY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736454514; c=relaxed/simple;
	bh=d9M4KJSgW7dnqj/6cTthDUQHRjeoYXf6tlr7W83uMs4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=up8nP5TX/wN99p4jvI8Y6aQKoiprX9LoCCne3AnBW6cQ5sZ9MjovbjeodLNuIOQF8IBBT5ae/zoZyzi1y9tGE5Z4THMZ4CFWC1fAddOSe+pgzpFbyyH+FtdrIzC8hej9b9zWy2JUOUtJYQhFsyaRxlGEpY0Mmm8ci1OgR7zzBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a78c40fa96so10247055ab.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Jan 2025 12:28:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736454512; x=1737059312;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YDFetDVDsxn3rNvzyUho9dHLIst58f1q7VRKzcDbHiE=;
        b=jnMYAhPPF3bgedVINx03bpSzLeKIlvyIMRIcdlciUFQqroOzB7eRD2AylbI2je6/Hh
         fmBVw7R5CEPd6YGunL29sZHNpqKq7e9REjqc2EMQ0CbYIu7CPo/YwjcZl7uRB0hUKbzL
         CNENbzQckgXqX+QNG/nPlABq1sahOidd2AKCi3D6MzYodORyIRSPUXbaUGTzAEkcLPyC
         9dfqHveAGtz9Tivnfhob/B0vo3YeJfzrucfCXhWRv0iZrRwtFLLZCSNbMUxE2rR3dgve
         IClO3Vo33m8qHSJv5thvTkt33yHYbmSxM8vgVvc0Wjn+tFT2yZPP+eE/wKGQ80/hnZ7C
         722g==
X-Forwarded-Encrypted: i=1; AJvYcCUbRoboSWHDbg7rLsguem8YOGPIeYDgOvQsOUjKdotEhN33MXnaCLTLeKK472mXoR+x1Ol2fo01w/h9KQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxtBZK+F7s26k1S8zr1MnMtWnRyOE/cIcPEx/6BCFQAqx+2yH8g
	R0EJW0jezCKc5dDbcMpUtWYO5Aqli0cuAlnirazJRSiN5laoC3G/MV9jS+6hNb+r0Te5PeL41hO
	0kGzArk3YUdvYGQFnjg6WgkkN/0EEFq5zKqr6QJMnejMIGCGUFbABuko=
X-Google-Smtp-Source: AGHT+IFi4tb68eiJbZjr6oo6c6yhT86A7i8DW2SyhtzSNLyiNdolFIYaECYEfxsoFYVKziaM7JtCPPwBBDRAszDh4PN2bTO5Di62
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c5c6:0:b0:3a7:98c4:86a9 with SMTP id
 e9e14a558f8ab-3ce4b0093c2mr22409535ab.20.1736454511973; Thu, 09 Jan 2025
 12:28:31 -0800 (PST)
Date: Thu, 09 Jan 2025 12:28:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6780316f.050a0220.25a300.01cd.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_page_mkwrite (2)
From: syzbot <syzbot+ecfa701c0b41415f36d4@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ab75170520d4 Merge tag 'linux-watchdog-6.13-rc6' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147756f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
dashboard link: https://syzkaller.appspot.com/bug?extid=ecfa701c0b41415f36d4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ab751705.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/81d0d11be3bd/vmlinux-ab751705.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f076be686f8/bzImage-ab751705.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecfa701c0b41415f36d4@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
Aborting journal on device loop0-75.
syz.0.0: attempt to access beyond end of device
loop0: rw=169985, sector=640, nr_sectors = 1 limit=0
Buffer I/O error on dev loop0, logical block 640, lost sync page write
JBD2: I/O error when updating journal superblock for loop0-75.
(syz.0.0,5316,0):__ocfs2_journal_access:705 ERROR: Error -5 getting 1 access to buffer!
(syz.0.0,5316,0):ocfs2_rotate_rightmost_leaf_left:2893 ERROR: status = -5
(syz.0.0,5316,0):ocfs2_rotate_tree_left:3172 ERROR: status = -5
(syz.0.0,5316,0):ocfs2_try_to_merge_extent:3821 ERROR: status = -5
(syz.0.0,5316,0):__ocfs2_journal_access:705 ERROR: Error -30 getting 1 access to buffer!
(syz.0.0,5316,0):ocfs2_write_end_nolock:1966 ERROR: status = -30
(syz.0.0,5316,0):ocfs2_commit_trans:382 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/mmap.c:107!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5316 Comm: syz.0.0 Not tainted 6.13.0-rc5-syzkaller-00163-gab75170520d4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xd79/0xd80 fs/ocfs2/mmap.c:144
Code: 6d 68 0a fe 4c 89 e8 48 83 e0 01 75 0a e8 7f 63 0a fe e9 28 f8 ff ff 49 ff cd e8 72 63 0a fe e9 20 f8 ff ff e8 68 63 0a fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d23e2a0 EFLAGS: 00010283
RAX: ffffffff839520b8 RBX: 00000000ffffffe2 RCX: 0000000000100000
RDX: ffffc9000e76a000 RSI: 000000000008ba1e RDI: 000000000008ba1f
RBP: ffffc9000d23e460 R08: ffffffff83951ec7 R09: 1ffffffff2854931
R10: dffffc0000000000 R11: fffffbfff2854932 R12: dffffc0000000000
R13: 0000000000100000 R14: 00000000000000f4 R15: 0000000000000000
FS:  00007f94021ad6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcae4e6348 CR3: 0000000043c9c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_page_mkwrite+0x15c/0x350 mm/memory.c:3176
 do_shared_fault mm/memory.c:5398 [inline]
 do_fault mm/memory.c:5460 [inline]
 do_pte_missing mm/memory.c:3979 [inline]
 handle_pte_fault+0x10c6/0x5ed0 mm/memory.c:5801
 __handle_mm_fault mm/memory.c:5944 [inline]
 handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
 faultin_page mm/gup.c:1196 [inline]
 __get_user_pages+0x1c82/0x49e0 mm/gup.c:1494
 __get_user_pages_locked mm/gup.c:1760 [inline]
 __gup_longterm_locked+0xe64/0x17f0 mm/gup.c:2532
 gup_fast_fallback+0x2266/0x29c0 mm/gup.c:3434
 pin_user_pages_fast+0xcc/0x160 mm/gup.c:3540
 iov_iter_extract_user_pages lib/iov_iter.c:1844 [inline]
 iov_iter_extract_pages+0x3bb/0x5c0 lib/iov_iter.c:1907
 dio_refill_pages fs/direct-io.c:172 [inline]
 dio_get_page fs/direct-io.c:213 [inline]
 do_direct_IO fs/direct-io.c:915 [inline]
 __blockdev_direct_IO+0x1443/0x4890 fs/direct-io.c:1243
 ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2464
 generic_file_read_iter+0x341/0x550 mm/filemap.c:2811
 ocfs2_file_read_iter+0x42b/0xb80 fs/ocfs2/file.c:2589
 aio_read+0x363/0x500 fs/aio.c:1602
 io_submit_one+0x884/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x171/0x2e0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9401385d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f94021ad038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007f9401575fa0 RCX: 00007f9401385d29
RDX: 0000000020001d00 RSI: 000000001ffffff0 RDI: 00007f9402153000
RBP: 00007f9401401b08 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9401575fa0 R15: 00007ffe0ce4f5d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ocfs2_page_mkwrite fs/ocfs2/mmap.c:107 [inline]
RIP: 0010:ocfs2_page_mkwrite+0xd79/0xd80 fs/ocfs2/mmap.c:144
Code: 6d 68 0a fe 4c 89 e8 48 83 e0 01 75 0a e8 7f 63 0a fe e9 28 f8 ff ff 49 ff cd e8 72 63 0a fe e9 20 f8 ff ff e8 68 63 0a fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d23e2a0 EFLAGS: 00010283
RAX: ffffffff839520b8 RBX: 00000000ffffffe2 RCX: 0000000000100000
RDX: ffffc9000e76a000 RSI: 000000000008ba1e RDI: 000000000008ba1f
RBP: ffffc9000d23e460 R08: ffffffff83951ec7 R09: 1ffffffff2854931
R10: dffffc0000000000 R11: fffffbfff2854932 R12: dffffc0000000000
R13: 0000000000100000 R14: 00000000000000f4 R15: 0000000000000000
FS:  00007f94021ad6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcae4e6348 CR3: 0000000043c9c000 CR4: 0000000000352ef0
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
