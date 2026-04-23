Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42564322B7D
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776941362; cv=none; b=KnSNQoVq/+sCNxb8gh5FNPPRq3ACfWYLwGPkZDffBkctiiP5FqcDE3GIpE4b4wENtqkrFCRmuYAvsm8/phg2MmvwEP9QR/YO6Ug/huriaExuhRGmu8xd+DLjJ0A25pyAkgJKWnc+5lSKsk0+ZNgGFCBEaNUsVQtkIwvGrEZUzOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776941362; c=relaxed/simple;
	bh=wl0x3MiwmL4t2M8E/I/eiO5NX3diYIccia3v7qrRdDA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pYUjx8VZuf7h9snuklE5urwsYLX2NTfbSygRT/V/kb48A1qgFv7UQwS7o3m0/jCn5cYyYeFmg5x12k+ho3LFdc2Giy/j/YrsTf/m21TqfVt57tln+6jPoaqXINDLox4ZnK7F0rlmzzv4AYx+xhu9vOCknt0Gz3ndnYNhXzp1Byo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6961163ad6aso2027518eaf.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 03:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776941360; x=1777546160;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i1epOSAFMy6FRvV+vhtpyz0kfwoGN+5oAX7rQNGFCB0=;
        b=Yfi8OfSkS5KPc5cdMrp21v7APg7/acBtU6ouR5t+/3f9+x1p86/rvEi4loLXc5UGeX
         S4/4/XqHvR7kBOQ8hikg5kWzGw5Li4FZLs08D/9CV63TARBHM/zz5ETXA2GPe8FvSey+
         9b9cJw3bjOOYsNth4lk+zEl4GpPYeo0LpGN6mpPZjEJJ8+FJVBUfmRncEBo2O74wL36P
         jvhqNGO37tcsKiredKOpEvqnJY7gGr+hTym/UyLM47IwQafUSLOuRDXaB4rOT1UVP8/W
         MVZtNuAmc+X8WAB84XM4pTowWN88kalshd1YLZLAhHQceIA8tBYt/oVT3DiFTiNCl6hX
         sU2w==
X-Forwarded-Encrypted: i=1; AFNElJ9SNU/j2A1tPHgWPDH+xJ2dtP0T/RaZp6Jkm47qvSDluH21SR5Xi7+GZiwOUR7LhAX7cJ7QYxJ34DyK7A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYLvlRcy2qC72Gi8lHc3SltYhkzw4a6aQyCpb580mAwq895xJ7
	7plIbtTJEbOMHAAxm8flpQJuC/lC+dEZqWMk8x40al+pirHAxOhCFlB08+0wh5Why+CYOP8oWmx
	ICbMb1NCV4yyMEA+wIzyQgDEg4NKAdbQ/l0gowPIushSOxV8K58pneNkuIbs=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1384:b0:683:fa4c:2f2c with SMTP id
 006d021491bc7-69462ee6ca5mr13459341eaf.34.1776941360341; Thu, 23 Apr 2026
 03:49:20 -0700 (PDT)
Date: Thu, 23 Apr 2026 03:49:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e9f930.050a0220.24bfd3.0049.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in ocfs2_grow_tree (2)
From: syzbot <syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    faeab166167f Merge tag 'pinctrl-v7.1-1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1765ffca580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d120b114be21f79
dashboard link: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-faeab166.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/756ff8e81a3b/vmlinux-faeab166.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3c4cb66569b5/bzImage-faeab166.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
(syz.0.0,5330,0):ocfs2_check_set_options:1244 ERROR: Invalid heartbeat mount options
loop0: detected capacity change from 32768 to 32767
(syz.0.0,5330,0):ocfs2_validate_inode_block:1449 ERROR: Invalid dinode #17058: Corrupt state (nlink = 0 or mode = 0) detected!
(syz.0.0,5330,0):ocfs2_assign_bh:2417 ERROR: status = -117
(syz.0.0,5330,0):ocfs2_inode_lock_full_nested:2512 ERROR: status = -117
(syz.0.0,5330,0):ocfs2_reflink_inodes_lock:4747 ERROR: status = -117
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1112:9
index -1 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
CPU: 0 UID: 0 PID: 5330 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 ocfs2_sum_rightmost_rec fs/ocfs2/alloc.c:1112 [inline]
 ocfs2_shift_tree_depth fs/ocfs2/alloc.c:1433 [inline]
 ocfs2_grow_tree+0x37fc/0x4060 fs/ocfs2/alloc.c:1581
 ocfs2_insert_extent+0xc67/0x1700 fs/ocfs2/alloc.c:4764
 ocfs2_add_clusters_in_btree+0x678/0xff0 fs/ocfs2/alloc.c:4866
 ocfs2_add_inode_data+0xe7/0x140 fs/ocfs2/file.c:551
 ocfs2_write_cluster fs/ocfs2/aops.c:1117 [inline]
 ocfs2_write_cluster_by_desc+0x566/0x1de0 fs/ocfs2/aops.c:1221
 ocfs2_write_begin_nolock+0x3305/0x41a0 fs/ocfs2/aops.c:1797
 ocfs2_write_begin+0x1c5/0x320 fs/ocfs2/aops.c:1885
 generic_perform_write+0x2e2/0x8f0 mm/filemap.c:4324
 ocfs2_file_write_iter+0x1663/0x1e70 fs/ocfs2/file.c:2476
 iter_file_splice_write+0x9a1/0x10f0 fs/splice.c:736
 do_splice_from fs/splice.c:936 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1159
 splice_direct_to_actor+0x53a/0xc70 fs/splice.c:1103
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 vfs_copy_file_range+0xb02/0x1370 fs/read_write.c:1634
 __do_sys_copy_file_range fs/read_write.c:1683 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1650
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a2459c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5a25523fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f5a24815fa0 RCX: 00007f5a2459c819
RDX: 0000000000000004 RSI: 00002000000001c0 RDI: 0000000000000005
RBP: 00007f5a24632c91 R08: ffffffffa003e45b R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5a24816038 R14: 00007f5a24815fa0 R15: 00007ffc179ae578
 </TASK>
---[ end trace ]---


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
