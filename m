Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CACB1684AE
	for <ocfs2-devel@lists.linux.dev>; Wed,  9 Oct 2024 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506064; cv=none; b=GXq++nWQ/hYciPvkbJpbp76fVvWA6IByQhEYz0sYkc3G1By3bXSFLjnVmYQqI4enYgLXFD6GlrJPtsTp92RbStF8wsa78an7oplL/CDWUBQAPtqlBzRsJW777o9aZdKIT7NXQg1dwxX9Qjyg7oSAYbr3tEdDTmyTNKfRa3pF62o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506064; c=relaxed/simple;
	bh=HYNqo+FrutBFmzXam6OlwpksWYE+FxVlu10MgYsz8Ig=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Qqrt25P8XxLf3io8gtc38Ob5E7O0CBq2VnqduYRemXjw+g+LhiUzY2FUkTV7a79JGJ8Vhw9Fvae+NI2I6OQxpAQcyN5nHnoPlYrXH4aoPvldKBDk2Y1WazIdldKPljdAWnluJaJfrZ9BThtAWC4aJzGwu3FMm6+2sF0EpU+wQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a342e872a7so3221665ab.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 09 Oct 2024 13:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728506062; x=1729110862;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QSYix+4rQWG4VjgXOlQwElhZAFJZ4sWfAYzwYaj7dE4=;
        b=xPdkpAEYQ1Xm41Af41RB6JAwVQojFYiuS8Zew4Q90QljqHYxu2mWCVbEuUIRJC82iJ
         p/3jvh/s7TuqQDkfSdMV8BmwFtjEOBR0QlqopFu1NAUFXtlJBXCD3saVI5qWQ6Np6aej
         uGx0kk2N6HW0AK/39Soti27N/+sec/CkQf53JRMTirKorowE9C3xo45g0Jv7bEtpMDOf
         GtbGvihYCJwVZTBWySqGAB2BNCbr/yVGLo2MA4LEcOtLtKnwePZ1LNMNCaMzMANW9FrZ
         sidJM/eoPeGtMeuJ6W7ObvM1Qxv1DPegXaamVyxMiOE9YqGl5xHFgnCkX/6H7vn/zXC+
         JYjw==
X-Forwarded-Encrypted: i=1; AJvYcCUc2MTahCoDLatLc6/HhklA7t19x8lbnh4yz6KoIRfhEx8/SFpSnr3zPzRVQWHmiOQVfBI99b52hM3LQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxCl7GLjvz/dp1cWo96e256/IwE1qNkZfTfYy0LNRhdR2v6tX9R
	YJJWzPxjR5OSEwSZOtVGcowkam2gHVuVlKut9QybQXhD7WibKWxB6wfrtUxIBSSASOmqFhhn5Iw
	zPSpiCsjrmLvshjTbDHwQhQCiaQW17cwVM2QfZQfBRZn8UyxDVxtdkG0=
X-Google-Smtp-Source: AGHT+IFqWY2Y+yRqTYxICn0rzd+ydkpIiiHtWT9HnjvF0MhokQEm033nAmGMsRIaHa+q6t1QRUKs07PVaO/27OoRuS3gxneOn5nw
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152b:b0:3a2:463f:fd9e with SMTP id
 e9e14a558f8ab-3a397ce4910mr36647315ab.6.1728506061764; Wed, 09 Oct 2024
 13:34:21 -0700 (PDT)
Date: Wed, 09 Oct 2024 13:34:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6706e8cd.050a0220.67064.0053.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in __ocfs2_find_path
From: syzbot <syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    27cc6fdf7201 Merge tag 'linux_kselftest-fixes-6.12-rc2' of..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1653c79f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8af0b3195caed62
dashboard link: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12af7bd0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1153c79f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/87f1d994309a/disk-27cc6fdf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c7ccdaf7e44/vmlinux-27cc6fdf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7dc828e4bf0e/bzImage-27cc6fdf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/036cff156a70/mount_0.gz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=111b7d27980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=131b7d27980000
console output: https://syzkaller.appspot.com/x/log.txt?x=151b7d27980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
==================================================================
BUG: KASAN: use-after-free in __ocfs2_find_path+0x203/0x7e0 fs/ocfs2/alloc.c:1824
Read of size 4 at addr ffff8880707fb000 by task syz-executor231/5221

