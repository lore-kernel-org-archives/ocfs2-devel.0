Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA871CB50D
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725292234; cv=none; b=rKd0QN/7TRJE00uRxOn1pRzKBLv7fzu0jVFbMEQorA22qS18jsQrRo4sBk/FgkbZ9pqvVkLolDLflysYhWao98oy9WUNcCm7AXyfUCh9TbHb/tiEjpPvsg0EE16VH8xzg+PPWwRXtxdQt+z2YHN2NaYE2DD2WQ0k1PTMSPZ8PX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725292234; c=relaxed/simple;
	bh=Tk0amZoBHxPQO9s5mFrGPwgGJlDnntP2yAzT4VtCpc0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SIpjpm4mTCoLXw6mzs9cfK24Gt2+HN7KDVs5O3KiXqZaNECLEZpuFhniHj+R0HE91DRxI7Lqf7g6Z7Ya1meKS/Q2uOvKkDS7KZST6zvSiDUYFQ8KoZPxkeukijHO3IaYz1au+MezWGWlrowFanZSEiP8ckDVpnAz5OSjO+rkbFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a36f1515cso271513539f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 02 Sep 2024 08:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725292232; x=1725897032;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+g4KIsfJ0w1rNq+rjf1f9QqbPGYtVytgM9Uk5/GI2vg=;
        b=m/VgBaAaVJwqN6wg9rUldpTYO2D9Vld63igU3J7cW3IfForx6pW/zOp2wSGHuyRreO
         iSfgg1jxq8pLYzcQ+q+CMLgxJmSf5CCwrvBbISZxPTd6CeL64fPrmkww4LvzZPRwbcSr
         u9Ivv2vbnUpmHGWYWfjKWfvRaaNGhI6T4L84s6IHaknn5wBmEiKfYp3nY7cqJFxpPqmM
         B5H0DLn6loWMEzRn2nYgxQCRj1p3BMd+PlofvTDTFWqkpQZsbAIEZkv2zfHkgzDlcIG+
         8UW7WL2TLD9HKgbOgddx+ljvkh0pe2zGpH7bqG8PmXHJXauaWjgmdBT4qI5g0YoU2Ifw
         yCYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqXEDLuH7PQqWPYFmS1TWXHYXv8ShCyg+ITVQv9nQOEb3d/TZqgPJzLzJSfQ1ApbB3SLBf+nyqObZZQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxP+wH/lziO4tuVgD8ysEMTOfNP/bjtqWAa1p4fLAQvsZ16G6RW
	Kq3Jk6a/CAssyL9G7HKr5g+TLKKa0jdjmTLsKeCX2r3x6EBk3o7wTNAmenm11Uy/cOztjtiE0u1
	Wibsyqlg5fCjyowfw3AAq2D8lIfYOfFuY8teT1wHP3o67FD9/ODA7JRU=
X-Google-Smtp-Source: AGHT+IF8E26Z+G0nCEKkVFDjprJVoxZO8IAHdt+Fh0aQYHsrac3V0NMCvKBxbvMH9JmZnH9DRWWqKEkcLuG1lhcxEfqcas98bWV9
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:9820:b0:4c0:9a05:44c4 with SMTP id
 8926c6da1cb9f-4d017c4697bmr722040173.0.1725292232124; Mon, 02 Sep 2024
 08:50:32 -0700 (PDT)
Date: Mon, 02 Sep 2024 08:50:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1395d062124e614@google.com>
Subject: [syzbot] [ocfs2?] WARNING: ODEBUG bug in ocfs2_local_read_info
From: syzbot <syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    df54f4a16f82 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15c4a31f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dde5a5ba8d41ee9e
dashboard link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b4f0fb980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11974d43980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa2eb06e0aea/disk-df54f4a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/14728733d385/vmlinux-df54f4a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99816271407d/Image-df54f4a1.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0c40477ea929/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com

(syz-executor200,6389,1):ocfs2_local_read_info:763 ERROR: status = -5
------------[ cut here ]------------
ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c
WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 debug_print_object lib/debugobjects.c:515 [inline]
WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
WARNING: CPU: 1 PID: 6389 at lib/debugobjects.c:518 debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
Modules linked in:
CPU: 1 UID: 0 PID: 6389 Comm: syz-executor200 Not tainted 6.11.0-rc5-syzkaller-gdf54f4a16f82 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_print_object lib/debugobjects.c:515 [inline]
pc : __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
pc : debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
lr : debug_print_object lib/debugobjects.c:515 [inline]
lr : __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
lr : debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
sp : ffff800099586af0
x29: ffff800099586b30 x28: 0000000000000000 x27: ffff80008b4827c0
x26: ffff0000d78c6ac8 x25: dfff800000000000 x24: 0000000000000000
x23: ffff80009410aee8 x22: ffff0000d78c6000 x21: 0000000000000000
x20: ffff8000820f29cc x19: ffff0000d78c6800 x18: 0000000000000008
x17: 626f203832656330 x16: ffff800080345a84 x15: 0000000000000001
x14: 1fffe000367a12c8 x13: 0000000000000000 x12: 0000000000000003
x11: 0000000000000001 x10: 0000000000000003 x9 : 7913726110ee6700
x8 : 7913726110ee6700 x7 : ffff80008b3cfc98 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000006 x1 : ffff80008b462a00 x0 : ffff80012489c000
Call trace:
 debug_print_object lib/debugobjects.c:515 [inline]
 __debug_check_no_obj_freed lib/debugobjects.c:990 [inline]
 debug_check_no_obj_freed+0x398/0x47c lib/debugobjects.c:1020
 slab_free_hook mm/slub.c:2219 [inline]
 slab_free mm/slub.c:4473 [inline]
 kfree+0x124/0x3e0 mm/slub.c:4594
 ocfs2_local_read_info+0x1338/0x1550 fs/ocfs2/quota_local.c:785
 dquot_load_quota_sb+0x700/0xb48 fs/quota/dquot.c:2460
 dquot_load_quota_inode+0x280/0x4f4 fs/quota/dquot.c:2497
 ocfs2_enable_quotas+0x1d4/0x3cc fs/ocfs2/super.c:926
 ocfs2_fill_super+0x3c80/0x4740 fs/ocfs2/super.c:1141
 mount_bdev+0x1d4/0x2a0 fs/super.c:1679
 ocfs2_mount+0x44/0x58 fs/ocfs2/super.c:1188
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x28c fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
irq event stamp: 66264
hardirqs last  enabled at (66263): [<ffff8000802b6870>] raw_spin_rq_unlock_irq+0x14/0x24 kernel/sched/sched.h:1427
hardirqs last disabled at (66264): [<ffff80008b2ee35c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
softirqs last  enabled at (66246): [<ffff8000801f77b8>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (66246): [<ffff8000801f77b8>] handle_softirqs+0xa3c/0xbfc kernel/softirq.c:582
softirqs last disabled at (66225): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
---[ end trace 0000000000000000 ]---
(syz-executor200,6389,1):ocfs2_enable_quotas:939 ERROR: status = -1
(syz-executor200,6389,1):ocfs2_fill_super:1145 ERROR: status = -1
ocfs2: Unmounting device (7,0) on (node local)


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