CPU: 1 UID: 0 PID: 5221 Comm: syz-executor231 Not tainted 6.12.0-rc1-syzkaller-00306-g27cc6fdf7201 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 __ocfs2_find_path+0x203/0x7e0 fs/ocfs2/alloc.c:1824
 ocfs2_find_leaf+0xcf/0x230 fs/ocfs2/alloc.c:1938
 ocfs2_get_clusters_nocache+0x1ad/0xbf0 fs/ocfs2/extent_map.c:418
 ocfs2_get_clusters+0x5bd/0xbd0 fs/ocfs2/extent_map.c:621
 ocfs2_extent_map_get_blocks+0x24c/0x7d0 fs/ocfs2/extent_map.c:668
 ocfs2_read_virt_blocks+0x313/0xb20 fs/ocfs2/extent_map.c:983
 ocfs2_read_dir_block fs/ocfs2/dir.c:508 [inline]
 ocfs2_find_entry_el fs/ocfs2/dir.c:715 [inline]
 ocfs2_find_entry+0x43b/0x2780 fs/ocfs2/dir.c:1080
 ocfs2_find_files_on_disk+0xff/0x360 fs/ocfs2/dir.c:1981
 ocfs2_lookup_ino_from_name+0xb1/0x1e0 fs/ocfs2/dir.c:2003
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
 ocfs2_get_system_file_inode+0x305/0x7b0 fs/ocfs2/sysfile.c:112
 ocfs2_init_global_system_inodes+0x32c/0x730 fs/ocfs2/super.c:457
 ocfs2_initialize_super fs/ocfs2/super.c:2248 [inline]
 ocfs2_fill_super+0x2f47/0x5750 fs/ocfs2/super.c:994
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdb53261dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff04142618 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff04142630 RCX: 00007fdb53261dea
RDX: 0000000020004440 RSI: 0000000020000780 RDI: 00007fff04142630
RBP: 0000000000000004 R08: 00007fff04142670 R09: 0000000000004444
R10: 0000000001000000 R11: 0000000000000282 R12: 0000000001000000
R13: 00007fff04142670 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x707fb
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0001c1ff08 ffff8880b8744af0 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x8(__GFP_MOVABLE), pid 1, tgid 1 (swapper/0), ts 11895450743, free_ts 13010080278
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 split_free_pages mm/page_alloc.c:6478 [inline]
 alloc_contig_range_noprof+0x821/0xe20 mm/page_alloc.c:6605
 __alloc_contig_pages mm/page_alloc.c:6634 [inline]
 alloc_contig_pages_noprof+0x4b3/0x5c0 mm/page_alloc.c:6714
 debug_vm_pgtable_alloc_huge_page+0xaf/0x100 mm/debug_vm_pgtable.c:1084
 init_args+0x83b/0xb20 mm/debug_vm_pgtable.c:1266
 debug_vm_pgtable+0xe0/0x550 mm/debug_vm_pgtable.c:1304
 do_one_initcall+0x248/0x880 init/main.c:1269
 do_initcall_level+0x157/0x210 init/main.c:1331
 do_initcalls+0x3f/0x80 init/main.c:1347
 kernel_init_freeable+0x435/0x5d0 init/main.c:1580
 kernel_init+0x1d/0x2b0 init/main.c:1469
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcd0/0xf00 mm/page_alloc.c:2638
 free_contig_range+0x152/0x550 mm/page_alloc.c:6748
 destroy_args+0x8a/0x840 mm/debug_vm_pgtable.c:1017
 debug_vm_pgtable+0x4be/0x550 mm/debug_vm_pgtable.c:1397
 do_one_initcall+0x248/0x880 init/main.c:1269
 do_initcall_level+0x157/0x210 init/main.c:1331
 do_initcalls+0x3f/0x80 init/main.c:1347
 kernel_init_freeable+0x435/0x5d0 init/main.c:1580
 kernel_init+0x1d/0x2b0 init/main.c:1469
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff8880707faf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880707faf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880707fb000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff8880707fb080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880707fb100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
